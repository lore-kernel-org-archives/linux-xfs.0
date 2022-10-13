Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6574C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 15:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJMPKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 11:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiJMPKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 11:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A56248F7
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665673810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VVV54PEivNAROJTBawLaxyJ3VvT63imNw2B87EuyNTM=;
        b=KSTXtr8kZOgsy7ULDjKS681MB9K21nu0bTPh14nu/4CKGDOOsRj2k/ivd4NC/2Zd6FplI3
        pGCRjHhoKNz5hWLvQ90scqDEEZp2R27EQrqJ6THRNxKhpS3K0nmQOsiLd26wgpOzgQuTw9
        avb1+LIRwYtBoD4RZFGfQCOXlMP5Cck=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-wtVQthbLPZ2GVbS1BGjZyA-1; Thu, 13 Oct 2022 11:10:09 -0400
X-MC-Unique: wtVQthbLPZ2GVbS1BGjZyA-1
Received: by mail-qt1-f197.google.com with SMTP id k9-20020ac85fc9000000b00399e6517f9fso1464727qta.18
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 08:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVV54PEivNAROJTBawLaxyJ3VvT63imNw2B87EuyNTM=;
        b=PQCBZY3Iy735TSi2k9SgVRwlNJXBpbQEdTsl3ZhsFfN04CGKiTrTeptY3fr5fi+wX8
         +zjG+eDajwiPQLKbkfyFqH+NNlseT2ZyESded1dsm1za+kgJi0vySZUMix4eb9gNwmAe
         AXwuFDvQcfcUj1Q/3+Jb48s/cRo2gfc6XuDE+ShONJ3jBbPFokTchQHkQzI9MkUC0DHR
         H9FNsMiKsfrw2QtAQaGRqk35UEgtRkn1Tsj6c3WTG3/vp3+8/UEnMbrjvtDTTQxO1d9b
         xPr0WBvZ/0hi7cermuQKh2Kn4vTERcTjnbkgFWiCTZstkPRsrqP7FFr0pa9flxDkYw4n
         cUtw==
X-Gm-Message-State: ACrzQf1w0leXQK6DEpSzc73tu3ULd/g6x6FTpCJ+mWG0AKxLgqC52mQA
        M34UIS5vdLoVUBMiy3t5kObWcRu6l+D3RTyGBJaOtqSsIwtbYDLb34KE/c395wT6d51QAYkV+cC
        xPbkMq+1k2e7p/K0eStLO
X-Received: by 2002:a05:620a:440e:b0:6ed:ae2d:e52f with SMTP id v14-20020a05620a440e00b006edae2de52fmr299697qkp.450.1665673807973;
        Thu, 13 Oct 2022 08:10:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5b3P9G7h6cavTIa662/bHUSHzWGyjZXhBRd5ps2AoShjTNZIHzJpIatp2w02Ez5yxeTbibBA==
X-Received: by 2002:a05:620a:440e:b0:6ed:ae2d:e52f with SMTP id v14-20020a05620a440e00b006edae2de52fmr299665qkp.450.1665673807644;
        Thu, 13 Oct 2022 08:10:07 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w2-20020a05620a444200b006ee7e223bb8sm7792751qkp.39.2022.10.13.08.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:10:07 -0700 (PDT)
Date:   Thu, 13 Oct 2022 23:10:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/5] populate: wipe external xfs log devices when
 restoring a cached image
Message-ID: <20221013151002.ctyhb4wg6ckeokeq@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553913349.422450.12686256615707425089.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166553913349.422450.12686256615707425089.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 06:45:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The fs population code has the ability to save cached metadumps of
> filesystems to save time when running fstests.  The cached images should
> be unmounted cleanly, so we never save the contents of external log
> devices.
> 
> Unfortunately, the cache restore code fails to wipe the external log
> when restoring a clean image, so we end up with strange test failures
> because the log doesn't match the filesystem:
> 
> * ERROR: mismatched uuid in log
> *            SB : 5ffec625-d3bb-4f4e-a181-1f9efe543d9c
> *            log: 607bd75a-a63d-400c-8779-2139f0a3d384
> 
> Worse yet, xfs_repair will overwrite a filesystem's uuid with the log
> uuid, which leads to corruption messages later on:
> 
> Metadata corruption detected at 0x561f69a9a2a8, xfs_agf block 0x8/0x1000
> xfs_db: cannot init perag data (117). Continuing anyway.
> 
> Solve this by wiping the log device when restoring.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Make sense,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/populate |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index b501c2fe45..0bd78e0a0a 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -11,7 +11,12 @@ _require_populate_commands() {
>  	_require_xfs_io_command "falloc"
>  	_require_xfs_io_command "fpunch"
>  	_require_test_program "punch-alternating"
> -	_require_command "$XFS_DB_PROG" "xfs_db"
> +	case "${FSTYP}" in
> +	"xfs")
> +		_require_command "$XFS_DB_PROG" "xfs_db"
> +		_require_command "$WIPEFS_PROG" "wipefs"
> +		;;
> +	esac
>  }
>  
>  _require_xfs_db_blocktrash_z_command() {
> @@ -851,7 +856,19 @@ _scratch_populate_restore_cached() {
>  
>  	case "${FSTYP}" in
>  	"xfs")
> -		xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" && return 0
> +		xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
> +		res=$?
> +		test $res -ne 0 && return $res
> +
> +		# Cached images should have been unmounted cleanly, so if
> +		# there's an external log we need to wipe it and run repair to
> +		# format it to match this filesystem.
> +		if [ -n "${SCRATCH_LOGDEV}" ]; then
> +			$WIPEFS_PROG -a "${SCRATCH_LOGDEV}"
> +			_scratch_xfs_repair
> +			res=$?
> +		fi
> +		return $res
>  		;;
>  	"ext2"|"ext3"|"ext4")
>  		# ext4 cannot e2image external logs, so we cannot restore
> 

