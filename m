Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AD123F277
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 19:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744141366; cv=none; b=BaUJXxLtvwAZisb0pV4olkJmYEVbuBUuoqu7SnknwusDNyqmFAMRhu39KB0SjLlWwyY9BoceUfDTelTNN7PTtG/P1ZlzrkfM6HLXCUjtoHecJkgQmBqxxICsPEteUARE/3NPl5+iyZ4lueXCn2uAWuk3L4MER9Q7BZpx+Ad3uME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744141366; c=relaxed/simple;
	bh=EfH9/NeN8Wn9mZmzc9aIIPBqa9f9401D0eIsIyPc+5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mmlhi9Vg0Vvr6/gP22SqGPEkkMsglMSeK0C+97m5Gr+WJPV/lHXLxSi5kAWzwuD+fABN6g08QA9SzZcfLjhJT5mkUtITvQ97evn1GySPtMIW/4E9cA055HirGXMAN/DrrK0EUpy3YI0rL87apA8OQJLSj+WRD3j++LRfXFfs6AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E+Zk2YEt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+Zk2YEt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744141361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9g6bQwv7mzKc/dgYa3gePEsauo/hi2agtUzVzw00jIQ=;
	b=E+Zk2YEtCWvAz0CsBHzlpq7Z1z2L13FTkHk7nF8vIE5c3BdkyfAPybXrY29IKOLGvYQuAH
	G6EUNHPE8lMqNBVmgOlKMfJ3lJmmVqvoFJsDRBXMa7PrLofJiTcAa/Ztf5bjf0QAZLOgJx
	ZUdmFltjbcuBoPMUQAGNJtldJYv/Fyk=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-PmOcMh3pMYKDOoO7pjarKg-1; Tue, 08 Apr 2025 15:42:39 -0400
X-MC-Unique: PmOcMh3pMYKDOoO7pjarKg-1
X-Mimecast-MFC-AGG-ID: PmOcMh3pMYKDOoO7pjarKg_1744141359
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-73720b253fcso4739655b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 12:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744141359; x=1744746159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9g6bQwv7mzKc/dgYa3gePEsauo/hi2agtUzVzw00jIQ=;
        b=MD0PPJdXYEf+lLXNRkHWYRO9F7RYsrdw9zdyltyZSnDnajfT6b82AJE+V6aZRWMj8a
         7/KmWM6fBNWXomxGzADoH1Zwz2GzHQiUGq7TMcr8c7U4Ce0uCiLDXDJ07FQcnbqJ9HEN
         avzwo4eypRaBszvqF/wzr9aNd/TY9vsYkEMHx3b2uzjOcSO7ok7voyV1ftYRXxY9XSbe
         QCpKZaVrLCaJKyfwR6PLwWdsCDpv33PHr0PrFVTxjxYWgEqPkUbx2ED6FefAsh2lWlsy
         7zKSagO+PxyyaNsvjYkRRgw5HBBfyzyf027IYr2O2UcAOHHdfTN/oH/DRczJPGejiZsm
         465A==
X-Forwarded-Encrypted: i=1; AJvYcCVxKyueA31mKKj/nfFqS7/n5cPWSggWdUqg0mW3+dUG2eh8D5/HyxN6WtbHNa3+eivBb5+ibYX/554=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1qcvyHa/dddSj0VVEk+dF4yI2H++6xR7F7/acIOklg3biykFo
	uY5I3B6x8oFl1ouPIYN06hgffUIRJV1Bk65uTsHsDtTc3z/YR14qYoqFuhc3c304hbgcu2ypM6g
	/2k3s2ZHZYQ8Xsh4H4vCXnJWksfFpXD71/5/3RUF80A8kdwbh/c6JRu1FSw==
X-Gm-Gg: ASbGnctmVerdr8namb0vqrCiYF218Xg6k7Bc3enfhiR1eMa3acQ4IkdnnW7uM8IBZX9
	AF6yCyqkXv6/EBgLaNdu0H+UZQg92TEiVNMLqIUy5H6SwoOPxt1/4frdShGoMVt0ntsfq3NCnca
	NyjIiwb91Uok6Alz3hfyNcCOHco1CYZOcPbJ1tJHSyxiQQ/m5vFMMbr0d/JmlY2kf6B6QHbQ/fn
	qNmvDtqW6LIHOchTuDjXGYAelanWe16k0nvZMpF8LRpC0w5lluJT/89MPwnJ1k+E2AQKkmdwoCY
	cL4TS4Hw2UlmxB26QC1yqqCRRRNnN7Rvv+KVn8mZ52Qq1R8v65wCRQW8
X-Received: by 2002:a05:6a00:10cb:b0:739:50c0:b3fe with SMTP id d2e1a72fcca58-73bae4b7285mr347961b3a.8.1744141358690;
        Tue, 08 Apr 2025 12:42:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNYZ51tzV0+jDcH1z+AzngJjetFedImLP/+0cXrDoVBIsnRYzGkZ6nP1erSoPADQ4UEdWBqg==
X-Received: by 2002:a05:6a00:10cb:b0:739:50c0:b3fe with SMTP id d2e1a72fcca58-73bae4b7285mr347941b3a.8.1744141358342;
        Tue, 08 Apr 2025 12:42:38 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af9bc405c42sm9210915a12.62.2025.04.08.12.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 12:42:38 -0700 (PDT)
Date: Wed, 9 Apr 2025 03:42:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/801: provide missing sysfs-dump function
Message-ID: <20250408194233.3fwpiid4ochtfm6u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250408181732.GH6274@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408181732.GH6274@frogsfrogsfrogs>

On Tue, Apr 08, 2025 at 11:17:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test uses sysfs-dump to capture THP diagnostic information to
> $seqres.full.  Unfortunately, that's not a standard program (it's one of
> my many tools) and I forgot to paste the script into the test.  Hence
> it's been broken since merge for everyone else.  Fix it.
> 
> Cc: <fstests@vger.kernel.org> # v2024.08.11
> Fixes: 518896a7b483c0 ("xfs: test online repair when xfiles consists of THPs")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/801 |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tests/xfs/801 b/tests/xfs/801
> index 1190cfab8a9f94..a05a6efc1a9058 100755
> --- a/tests/xfs/801
> +++ b/tests/xfs/801
> @@ -42,6 +42,18 @@ test -w "$knob" || _notrun "tmpfs transparent hugepages disabled"
>  pagesize=`getconf PAGE_SIZE`
>  pagesize_kb=$((pagesize / 1024))
>  
> +sysfs-dump() {
> +	for i in "$@"; do
> +		if [ -d "$i" ]; then
> +			for x in "$i/"*; do
> +				test -f "$x" && echo "$x: $(cat "$x")"
> +			done
> +		else
> +			test -f "$i" && echo "$i: $(cat "$i")"
> +		fi
> +	done
> +}
> +
>  echo "settings now: pagesize=${pagesize_kb}KB" >> $seqres.full
>  sysfs-dump /sys/kernel/mm/transparent_hugepage/* >> $seqres.full
>  
> 

