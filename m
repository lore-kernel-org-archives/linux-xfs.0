Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BCE51C55
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 05:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709010662; cv=none; b=gRCs5vXptJ8XaAwlqfmrnmGMq9Vm8djMKs3hPfsYh5Ao1p7VStpFRhcphuIO+c7xpiYvRZ89W3olXGQ7UgyI/BvTODsQ1UKaeZYMA7sL5r6zElubyc99MqFYc+JjlYyfWnvLIsCg3avHwJuHjVqN04CTARoN4N3WHEMrknAXoyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709010662; c=relaxed/simple;
	bh=FSVotyAvgV+xn5aVoLZ+CfYH1wGm1W6JDEBz3wjMgXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtxXJcO/IThEQ0QRi2Yw3Zg6gbUpP/2g+SZ/LiWufrI0uGv2nKXpMuQKVZZHGQFZlCFKqHrw1lDPBChMIOPHo0ZwaUX5xkAzymjqXPMAZCS4oy4JVSj9TFQYuyC0OFooWvMbhdoXfF+sRl2lW2X+NGr3Ses4bxXxMRmUn2+f5S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMg29WfY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMg29WfY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709010658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9UKbUVmfg7rYiZ6YYythOWw2tRNdaLWQiIUax/Sx3TM=;
	b=VMg29WfYlz4MXaZ90g9/RaYl6DbLGTNPFRB6GcYFHsY6naWc2OuPEfSyqIopGcAnLbXlm2
	CTmfmRM40AV97bwO4XCAqTw5y0d9SUFyrVPYIGSgEZ0jz65+S1IMDE7cBlNEZGudhAWZro
	4PgcgJm40vLvoVXsLIL7sW0O+pHoyUk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-T_J2PRy9OBSvK1LuO2ci3g-1; Tue, 27 Feb 2024 00:10:53 -0500
X-MC-Unique: T_J2PRy9OBSvK1LuO2ci3g-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-299ba5ae65eso2891185a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 21:10:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709010653; x=1709615453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UKbUVmfg7rYiZ6YYythOWw2tRNdaLWQiIUax/Sx3TM=;
        b=BsHiQZYW8HA9ZO/gvGVR037q/ufUHuIT0cer9JDOlKAyFE71jXLT264HS/7DyoL1S4
         xzQ55kfbVGgkj3AZ5gq+f3oJdGMUrir1WSiuv1t65Rq0evrkWuuQ43d3xoh2xcLcxtqF
         51EpWpBzw4hmwRVEFdHtoW5MrJxBSt/XAX34CZa0UyOg3BLgbUEmSxD1dTxas3QUI2cB
         i0ACW6zDT2qUbjHYtKq/Drgyn0BZ292+17cofj81JzHw/Gnr1i+HPH+iRJO80czWN2er
         l6iz+LY69FX3diRwdTTx3WkMhxhpZd2E6j7pr+nBqOTlOGLwm0lBRYYxChXfMyf04ZRE
         0rUQ==
X-Gm-Message-State: AOJu0YwEybm8Anw1aWWN2uen47DQjVMVDKiwhJwpOqRMBix71xrnQR1I
	9qupaBJmrnHemYJc9G8LWCF5uzAyA/FlSFqBHRUZ1G1/J+8wQ6E3xYOIMwoDgU//gJi9+7IDxdQ
	QJUuKtQ6A4ihcmdVvWalIKjN7J68bTXIK/cDXF629ZMioL8QUkbl+hBs97Q==
X-Received: by 2002:a17:90a:f48b:b0:29a:7100:2519 with SMTP id bx11-20020a17090af48b00b0029a71002519mr6716839pjb.35.1709010652967;
        Mon, 26 Feb 2024 21:10:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGUHpH4/EQNYyazBorgO9isXCFqIXFmrElMB2zvliiLSm2TB11Hzh/KMnjMNTnp9SoH1BP0A==
X-Received: by 2002:a17:90a:f48b:b0:29a:7100:2519 with SMTP id bx11-20020a17090af48b00b0029a71002519mr6716824pjb.35.1709010652624;
        Mon, 26 Feb 2024 21:10:52 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fv6-20020a17090b0e8600b0029acce2420asm2364602pjb.10.2024.02.26.21.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 21:10:52 -0800 (PST)
Date: Tue, 27 Feb 2024 13:10:49 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <20240227051049.yzojj3n3qtwiag2t@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:02:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update this test to check that the ondisk unions for rt bitmap word and
> rt summary counts are always the correct size.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/122     |    2 +-
>  tests/xfs/122.out |    2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index ba927c77c4..4e5ba1dfee 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -195,7 +195,7 @@ echo 'int main(int argc, char *argv[]) {' >>$cprog
>  #
>  cat /usr/include/xfs/xfs*.h | indent |\
>  _attribute_filter |\
> -grep -E '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
> +grep -E '(} *xfs_.*_t|^(union|struct) xfs_[a-z0-9_]*$)' |\
>  grep -E -v -f $tmp.ignore |\
>  sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
>  sort | uniq |\
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index 067a0ec76b..a2b57cfb9b 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -124,6 +124,8 @@ sizeof(struct xfs_swap_extent) = 64
>  sizeof(struct xfs_sxd_log_format) = 16
>  sizeof(struct xfs_sxi_log_format) = 80
>  sizeof(struct xfs_unmount_log_format) = 8
> +sizeof(union xfs_rtword_raw) = 4
> +sizeof(union xfs_suminfo_raw) = 4
>  sizeof(xfs_agf_t) = 224
>  sizeof(xfs_agfl_t) = 36
>  sizeof(xfs_agi_t) = 344
> 

