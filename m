Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92IZApg073963 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 13:35:10 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	08SwQnr86TktF3qA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 11:36:34 -0700 (PDT)
Received: by obbun3 with SMTP id un3so7417855obb.26
	for <xfs@oss.sgi.com>; Tue, 02 Oct 2012 11:36:33 -0700 (PDT)
Date: Tue, 2 Oct 2012 10:47:18 -0600 (MDT)
From: Anand Tiwari <tiwarikanand@gmail.com>
Subject: Re: xfs_repair deleting realtime files.
In-Reply-To: <20121002005906.GL23520@dastard>
Message-ID: <alpine.DEB.2.02.1210021039330.21488@artemis>
References: <505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
	<CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
	<20120926024403.GH29154@dastard>
	<CAHt31__FPLsDdVCVwwLO0Sh9v_KK2pzU577nywFPAmf_C-gRcQ@mail.gmail.com>
	<20120926061732.GI29154@dastard>
	<CAHt31__59_XJw9EF7MniiYH5sS6CX44q9gGwxiqxx43k5OFZ4A@mail.gmail.com>
	<20120928064742.GE25626@dastard>
	<alpine.DEB.2.02.1209291645330.7208@artemis>
	<20121002005906.GL23520@dastard>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Anand Tiwari <tiwarikanand@gmail.com>, xfs@oss.sgi.com



On Tue, 2 Oct 2012, Dave Chinner wrote:

> On Sat, Sep 29, 2012 at 04:49:03PM -0600, Anand Tiwari wrote:
> > Subject: [PATCH] xfs_repair: detect realtime extent shared by multiple
> >  records in extent map
> >
> > XFS currently can have records in extent map, which starts from unaligned start block w.r.t rextsize.
> > xfs_repair considers this as a bug (multiple claims for a real-time extent) and deletes the file.
> > This patch addresses the issue, by comparing current and previous records and make sure they are
> > contiguous and not overlapped.
> >
> > Signed-off-by: Anand Tiwari <anand.tiwari@linux.com>
> > ---
> >  repair/dinode.c |   37 ++++++++++++++++++++++++++++++++++---
> >  1 file changed, 34 insertions(+), 3 deletions(-)
> >
> > diff --git a/repair/dinode.c b/repair/dinode.c
> > index 5a2da39..5537f1c 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -406,6 +406,7 @@ verify_agbno(xfs_mount_t	*mp,
> >  static int
> >  process_rt_rec(
> >  	xfs_mount_t		*mp,
> > +	xfs_bmbt_irec_t 	*prev,
> >  	xfs_bmbt_irec_t 	*irec,
> >  	xfs_ino_t		ino,
> >  	xfs_drfsbno_t		*tot,
> > @@ -413,8 +414,11 @@ process_rt_rec(
> >  {
> >  	xfs_dfsbno_t		b;
> >  	xfs_drtbno_t		ext;
> > +	xfs_drtbno_t		start_block;
> > +	xfs_filblks_t		block_count;
> >  	int			state;
> >  	int			pwe;		/* partially-written extent */
> > +	int 			rtext_remainder;	/* start block is not aligned w.r.t rextsize */
> >
> >  	/*
> >  	 * check numeric validity of the extent
> > @@ -461,12 +465,32 @@ _("malformed rt inode extent [%" PRIu64 " %" PRIu64 "] (fs rtext size = %u)\n"),
> >  		return 1;
> >  	}
> >
> > +	/* If we have start of record unaligned w.r.t to rextsize, see
> > +	 * if we are sharing this realtime extent with previous record. sharing is only
> > +	 * allowed with previous extent. fail otherwise.
> > +	 * Also, we above condition is true, align start block and block count
> > +	 */
>
> Comment format is:
>
> /*
>  * this is a
>  * multiline comment
>  */
>
> > +	rtext_remainder = irec->br_startblock % mp->m_sb.sb_rextsize;
> > +	if (rtext_remainder) {
> > +		do_warn(
> > +_("data fork in rt ino %" PRIu64 " has unalinged start block %"PRIu64 "\n"),
>                                           unaligned
>
> > +		ino,
> > +		irec->br_startblock);
>
> indent these a bit so the fact they are part of the do_warn function
> call is obvious. i.e.
>
> 		do_warn(
> 				<format string>
> 			ino, irec->br_startblock);
>
> > +		if ((prev->br_startoff + prev->br_blockcount == irec->br_startoff) &&
> > +		    (prev->br_startblock + prev->br_blockcount == irec->br_startblock)) {
> > +			start_block = irec->br_startblock + (mp->m_sb.sb_rextsize - rtext_remainder);
> > +			block_count = irec->br_blockcount - (mp->m_sb.sb_rextsize - rtext_remainder);
> > +		}
> > +	} else {
> > +		start_block = irec->br_startblock;
> > +		block_count = irec->br_blockcount;
> > +	}
>
> So this just changes the loop below not to check the first part of
> the new extent and therefore avoid the duplicate extent usage
> detection?
>
> Any plans to correct the bmapbt extents so that repeated repair runs
> don't keep warning about the same problem?
>

I was planning on fixing kernel code first and tackle this later. Let me
know if you guys think otherwise.

> > +
> >  	/*
> >  	 * set the appropriate number of extents
> >  	 * this iterates block by block, this can be optimised using extents
> >  	 */
> > -	for (b = irec->br_startblock; b < irec->br_startblock +
> > -			irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {
> > +	for (b = start_block; b < start_block + block_count; b += mp->m_sb.sb_rextsize)  {
> >  		ext = (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;
> >  		pwe = xfs_sb_version_hasextflgbit(&mp->m_sb) &&
> >  				irec->br_state == XFS_EXT_UNWRITTEN &&
> > @@ -548,6 +572,7 @@ process_bmbt_reclist_int(
> >  	int			check_dups,
> >  	int			whichfork)
> >  {
> > +	xfs_bmbt_irec_t		prev;
> >  	xfs_bmbt_irec_t		irec;
> >  	xfs_dfilblks_t		cp = 0;		/* prev count */
> >  	xfs_dfsbno_t		sp = 0;		/* prev start */
> > @@ -574,6 +599,11 @@ process_bmbt_reclist_int(
> >  	else
> >  		ftype = _("regular");
> >
> > +	prev.br_startoff = 0;
> > +	prev.br_blockcount = 0;
> > +	prev.br_startblock = 0;
> > +	prev.br_state = 0;
>
> 	memset(&prev, 0, sizeof(prev));
>

which one is more preferred in XFS land,
a) 	xfs_bmbt_irec_t		prev = {0};
b)	memset(&prev, 0, sizeof(prev));

my vote is "a". I already addressed other suggestions.

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

thanks a bunch,
anand

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
