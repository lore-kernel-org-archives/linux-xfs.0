Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A54C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28E76208D6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="ge1bTVbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgCSN02 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:26:28 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36206 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbgCSN02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Mar 2020 09:26:28 -0400
Received: by mail-io1-f67.google.com with SMTP id d15so2231518iog.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2020 06:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ELzuLaETk+r2ZXzUPTvEeZ+DOphV4yXCIcFXj69MsNI=;
        b=ge1bTVbPAUe6up49inz2h5oOtZAnsYo3qnbEXPjFiwrC94fxXjKA5N+hX5v6phl1er
         DiET8IKSFeg9BAvbAf7DJ3UcjuClzFI/DwgvxFeNjRYMwJG+/vLRykcBfsBtbChRnIxu
         3lx6PD7yM+uqLzFTsOrmidL512kykJnV+Uh2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ELzuLaETk+r2ZXzUPTvEeZ+DOphV4yXCIcFXj69MsNI=;
        b=IxhdKTMfJX2aXqnOE9r9WH8KieJJqoRARW0Cwali/OmPBcIG0C/iV0f7qZfROPpE/P
         AdGVM6pKOUTaGU2gbxAK8vHcG9ZfjhFG85wr7xY6MAMVvF4ZTp3dD4H8ELClC0UgoE3O
         N+I3NAngGRncG1J9VhEVJeZykzcURJZckWDuI8HK0ELOhHgH0YCWnBzmqSM00V66ihMG
         0WpB6l180Yv4Audst7CQjcQ6OuZ8dn0Itgxrbn35lIUJ77nxisoOi42coWeObVtwrxr4
         yyDCDq56ggP51RezlZB4iodI3Qr7Kkdt/AUP79Z0lFrVJ3CthFD9/OIaEie/XbbXD3hy
         i8Nw==
X-Gm-Message-State: ANhLgQ25xvByAPOHsdklKOa70zdhFmfHXpcRDhbixQjD/CrqDb15dv9N
        IWWWEfiBz+yz9FZcuUuRSW+wpswQAYo=
X-Google-Smtp-Source: ADFU+vtZ2pAF36LHorptU/g17HKI6xC4McFW0/1wVvgewt2zUPkUjvPlFwAekEnJhH3wwZwaOW7tmQ==
X-Received: by 2002:a02:1683:: with SMTP id a125mr3039836jaa.61.1584624386564;
        Thu, 19 Mar 2020 06:26:26 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id g12sm862429ilj.14.2020.03.19.06.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 06:26:25 -0700 (PDT)
Subject: Re: [PATCH] xfs: remove unused SHUTDOWN_ flags
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20200319130650.1141068-1-hch@lst.de>
From:   Alex Elder <elder@ieee.org>
Message-ID: <bccb71f0-3d16-ea5a-378f-15c525a654d3@ieee.org>
Date:   Thu, 19 Mar 2020 08:26:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200319130650.1141068-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/19/20 8:06 AM, Christoph Hellwig wrote:
> Remove two flags to xfs_force_shutdown that aren't used anywhere.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
>  fs/xfs/xfs_fsops.c | 5 +----
>  fs/xfs/xfs_mount.h | 2 --
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 3e61d0cc23f8..ef1d5bb88b93 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -504,10 +504,7 @@ xfs_do_force_shutdown(
>  	} else if (logerror) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
>  			"Log I/O Error Detected. Shutting down filesystem");
> -	} else if (flags & SHUTDOWN_DEVICE_REQ) {
> -		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -			"All device paths lost. Shutting down filesystem");
> -	} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
> +	} else {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
>  			"I/O Error Detected. Shutting down filesystem");
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 88ab09ed29e7..847f6f85c4fc 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -254,8 +254,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
>  #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
>  #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
> -#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
> -#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
>  
>  /*
>   * Flags for xfs_mountfs
> 

