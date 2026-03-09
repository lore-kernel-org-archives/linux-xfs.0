Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669AB351C12
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773083608; cv=none; b=B/PgvLaUlQALM6TFClD753mWc7QnnU6ZkqSV373YGYKLuyhESFZZhlbYf2eOIW/jEUM+inZ9wRe8+1Dwc8XDMpxdhbXcKSz7GH1m9Ng35VtbTWZYjZzQ8WxLwC53eMEI6genvKxZfqMBnIAbJnVaqg892xyUSPWlQUzmN9NCk6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773083608; c=relaxed/simple;
	bh=QpwyLBRI/OOkt0kUJ8q+Dx+CP3iPKCrxuD3cHD7w6v0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btsDRXOp5Rcg4bfqiPYNLXLL4vYkzCtPndlQRQ2J7odcjKffT8Vf2nllUvSDJ+79DADjtH/N5g0kJygSDcXwEQFr7NgLTxiC1oUNQ6BTCa19iu1pVUlQRpL4tN0chhwP8am6b8Cx7DWwLotCBalwjh+k56HINSVgH+QBgcjzGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GLfZ7l3k; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kpc6uuLa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLfZ7l3k";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kpc6uuLa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773083605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UO+YM8h3OCEFHm0g8D0cIquq7QfxPMQ2VtOUTJCe2E4=;
	b=GLfZ7l3kCdwVmW8EYQrsbDu1C64I4LtsKmMlUJ2+jr5MfeLnT9Nr0rxc7Qt1VoLmQBVK8c
	oYwgEMEuw5izDD+tHz8d3tGWrnjo0bD8sZuHVUU3BBfoWqDC76RktOFHwnSUIyTd0lIBnn
	Mm0Aokax0DJ4cdARChX7nPJ1AgG6DA8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-pRX7u5j7NpGbNWtFc9Gs7A-1; Mon, 09 Mar 2026 15:13:24 -0400
X-MC-Unique: pRX7u5j7NpGbNWtFc9Gs7A-1
X-Mimecast-MFC-AGG-ID: pRX7u5j7NpGbNWtFc9Gs7A_1773083603
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c73b1376f98so5664010a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Mar 2026 12:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773083603; x=1773688403; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UO+YM8h3OCEFHm0g8D0cIquq7QfxPMQ2VtOUTJCe2E4=;
        b=kpc6uuLancKFaJ5YAFLCl+ZH1822oLTZKze0zewfIE+atWB2a2yNkeJMkmC8/nPnUa
         tvtBeOwsaNaYegHricTkcqCjJ/t5LFB33WN4njeVAWMAW8TYpGQCypT8pcLUU/pveJTV
         PrN9vleYzmwcAFD9dOslCtdvvvH7fAAXKqHWVGwFn18diV1/3BprgTmsbN2PKGAxZJo/
         Q4aKKxMCRUkCvSquxl1rwU6qt4zsT1PB0G+GWpFYwYtzSfU3oCJA9L5Q0qGypcZ7ijjZ
         Op4o8HoKAppSbMhRt9Ho0FQvrIyVVFskBxScwv0myYaNvB8MIfZUlXa8YTQe54vVjvmw
         WYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773083603; x=1773688403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UO+YM8h3OCEFHm0g8D0cIquq7QfxPMQ2VtOUTJCe2E4=;
        b=r8Sbx+x5sVOPtH/OMNAGvOy7x9AHcWiVQNfd07r5dTLvCCHHb+vushzVYZEw93UZ7s
         a/v6lAQt1ElNe3W/ydXFacdo2XnRcvDCpQM1zOJLKZStWwWk5oU9sh0i1i7GVNMtE5D9
         GpOo9s5kCoHRIwOxP+issa+HyXdtZLkiD6xTpauCE6iBybxp81isqB68bDZN+8P35QNT
         OwD0AC+Jc9Jw3veM059X0NdB/zInHrH58pDT+NkBsyb3NPJZLaTPHuDpP1VR+Aa7Hop4
         bgfeqznSoWKNUVi/xcksuGJ55vmAWXKfhpCnCn0vJn5jiDZz4jCWK14JRjAEH+dRPkTR
         aucw==
