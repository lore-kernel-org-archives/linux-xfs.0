Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7ED9B7F56
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2015 07:19:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D752304032
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2015 05:19:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0m5U00IF6aEB3v6U (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 14 Mar 2015 05:19:54 -0700 (PDT)
Date: Sat, 14 Mar 2015 08:19:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_db: Allow writes of corrupted data by optionally
	skipping write verifiers
Message-ID: <20150314121950.GA16452@bfoster.bfoster>
References: <54F8CA08.303@redhat.com> <20150313134317.GC2678@laptop.bfoster>
	<55036930.5020204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55036930.5020204@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 13, 2015 at 05:48:16PM -0500, Eric Sandeen wrote:
> On 3/13/15 8:43 AM, Brian Foster wrote:
> > On Thu, Mar 05, 2015 at 03:26:32PM -0600, Eric Sandeen wrote:
> >> Being able to write corrupt data is handy if we wish to test
> >> repair against specific types of corruptions.
> >>
> >> Add a "-c" option to the write command which allows this.
> >>
> >> Note that this also skips CRC updates; it's not currently possible
> >> to write invalid data with a valid CRC; CRC recalculation is
> >> intertwined with validation.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/db/crc.c b/db/crc.c
> >> index ad46c3f..861086a 100644
> >> --- a/db/crc.c
> >> +++ b/db/crc.c
> > 
> > This depends on the previous crc command which isn't merged yet. It
> > might be worth it to include that again here so it hopefully gets picked
> > up.
> > 
> >> @@ -58,13 +58,6 @@ crc_help(void)
> >>  
> >>  }
> >>  
> >> -void
> >> -xfs_dummy_verify(
> >> -	struct xfs_buf *bp)
> >> -{
> >> -	return;
> >> -}
> >> -
> >>  static int
> >>  crc_f(
> >>  	int		argc,
> >> diff --git a/db/crc.h b/db/crc.h
> >> index 80ecec3..9f44615 100644
> >> --- a/db/crc.h
> >> +++ b/db/crc.h
> >> @@ -20,4 +20,3 @@ struct field;
> >>  
> >>  extern void	crc_init(void);
> >>  extern void	crc_struct(const field_t *fields, int argc, char **argv);
> >> -extern void	xfs_dummy_verify(struct xfs_buf *bp);
> >> diff --git a/db/io.c b/db/io.c
> >> index eb3daa1..2d18d56 100644
> >> --- a/db/io.c
> >> +++ b/db/io.c
> >> @@ -458,6 +458,13 @@ write_cur_bbs(void)
> >>  }
> >>  
> >>  void
> >> +xfs_dummy_verify(
> >> +	struct xfs_buf *bp)
> >> +{
> >> +	return;
> >> +}
> >> +
> >> +void
> >>  write_cur(void)
> >>  {
> >>  	int skip_crc = (iocur_top->bp->b_ops->verify_write == xfs_dummy_verify);
> >> diff --git a/db/io.h b/db/io.h
> >> index 71082e6..31d96b4 100644
> >> --- a/db/io.h
> >> +++ b/db/io.h
> >> @@ -63,6 +63,7 @@ extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
> >>  			bbmap_t *bbmap);
> >>  extern void     ring_add(void);
> >>  extern void	set_iocur_type(const struct typ *t);
> >> +extern void	xfs_dummy_verify(struct xfs_buf *bp);
> >>  
> >>  /*
> >>   * returns -1 for unchecked, 0 for bad and 1 for good
> >> diff --git a/db/write.c b/db/write.c
> >> index a0f14f4..a01c25a 100644
> >> --- a/db/write.c
> >> +++ b/db/write.c
> >> @@ -38,7 +38,7 @@ static int	write_f(int argc, char **argv);
> >>  static void     write_help(void);
> >>  
> >>  static const cmdinfo_t	write_cmd =
> >> -	{ "write", NULL, write_f, 0, -1, 0, N_("[field or value]..."),
> >> +	{ "write", NULL, write_f, 0, -1, 0, N_("[-c] [field or value]..."),
> >>  	  N_("write value to disk"), write_help };
> >>  
> >>  void
> >> @@ -79,6 +79,7 @@ write_help(void)
> >>  "  String mode: 'write \"This_is_a_filename\" - write null terminated string.\n"
> >>  "\n"
> >>  " In data mode type 'write' by itself for a list of specific commands.\n\n"
> >> +" Specifying the -c option will allow writes of invalid (corrupt) data.\n\n"
> >>  ));
> >>  
> >>  }
> >> @@ -90,6 +91,9 @@ write_f(
> >>  {
> >>  	pfunc_t	pf;
> >>  	extern char *progname;
> >> +	int c;
> >> +	int corrupt = 0;		/* Allow write of corrupt data; skip verification */
> >> +	const struct xfs_buf_ops *stashed_ops = NULL; 
> > 
> > Trailing space here.
> > 
> >>  
> >>  	if (x.isreadonly & LIBXFS_ISREADONLY) {
> >>  		dbprintf(_("%s started in read only mode, writing disabled\n"),
> >> @@ -109,12 +113,36 @@ write_f(
> >>  		return 0;
> >>  	}
> >>  
> >> -	/* move past the "write" command */
> >> -	argc--;
> >> -	argv++;
> >> +	if (argc) while ((c = getopt(argc, argv, "c")) != EOF) {
> > 
> > Isn't argc always going to be non-zero at this point (e.g., argv[0] ==
> > "write")?
> 
> Hm, yeah, not sure if that was a thinko or a typo, thanks.
> 
> (hm, db's bmap_f does the same thing, I might have just blindly copied that)
> 
> >> +	if (corrupt) {
> >> +		struct xfs_buf_ops nowrite_ops;
> >> +
> > 
> > This may not be an explicit failure, but I'd rather not define this on
> > the stack in the local scope of this branch and then implicitly use it
> > outside of that scope. Could we move the definition and possibility the
> > initialization to the top of the function?
> 
> *nod* I'll fix that too.
> 
> I'll send the crc patch & this in another 2-patch series (though I am wondering
> if the crc patch is needed, if we're able to write bad data; it kind of achieves
> the same goal - thoughts?)
> 

I suppose that makes sense, but I forget the specifics of the crc
command. Did it just munge the crc? Can we accomplish the same thing
with this command (e.g., can we write the crc field itself)? If not, I
guess it doesn't hurt to have the ability to corrupt a data structure
as well the crc itself, where the data structure could be otherwise
valid.

Brian

> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
