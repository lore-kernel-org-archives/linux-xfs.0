Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B62C4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 16:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE6E2389E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 16:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgLQQgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:36:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgLQQgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Dec 2020 11:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608222918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4CKuD1W7ChDE2WYgxIRTHIn0WivC0nHT/CX0PPGyANQ=;
        b=FwSrinDZc0BWjp9flq/u+jH5XcLr/XnFeplbo08qQwcBQaBo2j96pUOn/ydvPKQlWj3J/x
        bYYQOqjAJ+C0cfZz6rOQxKlxpSewR6yxryt1UqFBYbJ4ngwM66GqVnojyKEbvPkp1Xwq49
        GtfJhzwOvKsN0TCCePWvvpDDUWfsu4k=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-qm-gjHomMCi9Vj1b6IDEHw-1; Thu, 17 Dec 2020 11:35:15 -0500
X-MC-Unique: qm-gjHomMCi9Vj1b6IDEHw-1
Received: by mail-pf1-f200.google.com with SMTP id 193so18940976pfz.9
        for <linux-xfs@vger.kernel.org>; Thu, 17 Dec 2020 08:35:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4CKuD1W7ChDE2WYgxIRTHIn0WivC0nHT/CX0PPGyANQ=;
        b=NAh/nFXR9xT1vr2qVHuTeQtZrwZWs9IdT4jLKTmP6iKjqH+ylTERqGi4DYGp4wyflZ
         DVD2uzc4g6ONrUDi3OGy13fj3bNfpB04YimUIWH8B35jzR/pfJU0s228TmD1hsyiVP1K
         5aHqu2s+yG7j2SKP8EBUou2NBZuxxPmIFQBQH2li8GEIcodJ839xlm9Gpu7UXSj+9VhG
         u1toWjQIjvAqXmoJT+YKnt0+UEUL4NlNy8f6g4SBnhymUGjqq2uQehPsrslzkQCcM6p9
         ymVLuXzaSYMJ58VkSv1v3STVDLQR1jXvj9Qr1gMyRBfPUUeLP7PQEe7F/HLy2N+2KB8/
         P76A==
X-Gm-Message-State: AOAM530dcIFDYfjR8u2BOSEXdMrmHY6ze7h+eiDuDrFnCzYBhUF4ilPS
        GQfuoDY4hbxEm45ATaoOVI7/5XioDq3Ve28pptOUSJRciC9jK851lcdghpDonTTsmE1HLhERPzn
        bE/5u7s+saF2qFQL6BWk3
X-Received: by 2002:a17:902:9694:b029:db:d855:d166 with SMTP id n20-20020a1709029694b02900dbd855d166mr34458638plp.71.1608222913862;
        Thu, 17 Dec 2020 08:35:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsu7ljSy1uFI6NdUzq2MvwaaJnPRAsYjmm8iP/kXkfAJj1NP24hUZpQ481lcb4z7T0caZQKQ==
X-Received: by 2002:a17:902:9694:b029:db:d855:d166 with SMTP id n20-20020a1709029694b02900dbd855d166mr34458603plp.71.1608222913498;
        Thu, 17 Dec 2020 08:35:13 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d38sm6752661pgb.20.2020.12.17.08.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 08:35:13 -0800 (PST)
Date:   Fri, 18 Dec 2020 00:35:03 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: sync lazy sb accounting on quiesce of read-only
 mounts
Message-ID: <20201217163503.GA994168@xiangao.remote.csb>
References: <20201217145334.2512475-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201217145334.2512475-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 17, 2020 at 09:53:34AM -0500, Brian Foster wrote:
> xfs_log_sbcount() syncs the superblock specifically to accumulate
> the in-core percpu superblock counters and commit them to disk. This
> is required to maintain filesystem consistency across quiesce
> (freeze, read-only mount/remount) or unmount when lazy superblock
> accounting is enabled because individual transactions do not update
> the superblock directly.
> 
> This mechanism works as expected for writable mounts, but
> xfs_log_sbcount() skips the update for read-only mounts. Read-only
> mounts otherwise still allow log recovery and write out an unmount
> record during log quiesce. If a read-only mount performs log
> recovery, it can modify the in-core superblock counters and write an
> unmount record when the filesystem unmounts without ever syncing the
> in-core counters. This leaves the filesystem with a clean log but in
> an inconsistent state with regard to lazy sb counters.
> 
> Update xfs_log_sbcount() to use the same logic
> xfs_log_unmount_write() uses to determine when to write an unmount
> record. We can drop the freeze state check because the update is
> already allowed during the freezing process and no context calls
> this function on an already frozen fs. This ensures that lazy
> accounting is always synced before the log is cleaned. Refactor this
> logic into a new helper to distinguish between a writable filesystem
> and a writable log. Specifically, the log is writable unless the
> filesystem is mounted with the norecovery mount option, the
> underlying log device is read-only, or the filesystem is shutdown.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

It seems I get the point... Although a minor thing is that I think if
xfs_log_writable() in xfs_log_sbcount() is false, there is no need to
xfs_log_quiesce() entirely then... But that may be another rework story.

So overall, it looks good to me:
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

> ---
> 
> This is something I noticed when reworking the log quiesce code to reuse
> log covering. It seems like a bug worth an independent fix, so I peeled
> it off into a standalone patch. Note that the broader rework currently
> removes both xfs_log_sbcount() and xfs_quiesce_attr(), so this is
> intended to be an isolated/backportable bug fix. The problem is easily
> reproducible with a small tweak to generic/388 that I'll post shortly...
> 
> Brian
> 
>  fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
>  fs/xfs/xfs_log.h   |  1 +
>  fs/xfs/xfs_mount.c |  3 +--
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa2d05e65ff1..b445e63cbc3c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -347,6 +347,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
>  	tic->t_res_num++;
>  }
>  
> +bool
> +xfs_log_writable(
> +	struct xfs_mount	*mp)
> +{
> +	/*
> +	 * Never write to the log on norecovery mounts, if the block device is
> +	 * read-only, or if the filesystem is shutdown. Read-only mounts still
> +	 * allow internal writes for log recovery and unmount purposes, so don't
> +	 * restrict that case here.
> +	 */
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
> +		return false;
> +	if (xfs_readonly_buftarg(mp->m_log->l_targ))
> +		return false;
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return false;
> +	return true;
> +}
> +
>  /*
>   * Replenish the byte reservation required by moving the grant write head.
>   */
> @@ -886,15 +905,8 @@ xfs_log_unmount_write(
>  {
>  	struct xlog		*log = mp->m_log;
>  
> -	/*
> -	 * Don't write out unmount record on norecovery mounts or ro devices.
> -	 * Or, if we are doing a forced umount (typically because of IO errors).
> -	 */
> -	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
> -	    xfs_readonly_buftarg(log->l_targ)) {
> -		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> +	if (!xfs_log_writable(mp))
>  		return;
> -	}
>  
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 58c3fcbec94a..98c913da7587 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -127,6 +127,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
>  int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
>  void      xfs_log_unmount(struct xfs_mount *mp);
>  int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
> +bool	xfs_log_writable(struct xfs_mount *mp);
>  
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
>  void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7110507a2b6b..a62b8a574409 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1176,8 +1176,7 @@ xfs_fs_writable(
>  int
>  xfs_log_sbcount(xfs_mount_t *mp)
>  {
> -	/* allow this to proceed during the freeze sequence... */
> -	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
> +	if (!xfs_log_writable(mp))
>  		return 0;
>  
>  	/*
> -- 
> 2.26.2
> 

