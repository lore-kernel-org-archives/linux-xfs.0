Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0553112A5;
	Thu, 18 Jun 2026 13:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790857; cv=none; b=D+d+reQ7qFX95eiKft82rEoehM7ByPykc5bGcA5HcsmUW7YuixVI/BEAxndJp316h2cgnXcOAxqSCT6F/GqfCmsEVnyOgXGRQ9hQAotKMhICeZwzKnXg4LpIeYb5wrKRraNFT8YM8zGG/fpE5FY52RVOaCfAyvUv+F98kbdh6OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790857; c=relaxed/simple;
	bh=MWV2PzKq1+HwtW3ZkNtQRu0GiYZyT1CKTNvtHnyWhG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vcjle5RvVHpfbz/l22lHbI5cfEUIOfyZ3bkw5ZZ9J5Uduo0OJ0XdAUMsMp0hv7F7CJzxtV4j6LQYE85eS1DoFaJ/v8x7at7lfFmWXAGcvJY2EfLgCHfXJ7eHCp2ztgQRzXz94bbEjmYyo8WS1jex74Bz9Z4AH90fZrsubnk9zZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=PeB68YbP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jfoexykK; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="PeB68YbP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jfoexykK"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id B1CE8EC021A;
	Thu, 18 Jun 2026 09:54:14 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 18 Jun 2026 09:54:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1781790854;
	 x=1781877254; bh=decbjfi+lAEJpbxeHDL5qHOjQZpsb2h/3EofLyxIDIM=; b=
	PeB68YbPLhxXyYxL+PBh7VQGQFmQWQtaZlPqLRw/mP8Wf/lSyQMHM0O/dMaNzweg
	qM+G2dWC3lQAPfESIJPSPJt7tztFcnwSO88QneJfUh8gFy00LDgv9A1NyNAmzKgW
	GSzhJ+ub6DpaBRM7pFkww7r1Ca2MXktKS72S3V0RfHS0yXUk7H4j3ZsTkFtuvJLB
	hNOEWVj8hA6aWWGWIjPOXXkR0PTrPw9R0uPBz2WAfm/OFVlVy24729untm/50OTt
	lpSMoMpji+0T+ndt9Wep4u2Xbgy7TjmBKcwCKzP0fbFn8jN0LMFP8W1YO3X5ly78
	DXs2xxp31GVrWy9/0bwzcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781790854; x=
	1781877254; bh=decbjfi+lAEJpbxeHDL5qHOjQZpsb2h/3EofLyxIDIM=; b=j
	foexykKZc6iHUUNlwtflS+yDDWjuZ71uBbB/yhvmhL15GBEsEvxixppGADq3AN8K
	KweJdAxLZ4AQjowGANBYLLDvgajKSKKwZB5MlRlm2iMRypo+KOQK1lVjem0XAgK7
	ug5zdzoHVF6uje+GJYKAEgnQ5hd53PUG8JR9m9ez1t9uRuLOlD0t3Ex8Kl4CcLhk
	lgmuS0oI+PezN8asVk1nNTSPHyIowRSdk0hBwpJpFZPlHYrP0sJGN0UQjR3xH4Lg
	lXOgKEhu+jRaTFcLU2DRaCwZaFTZmJl5pyqE5G0fcHKxO8iYYKB39JDo3o5tMYEZ
	4LxqfO2eA3UBz5amuF15Q==
X-ME-Sender: <xms:hvgzajxt1-l2NdKFz--4IfMcGwpeHe7-L_A5HOQMiHUm31J1WhC_pQ>
    <xme:hvgzar_Y3GakCOvB6e_DUnakLAoiQZe5brsZWLX1-z02pLrOt5GHlJQzZjPtpi8qW
    4GHMAmeWe5tgjGNKHW9seQieBgQNxOtkO4tDWdTZVmryqmwysWwvjw>
