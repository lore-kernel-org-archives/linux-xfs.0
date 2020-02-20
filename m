Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31991C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA2C1206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bhhnSmNM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgBTOGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 09:06:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24257 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgBTOGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 09:06:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582207595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUqIhZ3w2qDDYN4RUwMdbaOF4z51UXkUyFLw1Mnedks=;
        b=bhhnSmNMTpVPXkbRMbm9HJGpwWqUsJOx8ZEu8T4HssrQTUAuaVQqQkiTLRtw/jNlCIygKb
        8tEAsKGlG192LMZwkf7XDsV1Q0i4zrNECz/5mlImHBvwVsFpllq/sjpXJzpPOpm9yGEFXy
        4Y6QY9cjCtG0rwDesh2wjs7JIPMoMCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-m9H718ekNlaCVJay7O_6sg-1; Thu, 20 Feb 2020 09:06:33 -0500
X-MC-Unique: m9H718ekNlaCVJay7O_6sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B4838010EB;
        Thu, 20 Feb 2020 14:06:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 273C65C297;
        Thu, 20 Feb 2020 14:06:32 +0000 (UTC)
Date:   Thu, 20 Feb 2020 09:06:30 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] libfrog: always fsync when flushing a device
Message-ID: <20200220140630.GD48977@bfoster>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216295197.601264.12572804096602430873.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216295197.601264.12572804096602430873.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:42:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Always call fsync() when we're flushing a device, even if it is a block
> device.  It's probably redundant to call fsync /and/ BLKFLSBUF, but the
> latter has odd behavior so we want to make sure the standard flush
> methods have a chance to run first.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libfrog/linux.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 60bc1dc4..40a839d1 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -155,14 +155,18 @@ platform_flush_device(
>  	if (major(device) == RAMDISK_MAJOR)
>  		return 0;
>  
> +	ret = fsync(fd);
> +	if (ret)
> +		return ret;
> +
>  	ret = fstat(fd, &st);
>  	if (ret)
>  		return ret;
>  
> -	if (S_ISREG(st.st_mode))
> -		return fsync(fd);
> +	if (S_ISBLK(st.st_mode))
> +		return ioctl(fd, BLKFLSBUF, 0);
>  
> -	return ioctl(fd, BLKFLSBUF, 0);
> +	return 0;
>  }
>  
>  void
> 

