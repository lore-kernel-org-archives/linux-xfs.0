Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F05C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 20:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiKJUFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiKJUFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 15:05:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDC42C65C
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 12:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4125B82313
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 20:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D423C433C1;
        Thu, 10 Nov 2022 20:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668110729;
        bh=w2JEsB+ZXZ/65YSlnnyv1Wuw8O+8WMzCYV0Zc2UOJSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZStNUa9X8GBfl9VUPaJyMrezTA0tpo9DBxsORQEM28IbqLRNmp4phhfqoqMIea1P
         JXevvfss4C9zjkISNUdXpBHLSkj+EPIPMKFt4QFwejR0hvIFHvb0E/1Jb3RRf3k1/1
         aA9xUbqKyG4zCrWSe3Rss/kZfTEnpfI2EWuOMCLfouGvOgBqLSYVJ9JCLgXzDfSaZ7
         1kxRa44quej3THJytyrj0Ti0sUZTD7KRwVvZBHYXjL2HAoTpPDSU35bZtDKTgRKhLx
         xJ50vkSDnkeQ2SNhAdifBgDILejFykaui9l/CnpIV5tK8BKPw2hXajrhH+5qI+Yj9F
         X6wE88M/ERgaQ==
Date:   Thu, 10 Nov 2022 12:05:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH v1 2/2] xfs: add FS_IOC_GETFSUUID ioctl
Message-ID: <Y21ZibTXMsyjekbW@magnolia>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
 <20221109221959.84748-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109221959.84748-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 02:19:59PM -0800, Catherine Hoang wrote:
> Add a new ioctl to retrieve the UUID of a mounted xfs filesystem.

I think it's worth mentioning that this is the precursor to trying to
implement SETFSUUID... but that's something for a future series, since
changing the uuid will upset the log, and we have to figure out how to
deal with that gracefully.

> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1f783e979629..657fe058dfba 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1865,6 +1865,35 @@ xfs_fs_eofblocks_from_user(
>  	return 0;
>  }
>  
> +static int xfs_ioctl_getuuid(

Nit: function names should start on a new line.

> +	struct xfs_mount	*mp,
> +	struct fsuuid __user	*ufsuuid)
> +{
> +	struct fsuuid		fsuuid;
> +	__u8			uuid[UUID_SIZE];
> +
> +	if (copy_from_user(&fsuuid, ufsuuid, sizeof(fsuuid)))
> +		return -EFAULT;
> +
> +	if (fsuuid.fsu_len == 0) {
> +		fsuuid.fsu_len = UUID_SIZE;
> +		if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid.fsu_len)))
> +			return -EFAULT;
> +		return -EINVAL;

Ted and I were looking through the ext4_ioctl_getuuid function on this
morning's ext4 concall, and we decided that copying the desired uuid
buffer length out to userspace shouldn't result in an EINVAL return
here...

> +	}
> +
> +	if (fsuuid.fsu_len != UUID_SIZE || fsuuid.fsu_flags != 0)

...and that we shouldn't reject the case where fsu_len > UUID_SIZE.
Instead, we should copy the uuid and update the caller's fsu_len to
reflect however many bytes we copied out.  I'll send patches to do that
shortly.

> +		return -EINVAL;
> +
> +	spin_lock(&mp->m_sb_lock);
> +	memcpy(uuid, &mp->m_sb.sb_uuid, UUID_SIZE);
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	if (copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
> +		return -EFAULT;

The rest of this logic looks correct to me.  Thanks for getting this out
there.

--D

> +	return 0;
> +}
> +
>  /*
>   * These long-unused ioctls were removed from the official ioctl API in 5.17,
>   * but retain these definitions so that we can log warnings about them.
> @@ -2153,6 +2182,9 @@ xfs_file_ioctl(
>  		return error;
>  	}
>  
> +	case FS_IOC_GETFSUUID:
> +		return xfs_ioctl_getuuid(mp, arg);
> +
>  	default:
>  		return -ENOTTY;
>  	}
> -- 
> 2.25.1
> 
