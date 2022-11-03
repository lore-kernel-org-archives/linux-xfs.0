Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA34C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 13:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKCNd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 09:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiKCNd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 09:33:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFF865E3
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 06:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667482379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vdtHTEEQa72WWaZ/E+XcyiYZeYPEAtJSQL3sfM4fXUk=;
        b=gGJ1cuDSGBD0AB0mKDEa34a8xGxaOX1hXAgtL34gaWVvvB+Dh8yrLKCNFsmt5PzhrhxZGA
        fhB8cUnvzfj5wkzb5j3jx9RRgPk7li3l2ye3ZI+iQ2fnCcsyU3i+1lRrDJy915YMDqqf3F
        xnx7rXNScGc8kG/CN3pjyxzteadM5aY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-PryQkrQqOBm_OYblsI11LQ-1; Thu, 03 Nov 2022 09:32:55 -0400
X-MC-Unique: PryQkrQqOBm_OYblsI11LQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 830C03C0ED4F;
        Thu,  3 Nov 2022 13:32:55 +0000 (UTC)
Received: from ovpn-192-135.brq.redhat.com (ovpn-192-135.brq.redhat.com [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71D1A40C6E14;
        Thu,  3 Nov 2022 13:32:54 +0000 (UTC)
Date:   Thu, 3 Nov 2022 14:32:52 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Lukas Herbolt <lukas@herbolt.com>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
Message-ID: <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
References: <l2a3zCkMp4g9yjUsn7MdftktWgI6xqW45ngK9WGU8-OQp_SWHRFpO5xZbUySxT3QRk1C4PyeLgqoVEY3VRRH_w==@protonmail.internalid>
 <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 01, 2022 at 12:19:06PM -0500, Eric Sandeen wrote:
> From: Lukas Herbolt <lukas@herbolt.com>
> 
> As of now only device names are printed out over __xfs_printk().
> The device names are not persistent across reboots which in case
> of searching for origin of corruption brings another task to properly
> identify the devices. This patch add XFS UUID upon every mount/umount
> event which will make the identification much easier.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> [sandeen: rebase onto current upstream kernel]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Hi,

it is a simple enough, nonintrusive change so it may not really matter as
much, but I was wondering if there is a way to map the device name to
the fs UUID already and I think there may be.

I know that udev daemon is constantly scanning devices then they are
closed in order to be able to read the signatures. It should know
exactly what is on the device and I know it is able to track the history
of changes. What I am not sure about is whether it is already logged
somewhere?

If it's not already, maybe it can be done and then we can cross
reference kernel log with udev log when tracking down problems to see
exactly what is going on without needing to sprinkle UUIDs in kernel log ?

Any thoughts?

-Lukas

> ---
> 
> [resending this as it seems to have gotten lost, and looks to me like
> a trivial and useful enhancement to xfs logmessages. This was requested
> (and authored!) by our support folks.]
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f02a0dd522b3..0141d9907d31 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -644,12 +644,14 @@ xfs_log_mount(
>  	int		min_logfsbs;
> 
>  	if (!xfs_has_norecovery(mp)) {
> -		xfs_notice(mp, "Mounting V%d Filesystem",
> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
> +		xfs_notice(mp, "Mounting V%d Filesystem %pU",
> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
> +			   &mp->m_sb.sb_uuid);
>  	} else {
>  		xfs_notice(mp,
> -"Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
> +"Mounting V%d filesystem %pU in no-recovery mode. Filesystem will be inconsistent.",
> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
> +			   &mp->m_sb.sb_uuid);
>  		ASSERT(xfs_is_readonly(mp));
>  	}
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f029c6702dda..0ed477df6480 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1110,7 +1110,7 @@ xfs_fs_put_super(
>  	if (!sb->s_fs_info)
>  		return;
> 
> -	xfs_notice(mp, "Unmounting Filesystem");
> +	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
>  	xfs_filestream_unmount(mp);
>  	xfs_unmountfs(mp);
> 
> 
> 