X-ME-Received: <xmr:hvgzari3jPDYy-5sc_3fyb3ane7N883r8aJIicc00ulO5Iv0SWik5n8HtlKijobgCxfUxLRnMQNLjPyY48iXPlkdRkx8pQ>
X-ME-Proxy-Cause: dmFkZTEDFuAzFvWEW8te4vIMnEVrO076s+oub3p5gM/HYz38f79LbPJfM0GX2FoeizMA4C
    IaScGqEpQC91/Y/68t1M7IftcMWTmp8SuztInWVCFIA2tDFRkVE+Sl7SImVv36/ThHXu4g
    aCSF4ZcIXe3gY/UBTKPKyTamnfyqwN5NusjSKIwKg9PaOtXunASBWtyrax5rVDWyXRgxrQ
    TDltANzPTzqavU8ERKSZEDiGsyVhvZjt+Se+Fckxd7eJMZVNvINOOWkZgpWIAfqa5RpiaS
    vaEE/+QPAhmWkcjjYdpopnARfUaKcJwyPUSbnWVZryobq7Cq3LMEGetAVE4/dGTcgaZ3Gw
    ZVaFz0KwU2hGzvc4K25J+CrX62xPJajfeZyzbgpAebpqKcQJ1mpxipQ6tGmYxXBEojxDw7
    EvU7jz2etXsYKI4otO7YRvYLJ1xF22iYz7f2H9iaIPva5x9BLmeLqRqP6ItVnJtKEzmkAj
    JCvtz2Y+RzZTOefzV/gVqZO0NxcS7PLaQHx90HIbtK7v9ZrWr8DJEpSpt4Rvlfo/sAyZlc
    YnYkKqk9ySfOxgVyuUyhyOosQa6x9RCyBfqUmjJEfhTBWKKv+KfYyA2BNcwPwf3sK9Fauc
    flGm4iS76tXU1ih9WdxRRFqqOMtWWsFMNHcq0z44E/RKjwXru/mlNfVA/Dbg
X-ME-Proxy: <xmx:hvgzaiHp5hjpBJrF40UvPPWFMfOw5tmBziFzvjBZZRLt1PiDvVt1_g>
    <xmx:hvgzaq9ECwykC4f1Py6SCEIfJpTvoeTuzvqB_jzdZUUvroK66oylkg>
    <xmx:hvgzapxzPuIz5sBqgUTMoMrLM-wdBbit5TQnLw9Nay5EiuY5eWxBRA>
    <xmx:hvgzamMf0t_BprrF0_patECu8jEp440dOenB0sZYPY6sZxvu0JpChw>
    <xmx:hvgzatsbQ7Du55hCpT0LMrCLrXEsCyaWiWVukBlwqOO-AQ7RDvhbGuQG>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Jun 2026 09:54:13 -0400 (EDT)
Message-ID: <997e50d2-83d8-4b41-9c2a-749e5c85bf4b@sandeen.net>
Date: Thu, 18 Jun 2026 08:54:13 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs/078: disable all concurrency scaling
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260618134834.237647-1-hch@lst.de>
 <20260618134834.237647-2-hch@lst.de>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260618134834.237647-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/18/26 8:48 AM, Christoph Hellwig wrote:
> Disable concurrency scaling to avoid mismatching output on systems with
> a large CPU count.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think this papers over what I still feel is a problem in mkfs.xfs
behavior, but that's a different issue and making tests pass is good, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/xfs/078 | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/078 b/tests/xfs/078
> index 6057aeea12ab..8ef52614b125 100755
> --- a/tests/xfs/078
> +++ b/tests/xfs/078
> @@ -57,9 +57,11 @@ _grow_loop()
>  	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
>  	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
>  
> -	dparam=""
> +	# Disable concurrency scaling to avoid output differences due to large
> +	# CPU counts.
> +	mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
>  	if [ -n "$agsize" ]; then
> -		dparam="-d agsize=$agsize"
> +		mkfs_opts="$mkfs_opts -d agsize=$agsize"
>  	fi
>  
>  	echo
> @@ -67,7 +69,7 @@ _grow_loop()
>  	echo
>  
>  	echo "*** mkfs loop file (size=$original)"
> -	$MKFS_XFS_PROG -b size=$bsize $dparam $loop_dev | \
> +	$MKFS_XFS_PROG -b size=$bsize $mkfs_opts $loop_dev | \
>  		_filter_mkfs 2>/dev/null
>  
>  	echo "*** extend loop file"

