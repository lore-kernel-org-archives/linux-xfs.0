Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22328 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755701AbdKJDVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 22:21:11 -0500
Date: Thu, 9 Nov 2017 19:21:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: fix gcc-7 related printf warnings
Message-ID: <20171110032104.GA25227@magnolia>
References: <20171110013926.15289-1-david@fromorbit.com>
 <ac210659-80a1-1eec-3704-a79d650ada40@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac210659-80a1-1eec-3704-a79d650ada40@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Nov 09, 2017 at 07:43:59PM -0600, Eric Sandeen wrote:
> On 11/9/17 7:39 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > New compiler, new checks, new warnings.
> > 
> > Fix the new [-Wformat-truncation=] warnings that io/fsmap.c is
> > throwing w/ gcc-7.2 because "%lld..%lld" requires a buffer 40
> > characters long, not 32.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> 
> 2^63 is 19 chars, yup.
> 
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
> 
> > ---
> >  io/fsmap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/io/fsmap.c b/io/fsmap.c
> > index 448fb5356466..e46fdbaa148c 100644
> > --- a/io/fsmap.c
> > +++ b/io/fsmap.c
> > @@ -184,8 +184,8 @@ dump_map_verbose(
> >  	off64_t			agoff, bperag;
> >  	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
> >  	int			nr_w, dev_w;
> > -	char			rbuf[32], bbuf[32], abuf[32], obuf[32];
> > -	char			nbuf[32], dbuf[32], gbuf[32];
> > +	char			rbuf[40], bbuf[40], abuf[40], obuf[40];
> > +	char			nbuf[40], dbuf[40], gbuf[40];

Waitaminute.  The longest format string is bbuf, which gets
"[%lld..%lld]:".  The longest number %lld can print is
"-9223372036854775807" which requires 20 bytes.  Therefore, bbuf needs
1 + 20 + 2 + 20 + 2 + 1 == 46 bytes, not 40.  rbuf and abuf have similar
problems, though I guess a 48-byte string will work for all.

Granted, it's snprintf so it'll just truncate the second number if it
has to, but seeing as this came from a gcc warning:

"fsmap.c:228:3: note: ‘snprintf’ output between 8 and 40 bytes into a
destination of size 32"

So am I just bad at math, or is gcc wrong here?

--D

> >  	char			owner[OWNER_BUF_SZ];
> >  	int			sunit, swidth;
> >  	int			flg = 0;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
