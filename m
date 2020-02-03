Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A0FC35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8E420720
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgBCXfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 18:35:07 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33890 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726287AbgBCXfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 18:35:07 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 41F5C3A286E;
        Tue,  4 Feb 2020 10:35:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iylFA-0006eI-J6; Tue, 04 Feb 2020 10:35:04 +1100
Date:   Tue, 4 Feb 2020 10:35:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 6/7] xfs: update excl. lock check for IOLOCK and ILOCK
Message-ID: <20200203233504.GI20628@dread.disaster.area>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-7-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203175850.171689-7-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=tJt1dGW8nmEQuiws8H0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 06:58:49PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c3638552b3c0..2d371f87e890 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5829,7 +5829,8 @@ xfs_bmap_collapse_extents(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL) ||
> +		xfs_is_ilocked(ip, XFS_ILOCK_EXCL));

Hmmm. I think this is incorrect - a bug in the original code in that
xfs_isilocked() will only check one lock type and so this never
worked as intended.

That is, we should have both the IOLOCK and the ILOCK held here.
The IOLOCK is taken by the high level xfs_file_fallocate() code to
lock out IO, while ILOCK is taken cwinside the transaction to make
the metadata changes atomic.

Hence I think this should actually end up as:

	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL));
	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));

>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(tp, ip, whichfork);
> @@ -5946,7 +5947,8 @@ xfs_bmap_insert_extents(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_is_iolocked(ip, XFS_IOLOCK_EXCL) ||
> +		xfs_is_ilocked(ip, XFS_ILOCK_EXCL));

Same here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
