Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0CEC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 21:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiKUVCz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 16:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiKUVCw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 16:02:52 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3110EE09
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 13:02:27 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 136so12291728pga.1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 13:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9CTLQFhADzE3dTllfvu5X3oDge9IC1KTSOr/JLTdcdI=;
        b=i5wVDXUvz1Z7aO2IIkuSoLru+C9Lbky9Rr/PWRji+3mpJegUUEl0q2TMBOYVz8zeMy
         910Hq21QWlR/iUmqi4aQApFC6yZZkkK3GqPuHX0FHjCIk+T0ocp/z/67rfg1pO6o2asK
         CAa+evsWbS7glCaDCUtE1qMm29gH51TGXQ8jyEkPI8PEd4zVn8YEe01zWe4Gq8g78kSk
         Rb5xbzHtcXmCP8nW/PziN+9f5RBP9uomFG3WfUafwUfM+gMlPpQVwRv3Z7ZUPFU1dy3v
         553V35yHBH0nUyDx5bALXhRvOOhzzmUJQjZjS4WSNtVbuYDBw03SqKubWcH3pjZmtSNh
         OW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9CTLQFhADzE3dTllfvu5X3oDge9IC1KTSOr/JLTdcdI=;
        b=l+iGP8M8xYRAcRQnEdNcn8pBR65Hg3UE5WbinkYHvFZAioKbZpVDKNVk+9wzC1aEFB
         OFV/T1W79to8rTyxxv1V7CF1vT9hlNx9m6FpWt4hEguB1NZFN2SaK3B3mD5m4WQWWCST
         ZyZWnZ/wx0jKiLQItcCVXwJVqdDU1UDCv2u3bL6fwem1l5XyfuVJNM3Oqh0fnb6NrvzS
         vB8dGxc2b8HKHJGbDnoa/3bquBjkgyZRWToX80aVO3aLzOdxuSJW20OWsXrgWLpjUelz
         OeLzcu/pEwLld2xA6kVMl0b/pXTL4r8XRmKx24cYDCs+KFbyH4LOV3qYED5h640TJIMm
         MTHw==
X-Gm-Message-State: ANoB5pllbGT2RDapWDsAsChBq7LxX6pjksFvaC/mBQ5n1jEyn8Q3d8Bm
        n66PgjPgjgg6x90aAlP1+5OcRQ==
X-Google-Smtp-Source: AA0mqf5P6g2NtmeRkT3aUS78NMI/LVKEGuMGE1jGWsgSK+LbDFFpN2LUzPff3CqzvPmQZsMEdRpcpw==
X-Received: by 2002:a62:fb11:0:b0:56b:dbab:5362 with SMTP id x17-20020a62fb11000000b0056bdbab5362mr21945413pfm.47.1669064546790;
        Mon, 21 Nov 2022 13:02:26 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902c1c500b0017fe9b038fdsm10179926plc.14.2022.11.21.13.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 13:02:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxDvr-00H0tW-IY; Tue, 22 Nov 2022 08:02:23 +1100
Date:   Tue, 22 Nov 2022 08:02:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: add FS_IOC_GETFSUUID ioctl
Message-ID: <20221121210223.GJ3600936@dread.disaster.area>
References: <20221118211408.72796-1-catherine.hoang@oracle.com>
 <20221118211408.72796-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118211408.72796-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2022 at 01:14:08PM -0800, Catherine Hoang wrote:
> Add a new ioctl to retrieve the UUID of a mounted xfs filesystem. This is a
> precursor to adding the SETFSUUID ioctl.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1f783e979629..cf77715afe9e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1865,6 +1865,39 @@ xfs_fs_eofblocks_from_user(
>  	return 0;
>  }
>  
> +static int
> +xfs_ioctl_getuuid(
> +	struct xfs_mount	*mp,
> +	struct fsuuid __user	*ufsuuid)
> +{
> +	struct fsuuid		fsuuid;
> +	__u8			uuid[UUID_SIZE];

uuid_t, please, not an open coded uuid_t.

> +
> +	if (copy_from_user(&fsuuid, ufsuuid, sizeof(fsuuid)))
> +		return -EFAULT;

I still think this failing to copy the flex array member and then
having to declare a local uuid buffer is an ugly wart, not just on
the API side of things.

> +	if (fsuuid.fsu_len == 0) {
> +		fsuuid.fsu_len = UUID_SIZE;

XFS uses sizeof(uuid_t) for the size of it's uuids, not UUID_SIZE.

> +		if (copy_to_user(&ufsuuid->fsu_len, &fsuuid.fsu_len,
> +					sizeof(fsuuid.fsu_len)))
> +			return -EFAULT;
> +		return 0;
> +	}
> +
> +	if (fsuuid.fsu_len < UUID_SIZE || fsuuid.fsu_flags != 0)
> +		return -EINVAL;
> +
> +	spin_lock(&mp->m_sb_lock);
> +	memcpy(uuid, &mp->m_sb.sb_uuid, UUID_SIZE);
> +	spin_unlock(&mp->m_sb_lock);

Hmmmm. Shouldn't we be promoting xfs_fs_get_uuid() to xfs_super.c
(without the pNFS warning!) and calling that here, rather than open
coding another "get the XFS superblock UUID" function here?

i.e.
	if (fsuuid.fsu_flags != 0)
		return -EINVAL;

	error = xfs_fs_get_uuid(&mp->m_sb, uuid, &fsuuid.fsu_len, NULL);
	if (error)
		return -EINVAL;

Also, uuid_copy()?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
