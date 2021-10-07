Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2796C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E5216105A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbhJGQRn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 12:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231495AbhJGQRn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Oct 2021 12:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DA16610E6;
        Thu,  7 Oct 2021 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623349;
        bh=s78kXF6ET3D+RY8YLYXBo5UxO6AnsgdgwjJt8RVB3iM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T0/zHlMro95taJUzknqTWCH/zKaeqjURxnPfSua0xW1CedVySEBFE348oZufI8Hqv
         gbiAoVXHPjE17tBfwan/I3yZSKCzw8OV93lVblYhL8D8YkO9zTEo+lYalzzw46AC9l
         lRIcYz8TqTQoxgR10EwYQ1twE3kx2UDnSH9nyAMUNJvuayqn2ZR2r7L4dLgEM0tVXL
         iU1UasLMeNiNQVmW2lqS+pOh9ZyM07GWdId1UyQ46LWHDB7jalgVe9rechHs0Vy1M0
         kbWTPD0QEqpr4prpaN01Y2XfQniowb1FuEOL2o6C1E+8cAczi8j4QtWtoWBTirsFp0
         WU8S+YcCyCfZw==
Date:   Thu, 7 Oct 2021 09:15:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH v2 4/4] common/log: Fix *_dump_log routines for ext4
Message-ID: <20211007161548.GA24282@magnolia>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
 <20211007002641.714906-5-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007002641.714906-5-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 07, 2021 at 12:26:41AM +0000, Catherine Hoang wrote:
> dumpe2fs -h displays the superblock contents, not the journal contents.
> Use the logdump utility to dump the contents of the journal.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/log | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/common/log b/common/log
> index 0a9aaa7f..154f3959 100644
> --- a/common/log
> +++ b/common/log
> @@ -229,7 +229,7 @@ _scratch_dump_log()
>  		$DUMP_F2FS_PROG $SCRATCH_DEV
>  		;;
>  	ext4)
> -		$DUMPE2FS_PROG -h $SCRATCH_DEV
> +		$DEBUGFS_PROG -R "logdump -a" $SCRATCH_DEV

Hmm.  Some of the tests call _require_command on various e2fsprogs
programs.  However, debugfs has been a part of e2fsprogs since forever
and e2fsprogs is a required fstests dependency, so I guess those
callsites are unnecessary (but otherwise benign).  For that matter, I
think e2fsprogs is an 'essential' package on Debian and almost always
installed by Linux distros.  I think that means it's safe to assume that
debugfs is present.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  		;;
>  	*)
>  		;;
> @@ -246,7 +246,7 @@ _test_dump_log()
>  		$DUMP_F2FS_PROG $TEST_DEV
>  		;;
>  	ext4)
> -		$DUMPE2FS_PROG -h $TEST_DEV
> +		$DEBUGFS_PROG -R "logdump -a" $TEST_DEV
>  		;;
>  	*)
>  		;;
> -- 
> 2.25.1
> 
