Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AA5C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 21:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiKUVOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 16:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiKUVOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 16:14:42 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59F42AE11
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 13:14:41 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id y13so12473665pfp.7
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 13:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s8+dFQmx58ANw+r8MGg9bTob9gkWWskruTEs35xx1SY=;
        b=CpShpRuprHZSXGlKKBL+8ZFB2ZG81y9o78EAiVpgdpfUbJMVQS2OsSAacqXw72MbKI
         GpxDoRe/7sqRSMVwK4iqdZfoDZ6se4uiYtyh1SxOGHDb7jxdgUKh7M8dGBo0SU13dfLo
         6DQ4DsanjCvTxShUY739NLDDS3eTWWRkxUoFeiflJey2Ukp8Y0bGqqxxnrpso+T+jVza
         /U4vc1MGITvIGq6n0dyfDsFX1jK5uqcLSR1hDkaWGyrtizeNYzfYaP3EcFlZ78mEFMaY
         mhgIjBDOOdtsoNnNX7kbZmiCN3CDpGGgvXsRYdySAA3DI0FlDCDq2S+YIJgwLjK4WfgK
         UBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8+dFQmx58ANw+r8MGg9bTob9gkWWskruTEs35xx1SY=;
        b=wwjgIT4mw7N+5huJ7F56vQClcZtKEoAvszdkX6fHTIhI4ShrSFQf5ymlLaV8FXmow+
         toL5gFFFKYLIOJ1k0QTyxePQfZHnvzzBnWwVs4qZHvUnfOBbnNv2tExxDzT3NUSnRfZB
         uwjNbzFg9ANruZKTjm5jyoWNPc6/cnAZ3EYlQ5mRJdJfOwgWWQZHK+6OzjjWuF6Ka2jy
         xo09nPjoygv/rbwu59RsVmU0hsdAR4Ojza54nWQEbPXt1jtQr1JafAqGMtPDH/mVT6mh
         ylo9eDc5H/EyJ9eebJZjUifbvUa4BV1igw7t4ZIznZdlMcik1YrPpvE+HsjadzWvabHQ
         w92A==
X-Gm-Message-State: ANoB5pmYYmU/Y69CMpg1biV4d3Suj0CnhLZpGCtFGRlsiliiYVoesBUy
        NtbSXQV2jItIYk4Gn6KeSO8qasGg3hHPhQ==
X-Google-Smtp-Source: AA0mqf7MB8FgEma9AVeybczD7gW/6YFti5g5FVjVFiTeE2O36bb84KaVETW2k8qEe83AW0BSxDWglw==
X-Received: by 2002:aa7:93b4:0:b0:56d:1fdc:9d37 with SMTP id x20-20020aa793b4000000b0056d1fdc9d37mr1099575pff.77.1669065281365;
        Mon, 21 Nov 2022 13:14:41 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id ij28-20020a170902ab5c00b00188ffe7f6a1sm8071983plb.190.2022.11.21.13.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 13:14:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxE7h-00H112-Vx; Tue, 22 Nov 2022 08:14:38 +1100
Date:   Tue, 22 Nov 2022 08:14:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 1/2] fs: hoist get/set UUID ioctls
Message-ID: <20221121211437.GK3600936@dread.disaster.area>
References: <20221118211408.72796-1-catherine.hoang@oracle.com>
 <20221118211408.72796-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118211408.72796-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2022 at 01:14:07PM -0800, Catherine Hoang wrote:
> Hoist the EXT4_IOC_[GS]ETFSUUID ioctls so that they can be used by all
> filesystems. This allows us to have a common interface for tools such as
> coreutils.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
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

As I pointed out in my last comments, flex arrays in user APIs are
really unfriendly, because it means the structures have to be
dynamically allocated and can't be put on the stack. This makes the
obvious use of the API (i.e. a local stack struct fsuuid
declaration) dangerous to users.

Also, UUIDs are 16 bytes long - always have been, always will be.
So why does this API need to support -variable length UUIDs-? If
this is intended for use with other types of filesystem IDs (e.g.
GUIDs), then it needs to be named differently and it needs to have
a man page written for it to explain what it contains....

Shouldn't these landmines get fixed before we promote the API to
being a VFS-wide operation?

Also, if this is VFS wide, then why do we need filesystem specific
implementations to retreive the UUID? After all, the VFS superblock
has the public filesystem UUID in it (i.e. sb->s_uuid), and so we
should just have a single ioctl implementation that reads out the
sb->s_uuid. Yes, Setting the UUID is a different matter altogether
because filesystems need to change on-disk stuff, but we don't need
to reimplement retreiving sb->s_uuid in every filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
