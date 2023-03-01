Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF425C64EC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 00:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjCAAjG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 19:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjCAAjE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 19:39:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922F9C17D
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 16:39:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F051B80E95
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 00:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7C8C433EF;
        Wed,  1 Mar 2023 00:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677631141;
        bh=H+GofQ9iJygh3yjGPcQyY2LfGnunEbIp8xhGx57CMZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N3vAJgbpP2Sk+9udg82W96Ppp46ABrI4IE7nGH7kS+6RxaFibTZcU4LgcoA+vLo2T
         veIQWu5CLF5mb6YVzdZ2XfSTMbtMlvdUK0Q338RCKr1xxe9eiXdSx6KTk8mbmONgPK
         b7ryFk2Tq4H325N6fQUlh1PjS4FhHG+JH9ogIInWBNFNxSmWWaQOcPRRDj6ro1pZF0
         96osdvWqoO4DN7rPZvFca2hYVfwwSlIUEQ9aXYNdmHDfp3n+OEs2sQ99QZwA6wGMT/
         a4QF3eAaHkosjmn70bSUk2uMuRII1s62WERDy5srKWZ2900h0NrSsogVVj5rsTRyFo
         qP297u+NB7cNA==
Date:   Tue, 28 Feb 2023 16:39:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: quotacheck failure can race with background inode
 inactivation
Message-ID: <Y/6epIzi5Y23w69v@magnolia>
References: <20230228051250.1238353-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228051250.1238353-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 28, 2023 at 04:12:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The background inode inactivation can attached dquots to inodes, but
> this can race with a foreground quotacheck failure that leads to
> disabling quotas and freeing the mp->m_quotainfo structure. The
> background inode inactivation then tries to allocate a quota, tries
> to dereference mp->m_quotainfo, and crashes like so:
> 
> XFS (loop1): Quotacheck: Unsuccessful (Error -5): Disabling quotas.
> xfs filesystem being mounted at /root/syzkaller.qCVHXV/0/file0 supports timestamps until 2038 (0x7fffffff)
> BUG: kernel NULL pointer dereference, address: 00000000000002a8
> ....
> CPU: 0 PID: 161 Comm: kworker/0:4 Not tainted 6.2.0-c9c3395d5e3d #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> Workqueue: xfs-inodegc/loop1 xfs_inodegc_worker
> RIP: 0010:xfs_dquot_alloc+0x95/0x1e0
> ....
> Call Trace:
>  <TASK>
>  xfs_qm_dqread+0x46/0x440
>  xfs_qm_dqget_inode+0x154/0x500
>  xfs_qm_dqattach_one+0x142/0x3c0
>  xfs_qm_dqattach_locked+0x14a/0x170
>  xfs_qm_dqattach+0x52/0x80
>  xfs_inactive+0x186/0x340
>  xfs_inodegc_worker+0xd3/0x430
>  process_one_work+0x3b1/0x960
>  worker_thread+0x52/0x660
>  kthread+0x161/0x1a0
>  ret_from_fork+0x29/0x50
>  </TASK>
> ....
> 
> Prevent this race by flushing all the queued background inode
> inactivations pending before purging all the cached dquots when
> quotacheck fails.
> 
> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Makes sense,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 40 ++++++++++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index e2c542f6dcd4..78ca52e55f03 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1321,15 +1321,14 @@ xfs_qm_quotacheck(
>  
>  	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
>  			NULL);
> -	if (error) {
> -		/*
> -		 * The inode walk may have partially populated the dquot
> -		 * caches.  We must purge them before disabling quota and
> -		 * tearing down the quotainfo, or else the dquots will leak.
> -		 */
> -		xfs_qm_dqpurge_all(mp);
> -		goto error_return;
> -	}
> +
> +	/*
> +	 * On error, the inode walk may have partially populated the dquot
> +	 * caches.  We must purge them before disabling quota and tearing down
> +	 * the quotainfo, or else the dquots will leak.
> +	 */
> +	if (error)
> +		goto error_purge;
>  
>  	/*
>  	 * We've made all the changes that we need to make incore.  Flush them
> @@ -1363,10 +1362,8 @@ xfs_qm_quotacheck(
>  	 * and turn quotaoff. The dquots won't be attached to any of the inodes
>  	 * at this point (because we intentionally didn't in dqget_noattach).
>  	 */
> -	if (error) {
> -		xfs_qm_dqpurge_all(mp);
> -		goto error_return;
> -	}
> +	if (error)
> +		goto error_purge;
>  
>  	/*
>  	 * If one type of quotas is off, then it will lose its
> @@ -1376,7 +1373,7 @@ xfs_qm_quotacheck(
>  	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
>  	mp->m_qflags |= flags;
>  
> - error_return:
> +error_return:
>  	xfs_buf_delwri_cancel(&buffer_list);
>  
>  	if (error) {
> @@ -1395,6 +1392,21 @@ xfs_qm_quotacheck(
>  	} else
>  		xfs_notice(mp, "Quotacheck: Done.");
>  	return error;
> +
> +error_purge:
> +	/*
> +	 * On error, we may have inodes queued for inactivation. This may try
> +	 * to attach dquots to the inode before running cleanup operations on
> +	 * the inode and this can race with the xfs_qm_destroy_quotainfo() call
> +	 * below that frees mp->m_quotainfo. To avoid this race, flush all the
> +	 * pending inodegc operations before we purge the dquots from memory,
> +	 * ensuring that background inactivation is idle whilst we turn off
> +	 * quotas.
> +	 */
> +	xfs_inodegc_flush(mp);
> +	xfs_qm_dqpurge_all(mp);
> +	goto error_return;
> +
>  }
>  
>  /*
> -- 
> 2.39.2
> 
