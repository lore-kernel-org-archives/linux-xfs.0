Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7354C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99846652B1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCIFEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhCIFET (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 00:04:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4146C65199;
        Tue,  9 Mar 2021 05:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615266259;
        bh=BJqI1aGpYnIO+O1/iOnaZD7P9grW63eEqAJ0kc8tR9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=npzz0AJi3rOYYrB+6wbQPG5nCbV2aZ6b5KgT4bitQYWO4QJ5jIwWkKXtLF1sKnD2/
         IPMj29CukovukN10rlQMiKl9MtdyQAeCKZQSmr/KPXemHjPi474PREMQw0uz9qbQ9V
         BzDfuSDDL+r/ChUqAYQu5cEpUjTNJo+27vHyoLoQoAnyw5LwGdU2EKaq0eSb5XxNep
         mTwuR1g1c3R166A60v/Vv6M/fE3TQ43yI0vIei+KNp3AkTn8F8/0l3ZSzqav96EOT3
         YydKElYuSOBseS7M4h5nprzygiShM8r3CEA6+9UZ2nCeuRJFL9In0PhExdlkONWFeq
         8SZkdKvhd0c8w==
Date:   Mon, 8 Mar 2021 21:04:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 02/13] common/xfs: Add a helper to get an inode fork's
 extent count
Message-ID: <20210309050418.GA7269@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309050124.23797-3-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 10:31:13AM +0530, Chandan Babu R wrote:
> This commit adds the helper _scratch_get_iext_count() which returns an
> inode fork's extent count.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 41dd8676..26ae21b9 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -924,6 +924,26 @@ _scratch_get_bmx_prefix() {
>  	return 1
>  }
>  
> +_scratch_get_iext_count()
> +{
> +	local ino=$1
> +	local whichfork=$2
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
> +	_scratch_xfs_get_metadata_field $field "inode $ino"
> +}
> +
>  #
>  # Ensures that we don't pass any mount options incompatible with XFS v4
>  #
> -- 
> 2.29.2
> 
