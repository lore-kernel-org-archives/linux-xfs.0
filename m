Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7B5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E87856146D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353633AbhCDARx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376996AbhCCRbc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 12:31:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BF5E64ED7;
        Wed,  3 Mar 2021 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614792650;
        bh=c+qOUlJRXSc5O5xegPIbacK6aRD2s42BYZIJyXiGAa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iibk+FMHtVcRfWjEMprArT89nlUzBGkVZhj5TTlRaJOoucgOIj10TMiSk9+BbqW3A
         OpcKgXmXNC+YznDQRN0KGHYa4M/RYEqxGIbxg/ToLckJdTMwXslHC1Q9WvAAR94wtF
         jui/OeufIV1HnYVK0OV//U9ygAw0rE0e8U1n8wRmfXEU1oUWRqVW5/sqpIt+IJuqAH
         XZfGHRlI3W78Tbr+EbJ2vw9MCRf0yitfWfCBq/1GihT3x/n+wqNiViRQptJj+3++Jb
         BzFrFw4qTFJtzqAXHd2HjHzYecslL372f5H/Xgi9tWygAs/iNJkv5sPQdE7dIntpxK
         FCdQFcCLVaICA==
Date:   Wed, 3 Mar 2021 09:30:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 01/11] common/xfs: Add a helper to get an inode fork's
 extent count
Message-ID: <20210303173050.GI7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-2-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:12AM +0530, Chandan Babu R wrote:
> This commit adds the helper _scratch_get_iext_count() which returns an
> inode fork's extent count.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  common/xfs | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 3f5c14ba..641d6195 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -903,6 +903,28 @@ _scratch_get_bmx_prefix() {
>  	return 1
>  }
>  
> +_scratch_get_iext_count()
> +{
> +	ino=$1
> +	whichfork=$2

Function variables should be declared with 'local' so they don't bleed
into the global namespace (yay bash!), e.g.

	local ino="$1"

Also, now that Eric has landed the xfs_db 'path' command upstream, you
might consider using it:

	_scratch_xfs_get_metadata_field "core.nextents" "path /windows/system.ini"

> +
> +	case $whichfork in
> +		"attr")
> +			field=core.naextents
> +			;;
> +		"data")
> +			field=core.nextents
> +			;;
> +		*)
> +			return 1
> +	esac
> +
> +	nextents=$(_scratch_xfs_db  -c "inode $ino" -c "print $field")
> +	nextents=${nextents##${field} = }

_scratch_xfs_get_metadata_field?

--D

> +
> +	echo $nextents
> +}
> +
>  #
>  # Ensures that we don't pass any mount options incompatible with XFS v4
>  #
> -- 
> 2.29.2
> 
