Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB34C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C6E206A1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlXc9Ddz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGAI6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGAI6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:58:14 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57E6C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:58:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cv18so5162847pjb.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jzNEORl5EvbX1XVcKco1Y5e/vpFxmJxRCfKQEXG2cm4=;
        b=DlXc9Ddzdfj0NzCA099dOB8L5ROdzGgc+fnW57zmcu6mso4q5VExP6TJogx3+93MPl
         QzBhDbheySBcNqmyMPyrBM1r846rbn3lsizUCbqhrEsEqV39mNdbvHzoZ7TIY12p/ySa
         EvNKOi3BiwDZo9nN1ZQKSu6mSgscqnbznMhYH+3NwIsIFqYZ+PNjhhIJ6blbRsOuP/Gj
         LNn8O2WwGt212Semf6N+uvRA5K1HmWN1EVUNuG4ZwDbCmoMwVQfYJqEmNvqRxAmdBvo3
         QvYhCsw8oWsYJpurqE9+g3+xclCRwdnv5kBFE9o1IcwKPchPfug1Y4Em1HzNe+k5GgHj
         LRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jzNEORl5EvbX1XVcKco1Y5e/vpFxmJxRCfKQEXG2cm4=;
        b=HVNlnMQVH8nEunxP8mD1fLtgpfnZ6gHlZoKaM1I7TER/1B7NphFFuVFgzLe6FsE5NH
         Y7Hwl4t9vdD0bFqCZ1KbHTKHtytRB44bTzBsf53PlNu+FDOY3zB9ke563NwDKaMP2l71
         OD+FF9AHsOWg5zwk7r2Iw+xgUAV+lJ+KXveQjH7rHWAorO7j+5WrUuQnCPVC0MKBlRyx
         SF66sy9GyC4dscQyJy89BFVe4nC5MFL/FhIe6+1kC9okjKaVfiuKLtSp4af7/dhrxqOt
         6izA51etko4QTVyuHym5xitSvvmBw/BJQmlE7Z7I8964hBMJ/OYCNN6/mOc4IpG2mtEl
         EWWA==
X-Gm-Message-State: AOAM531WXkpgazKbLgvJIQhPsovAg1gRrBWuklR6r63kCOmFhv3t+WmF
        I95kEmm4R6M+QDk7u8dMVg6oCwl0
X-Google-Smtp-Source: ABdhPJytnUqu7i7mtnGLJ3uMYSQHsKewpOJYHRJY+cCydkLdwM914LJ0XEtQHDNSlffrnjM+h85mXg==
X-Received: by 2002:a17:902:7247:: with SMTP id c7mr21641105pll.103.1593593893493;
        Wed, 01 Jul 2020 01:58:13 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id 193sm5066045pfz.85.2020.07.01.01.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:58:13 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/18] xfs: remove unnecessary arguments from quota adjust functions
Date:   Wed, 01 Jul 2020 14:28:10 +0530
Message-ID: <4951222.h745PxFzCZ@garuda>
In-Reply-To: <159353179380.2864738.11917531841285726141.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353179380.2864738.11917531841285726141.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:13 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> struct xfs_dquot already has a pointer to the xfs mount, so remove the
> redundant parameter from xfs_qm_adjust_dq*.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c       |    4 ++--
>  fs/xfs/xfs_dquot.h       |    6 ++----
>  fs/xfs/xfs_qm.c          |    4 ++--
>  fs/xfs/xfs_qm_syscalls.c |    2 +-
>  fs/xfs/xfs_trans_dquot.c |    4 ++--
>  5 files changed, 9 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 6975c27145fc..35a113d1b42b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -66,9 +66,9 @@ xfs_qm_dqdestroy(
>   */
>  void
>  xfs_qm_adjust_dqlimits(
> -	struct xfs_mount	*mp,
>  	struct xfs_dquot	*dq)
>  {
> +	struct xfs_mount	*mp = dq->q_mount;
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
>  	int			prealloc = 0;
> @@ -112,9 +112,9 @@ xfs_qm_adjust_dqlimits(
>   */
>  void
>  xfs_qm_adjust_dqtimers(
> -	struct xfs_mount	*mp,
>  	struct xfs_dquot	*dq)
>  {
> +	struct xfs_mount	*mp = dq->q_mount;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
>  
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 62b0fc6e0133..e37b4bebc1ea 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -181,10 +181,8 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
>  void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
>  int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
>  void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
> -void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
> -						struct xfs_dquot *d);
> -void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
> -						struct xfs_dquot *d);
> +void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
> +void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
>  xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
>  int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
>  					uint type, bool can_alloc,
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 28326a6264a8..30deb6cf6a7a 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1107,8 +1107,8 @@ xfs_qm_quotacheck_dqadjust(
>  	 * There are no timers for the default values set in the root dquot.
>  	 */
>  	if (dqp->q_id) {
> -		xfs_qm_adjust_dqlimits(mp, dqp);
> -		xfs_qm_adjust_dqtimers(mp, dqp);
> +		xfs_qm_adjust_dqlimits(dqp);
> +		xfs_qm_adjust_dqtimers(dqp);
>  	}
>  
>  	dqp->dq_flags |= XFS_DQ_DIRTY;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 393b88612cc8..5423e02f9837 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -594,7 +594,7 @@ xfs_qm_scall_setqlim(
>  		 * is on or off. We don't really want to bother with iterating
>  		 * over all ondisk dquots and turning the timers on/off.
>  		 */
> -		xfs_qm_adjust_dqtimers(mp, dqp);
> +		xfs_qm_adjust_dqtimers(dqp);
>  	}
>  	dqp->dq_flags |= XFS_DQ_DIRTY;
>  	xfs_trans_log_dquot(tp, dqp);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 392e51baad6f..2712814d696d 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -382,8 +382,8 @@ xfs_trans_apply_dquot_deltas(
>  			 * Start/reset the timer(s) if needed.
>  			 */
>  			if (dqp->q_id) {
> -				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
> -				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
> +				xfs_qm_adjust_dqlimits(dqp);
> +				xfs_qm_adjust_dqtimers(dqp);
>  			}
>  
>  			dqp->dq_flags |= XFS_DQ_DIRTY;
> 
> 


-- 
chandan



