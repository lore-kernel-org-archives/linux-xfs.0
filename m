Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A2CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ADF2610F9
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhJNQ1E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 12:27:04 -0400
Received: from sandeen.net ([63.231.237.45]:47340 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhJNQ1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 12:27:03 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7114678C9;
        Thu, 14 Oct 2021 11:23:54 -0500 (CDT)
Message-ID: <1fc7e5f8-7913-ad48-731c-03eb4472f87a@sandeen.net>
Date:   Thu, 14 Oct 2021 11:24:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20211005223155.GD24307@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] libxfs: fix call_rcu crash when unmounting the fake mount
 in mkfs
In-Reply-To: <20211005223155.GD24307@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/5/21 5:31 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit a6fb6abe, we simplified the process by which mkfs.xfs computes
> the minimum log size calculation by creating a dummy xfs_mount with the
> draft superblock image, using the dummy to compute the log geometry, and
> then unmounting the dummy.
> 
> Note that creating a dummy mount with no data device is supported by
> libxfs, though with the caveat that we don't set up any perag structures
> at all.  Up until this point this has worked perfectly well since free()
> (and hence kmem_free()) are perfectly happy to ignore NULL pointers.
> 
> Unfortunately, this will cause problems with the upcoming patch to shift
> per-AG setup and teardown to libxfs because call_rcu in the liburcu
> library actually tries to access the rcu_head of the passed-in perag
> structure, but they're all NULL in the dummy mount case.  IOWs,
> xfs_free_perag requires that every AG have a per-AG structure, and it's
> too late to change the 5.14 kernel libxfs now, so work around this by
> altering libxfs_mount to remember when it has initialized the perag
> structures and libxfs_umount to skip freeing them when the flag isn't
> set.
> 
> Just to be clear: This fault has no user-visible consequences right now;
> it's a fixup to avoid problems in the libxfs sync series for 5.14.

Thanks Darrick - I think this seems fine for now. We could re-evaluate whether
we want to change xfs_free_perag() to handle NULLs later, but since this
is a special case for userspace anyway, I think it might be most clear to
just keep this workaround in the caller as you've done here.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> Fixes: a6fb6abe ("mkfs: simplify minimum log size calculation")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   include/xfs_mount.h |    1 +
>   libxfs/init.c       |   13 ++++++++++---
>   2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 2f320880..9e43cd23 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -190,6 +190,7 @@ xfs_perag_resv(
>   #define LIBXFS_MOUNT_COMPAT_ATTR	0x0008
>   #define LIBXFS_MOUNT_ATTR2		0x0010
>   #define LIBXFS_MOUNT_WANT_CORRUPTED	0x0020
> +#define LIBXFS_MOUNT_PERAG_DATA_LOADED	0x0040
>   
>   #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
>   
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 17fc1102..d0753ce5 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -912,6 +912,7 @@ libxfs_mount(
>   			progname);
>   		exit(1);
>   	}
> +	mp->m_flags |= LIBXFS_MOUNT_PERAG_DATA_LOADED;
>   
>   	return mp;
>   }
> @@ -1031,9 +1032,15 @@ libxfs_umount(
>   	libxfs_bcache_purge();
>   	error = libxfs_flush_mount(mp);
>   
> -	for (agno = 0; agno < mp->m_maxagi; agno++) {
> -		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> -		kmem_free(pag);
> +	/*
> +	 * Only try to free the per-AG structures if we set them up in the
> +	 * first place.
> +	 */
> +	if (mp->m_flags & LIBXFS_MOUNT_PERAG_DATA_LOADED) {
> +		for (agno = 0; agno < mp->m_maxagi; agno++) {
> +			pag = radix_tree_delete(&mp->m_perag_tree, agno);
> +			kmem_free(pag);
> +		}
>   	}
>   
>   	kmem_free(mp->m_attr_geo);
> 
