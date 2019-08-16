Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8B8C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 13:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 499F22064A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 13:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfHPNvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 09:51:06 -0400
Received: from sandeen.net ([63.231.237.45]:55306 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbfHPNvG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Aug 2019 09:51:06 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7CAD4328A1E;
        Fri, 16 Aug 2019 08:51:05 -0500 (CDT)
Subject: Re: [PATCH 1/2] xfs: fall back to native ioctls for unhandled compat
 ones
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>
References: <20190816063547.1592-1-hch@lst.de>
 <20190816063547.1592-2-hch@lst.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <2a1854b9-26a4-402c-4932-7fde02e14ecb@sandeen.net>
Date:   Fri, 16 Aug 2019 08:51:04 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816063547.1592-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/16/19 1:35 AM, Christoph Hellwig wrote:
> Always try the native ioctl if we don't have a compat handler.  This
> removes a lot of boilerplate code as 'modern' ioctls should generally
> be compat clean, and fixes the missing entries for the recently added
> FS_IOC_GETFSLABEL/FS_IOC_SETFSLABEL ioctls.
> 
> Fixes: f7664b31975b ("xfs: implement online get/set fs label")

whoops

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_ioctl32.c | 54 ++------------------------------------------
>  1 file changed, 2 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 7fcf7569743f..bae08ef92ac3 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -553,57 +553,6 @@ xfs_file_compat_ioctl(
>  	trace_xfs_file_compat_ioctl(ip);
>  
>  	switch (cmd) {
> -	/* No size or alignment issues on any arch */
> -	case XFS_IOC_DIOINFO:
> -	case XFS_IOC_FSGEOMETRY_V4:
> -	case XFS_IOC_FSGEOMETRY:
> -	case XFS_IOC_AG_GEOMETRY:
> -	case XFS_IOC_FSGETXATTR:
> -	case XFS_IOC_FSSETXATTR:
> -	case XFS_IOC_FSGETXATTRA:
> -	case XFS_IOC_FSSETDM:
> -	case XFS_IOC_GETBMAP:
> -	case XFS_IOC_GETBMAPA:
> -	case XFS_IOC_GETBMAPX:
> -	case XFS_IOC_FSCOUNTS:
> -	case XFS_IOC_SET_RESBLKS:
> -	case XFS_IOC_GET_RESBLKS:
> -	case XFS_IOC_FSGROWFSLOG:
> -	case XFS_IOC_GOINGDOWN:
> -	case XFS_IOC_ERROR_INJECTION:
> -	case XFS_IOC_ERROR_CLEARALL:
> -	case FS_IOC_GETFSMAP:
> -	case XFS_IOC_SCRUB_METADATA:
> -	case XFS_IOC_BULKSTAT:
> -	case XFS_IOC_INUMBERS:
> -		return xfs_file_ioctl(filp, cmd, p);
> -#if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
> -	/*
> -	 * These are handled fine if no alignment issues.  To support x32
> -	 * which uses native 64-bit alignment we must emit these cases in
> -	 * addition to the ia-32 compat set below.
> -	 */
> -	case XFS_IOC_ALLOCSP:
> -	case XFS_IOC_FREESP:
> -	case XFS_IOC_RESVSP:
> -	case XFS_IOC_UNRESVSP:
> -	case XFS_IOC_ALLOCSP64:
> -	case XFS_IOC_FREESP64:
> -	case XFS_IOC_RESVSP64:
> -	case XFS_IOC_UNRESVSP64:
> -	case XFS_IOC_FSGEOMETRY_V1:
> -	case XFS_IOC_FSGROWFSDATA:
> -	case XFS_IOC_FSGROWFSRT:
> -	case XFS_IOC_ZERO_RANGE:
> -#ifdef CONFIG_X86_X32
> -	/*
> -	 * x32 special: this gets a different cmd number from the ia-32 compat
> -	 * case below; the associated data will match native 64-bit alignment.
> -	 */
> -	case XFS_IOC_SWAPEXT:
> -#endif
> -		return xfs_file_ioctl(filp, cmd, p);
> -#endif
>  #if defined(BROKEN_X86_ALIGNMENT)
>  	case XFS_IOC_ALLOCSP_32:
>  	case XFS_IOC_FREESP_32:
> @@ -705,6 +654,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_FSSETDM_BY_HANDLE_32:
>  		return xfs_compat_fssetdm_by_handle(filp, arg);
>  	default:
> -		return -ENOIOCTLCMD;
> +		/* try the native version */
> +		return xfs_file_ioctl(filp, cmd, p);
>  	}
>  }
> 
