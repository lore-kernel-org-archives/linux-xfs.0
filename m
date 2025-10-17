Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631982FC034
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760726325; cv=none; b=N6AHrlJw8Vk6IYzWySTZRK6cIUUgWYWrQqas60dHsNPM4D2I4uFrtKTbTjbNojYzn5ZgICLEpZtjpyPBc1mhb+4B1v9aUlp0sUwKHnEcalwIOFy5WD7JPFVjn7qB/twbFx5F6EjeQA+YpAcDbRkcBqxtGog932H37jSKlQDjo4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760726325; c=relaxed/simple;
	bh=SLpa/ja4YiwbWy8iOnOXxTO05IM1w0aQFwlbs8U7ERI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKcfdd5P41jPiUq/U+eAHZBnSEjrzqhxCxkFLPpJYDij8FTfncnmW0qM/3pgsow6lGOb2gr5EyvBWQcynkCZv150DlNxPOmENAI7XdikrI0CpxEJVyIeWiMjFYubdxBaigYd80AXb708hI/eqa42zpc7l0dk4Gvbpxx+rEu7AeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYlYKfn2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYlYKfn2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760726322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ExpLnfaK5VsN9XkZ7Guo6bIcSOrzrOYWTg0vA9xfLp4=;
	b=ZYlYKfn2PAieB83hTbLGRCojLbT3iFzx9F1LVuPy0faC/Jxr3gCDnqGrD7gFq6rGi5X6n4
	ykrmni+3JzWnb6Ac5BEI3eRCl4fUpLBC1AOoQJdw9DIG/uR/eVXG/4r5d+//lDAoFhJ7zk
	hmKjiiEtcCBd358roE2qIbS72KX+SOc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-9YwuHQsXMTylaIJE5nEr-w-1; Fri, 17 Oct 2025 14:38:39 -0400
X-MC-Unique: 9YwuHQsXMTylaIJE5nEr-w-1
X-Mimecast-MFC-AGG-ID: 9YwuHQsXMTylaIJE5nEr-w_1760726319
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2909daa65f2so26300755ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 11:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760726318; x=1761331118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExpLnfaK5VsN9XkZ7Guo6bIcSOrzrOYWTg0vA9xfLp4=;
        b=Z8Q4TlR1g3GUluv+bjxeLqprmmmwIEI1VV8bWdqDPmfj+vZeZghmadZ/RJKwePXT2O
         6X/08El90pKYRCWzPTLNQwTwFv6aDsgRgeBYMrI5pj22YLlzGGNglbQxpCVvkLHzmjjs
         qBHbra2PaJprsYnyI8yoPrB+cLR6gvhngRRiznNRqS00Vx+zE/K4lCkor8x1kMu1paK9
         pJkIV3m95AIiqkUm0528hShNzuT6lmvU3gU9ZIDZCeUim8AcQNYGCAffB7UicDTUApb4
         J05h4XzMilSw0HaB4iLHsfBb/WwbYM7UYuI54zc8wwT2ECsoglguIB+XbiJV20cwaqCz
         8MYg==
X-Forwarded-Encrypted: i=1; AJvYcCUwQ2CCyMUVB8SMRr0Ks8D8vWflH/s8tjTI8FP+z1SztVw0Ir+QFoz9mXo3ntL1K2TV5jNriKPj90o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBr5cpryhd8KhHbS4MjFgdCoMQkDL/NdvykAR3UfMXBeusfD9F
	4U8pV/e6CjeSVfUn46taX4MEFYGFXcRvnsflSvGCEBARIQmDrAL94ALDHzAUTkrKZHIub+s7qem
	s/i8v94wXZqQhGMJiPfR5rz3kBJX2xMDuAzsgZs/hD8vFQNwK72Bx6l4o8WxCIg==
