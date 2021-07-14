Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AF7C47E48
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA35C613D2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhGNXcF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237638AbhGNXcE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 444E6613CF;
        Wed, 14 Jul 2021 23:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305352;
        bh=OtqOMCr7Sn+vLuNyRf5QZ4iOyDLxpUJvZYIQEEDR1ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mfJ/wfHaUkFQg0x6VV1QM8sKQmosGAh7IcHMyJDsw+IuechKxbvehI+gTiQdsPEyY
         oCtK9q/KN0zplTUc8Z/rjBEHAncruwMZqpYEBvKYqtK9w704r5gyGNaWV8GvKvQOe4
         Sz55kh67vyF60xMRQZGgzULEOnzr8V8aTYGhSgspfF8xZHAMl/Hz9aJF6QsTXxTiYS
         FtIpvmDZ02I9MCBYv/XClKlTl2ZD5sxHT50Yy7nYHKw36IknhAgIioaGqIei9eS1Qz
         ChaWr9f4LYexU9qzA76G8pnGHnaXU/cFaCEUySs35ThiZCeK5tllCBqzNQVpzYwrmJ
         TLEtqLmwO/VKQ==
Date:   Wed, 14 Jul 2021 16:29:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs/304: don't turn quota accounting off
Message-ID: <20210714232912.GN22402@magnolia>
References: <20210712111146.82734-1-hch@lst.de>
 <20210712111146.82734-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111146.82734-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:11:45PM +0200, Christoph Hellwig wrote:
> The test case tests just as much when just testing turning quota
> enforcement off, so switch it to that.  This is in preparation for
> removing support to turn quota accounting off.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/304 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/304 b/tests/xfs/304
> index 2716ccd5..91fa5d97 100755
> --- a/tests/xfs/304
> +++ b/tests/xfs/304
> @@ -31,7 +31,7 @@ QUOTA_DIR=$SCRATCH_MNT/quota_dir
>  
>  mkdir -p $QUOTA_DIR
>  echo "*** turn off group quotas"
> -xfs_quota -x -c 'off -g' $SCRATCH_MNT
> +xfs_quota -x -c 'disable -g' $SCRATCH_MNT
>  rmdir $QUOTA_DIR
>  echo "*** umount"
>  _scratch_unmount
> @@ -39,7 +39,7 @@ _scratch_unmount
>  _qmount
>  mkdir -p $QUOTA_DIR
>  echo "*** turn off project quotas"
> -xfs_quota -x -c 'off -p' $SCRATCH_MNT
> +xfs_quota -x -c 'disable -p' $SCRATCH_MNT
>  rmdir $QUOTA_DIR
>  echo "*** umount"
>  _scratch_unmount
> @@ -47,7 +47,7 @@ _scratch_unmount
>  _qmount
>  mkdir -p $QUOTA_DIR
>  echo "*** turn off group/project quotas"
> -xfs_quota -x -c 'off -gp' $SCRATCH_MNT
> +xfs_quota -x -c 'disable -gp' $SCRATCH_MNT
>  rmdir $QUOTA_DIR
>  echo "*** umount"
>  _scratch_unmount
> -- 
> 2.30.2
> 
