Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B7D1D2F42
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 05:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747200057; cv=none; b=hAgj+dgOSwE4covx0diUxw2UGSbZYynz8dIrDsGi+AJh2nzXAS8rPoX7ZL/wupWXs3EHWObU2RAw1YT0ksadrwhH0HHM5sX6VZNGB7HBaOH9qJBTtJKBXnKg0evKE+lKk60i8Tss5emrUBaUTpsCGQzUmDJkuiVpD/69QBN4T/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747200057; c=relaxed/simple;
	bh=iaSoaw7bB3NhqQPx7C2KU/lCarj17ymW18hvtWU4L/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5tkc4yWduI+g4JWnbVoH711lZvQFlkjPL+6mOTggzNmMcr1gvcAThp/fRpeuFLFhI/RWKtu3gAyMJ0BVRHZ61GKGOVdu0xwHOFxAVO0+rHiY6653RYlXOtMSh9lEzqr/NmEV3IYLwW1Cm5pabPSpLaY+exNC9tJdAzhiN5ExNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBZaikTF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBZaikTF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747200051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXtBDIE77Q4RcA96cyQfjtM+WgYsnihPBjFJnUlXQZY=;
	b=bBZaikTF5iKza3DLG/JUj++BCkPShSIEp73sYyelnoHu2nFi1gzgcTrTn/RdLRLEnivl3A
	CTl7/o7QSvC5BXKMpAtMmeYJ9Dkjyi0+1UusH2CsV7iJ+ctFOZGEXvm/cT/q7CBmWGg2W9
	lmDe58ED/J6uiSCZYdxVBhqG30FnO1U=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-BInIVTlzNvGk53UHn_hXHA-1; Wed, 14 May 2025 01:20:50 -0400
X-MC-Unique: BInIVTlzNvGk53UHn_hXHA-1
X-Mimecast-MFC-AGG-ID: BInIVTlzNvGk53UHn_hXHA_1747200049
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-22e68e50f80so45450945ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 22:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747200049; x=1747804849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXtBDIE77Q4RcA96cyQfjtM+WgYsnihPBjFJnUlXQZY=;
        b=fENaDPWeaNOriOofXLTJkQKGf8+ZymXkk+oM/YeEryPQ0UbWNHBkBKD6yLiNZdRFZW
         i8hpx1802GbAwFAptIg37o+58h48A/rp/2hbZdsSrRgYkD6fycjyewV4QOmkxnwiB5OR
         bp2w8yEvitnI40D2fPzwNbKX0D3UY9kzrxV1V8bH9ppz3xL8Oh8m7I1DQb0DrQjogWz4
         WEuT9shEwDweZdz2+NR9sxkvoYVyTu7DiQ8Zk7D3nb1QiUgrnjEPMCn0USr7BDEVJAzc
         VhGiJyNUhpMOIXi017j0UvhJLu5rbbctKpG7cCewQXy4E7SzCV0XuTih39YgoXe2fL02
         ruYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLx0hUeDkPEQgE06Yt2N0waf3Ke8LsqlBtzbSbdYwNOiMycKYYZmXWVN5COFCVk8DGZSH3GIaO2U0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh96vtA4v7/4tcKrDX6b6E46ADxKmPs/1ED9NPo8U8QEqmNDpG
	Yab0zwjQUHCd5/dATa0oFMmtY6jIzrMpVJr0bwbS3YiiPYzm6gwWfbV+kzcaWo8KFEEkV4veVW8
	hJ0iv1KkwTnQCahJDWLVFXNkvFXG5GEDSQZAjQr5kxth7Avel9v1kzCdKqw==
X-Gm-Gg: ASbGncsPiJwRDg+RVScP8X444b+T3HIwiCOVCS++SjU6vjyWh5dFbFdgrTFxP3VjDM1
	ungPhJCGQEVhrjm4gsTBCoHHOx66P50UREHwQQfLLuJ4ZnnVBTCQ9gYMdcfFQRa8NYmlUcbNiE5
	7GVatRdN+jGQeu1rvs+mZqD/8fiI43pNgWK+o01BMnDFM1xp3yJPVxdut1zrAIiHqMYcMhBna9R
	4O9MsPEHTZDHXnP1W9XyHcjMnSvbXB2F27CNM9iPsq1amIQxHgwHvTXTuEAAZUZcJ5KVwHn5Wzv
	9lHxq4C+yziXwGAvTsRmCXkKfmFZyeoEJ02ycIC2ax7mGEjBpvWr
X-Received: by 2002:a17:902:d4d0:b0:22e:68c4:2602 with SMTP id d9443c01a7336-231981a85c1mr28934405ad.33.1747200049502;
        Tue, 13 May 2025 22:20:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlx6APVjppTpKolovlnJP7aetqZfQVG8S4gkZTYEsgBJ0KT5TH/IvUnaGF4AlKDpj3hN7dsw==
X-Received: by 2002:a17:902:d4d0:b0:22e:68c4:2602 with SMTP id d9443c01a7336-231981a85c1mr28934185ad.33.1747200049163;
        Tue, 13 May 2025 22:20:49 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc8271d98sm89427225ad.154.2025.05.13.22.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 22:20:48 -0700 (PDT)
Date: Wed, 14 May 2025 13:20:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v1 2/3] new: Replace "status=0; exit 0" with _exit 0
Message-ID: <20250514052043.o7as5lxhkzklungz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1747123422.git.nirjhar.roy.lists@gmail.com>
 <96ea8b7bb8dcaa397ade82611d56482d79f28598.1747123422.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96ea8b7bb8dcaa397ade82611d56482d79f28598.1747123422.git.nirjhar.roy.lists@gmail.com>

On Tue, May 13, 2025 at 08:10:11AM +0000, Nirjhar Roy (IBM) wrote:
> We should now start using _exit 0 for every new test
> that we add.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  new | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/new b/new
> index 139715bf..e55830ce 100755
> --- a/new
> +++ b/new
> @@ -176,8 +176,7 @@ exit
>  #echo "If failure, check \$seqres.full (this) and \$seqres.full.ok (reference)"
>  
>  # success, all done
> -status=0
> -exit
> +_exit 0

Hmm, this makes sense after we have:

  744623644 common: Move exit related functions to a common/exit

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  End-of-File
>  
>  sleep 2		# latency to read messages to this point
> -- 
> 2.34.1
> 
> 