X-Gm-Gg: ASbGncvHf7zZWRfF+cNNvYUXphtklijQGlfSIjiYepjJbJNkWIQlkxQXSNxKb0mjhJm
	rgRwqtB8WUyXLJSlT9RXbqBmSSWsgPM0f1c2PznqN0t9o2QBum5rFxdo4oT7l9DxX5P6GCx+wDJ
	T+Xq4uzHQgbxszyqPlMfwus2SozVCNAGwuCaXWta8M+bUPPt1hkyK9Tx8x2KNdOYeciUMyz2K7A
	MAiZ3PJ4D4EOMC4X9cB9gsQVO55FjGrRpKAJ8E4NJTXOpuguhEkLR/PyQf1Acv+XqyhWmnmkYUj
	PhGS2kjUvdqcqrkmBVgOSJ/87b2gBmgI1qwnrP1k4kkDqZxL67wNc/j1JYchue/DvqnsqSipNfr
	lcW6Bbo5yXe7akVy9DTVOz3tXpW5Vc605EJ9R6jc=
X-Received: by 2002:a17:903:2f91:b0:265:62b6:c51a with SMTP id d9443c01a7336-29091b8e553mr86886725ad.23.1760726318480;
        Fri, 17 Oct 2025 11:38:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlSps9FM2fsaq1q0PxHLN6Yrh13diUDUi+9KW4jhFsK/IZsntt/GxiVsHdicvvaVrGZmRupg==
X-Received: by 2002:a17:903:2f91:b0:265:62b6:c51a with SMTP id d9443c01a7336-29091b8e553mr86886555ad.23.1760726317945;
        Fri, 17 Oct 2025 11:38:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5c00sm1973365ad.74.2025.10.17.11.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 11:38:37 -0700 (PDT)
Date: Sat, 18 Oct 2025 02:38:31 +0800
From: Zorro Lang <zlang@redhat.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Naohiro Aota <naohiro.aota@wdc.com>,
	linux-btrfs@vger.kernel.org, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v5 2/3] common/zoned: add helpers for creation and
 teardown of zloop devices
Message-ID: <20251017183831.pszgljhi7zwotslg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251016152032.654284-1-johannes.thumshirn@wdc.com>
 <20251016152032.654284-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016152032.654284-3-johannes.thumshirn@wdc.com>

On Thu, Oct 16, 2025 at 05:20:31PM +0200, Johannes Thumshirn wrote:
> Add _create_zloop, _destroy_zloop and _find_next_zloop helper functions
> for creating destroying and finding the next free zloop device.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  common/zoned | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/common/zoned b/common/zoned
> index 41697b08..313e755e 100644
> --- a/common/zoned
> +++ b/common/zoned
> @@ -45,3 +45,55 @@ _require_zloop()
>  	    _notrun "This test requires zoned loopback device support"
>      fi
>  }
> +
> +_find_next_zloop()
> +{
> +    id=0
> +
> +    while true; do
> +        if [[ ! -b "/dev/zloop$id" ]]; then
> +            break
> +        fi
> +        id=$((id + 1))
> +    done
> +
> +    echo "$id"
> +}
> +
> +# Create a zloop device
> +# usage: _create_zloop <base_dir> <zone_size> <nr_conv_zones>
> +_create_zloop()
> +{
> +    local id="$(_find_next_zloop)"
> +
> +    if [ -n "$1" ]; then
> +        local zloop_base="$1"
> +    else
> +	local zloop_base="/var/local/zloop"
> +    fi
> +
> +    if [ -n "$2" ]; then
> +        local zone_size=",zone_size_mb=$2"
> +    fi
> +
> +    if [ -n "$3" ]; then
> +        local conv_zones=",conv_zones=$3"
> +    fi
> +
> +    mkdir -p "$zloop_base/$id"
> +
> +    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones"

Are there more arguments for zloop creation, if so, how about add "$*" to the end?

> +
> +    echo "$zloop_args" > /dev/zloop-control

Can this step always succeed? If not, better to _fail if the device isn't created.

> +
> +    echo "/dev/zloop$id"
> +}
> +
> +_destroy_zloop() {
> +	local zloop="$1"
> +
> +	test -b "$zloop" || return
> +	local id=$(echo $zloop | grep -oE '[0-9]+$')
> +
> +	echo "remove id=$id" > /dev/zloop-control

Same question, can this step always succeed?

Thanks,
Zorro

> +}
> -- 
> 2.51.0
> 

