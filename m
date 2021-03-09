Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF85BC433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA17652B4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCIFEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhCIFEb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 00:04:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D204B6529C;
        Tue,  9 Mar 2021 05:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615266271;
        bh=DSVTX0sULXQJLB5Ilz/PObwUY6hhE8+pUmQUEntWUns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qN6vMHXja/o7CqZyO+HQWVIrVbgBdetIsHeRrWfeDa19eoWsVOtPFIbiN7t3p9p0b
         OdRP1hhXVBDAPpOpGF3lT7vFh0qXI/kBCeX25Zx7hu/yYTQAnSTuCZoT8ydaDLrrFw
         j/OM1NRQQuTjpPYs2a7cwZZH8tFYz7jEc7mZWCYfYUmGVUZscMklbvigjDVxJi6tXm
         mPkGemMLNzZ/xmfsDDnJpXeHw7ID4D/ZhgBKsAaEX/Xo7oFbxmAMG6aqxPa+ZdDXak
         Xs01Lb46TWlwUFf/27kI/HCtRnVq3O1iH5WQ9xuv1YEjTjsYpClxinznzYk3BaLG+8
         AMu83j9oYc+UQ==
Date:   Mon, 8 Mar 2021 21:04:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 03/13] common/xfs: Add helper to obtain fsxattr field
 value
Message-ID: <20210309050430.GB7269@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309050124.23797-4-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 10:31:14AM +0530, Chandan Babu R wrote:
> This commit adds a helper function to obtain the value of a particular field
> of an inode's fsxattr fields.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Seems reasonable,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 26ae21b9..130b3232 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -194,6 +194,15 @@ _xfs_get_file_block_size()
>  	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
>  }
>  
> +_xfs_get_fsxattr()
> +{
> +	local field="$1"
> +	local path="$2"
> +
> +	local value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
> +	echo ${value##fsxattr.${field} = }
> +}
> +
>  # xfs_check script is planned to be deprecated. But, we want to
>  # be able to invoke "xfs_check" behavior in xfstests in order to
>  # maintain the current verification levels.
> -- 
> 2.29.2
> 
