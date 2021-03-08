Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27ACC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28A7652B7
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCHRwd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhCHRwP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 12:52:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D128652AB;
        Mon,  8 Mar 2021 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615225935;
        bh=KOoaIFouh6pUamKpbNK7O1GDD9SS5S6gzgOIm5e2TQE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C3KTndvFGX4mqbfcZMUIEayTqZZJos8memGC6pH8Y7MnYN5+DTmIOrsY6hOMJGCua
         bHkK+Y7FqOtYvMIfluE4nhh1lfSdxAYgiaSpvLquAiRvrCOaYVu9cvSBvMs/uwGWsI
         +VXROWdQokBXsZqCJniuMzq4fzQbn47BNSFDDhtqASIhez2m8vDTfNgo97UdPEI8OS
         4oiUOmxZDCAFWz/o0qoaDsh/4F7sEv23TSsBlFxIAEAA+YbDSJh+hgPbJK+1dmDRrS
         S/TOrFJRC9VGwFedtiyBFnRf68sksky3HElV4ucsy26IDAZWEeHUh05OfW5hT2JRKd
         y88dBdGV0nDqQ==
Date:   Mon, 8 Mar 2021 09:52:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 02/13] common/xfs: Add a helper to get an inode fork's
 extent count
Message-ID: <20210308175213.GP3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-3-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:21:00PM +0530, Chandan Babu R wrote:
> This commit adds the helper _scratch_get_iext_count() which returns an
> inode fork's extent count.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  common/xfs | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 7ec89492..f0ae321e 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -914,6 +914,29 @@ _scratch_get_bmx_prefix() {
>  	return 1
>  }
>  
> +_scratch_get_iext_count()
> +{
> +	local ino=$1
> +	local whichfork=$2
> +	local nextents=0
> +	local field=""
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
> +	nextents=$(_scratch_xfs_get_metadata_field $field "inode $ino")
> +
> +	echo $nextents

Any reason why you capture the contents into a variable and then echo
the variable a line later?  You could omit all that and just end with
the get_metadata_field call.

--D

> +}
> +
>  #
>  # Ensures that we don't pass any mount options incompatible with XFS v4
>  #
> -- 
> 2.29.2
> 
