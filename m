Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87951C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 16:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbiAKQYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 11:24:43 -0500
Received: from sandeen.net ([63.231.237.45]:49240 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349966AbiAKQYj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Jan 2022 11:24:39 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BCAD348FB;
        Tue, 11 Jan 2022 10:23:34 -0600 (CST)
Message-ID: <ba30642f-9b0d-c2f2-c89e-eddb2c0f2165@sandeen.net>
Date:   Tue, 11 Jan 2022 10:24:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 2/2] xfs: hide the XFS_IOC_{ALLOC,FREE}SP* definitions
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20220110174827.GW656707@magnolia>
 <20220110175154.GX656707@magnolia> <20220110195854.GY656707@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220110195854.GY656707@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/10/22 1:58 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've made these ioctls defunct, move them from xfs_fs.h to
> xfs_ioctl.c, which effectively removes them from the publicly supported
> ioctl interfaces for XFS.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: nuke the 32-bit compat definitions too

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   fs/xfs/libxfs/xfs_fs.h |    8 ++++----
>   fs/xfs/xfs_ioctl.c     |    9 +++++++++
>   fs/xfs/xfs_ioctl32.h   |    4 ----
>   3 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index c43877c8a279..49c0e583d6bb 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -781,13 +781,13 @@ struct xfs_scrub_metadata {
>    * For 'documentation' purposed more than anything else,
>    * the "cmd #" field reflects the IRIX fcntl number.
>    */
> -#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
> -#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
> +/*	XFS_IOC_ALLOCSP ------- deprecated 10	 */
> +/*	XFS_IOC_FREESP -------- deprecated 11	 */
>   #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
>   #define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
>   #define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
> -#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
> -#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
> +/*	XFS_IOC_ALLOCSP64 ----- deprecated 36	 */
> +/*	XFS_IOC_FREESP64 ------ deprecated 37	 */
>   #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
>   #define XFS_IOC_FSSETDM		_IOW ('X', 39, struct fsdmidata)
>   #define XFS_IOC_RESVSP		_IOW ('X', 40, struct xfs_flock64)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 38b2a1e881a6..15ec3d4a1516 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1854,6 +1854,15 @@ xfs_fs_eofblocks_from_user(
>   	return 0;
>   }
>   
> +/*
> + * These long-unused ioctls were removed from the official ioctl API in 5.17,
> + * but retain these definitions so that we can log warnings about them.
> + */
> +#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
> +#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
> +#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
> +#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
> +
>   /*
>    * Note: some of the ioctl's return positive numbers as a
>    * byte count indicating success, such as readlink_by_handle.
> diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
> index 9929482bf358..fc5a91f3a5e0 100644
> --- a/fs/xfs/xfs_ioctl32.h
> +++ b/fs/xfs/xfs_ioctl32.h
> @@ -154,10 +154,6 @@ typedef struct compat_xfs_flock64 {
>   	__s32		l_pad[4];	/* reserve area */
>   } compat_xfs_flock64_t;
>   
> -#define XFS_IOC_ALLOCSP_32	_IOW('X', 10, struct compat_xfs_flock64)
> -#define XFS_IOC_FREESP_32	_IOW('X', 11, struct compat_xfs_flock64)
> -#define XFS_IOC_ALLOCSP64_32	_IOW('X', 36, struct compat_xfs_flock64)
> -#define XFS_IOC_FREESP64_32	_IOW('X', 37, struct compat_xfs_flock64)
>   #define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
>   #define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
>   #define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
> 
