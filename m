Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC44AC61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 08:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjBVIq7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 03:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjBVIq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 03:46:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C428334C21
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 00:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53ECE61252
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 08:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9297AC433EF;
        Wed, 22 Feb 2023 08:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677055616;
        bh=/+lBuN7TFHnviq4SQsxhUHxcumJcCjGo1wJmBUQLLZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PFpCM/DYlUcPiEk5AbWgXJ9iv/K8nZivWczxU+kLXzhIBhDB6PjnxoiPyNqojM3xq
         yui9He+sOP+bioEcXluJso5JR3jX/bTs0UjXtcsj6ydpH78aWgZW3qrB8vo80l7SYS
         bl8W1QSCSBPBFxWpoQljMFJW43jhw3kOw1281IdXAPQ/w35pIu9nztQUAg0l8jWvd/
         h3cEVUTdP4MYzAVaSCZ/y5sErW4DEf6RUHRUk/odnrbZ5ZWLzLgnmTlvpafsO96LDf
         ER8a25glKRkPxtm51e7h+S46/0iPqBowk5xklExefWfg+jS8k+kB2wDnuFjYpjPvK5
         yO9X+l6G27SHg==
Date:   Wed, 22 Feb 2023 09:46:52 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     tytso@mit.edu, linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 3/5] xfs_io: set fs_path when opening files on foreign
 filesystems
Message-ID: <20230222084652.icpnejpymejeo5y6@andromeda>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
 <cm6fxha5Jffo2nKvE7TOn9PCrb6SxOEuuAFnS8igABlWorje19b3Hs-NNQnK5SqupD4oecWKUqiOMB-auKQtGQ==@protonmail.internalid>
 <167658438451.3590000.8820235517511814402.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167658438451.3590000.8820235517511814402.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 16, 2023 at 01:53:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ted noticed that the following command:
> 
> $ xfs_io -c 'fsmap -d 0 0' /mnt
> xfs_io: xfsctl(XFS_IOC_GETFSMAP) iflags=0x0 ["/mnt"]: Invalid argument
> 
> doesn't work on an ext4 filesystem.  The above command is supposed to
> issue a GETFSMAP query against the "data" device.  Although the manpage
> doesn't claim support for ext4, it turns out that this you get this
> trace data:
> 
>           xfs_io-4144  [002]   210.965642: ext4_getfsmap_low_key: dev
> 7:0 keydev 163:2567 block 0 len 0 owner 0 flags 0x0
>           xfs_io-4144  [002]   210.965645: ext4_getfsmap_high_key: dev
> 7:0 keydev 32:5277:0 block 0 len 0 owner -1 flags 0xffffffff
> 
> Notice the random garbage in the keydev field -- this happens because
> openfile (in xfs_io) doesn't initialize *fs_path if the caller doesn't
> supply a geometry structure or the opened file isn't on an XFS
> filesystem.  IOWs, we feed random heap garbage to the kernel, and the
> kernel rejects the call unnecessarily.
> 
> Fix this to set the fspath information even for foreign filesystems.
> 
> Reported-by: tytso@mit.edu
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  io/open.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/io/open.c b/io/open.c
> index d8072664c16..15850b5557b 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -116,7 +116,7 @@ openfile(
>  	}
> 
>  	if (!geom || !platform_test_xfs_fd(fd))
> -		return fd;
> +		goto set_fspath;
> 
>  	if (flags & IO_PATH) {
>  		/* Can't call ioctl() on O_PATH fds */
> @@ -150,6 +150,7 @@ openfile(
>  		}
>  	}
> 
> +set_fspath:
>  	if (fs_path) {
>  		fsp = fs_table_lookup(path, FS_MOUNT_POINT);
>  		if (!fsp)
> 

-- 
Carlos Maiolino
