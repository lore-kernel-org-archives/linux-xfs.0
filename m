Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1954608AbdDZNPf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 09:15:35 -0400
Subject: Re: [PATCH] xfs_io: Add statx support for PowerPC architecture
References: <1493188758-3173-1-git-send-email-chandan@linux.vnet.ibm.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <17f95c8b-9343-adbf-814f-96ab492cfc6d@redhat.com>
Date: Wed, 26 Apr 2017 08:15:34 -0500
MIME-Version: 1.0
In-Reply-To: <1493188758-3173-1-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org

On 4/26/17 1:39 AM, Chandan Rajendra wrote:
> Linux kernel commit f717629c7f834ab2efa05c7dbf0826f1d7c32ade (powerpc:
> Wire up statx() syscall) added support for statx syscall for PowerPC
> architecture. This commit enables using 'statx' sub-command of xfs_io to
> be used on PowerPC.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Ok, sure - some day I hope to get rid of io/statx.h but for now I want
to be sure we run on the architectures that people "care" about ;) so
this sounds good.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> This patch is based on Eric's "xfs_io: fix statx definition for non-x86
> architecture" patch.
> 
>  io/statx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/statx.h b/io/statx.h
> index eea7944..14361a8 100644
> --- a/io/statx.h
> +++ b/io/statx.h
> @@ -16,7 +16,7 @@
>  #endif
>  
>  #ifndef __NR_statx
> -# ifdef __i386__
> +# if defined(__i386__) || defined(__powerpc__)
>  #  define __NR_statx 383
>  # elif defined (__x86_64__)
>  #  if defined (__ILP32__)
> 