X-Forwarded-Encrypted: i=1; AJvYcCXRURuHxTPG6QzUlUerZfzeLSChviKe1si8nSpHIAJaPI+vPFHLTENFIdnjebUSWC+dooBV8dqn5Sk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwABxVCbzgS9VJsQPGtlubYDB3dwRtGQVGw8Ucm8Wg/lAzOWodk
	24vQSEkcdbXznrCQBlHqm5U/zJdWaib3cin30KI7xKeoCBwaZsrjvN6oo+KSv0VW6oiF8U0SR3m
	VtHRVt1HC3HJL5vP7WLFsFgB7MMaHodbvVtfQ5zDWbgTYT6vx5VRfzQPGEi+Grg==
X-Gm-Gg: ATEYQzwgC38MwsD8ziFHufm20ynN1gQqaqh2KsR1QyHDsugQtKOCU4MErmJEgqdUgSU
	AH/TcsHZ0K5w2gASnlUy5CCJOoni16j9krFyrQde/oyQOVVLP137Zk2K3nwMWsjdOoZlxhr9ZN+
	KWLwjn2SOZkj82BVkAKbHGpW7RzVYUCQvPXeBiPOdBU0pyjnZOJjNA0nlKOZYD1gJiGCBx6EoWv
	4F/R8/IAJQOFRWobbPSZIyC4bpLPgKspMCc3S9GZOMSGQIU9vu1ZDS7fsuXL97+WjxMfOXnluxU
	b0Yy3o9UQI00YYu15XHNQwycoS86Zfyq6RtIuWvVu8xQzRAoUmQbRv7bFuA0wF9sKG+6OXqH1PL
	gVkniiXs3KXp67RuYUaoZxWMN8+gkyuK52VoV3X3XiCVQgp5BYbmvvrSDI6sJaw==
X-Received: by 2002:a05:6a21:2d8a:b0:398:7357:bb84 with SMTP id adf61e73a8af0-3987357bcdemr9099338637.12.1773083602996;
        Mon, 09 Mar 2026 12:13:22 -0700 (PDT)
X-Received: by 2002:a05:6a21:2d8a:b0:398:7357:bb84 with SMTP id adf61e73a8af0-3987357bcdemr9099315637.12.1773083602558;
        Mon, 09 Mar 2026 12:13:22 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0acde5sm9444628a12.7.2026.03.09.12.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 12:13:22 -0700 (PDT)
Date: Tue, 10 Mar 2026 03:13:17 +0800
From: Zorro Lang <zlang@redhat.com>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] fstests: add _mkfs_scratch_clone() helper
Message-ID: <20260309191317.vxcjvqfpoqdiycki@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1772095513.git.asj@kernel.org>
 <254fdd3e212f6618ea33207ef24db2b316d2d8fc.1772095513.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254fdd3e212f6618ea33207ef24db2b316d2d8fc.1772095513.git.asj@kernel.org>

On Thu, Feb 26, 2026 at 10:41:43PM +0800, Anand Jain wrote:
> Introduce _mkfs_scratch_clone() to mkfs the scratch device and clone it to
> the next device in SCRATCH_DEV_POOL.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 9db8b3e88996..2253438ef0f6 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1503,6 +1503,38 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +_scratch_mkfs_sized_clone()
> +{
> +	local devs=($SCRATCH_DEV_POOL)
> +	local scratch_data="$1"
> +	local size=$(_small_fs_size_mb 128) # Smallest possible
> +
> +	size=$((size * 1024 * 1024))
> +
> +	# make sure there are two devices
> +	if [ "${#devs[@]}" -ne 2 ]; then

What about if ${#devs[@]} > 2 ?

> +		_notrun "Test requires exactly 2 devices"
> +	fi
> +
> +	case "$FSTYP" in
> +	"btrfs")
> +		_scratch_mkfs_sized $size
> +		_scratch_mount
> +		$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/sv1
> +		_scratch_unmount
> +		;;
> +	"xfs"|"ext4")
> +		_scratch_mkfs_sized $size
> +		;;
> +	*)
> +		_notrun "fstests clone op unsupported for FS $FSTYP"
> +		;;
> +	esac
> +
> +	# clone SCRATCH_DEV devs[0] to devs[1].
> +	dd if=$SCRATCH_DEV of=${devs[1]} bs=$size status=none count=1 || \
> +							_fail "Clone failed"

I'm wondering if we absolutely need to use SCRATCH_DEV_POOL for this test. Could we clone SCRATCH_DEV
to an image file instead? Or would it be feasible to simply run the test using two image files?

Thanks,
Zorro

> +}
>  
>  # Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
>  # errors found or errors were fixed) and nonzero otherwise; also spits out
> -- 
> 2.43.0
> 
> 

