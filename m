Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A07C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A10920759
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6lmQXbC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgI3P5k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:57:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgI3P5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 11:57:39 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601481458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U11Em4ZRArGIS2y3a1jYeCfYKH35nXNbnTYdgTtb5v4=;
        b=U6lmQXbCoy8YnWBgp9Q2oA4O/pK6wHjDyi3DEeJIzIH01FqPggrICAW3atzkfqDcff+VX3
        75CqP4QC2ydvRzYeRiYFxswvXjzzQT/xjpd3Zx2xKU7snxYtGRzmUYLc1cjRwv0c8eNoUN
        LDPfNJftftHYgG0ko9xTxM8kHeoZG8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-Gwn-3C68MneB1whBHXm8Rg-1; Wed, 30 Sep 2020 11:57:36 -0400
X-MC-Unique: Gwn-3C68MneB1whBHXm8Rg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAC648030DE
        for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2020 15:57:35 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9700310027A5
        for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2020 15:57:35 +0000 (UTC)
Subject: Re: [PATCH] xfs_repair: be more helpful if rtdev is not specified for
 rt subvol
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <ee05a000-4c9d-ad5d-66d0-48655cb69e95@redhat.com>
Message-ID: <8c462161-25b8-a742-1552-6d8e15ef4f77@redhat.com>
Date:   Wed, 30 Sep 2020 10:57:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <ee05a000-4c9d-ad5d-66d0-48655cb69e95@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/20 10:54 AM, Eric Sandeen wrote:
> Today, if one tries to repair a filesystem with a realtime subvol but
> forgets to specify the rtdev on the command line, the result sounds dire:
> 
> Phase 1 - find and verify superblock...
> xfs_repair: filesystem has a realtime subvolume
> xfs_repair: realtime device init failed
> xfs_repair: cannot repair this filesystem.  Sorry.
> 
> We can be a bit more helpful, following the log device example:
> 
> Phase 1 - find and verify superblock...
> This filesystem has a realtime subvolume.  Specify rt device with the -r option.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Oops, no.  This is in core code not repair code, we can't make suggestions about
command line options here, sorry.

> diff --git a/libxfs/init.c b/libxfs/init.c
> index cb8967bc..65cc3d4c 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -429,9 +429,9 @@ rtmount_init(
>  	if (sbp->sb_rblocks == 0)
>  		return 0;
>  	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
> -		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
> -			progname);
> -		return -1;
> +		fprintf(stderr, _("This filesystem has a realtime subvolume.  "
> +			   "Specify rt device with the -r option.\n"));
> +		exit(1);
>  	}
>  	mp->m_rsumlevels = sbp->sb_rextslog + 1;
>  	mp->m_rsumsize =
> 

