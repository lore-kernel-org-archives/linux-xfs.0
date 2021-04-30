Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F74C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 13:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE4B61474
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 13:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhD3Ndm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 09:33:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhD3Ndm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Apr 2021 09:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619789573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8uIkx91lGwsWh6Q9Rbr0JL7bR3kYSukQq4rBPLEweLE=;
        b=Gp56iVPhpz23uPtsy+gBqDcEox1TIzDB0+zqSHY5Ow63250zqlbMO5ctHal7SoWlt6P6ge
        P07MfXufRDNgBSXFmr7H19rZUoZ7kNYWwtYco37Jh0JraEC9FKUleOD/L6yHVqeTIsS2Ul
        58TwO21XLsszs34mBlepIl3XMkz+3qs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-RMnf0_hVOy60TFslu1ROcg-1; Fri, 30 Apr 2021 09:32:51 -0400
X-MC-Unique: RMnf0_hVOy60TFslu1ROcg-1
Received: by mail-qk1-f199.google.com with SMTP id c76-20020ae9ed4f0000b02902e4caf24229so1597461qkg.4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 06:32:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8uIkx91lGwsWh6Q9Rbr0JL7bR3kYSukQq4rBPLEweLE=;
        b=BGAwqI9sF5B4r5V3tF8G0pIB6kw0p117fuIhmcYsVLtn9TGUBME5Lz6JpH/xpDfB0b
         JvTfCMEEqMUmiIFg5CT6Ck8//1AJF5zIg8Su5Dp2tBrqcIScXrQUMaRu4qnCvMNp8IUd
         3ECusNvq1bt4t+TEXkKqyu5P/GFmVNFZygmUeBnBY2gsZHgcOLDrolB75/un/2QBmr33
         44VJ6o9JNix8cOvtIAXRjynTAA3gb1XyJA4EwP20nimkf7/bC5RuKfmR5ne0bxBeUUtU
         3gkdSJatPPgTbVN+7oIdu5HKeMW1xNhBE7+HtdY9NSGLXZNVqzWZdR4X+YbomzpZiFXn
         0SCw==
X-Gm-Message-State: AOAM530CL6DrcVf3CmTkwsoRRgfb31kUa0gHfDuK5P0XkEtdiF3hWYp/
        QMuOY3DXJqfcVnJQ8q/llrGh3P94g2RSF64feP7kPy5pcKvMj+LSmg8cRo2B9ecvuUs9jLB7L86
        D3yblblv4DIU7mBOSsHbF
X-Received: by 2002:a05:6214:242c:: with SMTP id gy12mr5311155qvb.34.1619789571196;
        Fri, 30 Apr 2021 06:32:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbqMTrnBvFPcsLeaA83WAcmGVnHmED1DrJ+A7/LhLPFDjbGZ8Ow//tnxBsJCvjZ3v/Qbw7Yg==
X-Received: by 2002:a05:6214:242c:: with SMTP id gy12mr5311138qvb.34.1619789570972;
        Fri, 30 Apr 2021 06:32:50 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id t16sm1219432qtq.12.2021.04.30.06.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 06:32:50 -0700 (PDT)
Date:   Fri, 30 Apr 2021 09:32:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't allow log writes if the data device is
 readonly
Message-ID: <YIwHAGXOZSO+DnBw@bfoster>
References: <20210430004012.GO3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430004012.GO3122264@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 29, 2021 at 05:40:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running generic/050 with an external log, I observed this warning
> in dmesg:
> 
> Trying to write to read-only block-device sda4 (partno 4)
> WARNING: CPU: 2 PID: 215677 at block/blk-core.c:704 submit_bio_checks+0x256/0x510
> Call Trace:
>  submit_bio_noacct+0x2c/0x430
>  _xfs_buf_ioapply+0x283/0x3c0 [xfs]
>  __xfs_buf_submit+0x6a/0x210 [xfs]
>  xfs_buf_delwri_submit_buffers+0xf8/0x270 [xfs]
>  xfsaild+0x2db/0xc50 [xfs]
>  kthread+0x14b/0x170
> 
> I think this happened because we tried to cover the log after a readonly
> mount, and the AIL tried to write the primary superblock to the data
> device.  The test marks the data device readonly, but it doesn't do the
> same to the external log device.  Therefore, XFS thinks that the log is
> writable, even though AIL writes whine to dmesg because the data device
> is read only.
> 
> Fix this by amending xfs_log_writable to prevent writes when the AIL
> can't possible write anything into the filesystem.
> 
> Note: As for the external log or the rt devices being readonly--
> xfs_blkdev_get will complain about that if we aren't doing a norecovery
> mount.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 06041834daa3..e4839f22ec07 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -358,12 +358,14 @@ xfs_log_writable(
>  	 * Never write to the log on norecovery mounts, if the block device is
>  	 * read-only, or if the filesystem is shutdown. Read-only mounts still
>  	 * allow internal writes for log recovery and unmount purposes, so don't
> -	 * restrict that case here.
> +	 * restrict that case here unless the data device is also readonly.
>  	 */

The comment update is a little confusing because that second sentence
explicitly refers to the read-only mount case (i.e., why we don't check
XFS_MOUNT_RDONLY here), and that logic/reasoning remains independent of
this change. Perhaps instead change the first part to something like
"... if the data or log device is read-only, ..." ?

With that fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
>  		return false;
>  	if (xfs_readonly_buftarg(mp->m_log->l_targ))
>  		return false;
> +	if (xfs_readonly_buftarg(mp->m_ddev_targp))
> +		return false;
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return false;
>  	return true;
> 

