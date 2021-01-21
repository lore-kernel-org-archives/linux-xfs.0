Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D15C4332E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FA47230F9
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbhAUSqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbhAUSnq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jan 2021 13:43:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0911220663;
        Thu, 21 Jan 2021 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611254586;
        bh=MDAmd5xdMhBLazjqG4hkERW4i5wWIJTuqboe1LRFsws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CH7w1xv8xR5jkC1hwiZXGrdGtawiibm99E1Es9LdEU+hqa0Y4az1T5fCRUAIOjTKi
         2nsoWf40pj1Y2qXwLUxAEGKC1YFnH0t9os+TDAb2/WCQEMxJeEo1CEvqCGe+gDmroK
         B4AaRZyOIMbrvIIYZOi1srcvL5G83X9AE/2sKto4eESeRRUloBBFUOmEH83TtPA3sO
         pmLnUFAbA4yy9c+A97tGNg6MAg0TBMM7+C6VpTDGTtiXO11rFjl8kzczDi+pYM+aGR
         0UabhBBuLrjAx78jfADREcLzOJrNM/au7UwJB0R8EXuSxPv7DH9772nmhxClISLTr/
         eDBsF5fCwqjXg==
Date:   Thu, 21 Jan 2021 10:43:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/9] xfs: lift writable fs check up into log worker
 task
Message-ID: <20210121184305.GA1282127@magnolia>
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121154526.1852176-3-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 10:45:19AM -0500, Brian Foster wrote:
> The log covering helper checks whether the filesystem is writable to
> determine whether to cover the log. The helper is currently only
> called from the background log worker. In preparation to reuse the
> helper from freezing contexts, lift the check into xfs_log_worker().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b445e63cbc3c..7280d99aa19c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1049,14 +1049,12 @@ xfs_log_space_wake(
>   * there's no point in running a dummy transaction at this point because we
>   * can't start trying to idle the log until both the CIL and AIL are empty.
>   */
> -static int
> -xfs_log_need_covered(xfs_mount_t *mp)
> +static bool
> +xfs_log_need_covered(
> +	struct xfs_mount	*mp)
>  {
> -	struct xlog	*log = mp->m_log;
> -	int		needed = 0;
> -
> -	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
> -		return 0;
> +	struct xlog		*log = mp->m_log;
> +	bool			needed = false;
>  
>  	if (!xlog_cil_empty(log))
>  		return 0;
> @@ -1074,14 +1072,14 @@ xfs_log_need_covered(xfs_mount_t *mp)
>  		if (!xlog_iclogs_empty(log))
>  			break;
>  
> -		needed = 1;
> +		needed = true;
>  		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
>  			log->l_covered_state = XLOG_STATE_COVER_DONE;
>  		else
>  			log->l_covered_state = XLOG_STATE_COVER_DONE2;
>  		break;
>  	default:
> -		needed = 1;
> +		needed = true;
>  		break;
>  	}
>  	spin_unlock(&log->l_icloglock);
> @@ -1271,7 +1269,7 @@ xfs_log_worker(
>  	struct xfs_mount	*mp = log->l_mp;
>  
>  	/* dgc: errors ignored - not fatal and nowhere to report them */
> -	if (xfs_log_need_covered(mp)) {
> +	if (xfs_fs_writable(mp, SB_FREEZE_WRITE) && xfs_log_need_covered(mp)) {
>  		/*
>  		 * Dump a transaction into the log that contains no real change.
>  		 * This is needed to stamp the current tail LSN into the log
> -- 
> 2.26.2
> 
