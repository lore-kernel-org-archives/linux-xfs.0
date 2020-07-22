Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E750C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556CA207BB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595437306;
	bh=xMJmbrgSD56G3hsDab627QlshdRErLKnIMebeXBrAkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=j/ketAIqbMb4ChjVmoqz7uhp5klYwik2cKwVp8qIn22Y2WMb0HylYuSN5ZI9+AHCi
	 ZzQBCRFiMcz9dT0hzGGmFiQUUzZD0Vzn2cejbwgZ2HlpNs1lv3zoM0MyaZUvwWI5CG
	 JefIKlnx1337yLwaiLbz4Rsymtfjxmq2zj928QDQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGVRBp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 13:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgGVRBp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Jul 2020 13:01:45 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0354C206F5;
        Wed, 22 Jul 2020 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595437305;
        bh=xMJmbrgSD56G3hsDab627QlshdRErLKnIMebeXBrAkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mcrg0LQ7kWWLRIr39+9mAmoVfNntZdJlU+zBbCy+Ko3gnkD2oGpJzj91+9qlBiX4x
         tu1D0WRlSpmAoBQoLb7hGyoPGh5DmV0Qt/KS3Dl9ApxNiJoAZ5xfJlEaxKBj6Xa4eM
         YD/Qx+YH6UaIxEgMCb8UoHHAJLTXRpNmc/NW5XbU=
Date:   Wed, 22 Jul 2020 10:01:44 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4 6/7] fscrypt: document inline encryption support
Message-ID: <20200722170144.GC3912099@google.com>
References: <20200720233739.824943-1-satyat@google.com>
 <20200720233739.824943-7-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720233739.824943-7-satyat@google.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07/20, Satya Tangirala wrote:
> Update the fscrypt documentation file for inline encryption support.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>

> ---
>  Documentation/filesystems/fscrypt.rst | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index f5d8b0303ddf..ec81598477fc 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -1204,6 +1204,18 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
>  buffers regardless of encryption.  Other filesystems, such as ext4 and
>  F2FS, have to allocate bounce pages specially for encryption.
>  
> +Fscrypt is also able to use inline encryption hardware instead of the
> +kernel crypto API for en/decryption of file contents.  When possible,
> +and if directed to do so (by specifying the 'inlinecrypt' mount option
> +for an ext4/F2FS filesystem), it adds encryption contexts to bios and
> +uses blk-crypto to perform the en/decryption instead of making use of
> +the above read/write path changes.  Of course, even if directed to
> +make use of inline encryption, fscrypt will only be able to do so if
> +either hardware inline encryption support is available for the
> +selected encryption algorithm or CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK
> +is selected.  If neither is the case, fscrypt will fall back to using
> +the above mentioned read/write path changes for en/decryption.
> +
>  Filename hashing and encoding
>  -----------------------------
>  
> @@ -1250,7 +1262,9 @@ Tests
>  
>  To test fscrypt, use xfstests, which is Linux's de facto standard
>  filesystem test suite.  First, run all the tests in the "encrypt"
> -group on the relevant filesystem(s).  For example, to test ext4 and
> +group on the relevant filesystem(s).  One can also run the tests
> +with the 'inlinecrypt' mount option to test the implementation for
> +inline encryption support.  For example, to test ext4 and
>  f2fs encryption using `kvm-xfstests
>  <https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md>`_::
>  
> -- 
> 2.28.0.rc0.105.gf9edc3c819-goog
