Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1866C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 20:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiKJUGr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiKJUGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 15:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C9A2C65C
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 12:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66EDAB81F98
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 20:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1156BC43470;
        Thu, 10 Nov 2022 20:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668110799;
        bh=DxjfdfLLpS8r4aTCKxfCKIE7xNokJEf/RklabzMewqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BxVuLYZ5Cow1u90BPu80ZzeCeKt5+er6DFDF6a58a4tsONKF+WXqFm2/RJgDjBQ+y
         na+o266GOQ3cFcmWRXVKqGAuS6IzG/jq4v1tNgItQmF3RZ8o3MHASgjgKQ4eEqtLnS
         IbS9qIKkqAelxNgLdWs5tDqXJOkHFd2FcUZML0GTrJKS3LZAwkCjKGwM3XSFOcAJhw
         wPYXGeXm0aJ2BIUW8uea9zJyiYW2W63EufOB7WLSooUIs/XwQ0bPQ/VDijcbiyQk3A
         kvat3AVOEty67QQlVh2JpuXZHad7DKbdo/KvE28RgFei05czLyztKToa2Mo3IAL2wz
         GiJ5zPFURuhbQ==
Date:   Thu, 10 Nov 2022 12:06:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH v1 1/2] fs: hoist get/set UUID ioctls
Message-ID: <Y21Zzi4MnI1DTNLo@magnolia>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
 <20221109221959.84748-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109221959.84748-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 02:19:58PM -0800, Catherine Hoang wrote:
> Hoist the EXT4_IOC_[GS]ETFSUUID ioctls so that they can be used by all
> filesystems. This allows us to have a common interface for tools such as
> coreutils.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Also, for the inevitable v2 patchset after we sort out some weird bugs
in the ext4 implementation of this, can you please cc
linux-ext4@vger.kernel.org?

--D

> ---
>  fs/ext4/ext4.h          | 13 ++-----------
>  include/uapi/linux/fs.h | 11 +++++++++++
>  2 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8d5453852f98..b200302a3732 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -722,8 +722,8 @@ enum {
>  #define EXT4_IOC_GETSTATE		_IOW('f', 41, __u32)
>  #define EXT4_IOC_GET_ES_CACHE		_IOWR('f', 42, struct fiemap)
>  #define EXT4_IOC_CHECKPOINT		_IOW('f', 43, __u32)
> -#define EXT4_IOC_GETFSUUID		_IOR('f', 44, struct fsuuid)
> -#define EXT4_IOC_SETFSUUID		_IOW('f', 44, struct fsuuid)
> +#define EXT4_IOC_GETFSUUID		FS_IOC_GETFSUUID
> +#define EXT4_IOC_SETFSUUID		FS_IOC_SETFSUUID
>  
>  #define EXT4_IOC_SHUTDOWN _IOR ('X', 125, __u32)
>  
> @@ -753,15 +753,6 @@ enum {
>  						EXT4_IOC_CHECKPOINT_FLAG_ZEROOUT | \
>  						EXT4_IOC_CHECKPOINT_FLAG_DRY_RUN)
>  
> -/*
> - * Structure for EXT4_IOC_GETFSUUID/EXT4_IOC_SETFSUUID
> - */
> -struct fsuuid {
> -	__u32       fsu_len;
> -	__u32       fsu_flags;
> -	__u8        fsu_uuid[];
> -};
> -
>  #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
>  /*
>   * ioctl commands in 32 bit emulation
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index b7b56871029c..63b925444592 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -121,6 +121,15 @@ struct fsxattr {
>  	unsigned char	fsx_pad[8];
>  };
>  
> +/*
> + * Structure for FS_IOC_GETFSUUID/FS_IOC_SETFSUUID
> + */
> +struct fsuuid {
> +	__u32       fsu_len;
> +	__u32       fsu_flags;
> +	__u8        fsu_uuid[];
> +};
> +
>  /*
>   * Flags for the fsx_xflags field
>   */
> @@ -215,6 +224,8 @@ struct fsxattr {
>  #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
>  #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
>  #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
> +#define FS_IOC_GETFSUUID		_IOR('f', 44, struct fsuuid)
> +#define FS_IOC_SETFSUUID		_IOW('f', 44, struct fsuuid)
>  
>  /*
>   * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
> -- 
> 2.25.1
> 
