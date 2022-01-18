Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A0EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jan 2022 23:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349917AbiARXlw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 18:41:52 -0500
Received: from sandeen.net ([63.231.237.45]:49438 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235592AbiARXlw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Jan 2022 18:41:52 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1D811D73;
        Tue, 18 Jan 2022 17:40:37 -0600 (CST)
Message-ID: <6cec5ecb-6066-9590-0d12-cbb65c395e7d@sandeen.net>
Date:   Tue, 18 Jan 2022 17:41:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] xfs: remove unused xfs_ioctl32.h declarations
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20220118183005.GD13540@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220118183005.GD13540@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/18/22 12:30 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove these unused ia32 compat declarations; all the bits involved have
> either been withdrawn or hoisted to the VFS.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   fs/xfs/xfs_ioctl32.h |   18 ------------------
>   1 file changed, 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
> index fc5a91f3a5e0..c14852362fce 100644
> --- a/fs/xfs/xfs_ioctl32.h
> +++ b/fs/xfs/xfs_ioctl32.h
> @@ -142,24 +142,6 @@ typedef struct compat_xfs_fsop_attrmulti_handlereq {
>   	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
>   
>   #ifdef BROKEN_X86_ALIGNMENT
> -/* on ia32 l_start is on a 32-bit boundary */
> -typedef struct compat_xfs_flock64 {
> -	__s16		l_type;
> -	__s16		l_whence;
> -	__s64		l_start	__attribute__((packed));
> -			/* len == 0 means until end of file */
> -	__s64		l_len __attribute__((packed));
> -	__s32		l_sysid;
> -	__u32		l_pid;
> -	__s32		l_pad[4];	/* reserve area */
> -} compat_xfs_flock64_t;
> -
> -#define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
> -#define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
> -#define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
> -#define XFS_IOC_UNRESVSP64_32	_IOW('X', 43, struct compat_xfs_flock64)
> -#define XFS_IOC_ZERO_RANGE_32	_IOW('X', 57, struct compat_xfs_flock64)
> -
>   typedef struct compat_xfs_fsop_geom_v1 {
>   	__u32		blocksize;	/* filesystem (data) block size */
>   	__u32		rtextsize;	/* realtime extent size		*/
> 
