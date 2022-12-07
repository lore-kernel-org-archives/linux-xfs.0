Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45A7C352A1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 18:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiLGSHE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGSHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 13:07:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D622C60B6E
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 10:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670436368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cc8/Fg69uZrlQsY/Dp+epYkPqMeZZR7m5O0VMtpROEo=;
        b=a8tLRL2wwAKudqXYvOcM/zh6K8Wn1BHfRFilYyYZAzqSDptCfbYHhMSXibxvkyxe0MTSrS
        MuBF7FA5Z0e/a+o2lexk5m9lu1AJ6iM32yZHLvf1k1JU+CZAIu9g8hFxJjBKFst5ljazqS
        MccYOzCs8zksnYwWcY5hvrfIHMEhIzo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-K5zWi1gHMCy4Ztkb6h5qNQ-1; Wed, 07 Dec 2022 13:06:06 -0500
X-MC-Unique: K5zWi1gHMCy4Ztkb6h5qNQ-1
Received: by mail-pg1-f199.google.com with SMTP id e37-20020a635025000000b00476bfca5d31so15014614pgb.21
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 10:06:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cc8/Fg69uZrlQsY/Dp+epYkPqMeZZR7m5O0VMtpROEo=;
        b=FB3jIX0p30g1prf7n7JwevMeDbsXrNDyOB9rgVI+JmegKNbcUjOTKaVsrnWfoSyebz
         EtZ0afSV0M9waG3p7AkDeJM76ptUcbGh06FEyOyZDpQoY4uPEnC8eK12yXkaljgBV/KX
         Pj9EN9tYmnI2yaj/aclP4S2fgyD8dzwR2Q3x4+DYZaPemJWe5BP+i2h8IMxLULwl2UsS
         qSFeuAvE93WvV6L7Ty+/oqar7AkOwUmX42MKdXuJkcbEt9hPlXMWG/mLX/lRs13NVOGq
         C8raHpnqqeLYSV0JhW2fpKd6bZKF4TN1B50NtlCDNTaB5Rl7UALDoaA6Crv3pRMN5R07
         zryg==
X-Gm-Message-State: ANoB5pkIrW67xmut4vqr+A3RIeL34tSktpkXBLEjaHaJVyoEU+eRMhch
        aRlMUsin+j6iuz1tLR91x18XgN+I5UET+y70x9y/9J32LxVge+I+7l8fN0d+pIZfuMZnL0ki7TD
        3S2vTLGcsUioDTzSbVxV/
X-Received: by 2002:a17:902:7c98:b0:188:5255:66b9 with SMTP id y24-20020a1709027c9800b00188525566b9mr913414pll.15.1670436365675;
        Wed, 07 Dec 2022 10:06:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4xsWVtejDsII/yMTA7C7BFBwMKum2E/HkQiIJqRZnTxgH138zyTeydfBimDZtyvmdqHCxiVg==
X-Received: by 2002:a17:902:7c98:b0:188:5255:66b9 with SMTP id y24-20020a1709027c9800b00188525566b9mr913408pll.15.1670436365353;
        Wed, 07 Dec 2022 10:06:05 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v7-20020a1709029a0700b00172cb8b97a8sm14960203plp.5.2022.12.07.10.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 10:06:04 -0800 (PST)
Date:   Thu, 8 Dec 2022 02:06:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, hsiangkao@linux.alibaba.com,
        allison.henderson@oracle.com
Subject: Re: [PATCH V4 1/2] common/xfs: Add a helper to export inode core size
Message-ID: <20221207180600.5s3clfjx7qdjhuyp@zlang-mailbox>
References: <20221207093147.1634425-1-ZiyangZhang@linux.alibaba.com>
 <20221207093147.1634425-2-ZiyangZhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207093147.1634425-2-ZiyangZhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2022 at 05:31:46PM +0800, Ziyang Zhang wrote:
> Some xfs test cases need the number of bytes reserved for only the inode
> record, excluding the immediate fork areas. Now the value is hard-coded
> and it is not a good chioce. Add a helper in common/xfs to export the
> inode core size.
> 
> Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> ---

Darrick has given RVB to this patch, if you didn't change anything from V3
ou can keep it:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

>  common/xfs    | 15 +++++++++++++++
>  tests/xfs/335 |  3 ++-
>  tests/xfs/336 |  3 ++-
>  tests/xfs/337 |  3 ++-
>  tests/xfs/341 |  3 ++-
>  tests/xfs/342 |  3 ++-
>  6 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 8ac1964e..5074c350 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1486,3 +1486,18 @@ _require_xfsrestore_xflag()
>  	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
>  			_notrun 'xfsrestore does not support -x flag.'
>  }
> +
> +# Number of bytes reserved for only the inode record, excluding the
> +# immediate fork areas.
> +_xfs_inode_core_bytes()
> +{
> +	local dir="$1"
> +	
> +	if _xfs_has_feature "$dir" crc; then
> +		# v5 filesystems
> +		echo 176
> +	else
> +		# v4 filesystems
> +		echo 96
> +	fi
> +}
> diff --git a/tests/xfs/335 b/tests/xfs/335
> index ccc508e7..2fd9be54 100755
> --- a/tests/xfs/335
> +++ b/tests/xfs/335
> @@ -31,7 +31,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
>  echo "Create a three-level rtrmapbt"
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes $SCRATCH_MNT)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_ptrs=$(( (blksz - 56) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
> diff --git a/tests/xfs/336 b/tests/xfs/336
> index b1de8e5f..085b43ae 100755
> --- a/tests/xfs/336
> +++ b/tests/xfs/336
> @@ -42,7 +42,8 @@ rm -rf $metadump_file
>  echo "Create a three-level rtrmapbt"
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes $SCRATCH_MNT)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_ptrs=$(( (blksz - 56) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
> diff --git a/tests/xfs/337 b/tests/xfs/337
> index a2515e36..5d6b9964 100755
> --- a/tests/xfs/337
> +++ b/tests/xfs/337
> @@ -33,7 +33,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
>  
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes $SCRATCH_MNT)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_ptrs=$(( (blksz - 56) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
> diff --git a/tests/xfs/341 b/tests/xfs/341
> index f026aa37..c70dec3c 100755
> --- a/tests/xfs/341
> +++ b/tests/xfs/341
> @@ -33,7 +33,8 @@ rtextsz_blks=$((rtextsz / blksz))
>  
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes $SCRATCH_MNT)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
>  blocks=$((i_ptrs * bt_recs + 1))
> diff --git a/tests/xfs/342 b/tests/xfs/342
> index 1ae414eb..4855627f 100755
> --- a/tests/xfs/342
> +++ b/tests/xfs/342
> @@ -30,7 +30,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
>  
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes $SCRATCH_MNT)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
>  blocks=$((i_ptrs * bt_recs + 1))
> -- 
> 2.18.4
> 

