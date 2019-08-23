Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7355C3A589
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 04:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A965233FD
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 04:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389942AbfHWE4c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 00:56:32 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37839 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfHWE4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 00:56:32 -0400
Received: from dread.disaster.area (pa49-181-142-13.pa.nsw.optusnet.com.au [49.181.142.13])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 933B043E733;
        Fri, 23 Aug 2019 14:56:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i11bc-0000OH-9B; Fri, 23 Aug 2019 14:55:20 +1000
Date:   Fri, 23 Aug 2019 14:55:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
Message-ID: <20190823045520.GH1119@dread.disaster.area>
References: <20190823035528.GH1037422@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823035528.GH1037422@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=pdRIKMFd4+xhzJrg6WzXNA==:117 a=pdRIKMFd4+xhzJrg6WzXNA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=mfFUQ52AFmyX5K1GptkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 08:55:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Benjamin Moody reported to Debian that XFS partially wedges when a chgrp
> fails on account of being out of disk quota.  I ran his reproducer
> script:
> 
> # adduser dummy
> # adduser dummy plugdev
> 
> # dd if=/dev/zero bs=1M count=100 of=test.img
> # mkfs.xfs test.img
> # mount -t xfs -o gquota test.img /mnt
> # mkdir -p /mnt/dummy
> # chown -c dummy /mnt/dummy
> # xfs_quota -xc 'limit -g bsoft=100k bhard=100k plugdev' /mnt
> 
> (and then as user dummy)
> 
> $ dd if=/dev/urandom bs=1M count=50 of=/mnt/dummy/foo
> $ chgrp plugdev /mnt/dummy/foo
> 
> and saw:
> 
> ================================================
> WARNING: lock held when returning to user space!
> 5.3.0-rc5 #rc5 Tainted: G        W
> ------------------------------------------------
> chgrp/47006 is leaving the kernel with locks still held!
> 1 lock held by chgrp/47006:
>  #0: 000000006664ea2d (&xfs_nondir_ilock_class){++++}, at: xfs_ilock+0xd2/0x290 [xfs]
> 
> ...which is clearly caused by xfs_setattr_nonsize failing to unlock the
> ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
> unlock.
> 
> Reported-by: benjamin.moody@gmail.com
> Fixes: 253f4911f297 ("xfs: better xfs_trans_alloc interface")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iops.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index dd4076ae228a..ea614b4ae052 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -804,6 +804,7 @@ xfs_setattr_nonsize(
>  
>  out_cancel:
>  	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out_dqrele:
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);

/me goes back an looks at 253f4911f297 ("xfs: better xfs_trans_alloc
interface")

Fmeh. The original patch posting did:

out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-out_trans_cancel:
-	xfs_trans_cancel(tp);
+out_dqrele:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	return error;

Which leaked the transaction. Looks like I screwed up fixing that
up on commit - it no longer leaked the transaction, but leaked the
lock instead. And 3 and half years later someone notices it...

Oh, gawd that code is so grotty! I started saying "maybe we
should..." and then stopped when I realised just how much cleanup
needs to be done to that function...

The above patch fixes the issue, iso consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
