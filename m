Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6264EC35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322C220720
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgBCXZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 18:25:02 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57352 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726331AbgBCXZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 18:25:02 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9ED017EA302;
        Tue,  4 Feb 2020 10:24:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iyl5O-0006TY-L1; Tue, 04 Feb 2020 10:24:58 +1100
Date:   Tue, 4 Feb 2020 10:24:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 4/7] xfs: Update checking for iolock
Message-ID: <20200203232458.GG20628@dread.disaster.area>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203175850.171689-5-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=OWC6msWQGD-hzk2NLckA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 06:58:47PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 4 ++--
>  fs/xfs/xfs_bmap_util.c   | 4 ++--
>  fs/xfs/xfs_file.c        | 3 ++-
>  fs/xfs/xfs_inode.c       | 2 +-
>  fs/xfs/xfs_iops.c        | 2 +-
>  5 files changed, 8 insertions(+), 7 deletions(-)

....

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b8a4a3f29b36..9b3958ca73d9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -770,7 +770,8 @@ xfs_break_layouts(
>  	bool			retry;
>  	int			error;
>  
> -	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_is_iolocked(XFS_I(inode),
> +		XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));

Whitespace: XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL

Otherwise looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
