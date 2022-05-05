Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A57DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiEEQVU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiEEQVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:21:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58155BD01
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D808B82DC5
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5DDC385A8;
        Thu,  5 May 2022 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651767457;
        bh=tSH0TpLSjnfouFS0TO95weEE/u0NDHtb4/GuTlMnBNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EchnP/FU5ZI3xy82R07zfedEqegGzfEEKVdLgLcj6UqID1ZQcTHxNllMvrqWF8njF
         bokONNBfUIxeacehWHuuGJQNtPjLnsMDN8qbgCGdlrf2k4r8Z7VB3jdB+WWoIbJrH1
         U2Pq5KBq7TyToTR76XCC7VmTiJWne7XA0mO7Qp3g9NRwhGmOOSYBjgK7D5Z/UIqB/N
         tdr0GOcy/4vXmGI4mOAf0IPuFvPxLrm4lhUA3MS8Ep7VVxUUJqU8YqFNty9NBYCXg0
         bIDs6TSWgpsxlMWuDAr7GWRzoDnaEwLl3PIsKWnVkWbcsmfB5plr+uctZ+dcvF7eaP
         ItCa9XOnebmhA==
Date:   Thu, 5 May 2022 09:17:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] xfs: don't set warns on dquots
Message-ID: <20220505161736.GI27195@magnolia>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
 <20220505011815.20075-4-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505011815.20075-4-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 04, 2022 at 06:18:15PM -0700, Catherine Hoang wrote:
> Having just dropped support for quota warning limits and warning counters,
> the warning fields no longer have any meaning. Return -EINVAL if the
> fieldmask has any of the QC_*_WARNS set.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Slight nit I noticed in this patch: I think you should remove
QC_WARNS_MASK from XFS_QC_SETINFO_MASK and XFS_QC_MASK.  The first will
block the setting of warning counters from quotactl_ops.set_info, and
the second blocks it from quotactl_ops.set_dqblk.  With both those
#defins updated, I think you don't need the change below.

--D

> ---
>  fs/xfs/xfs_qm_syscalls.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 2149c203b1d0..188e1fed2eba 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
>  		return -EINVAL;
>  	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
>  		return 0;
> +	if (newlim->d_fieldmask & QC_WARNS_MASK)
> +		return -EINVAL;
>  
>  	/*
>  	 * Get the dquot (locked) before we start, as we need to do a
> -- 
> 2.27.0
> 
