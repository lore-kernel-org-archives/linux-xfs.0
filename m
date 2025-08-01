Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB628D8E2
	for <linux-xfs@vger.kernel.org>; Fri,  1 Aug 2025 18:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754074603; cv=none; b=OTmYM+9scJr2tpVd0Ttx7LYaYQCTVDVRDJD/rkf1BeFsjNBCTqDgvHwjH8UEys80CRTpIJ8AzZE9+t/gXXCC+0xu1McMEOIy2LxSL/6MscfY5JnCxaOja9fulelIERzwNLxGZEjmNRPu1CsSdHoM/tNkqidggLPzKC3dPilYSQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754074603; c=relaxed/simple;
	bh=NZSjdVx87HnyrSVozT0uc3abOkujfjk601OHRy2o96Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnUYwU1HOuvxt64zafqtQeobQxEHfYVsLKXks0eZFqjeWrDW7RsFc/bpOOzs1x7U9xu448KlSgHQhVL2UMbmGKaVsokurHlPv6vQ7PytL/FfSY6eWOmCKEbyZxn8SX39CDPNmfaQeYupkh9dFtBVMQbuSrCW4qesu5PGaZbPgGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AYdJtHPu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYdJtHPu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754074600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rLYdaEMzvcgs5Y4Lenm9HObKKAnQF1XP3lyqD9Xr2LY=;
	b=AYdJtHPux6AdxCQqeQGJTM5NCjZXIHVC0vgU/MFdU5XuOzeap7slNvAmhpfXHMjVdvg8A0
	ol7Qf789yzku7wwjBXxx2n6gg0bqoSU5vJZKUC+wwcUX0M86BrvGBH7k6ytHaduxX9Qmdj
	D7zOVnQhU9XTqkrql/mTQFY8n/cwpH0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-HeExZmsNMK-bsBK7kRA19g-1; Fri, 01 Aug 2025 14:56:38 -0400
X-MC-Unique: HeExZmsNMK-bsBK7kRA19g-1
X-Mimecast-MFC-AGG-ID: HeExZmsNMK-bsBK7kRA19g_1754074598
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2400a932e59so26763395ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 01 Aug 2025 11:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754074597; x=1754679397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLYdaEMzvcgs5Y4Lenm9HObKKAnQF1XP3lyqD9Xr2LY=;
        b=n3awBTmmnzotZtmPoNQeD/VK5kWVLzYxUK9tdfjZSsa6AjI37sQ7zCpRRczWfp5a1N
         i/ngAKYY5pGYC7a8ih4Na1OKaN+OgxW/o6uUg9yLdsW4LpMdH2kwcYxOdlTTtbUcY6km
         By0euIqo8vnXS4AYMRcKG0zj0BplgbODgWTVoDWg7hbaVEFSq2599YiJkrcDM55tcJdp
         oSsgz6Y0YwLN/NOmnuV/0gC92/bURp0C6cSOpcmKyi7WpNuzrbyw1SWNq2CuSVIkXQ1f
         KkSBn9iAOYE7TsMlrXCua08cJvyjBKrjdCBsFy7gfywmzzbeJ58oiv/EG2RjzM2il8Td
         +7ow==
X-Forwarded-Encrypted: i=1; AJvYcCWRFyIX9saQjvfLkBjW0D8erZrKpCPgLhGl2Vi9xGhtDvyUb5H0GaSBy+nvzjI3oWpLKWTpQ7HXmU0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5khwK+TD+5ELkTIJai5Kla+TqzoQXWQ0EGK0WIUoF2TIX/m+t
	AwZkl6HQszOh8t/lKr3ilcCsC6DiifyfZb17ViVUcMGxBEnsgYtVFer5hpfhB3HuAOhcSrIpXWB
	ERthOUu/gp1G7ENKTx1fZgUU/znKWseF6aTPUv5cHsn5YaNiTU0gtFTjj71Sdlvrs6DJivQ==
X-Gm-Gg: ASbGncsGt3KNfte7EctHEYcbyVfe0QbwdtYQaU5TnEEI7UJG/gXsiId8isuVYcWvfhw
	AYyfAIUS77E9RCjRivDVUEfcIl+mKVwTancLNk1fZgfSJPvNWtUzvBj7/GUz4rSwJg0OdEeknJs
	43jobf2bZb6Zuf4aS6eQPTMaEiLRvj3Kg7B8TPEtxf8ePe0uWqE1Fhe1f5Sp4PV2Qo9+VBLiri4
	n20ZtDdRtxX65lQCx0agQRJyn00tuvdidC8worMNJzbjNFPYNqvrEJ3ECf0MNn4Onzn7nve+/m+
	l7tVbn5RroRg1nx2CwyU8cNE28jjoiipymyUqmfhaXAsrenou8MWRECIII18EKAw40LotFHu6E7
	vZaQx
X-Received: by 2002:a17:903:22c8:b0:234:d292:be95 with SMTP id d9443c01a7336-2424703f838mr7568875ad.42.1754074597616;
        Fri, 01 Aug 2025 11:56:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbdDKWOMveqEbR97E8SC6jcWbRc3Z47TQmEoWmo/5+dYS5uWtB0AIUOciMua+aT+b1mJs8wA==
X-Received: by 2002:a17:903:22c8:b0:234:d292:be95 with SMTP id d9443c01a7336-2424703f838mr7568645ad.42.1754074597260;
        Fri, 01 Aug 2025 11:56:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aaac0esm49972555ad.152.2025.08.01.11.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 11:56:36 -0700 (PDT)
Date: Sat, 2 Aug 2025 02:56:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] generic/767: allow on any atomic writes filesystem
Message-ID: <20250801185633.adgwyt5qbhbs4mcf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957992.3020742.8103178252494146518.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381957992.3020742.8103178252494146518.stgit@frogsfrogsfrogs>

On Tue, Jul 29, 2025 at 01:09:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test now works correctly for any atomic writes geometry since we
> control all the parameters.  Remove this restriction so that we can get
> minimal testing on ext4 and fuse2fs.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Makes sense to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/767 |    1 -
>  1 file changed, 1 deletion(-)
> 
> 
> diff --git a/tests/generic/767 b/tests/generic/767
> index 161fef03825db4..558aab1e6acf34 100755
> --- a/tests/generic/767
> +++ b/tests/generic/767
> @@ -36,7 +36,6 @@ export SCRATCH_DEV=$dev
>  unset USE_EXTERNAL
>  
>  _require_scratch_write_atomic
> -_require_scratch_write_atomic_multi_fsblock
>  
>  # Check that xfs_io supports the commands needed to run this test
>  # Note: _require_xfs_io_command is not used here because we want to
> 

