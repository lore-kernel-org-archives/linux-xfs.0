Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F865C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E667C652AB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCHRyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230250AbhCHRxo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 12:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF3E664D73;
        Mon,  8 Mar 2021 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615226024;
        bh=1Km2A7ZwMXea+D2Om2Np0pD1iLZP9NN92dx+kFmPWs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=So3/uYYYDCRtMAr/WPBq/zyrY7/47As+BRPnIKUvnjZyaZQUDLPOO/+6uKYS8T15v
         8bC+5qOB2n4JSaZXRM0F/VvDR2xVLfQptm3enrC8mtdXq+7bdkEgdPXROLNt25KjnO
         yFHGv+3Y8iwHGTQccEHqM2Hg90AGXy3VnpuYHXqhYjt32kXDC15VSMXTT6U/uh1Rcq
         dS4/9yMmlLwHnpeNTchsWfCNDw7bAe0vsqArOR67J4G0jTGgz8Jed7N33HqUpqEQCZ
         fxmgcGn1r2X0+ukEvZesRB70O950+gVdTRR5e7s5SrX0G9Hf/1aYtLymLws/fc3VU7
         wyxQFvJsccbIg==
Date:   Mon, 8 Mar 2021 09:53:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 03/13] common/xfs: Add helper to obtain fsxattr field
 value
Message-ID: <20210308175343.GQ3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-4-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:21:01PM +0530, Chandan Babu R wrote:
> This commit adds a helper function to obtain the value of a particular field
> of an inode's fsxattr fields.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  common/xfs | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index f0ae321e..9a0ab484 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -194,6 +194,18 @@ _xfs_get_file_block_size()
>  	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
>  }
>  
> +xfs_get_fsxattr()

Shared helpers always begin with an underscore, e.g.
_xfs_get_fsxattr()

> +{
> +	local field="$1"
> +	local path="$2"
> +	local value=""
> +
> +	value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
> +	value=${value##fsxattr.${field} = }
> +
> +	echo "$value"

This could be streamlined to:

	local value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
	echo "${value##fsxattr.${field} = }"

Right?

--D

> +}
> +
>  # xfs_check script is planned to be deprecated. But, we want to
>  # be able to invoke "xfs_check" behavior in xfstests in order to
>  # maintain the current verification levels.
> -- 
> 2.29.2
> 
