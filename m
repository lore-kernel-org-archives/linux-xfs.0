Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18513C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 08:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E96C2206BF
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 08:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfH0IPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 04:15:33 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34118 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730905AbfH0IPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 04:15:33 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1723F43C2B4;
        Tue, 27 Aug 2019 18:15:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2WdU-000447-8N; Tue, 27 Aug 2019 18:15:28 +1000
Date:   Tue, 27 Aug 2019 18:15:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_spaceman: convert open-coded unit conversions to
 helpers
Message-ID: <20190827081528.GH1119@dread.disaster.area>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
 <156685444520.2839773.6764652190281485485.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685444520.2839773.6764652190281485485.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=5OE_as4z-lGFKXDfRq4A:9
        a=rC6LU9Pu0z2Kov8d:21 a=qUEhIRFckoCMyTDG:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:20:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create xfrog analogues of the libxfs byte/sector/block conversion
> functions and convert spaceman to use them instead of open-coded
> arithmatic we do now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/xfrog.h   |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  libfrog/fsgeom.c  |    1 +
>  spaceman/freesp.c |   18 ++++++--------
>  spaceman/trim.c   |    9 ++++---
>  4 files changed, 80 insertions(+), 14 deletions(-)

....
> +/* Convert fs block number to sector number. */
> +static inline uint64_t
> +xfrog_fsb_to_bb(
> +	struct xfs_fd		*xfd,
> +	uint64_t		fsbno)
> +{
> +	return fsbno << xfd->blkbb_log;
> +}
> +
> +/* Convert sector number to fs block number, rounded down. */
> +static inline uint64_t
> +xfrog_bb_to_fsbt(
> +	struct xfs_fd		*xfd,
> +	uint64_t		daddr)
> +{
> +	return daddr >> xfd->blkbb_log;
> +}

Same comment as previous ones about off_fsb_to_<foo> and vice versa.

And the more I see it, the less "xfrog" really means in these unit
conversion functions. How about we prefix them "cvt_"?

Then the name of the function actually does exactly what is says.
i.e. "convert basic blocks to offset in filesystem blocks"

> @@ -174,8 +170,10 @@ scan_ag(
>  	l = fsmap->fmh_keys;
>  	h = fsmap->fmh_keys + 1;
>  	if (agno != NULLAGNUMBER) {
> -		l->fmr_physical = agno * bperag;
> -		h->fmr_physical = ((agno + 1) * bperag) - 1;
> +		l->fmr_physical = xfrog_bbtob(
> +				xfrog_agb_to_daddr(xfd, agno, 0));
> +		h->fmr_physical = xfrog_bbtob(
> +				xfrog_agb_to_daddr(xfd, agno + 1, 0));
>  		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
>  	} else {
>  		l->fmr_physical = 0;

This is why - that's quite hard to read. A simple wrapper might be
better:

static inline uint64_t
cvt_agbno_to_off_b(
	struct xfs_fd		*xfd,
	xfs_agnumber_t		agno,
	xfs_agblock_t		agbno)
{
	return cvt_bbtob(cvt_agbno_to_daddr(xfd, agno, agbno));
}

And then we have:

		l->fmr_physical = cvt_agbno_to_off_b(xfd, agno, 0);
		h->fmr_physical = cvt_agbno_to_off_b(xfd, agno + 1, 0);


> @@ -206,9 +204,9 @@ scan_ag(
>  			if (!(extent->fmr_flags & FMR_OF_SPECIAL_OWNER) ||
>  			    extent->fmr_owner != XFS_FMR_OWN_FREE)
>  				continue;
> -			agbno = (extent->fmr_physical - (bperag * agno)) /
> -								blocksize;
> -			aglen = extent->fmr_length / blocksize;
> +			agbno = xfrog_daddr_to_agbno(xfd,
> +					xfrog_btobbt(extent->fmr_physical));

That's the reverse - cvt_off_b_to_agbno().

> +			aglen = xfrog_b_to_fsbt(xfd, extent->fmr_length);
>  			freeblks += aglen;
>  			freeexts++;
>  
> diff --git a/spaceman/trim.c b/spaceman/trim.c
> index ea1308f7..8741bab2 100644
> --- a/spaceman/trim.c
> +++ b/spaceman/trim.c
> @@ -23,7 +23,8 @@ trim_f(
>  	char			**argv)
>  {
>  	struct fstrim_range	trim = {0};
> -	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
> +	struct xfs_fd		*xfd = &file->xfd;
> +	struct xfs_fsop_geom	*fsgeom = &xfd->fsgeom;
>  	xfs_agnumber_t		agno = 0;
>  	off64_t			offset = 0;
>  	ssize_t			length = 0;
> @@ -66,11 +67,11 @@ trim_f(
>  		length = cvtnum(fsgeom->blocksize, fsgeom->sectsize,
>  				argv[optind + 1]);
>  	} else if (agno) {
> -		offset = (off64_t)agno * fsgeom->agblocks * fsgeom->blocksize;
> -		length = fsgeom->agblocks * fsgeom->blocksize;
> +		offset = xfrog_bbtob(xfrog_agb_to_daddr(xfd, agno, 0));
> +		length = xfrog_fsb_to_b(xfd, fsgeom->agblocks);

cvt_agbno_to_off_b() again...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
