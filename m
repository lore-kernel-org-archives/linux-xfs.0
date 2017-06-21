Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43630 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbdFUUaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 16:30:05 -0400
Date: Wed, 21 Jun 2017 13:29:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/12] libxcmd: add cvt{int, long} to convert strings to
 int and long
Message-ID: <20170621202951.GM4733@birch.djwong.org>
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755896133.3625.13813626356334626083.stgit@birch.djwong.org>
 <6c0086a3-d1db-baa0-f0a4-be1c6d2cebe7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c0086a3-d1db-baa0-f0a4-be1c6d2cebe7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 21, 2017 at 03:16:37PM -0500, Eric Sandeen wrote:
> On 6/15/17 3:36 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some helper functions to convert strings to int or long
> > in a standard way and work around problems in the C library
> > atoi/strtol functions.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/input.h |    8 +++
> >  libxcmd/input.c |  134 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 142 insertions(+)
> > 
> > 
> > diff --git a/include/input.h b/include/input.h
> > index 82cd2f4..145114b 100644
> > --- a/include/input.h
> > +++ b/include/input.h
> > @@ -28,6 +28,14 @@ extern char	**breakline(char *input, int *count);
> >  extern void	doneline(char *input, char **vec);
> >  extern char	*fetchline(void);
> >  
> > +extern int64_t	cvt_s64(char *s, int base);
> > +extern int32_t	cvt_s32(char *s, int base);
> > +extern int16_t	cvt_s16(char *s, int base);
> > +
> > +extern uint64_t	cvt_u64(char *s, int base);
> > +extern uint32_t	cvt_u32(char *s, int base);
> > +extern uint16_t	cvt_u16(char *s, int base);
> > +
> >  extern size_t numlen(uint64_t val, size_t base);
> >  extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
> >  extern void	cvtstr(double value, char *str, size_t sz);
> > diff --git a/libxcmd/input.c b/libxcmd/input.c
> > index 9437be3..8dd232c 100644
> > --- a/libxcmd/input.c
> > +++ b/libxcmd/input.c
> > @@ -149,6 +149,140 @@ numlen(
> >  	return len == 0 ? 1 : len;
> >  }
> >  
> > +/*
> > + * Convert string to int64_t, set errno if the conversion fails or
> > + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
> > + * prior to conversion.
> > + */
> > +int64_t
> > +cvt_s64(
> > +	char		*s,
> > +	int		base)
> > +{
> > +	long long	i;
> > +	char		*sp;
> > +	int		c;
> 
> unused var c
> 
> > +
> > +	errno = 0;
> > +	i = strtoll(s, &sp, base);
> > +	if (*sp == '\0' && sp != s)
> > +		return i;
> > +bad:
> 
> label bad: defined but not used

Fixed.  Sorry about the stupidity. :(

> > +	errno = -ERANGE;
> > +	return INT64_MIN;
> 
> Hm, doesn't strtoll return LLONG_MIN or LLONG_MAX for underflows
> and overflows?  Do you really want to return MIN even if this /overflowed/?
> (Maybe it doesn't matter, gut its a bit of a departure from strtoll semantics)

True, it's a departure from the usual semantics.  The intent is to call
the function this way:

long foo = cvt_s64(...);
if (errno) {
	fprintf(stderr, "N|_|MB3Rz ARE HARDZ!!1!\n");
	exit(5);
}

So at least in theory it wouldn't matter what we actually set foo to.

> > +}
> > +
> > +/*
> > + * Convert string to int32_t, set errno if the conversion fails or
> > + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
> > + * prior to conversion.
> > + */
> > +int32_t
> > +cvt_s32(
> > +	char		*s,
> > +	int		base)
> > +{
> > +	int64_t		i;
> > +
> > +	i = cvt_s64(s, base);
> > +	if (errno)
> > +		return i;
> > +	if (i > INT32_MAX || i < INT32_MIN) {
> > +		errno = -ERANGE;
> > +		return INT32_MIN;
> 
> same sort of Q here, wouldn't you want MIN or MAX
> for underflow/overflow?  Same below as well for all
> signed type conversions.
> 
> > +	}
> > +	return i;
> > +}
> > +
> > +/*
> > + * Convert string to int16_t, set errno if the conversion fails or
> > + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
> > + * prior to conversion.
> > + */
> > +int16_t
> > +cvt_s16(
> > +	char		*s,
> > +	int		base)
> > +{
> > +	int64_t		i;
> > +
> > +	i = cvt_s64(s, base);
> > +	if (errno)
> > +		return i;
> > +	if (i > INT16_MAX || i < INT16_MIN) {
> > +		errno = -ERANGE;
> > +		return INT16_MIN;
> > +	}
> > +	return i;
> > +}
> > +
> > +/*
> > + * Convert string to uint64_t, set errno if the conversion fails or
> > + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
> > + * prior to conversion.
> > + */
> > +uint64_t
> > +cvt_u64(
> > +	char		*s,
> > +	int		base)
> > +{
> > +	long long	i;
> > +	char		*sp;
> > +	int		c;
> 
> unused var c:
> 
> > +
> > +	errno = 0;
> > +	i = strtoll(s, &sp, base);
> > +	if (*sp == '\0' && sp != s)
> > +		return i;
> > +bad:
> 
> unused label bad:

Yeah, fixed.

--D

> > +	errno = -ERANGE;
> > +	return UINT64_MAX;
> > +}
> > +
> > +/*
> > + * Convert string to uint32_t, set errno if the conversion fails or
> > + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
> > + * prior to conversion.
> > + */
> > +uint32_t
> > +cvt_u32(
> > +	char		*s,
> > +	int		base)
> > +{
> > +	uint64_t	i;
> > +
> > +	i = cvt_u64(s, base);
> > +	if (errno)
> > +		return i;
> > +	if (i > UINT32_MAX) {
> > +		errno = -ERANGE;
> > +		return UINT32_MAX;
> > +	}
> > +	return i;
> > +}
> > +
> > +/*
> > + * Convert string to uint16_t, set errno if the conversion fails or
> > + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
> > + * prior to conversion.
> > + */
> > +uint16_t
> > +cvt_u16(
> > +	char		*s,
> > +	int		base)
> > +{
> > +	uint64_t	i;
> > +
> > +	i = cvt_u64(s, base);
> > +	if (errno)
> > +		return i;
> > +	if (i > UINT16_MAX) {
> > +		errno = -ERANGE;
> > +		return UINT16_MAX;
> > +	}
> > +	return i;
> > +}
> > +
> >  #define EXABYTES(x)	((long long)(x) << 60)
> >  #define PETABYTES(x)	((long long)(x) << 50)
> >  #define TERABYTES(x)	((long long)(x) << 40)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
