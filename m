Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAD2C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF856207BB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595437660;
	bh=lrvRB6IMtIhg3LyXmKGp5DKL4F5360nyGUKKpkB6a6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NJQO8XtFf9oMk+muzoR3yJ0xFHm1C2HY1ubNkOhKlzqNflhtw0Xk9dFIHcFxZ0GKz
	 0Cg1UDO7Ujfx11XoGLXHdoEbtWchl1WGNFYe+MEIkBC4c5qsync0pKaI/Cms0IG34x
	 m+Eoexu8EKEOx68puuFeG12+y5Z0p2FV+XgtihcM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgGVRHk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 13:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgGVRHk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Jul 2020 13:07:40 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76DED2065F;
        Wed, 22 Jul 2020 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595437659;
        bh=lrvRB6IMtIhg3LyXmKGp5DKL4F5360nyGUKKpkB6a6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aI9Wi6pSaEG/S9c9su+uORfKY473DfMmnndryhb7OhnbvOIVUD6fkKmpBSCRE7UDh
         Fq+REBJwGcG+FFGpCsa9h1LBIEdi95Eq9jp274ieWYidzJHQ1isIWpZej9n0sosl/9
         WLUxZiNa6zn3W1aeuYxFOmFX5AxdqOZWPdUA+NKU=
Date:   Wed, 22 Jul 2020 10:07:39 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4 4/7] ext4: support direct I/O with fscrypt using
 blk-crypto
Message-ID: <20200722170739.GG3912099@google.com>
References: <20200720233739.824943-1-satyat@google.com>
 <20200720233739.824943-5-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720233739.824943-5-satyat@google.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07/20, Satya Tangirala wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Wire up ext4 with fscrypt direct I/O support. direct I/O with fscrypt is
> only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
> have been enabled, the 'inlinecrypt' mount option must have been specified,
> and either hardware inline encryption support must be present or
> CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
> direct I/O on encrypted files is only supported when I/O is aligned
> to the filesystem block size (which is *not* necessarily the same as the
> block device's block size).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>

Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>

> ---
>  fs/ext4/file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2a01e31a032c..d534f72675d9 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -36,9 +36,11 @@
>  #include "acl.h"
>  #include "truncate.h"
>  
> -static bool ext4_dio_supported(struct inode *inode)
> +static bool ext4_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
>  {
> -	if (IS_ENABLED(CONFIG_FS_ENCRYPTION) && IS_ENCRYPTED(inode))
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +
> +	if (!fscrypt_dio_supported(iocb, iter))
>  		return false;
>  	if (fsverity_active(inode))
>  		return false;
> @@ -61,7 +63,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		inode_lock_shared(inode);
>  	}
>  
> -	if (!ext4_dio_supported(inode)) {
> +	if (!ext4_dio_supported(iocb, to)) {
>  		inode_unlock_shared(inode);
>  		/*
>  		 * Fallback to buffered I/O if the operation being performed on
> @@ -490,7 +492,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	}
>  
>  	/* Fallback to buffered I/O if the inode does not support direct I/O. */
> -	if (!ext4_dio_supported(inode)) {
> +	if (!ext4_dio_supported(iocb, from)) {
>  		if (ilock_shared)
>  			inode_unlock_shared(inode);
>  		else
> -- 
> 2.28.0.rc0.105.gf9edc3c819-goog
