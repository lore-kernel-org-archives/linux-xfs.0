Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CFCC4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 08:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A8EE2074D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 08:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcnHeotc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgCWIai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 04:30:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:29349 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727477AbgCWIai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 04:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584952237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9LT0yWtWSlIn/5/nzh8W4CZMsHHW20kHzBitwYfp7vo=;
        b=fcnHeotcC1sC8G2/gS+JojMDRfinJY6q/Jxsl28N8w/RvMM/8+dX6bSQU6Dr6i3cX2auDi
        i21/392iFai4yNmiUNgolHjT9f1q+7CCqBgZBozvt3iVzZRoxhm9boTtrhzwNhDrPQpucY
        JGZ7WSfq8HEldjowa7DEmW5tfdSdwZ0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-yyv5rlj3NVioW-6JMdDrlw-1; Mon, 23 Mar 2020 04:30:35 -0400
X-MC-Unique: yyv5rlj3NVioW-6JMdDrlw-1
Received: by mail-wr1-f69.google.com with SMTP id d17so7006786wrw.19
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2020 01:30:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=9LT0yWtWSlIn/5/nzh8W4CZMsHHW20kHzBitwYfp7vo=;
        b=JfmgjY7uNXSAPDwA84m/s5F1JrdxaicICtfVpGetDolPSU5ID48RaTr4sBbjf8uBa6
         xzcV/8LTmV520SeWbpG89o1qI4cr2X0tqx3XPOm0vs3+ZCdwAIJG/sK2XyKWw/xEEJxV
         ORNffDEXH8ZNZHZ/ql3mqFkl/abVEpsNgp2lZXoV7BRgn5K3x0z/h8jAvoFRXV6IATh7
         MR+yv+mId1dgabg7VgdK1mfOM3L013bKwh4HDyhzfJZq5WK0gachcIS96K6d67z/BYij
         ES4lMF1fJOY8Qn4XfGrTOloSCYMukoFGz/4eEoZwohM31KKOSiIDOo6Vpp5jDMCwDb0s
         DPzQ==
X-Gm-Message-State: ANhLgQ1HWo5Sh+2aXZAD20JF4c2QnBjisky0nwvZLhQWnYGiIyM3aSDw
        zk9hhumtkpmJu9UqoDHKEaNzne5Cz+Xlj+OyFRtPA7PnlQqo7dT8jVMbGlXNMPrG7PKgXPxl5N2
        1f60JV9qkLHht1Yh+DPjb
X-Received: by 2002:a05:600c:4145:: with SMTP id h5mr25654949wmm.3.1584952234290;
        Mon, 23 Mar 2020 01:30:34 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvffPjXzfAfWiik9EpscZidHTP9goPNPfXwTFTkkDdGPfRPWMJVUC2OfcY6HP+Ye/Ov0nqVPA==
X-Received: by 2002:a05:600c:4145:: with SMTP id h5mr25654931wmm.3.1584952234076;
        Mon, 23 Mar 2020 01:30:34 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id d5sm12905125wrh.40.2020.03.23.01.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 01:30:33 -0700 (PDT)
Date:   Mon, 23 Mar 2020 09:30:30 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unused SHUTDOWN_ flags
Message-ID: <20200323083030.svj2gsvqnkqksa7n@eorzea>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20200319130650.1141068-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319130650.1141068-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 19, 2020 at 02:06:50PM +0100, Christoph Hellwig wrote:
> Remove two flags to xfs_force_shutdown that aren't used anywhere.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
> -- 
> 2.24.1
> 

-- 
Carlos

