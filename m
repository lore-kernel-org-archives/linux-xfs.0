Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0398C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D54A60F11
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhJNQjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 12:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232090AbhJNQji (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 12:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5529660E09;
        Thu, 14 Oct 2021 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634229453;
        bh=V+xIu2w8ZXvqMRhElWV0v6opF0x85zM3Ijb8F7+/zVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XSWAEfN7dr/UOAFT7fUYrgu84FgaCkXfp8Wr7bvh9ST1OAt9c7n+xxKLl9yU2tMOn
         g1imykFDfB48qFCViv4KJrTUe8qYU0KK8LYHFFCpPy+eW+h9NT+3jjRf5sNFjErBxF
         +y116rdmhS65TTPmtWPFVcU6BIv5IGHdB4sYj0+B+r7aZ46G0MktHaF4PaKyVPjXtU
         A4wSZ4B7EnWBH6fqAIKJGUFdvnZYxC5jwhS1iidD0i35fGRYDONwuvvtsPbFy7Nzaa
         MiMnYuG9f9FKx/yYC3MyvLPQflHmbqhJGl0jLHEEi7wdrVojx4ZNwpaBhWDHJJVcMs
         N6jCus3cEv43Q==
Date:   Thu, 14 Oct 2021 09:37:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: replace snprintf in show functions with sysfs_emit
Message-ID: <20211014163732.GC24307@magnolia>
References: <1634095771-4671-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634095771-4671-1-git-send-email-wangqing@vivo.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 08:29:31PM -0700, Qing Wang wrote:
> coccicheck complains about the use of snprintf() in sysfs show functions.
> 
> Fix the coccicheck warning:
> WARNING: use scnprintf or sprintf.
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> 
> Signed-off-by: Qing Wang <wangqing@vivo.com>

This seems like a fairly straightforward conversion.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_sysfs.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index f1bc88f..3c171bf 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -104,7 +104,7 @@ bug_on_assert_show(
>  	struct kobject		*kobject,
>  	char			*buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bug_on_assert ? 1 : 0);
> +	return sysfs_emit(buf, "%d\n", xfs_globals.bug_on_assert ? 1 : 0);
>  }
>  XFS_SYSFS_ATTR_RW(bug_on_assert);
>  
> @@ -134,7 +134,7 @@ log_recovery_delay_show(
>  	struct kobject	*kobject,
>  	char		*buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.log_recovery_delay);
> +	return sysfs_emit(buf, "%d\n", xfs_globals.log_recovery_delay);
>  }
>  XFS_SYSFS_ATTR_RW(log_recovery_delay);
>  
> @@ -164,7 +164,7 @@ mount_delay_show(
>  	struct kobject	*kobject,
>  	char		*buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.mount_delay);
> +	return sysfs_emit(buf, "%d\n", xfs_globals.mount_delay);
>  }
>  XFS_SYSFS_ATTR_RW(mount_delay);
>  
> @@ -187,7 +187,7 @@ always_cow_show(
>  	struct kobject	*kobject,
>  	char		*buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.always_cow);
> +	return sysfs_emit(buf, "%d\n", xfs_globals.always_cow);
>  }
>  XFS_SYSFS_ATTR_RW(always_cow);
>  
> @@ -223,7 +223,7 @@ pwork_threads_show(
>  	struct kobject	*kobject,
>  	char		*buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
> +	return sysfs_emit(buf, "%d\n", xfs_globals.pwork_threads);
>  }
>  XFS_SYSFS_ATTR_RW(pwork_threads);
>  #endif /* DEBUG */
> @@ -326,7 +326,7 @@ log_head_lsn_show(
>  	block = log->l_curr_block;
>  	spin_unlock(&log->l_icloglock);
>  
> -	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, block);
> +	return sysfs_emit(buf, "%d:%d\n", cycle, block);
>  }
>  XFS_SYSFS_ATTR_RO(log_head_lsn);
>  
> @@ -340,7 +340,7 @@ log_tail_lsn_show(
>  	struct xlog *log = to_xlog(kobject);
>  
>  	xlog_crack_atomic_lsn(&log->l_tail_lsn, &cycle, &block);
> -	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, block);
> +	return sysfs_emit(buf, "%d:%d\n", cycle, block);
>  }
>  XFS_SYSFS_ATTR_RO(log_tail_lsn);
>  
> @@ -355,7 +355,7 @@ reserve_grant_head_show(
>  	struct xlog *log = to_xlog(kobject);
>  
>  	xlog_crack_grant_head(&log->l_reserve_head.grant, &cycle, &bytes);
> -	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
> +	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
>  }
>  XFS_SYSFS_ATTR_RO(reserve_grant_head);
>  
> @@ -369,7 +369,7 @@ write_grant_head_show(
>  	struct xlog *log = to_xlog(kobject);
>  
>  	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &bytes);
> -	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
> +	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
>  }
>  XFS_SYSFS_ATTR_RO(write_grant_head);
>  
> @@ -424,7 +424,7 @@ max_retries_show(
>  	else
>  		retries = cfg->max_retries;
>  
> -	return snprintf(buf, PAGE_SIZE, "%d\n", retries);
> +	return sysfs_emit(buf, "%d\n", retries);
>  }
>  
>  static ssize_t
> @@ -465,7 +465,7 @@ retry_timeout_seconds_show(
>  	else
>  		timeout = jiffies_to_msecs(cfg->retry_timeout) / MSEC_PER_SEC;
>  
> -	return snprintf(buf, PAGE_SIZE, "%d\n", timeout);
> +	return sysfs_emit(buf, "%d\n", timeout);
>  }
>  
>  static ssize_t
> @@ -503,7 +503,7 @@ fail_at_unmount_show(
>  {
>  	struct xfs_mount	*mp = err_to_mp(kobject);
>  
> -	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_fail_unmount);
> +	return sysfs_emit(buf, "%d\n", mp->m_fail_unmount);
>  }
>  
>  static ssize_t
> -- 
> 2.7.4
> 
