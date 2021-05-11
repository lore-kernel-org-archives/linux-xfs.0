Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C665C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 15:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 418CA6128E
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 15:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhEKPKx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 11:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231874AbhEKPKx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 11:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FEB5613C1;
        Tue, 11 May 2021 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620745786;
        bh=paei3DVSoEhmQ/3lQjt1xURX22gmIT6xKJm93DBNxkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PpHej/Dmsd+ktKuy2AlYfcrnAxxdpmkQfC1KDa1o1fgS/N3sO5HnzGMtGkBuOcjhr
         0QK1puMt2tORmjsJlkIDWJ2i4o+Ak+hW+W9HREkgzSLUTj+kJ5LA9cb52FYgWo6jt2
         WkOMjS0MJM1TZqT1oQNtp5ot8T/BCDfBQWHWnsHuWIU+CACIvuK0Sd0p6pUnh5vXWe
         7DrF5mhKPjE5ITZTqlwDAts3/1g8pqJ7dLl1p7014eAZJ8bByZ7Zb7KNhvmDUgjf0r
         YIKDG4X6g7OMCdXhISRZTD5Nc9rLSJ6lcwhIyAEcYdy/DDVfDRZx5PA8aHV/0gXYn6
         bQuvwuyoC/yaw==
Date:   Tue, 11 May 2021 08:09:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v5 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Message-ID: <20210511150946.GM8582@magnolia>
References: <20210511073945.906127-1-hsiangkao@redhat.com>
 <20210511073945.906127-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511073945.906127-2-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 03:39:43PM +0800, Gao Xiang wrote:
> In order to detect whether the current kernel supports XFS shrinking.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  common/xfs | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 69f76d6e..184aa01e 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -766,6 +766,26 @@ _require_xfs_mkfs_without_validation()
>  	fi
>  }
>  
> +_require_xfs_scratch_shrink()
> +{
> +	_require_scratch
> +	_require_command "$XFS_GROWFS_PROG" xfs_growfs
> +
> +	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +	. $tmp.mkfs
> +	_scratch_mount
> +	# here just to check if kernel supports, no need do more extra work
> +	errmsg=$($XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" 2>&1)
> +	if [ "$?" -ne 0 ]; then
> +		echo "$errmsg" | grep 'XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument' && \
> +			_notrun "kernel does not support shrinking"
> +		echo "$errmsg" | grep 'data size .* too small, old size is ' && \
> +			_notrun "xfsprogs does not support shrinking"
> +		_fail "$XFS_GROWFS_PROG failed unexpectedly"

Silly nit: why not print $errmsg in the fail string?

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	fi
> +	_scratch_unmount
> +}
> +
>  # XFS ability to change UUIDs on V5/CRC filesystems
>  #
>  _require_meta_uuid()
> -- 
> 2.27.0
> 
