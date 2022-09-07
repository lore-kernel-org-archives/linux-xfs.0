Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C95C38145
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Sep 2022 09:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiIGJKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Sep 2022 05:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIGJKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 05:10:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84D174B84;
        Wed,  7 Sep 2022 02:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A50B617D8;
        Wed,  7 Sep 2022 09:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFE0C433C1;
        Wed,  7 Sep 2022 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662541808;
        bh=a6rxNDyNfNYsftFOTgasxTViBPk+jSbvU4105tQOkhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WbUGnYmnyFUJoHmUJJNdkTfTbKlPdXgHPr6kq8a5AS52w8H4F2fLqyyuPqnpfXV8k
         37Zvs4OH5t6Hisr1Kr1ar+Srb4OFC2sceheTmucJeYWHEk0UabmunmqGt+Rmk/BZA+
         MIBjoqwWGIc1EU3fa/Pn7cfW3nZvtyCJNLWYMQY+jxycJNzGnHvEuiUs0DKarv6FSg
         XcNIBcxLDyRBP1Qbu0guN/v1Kfnb3RRqgCT2UJ3oHI7Yc1I2V8NTb8eTLSB5xrknjZ
         ATDIZfsT+DqdOdZMjCbb2DP99VSiZ1Mj/Xnsu3jHmWSU81XAYsNmH/NaXvzC45Ug5c
         w/N7bwzH1xjJw==
Date:   Wed, 7 Sep 2022 11:10:02 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 1/8] statx: add direct I/O alignment information
Message-ID: <20220907091002.6ay72r4tgk5g6rma@wittgenstein>
References: <20220827065851.135710-1-ebiggers@kernel.org>
 <20220827065851.135710-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220827065851.135710-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 26, 2022 at 11:58:44PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Traditionally, the conditions for when DIO (direct I/O) is supported
> were fairly simple.  For both block devices and regular files, DIO had
> to be aligned to the logical block size of the block device.
> 
> However, due to filesystem features that have been added over time (e.g.
> multi-device support, data journalling, inline data, encryption, verity,
> compression, checkpoint disabling, log-structured mode), the conditions
> for when DIO is allowed on a regular file have gotten increasingly
> complex.  Whether a particular regular file supports DIO, and with what
> alignment, can depend on various file attributes and filesystem mount
> options, as well as which block device(s) the file's data is located on.
> 
> Moreover, the general rule of DIO needing to be aligned to the block
> device's logical block size was recently relaxed to allow user buffers
> (but not file offsets) aligned to the DMA alignment instead.  See
> commit bf8d08532bc1 ("iomap: add support for dma aligned direct-io").
> 
> XFS has an ioctl XFS_IOC_DIOINFO that exposes DIO alignment information.
> Uplifting this to the VFS is one possibility.  However, as discussed
> (https://lore.kernel.org/linux-fsdevel/20220120071215.123274-1-ebiggers@kernel.org/T/#u),
> this ioctl is rarely used and not known to be used outside of
> XFS-specific code.  It was also never intended to indicate when a file
> doesn't support DIO at all, nor was it intended for block devices.
> 
> Therefore, let's expose this information via statx().  Add the
> STATX_DIOALIGN flag and two new statx fields associated with it:
> 
> * stx_dio_mem_align: the alignment (in bytes) required for user memory
>   buffers for DIO, or 0 if DIO is not supported on the file.
> 
> * stx_dio_offset_align: the alignment (in bytes) required for file
>   offsets and I/O segment lengths for DIO, or 0 if DIO is not supported
>   on the file.  This will only be nonzero if stx_dio_mem_align is
>   nonzero, and vice versa.
> 
> Note that as with other statx() extensions, if STATX_DIOALIGN isn't set
> in the returned statx struct, then these new fields won't be filled in.
> This will happen if the file is neither a regular file nor a block
> device, or if the file is a regular file and the filesystem doesn't
> support STATX_DIOALIGN.  It might also happen if the caller didn't
> include STATX_DIOALIGN in the request mask, since statx() isn't required
> to return unrequested information.
> 
> This commit only adds the VFS-level plumbing for STATX_DIOALIGN.  For
> regular files, individual filesystems will still need to add code to
> support it.  For block devices, a separate commit will wire it up too.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Looks good to me,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
