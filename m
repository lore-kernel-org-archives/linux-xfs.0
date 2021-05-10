Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF72C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 17:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43259614A5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 17:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhEJSA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 14:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232262AbhEJSA6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 May 2021 14:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60DC6611BD;
        Mon, 10 May 2021 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620669593;
        bh=02wHXbUR5HLBTn700P2Da+yYHwTsuw1A6Sj8seNhA2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rj/eVwnHtCZ09plcASVJTnMDuNzL3qLQmZ4qm4kpfFEzxLconDqLJKiZ/+NJ8vASp
         e2LLTrILmD5Ci+kHDrfjk3Ozt/5P0qtutV/b/GkmdEINSbmy9CHV9tPhkN/cTyXMPx
         gVKM7WQYU0Hjz8alw3PZs491H6LSS8MeCdiueZnqW0PcodA+4YUOcwexlPzX3/G8cq
         R4w4TrjD3IzkG/j+VQEzSZfsLph5jVkNrX1K7KldO/oLL6qjHnMl/OkTflcyHd+Ul+
         lgMovBZp9EfNv63Z8b2BPMJEDKSWZp/XSVKp6xK8yL/zJO1fm6c5iG06+WVHA9jnKR
         JmraBUWm1ckNw==
Date:   Mon, 10 May 2021 10:59:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v4 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Message-ID: <20210510175952.GA8558@magnolia>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
 <20210402094937.4072606-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402094937.4072606-2-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 05:49:35PM +0800, Gao Xiang wrote:
> In order to detect whether the current kernel supports XFS shrinking.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  common/xfs | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 69f76d6e..c6c2e3f5 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -766,6 +766,20 @@ _require_xfs_mkfs_without_validation()
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
> +	$XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" > /dev/null 2>&1 || \
> +		_notrun "kernel does not support shrinking"

I think isn't sufficiently precise -- if xfs_growfs (userspace) doesn't
support shrinking it'll error out with "data size XXX too small", and if
the kernel doesn't support shrink, it'll return EINVAL.

As written, this code attempts a single-block shrink and disables the
entire test if that fails for any reason, even if that reason is that
the last block in the filesystem isn't free, or we ran out of memory, or
something like that.

I think this needs to check the output of xfs_growfs to make the
decision to _notrun.

--D

> +	_scratch_unmount
> +}
> +
>  # XFS ability to change UUIDs on V5/CRC filesystems
>  #
>  _require_meta_uuid()
> -- 
> 2.27.0
> 
