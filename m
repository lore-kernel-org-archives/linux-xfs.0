Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A26AC32772
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 16:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245378AbiHWQr3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344056AbiHWQqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 12:46:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FE213DCC;
        Tue, 23 Aug 2022 07:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E8AB81E30;
        Tue, 23 Aug 2022 14:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57CFC433C1;
        Tue, 23 Aug 2022 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661264796;
        bh=/XRdScOVs0rz6Z1PqdGicykzKyHwkRLXRdw1F9grXUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=co7q30XrHvJLqNW+RIc2a9P4mQ0G19iE7019+Bxcoiro1qynBSICXiOGGuGsnCusr
         nOc5UG6ABXoGYcQsQR+HnEg4XktIV38yLIrA86Fa1ec07kONEf08VGIKZyvpmnWiYv
         sAtJvh4lze4Zs9sfELafJBLavN+VJaWtCMh0IWJJmVDmgvllSa0q0MdVRz94sE1WIo
         IlgED3wVV85xDQeH504kXcK3VpwN0qVxYRKS4xHUpRkBd5m9NYy+MOY6T4FNHl521s
         tXbjyxk61N8Axxv0OY5h06+vX0UaBL7YjNeb/IbWS6XpXiWbK8KW9GbkXclkiEs/hb
         ZwlrD39bQOwHw==
Date:   Tue, 23 Aug 2022 07:26:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zeng Heng <zengheng4@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove redundant else for clean code
Message-ID: <YwTjnM/vvzTKLQWk@magnolia>
References: <20220823014745.4156948-1-zengheng4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823014745.4156948-1-zengheng4@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 23, 2022 at 09:47:45AM +0800, Zeng Heng wrote:
> "else" is not generally useful after a return, so remove it for clean code.
> 
> There is no logical changes.
> 
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> ---
>  fs/xfs/xfs_log.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 386b0307aed8..f6e7e4fd72ae 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -226,12 +226,12 @@ xlog_ticket_reservation(
>  	if (head == &log->l_write_head) {
>  		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
>  		return tic->t_unit_res;
> -	} else {
> -		if (tic->t_flags & XLOG_TIC_PERM_RESERV)
> -			return tic->t_unit_res * tic->t_cnt;
> -		else
> -			return tic->t_unit_res;
>  	}
> +
> +	if (tic->t_flags & XLOG_TIC_PERM_RESERV)
> +		return tic->t_unit_res * tic->t_cnt;
> +
> +	return tic->t_unit_res;

I think this looks correct
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  }
>  
>  STATIC bool
> -- 
> 2.25.1
> 
