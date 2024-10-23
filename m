Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D14611E
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 04:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729657401; cv=none; b=ZMJmXsmxaehbagnTsllqs7ijzjHHbDZGQ0r2roBt3jHU9nRM5MpjzRCMjlrxJFonyNz3imW2py4psfSdEtGqeP1Oim7Wb7Pk7871f6O7x3ixlWGm/UNTjwpGeTvhgK840lfaXhvVYJOL0UhBgDNSob7ASNH5ChW0Sw4wSgtzJ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729657401; c=relaxed/simple;
	bh=L7+k1i8489tEGmKRN1ucBqp+4YMw4Bn0UzMNOhDXvDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RT/lCG8D6ZSdfIfprQnDRgQQuHDYv+P0n3Rjm8m1BpwU2X5mYZql9UP6SF9RiOmWDmnIgBvmVze0YFoU9+6tvH/7jd0ag6qfijU1GBmYOhvJ+Yxfe3dmv/6Ip93LDEYgcx33kPOXkajktBgY1diCXEA6FqZ+5D9eeKQr5pzc9+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QcttSHgI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QcttSHgI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729657399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OAkL5yCM6y7BDQ8CUK/gyfO8rGWWndsll5pUTO1Bpes=;
	b=QcttSHgIWLsqL0Vy/RhGI+22SEoaxc9/BUYKlPbFBdvCOk1JCiQxXAIkVwjXqsAWCgkIoq
	sUtjG2vT148QMzU3QLARwwlrPdyJPiflsw+/LdKlUSTS8I0RqSkDc9RpZmnTni6GopmPk7
	HS//4QsqoW16gL2WDX5xozTqxeblO5U=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-KnHB0qsXN0q5TK_mENao5w-1; Wed, 23 Oct 2024 00:23:16 -0400
X-MC-Unique: KnHB0qsXN0q5TK_mENao5w-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-20b6144cc2aso4806635ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 21:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729657396; x=1730262196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAkL5yCM6y7BDQ8CUK/gyfO8rGWWndsll5pUTO1Bpes=;
        b=HuvcOVEweUaX9TKhebS+sMNPqDlICTh699HvmmGRJLOulj/t0tEy1G+b+V7p0nNB+b
         KJCqQH+JZgq4iLjm7fDXTbi+jjhRpgzqVMmtDdvP7OiXG6q0IVLLPjUUELD6bbr7AlPF
         l06rZxxCnXYnpBrZAcTnsW2asd4xPtc/sms0akgaZJdB4eJuLNKXxd7gievO6WYJQ7NG
         HDCC9WHjLuf+gnV6nY9UAAlAhPMNYRHYm5qoms2Vf1wGbArSsiYzrZhE2EH1UvgrfdZv
         5cLpjKyqYj625oXxWKHZWB6BONUmuIbEyhfGbxpoHBQFPb8P8nywE+/KpPxIr/nmPPEl
         9e8A==
X-Gm-Message-State: AOJu0YyD0VujceDJrHMyEYCdfSQuK9zdueTLCX6LT5min5uUCUCEO/q9
	jOwdK17heVUeR7895DJmI3jsHTnedPsD/0MPS78mjdjEBMfrcVYBoyVEmWwxmJaYAyBB7KRKPSn
	khlXUWzaxyn0e+48z8VlN6V0JrAtB0/j1pGs1vg6thigA+33LObl7fklcJg==
X-Received: by 2002:a17:903:244a:b0:205:8763:6c2d with SMTP id d9443c01a7336-20fa9ea22f1mr23794645ad.9.1729657395806;
        Tue, 22 Oct 2024 21:23:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELkvnuc5PEhORNlgKURJl356pveYdM9/yfbKLimVQqNTxshnMQsUlXSHpgff8BM9YUmtbQeg==
X-Received: by 2002:a17:903:244a:b0:205:8763:6c2d with SMTP id d9443c01a7336-20fa9ea22f1mr23794445ad.9.1729657395390;
        Tue, 22 Oct 2024 21:23:15 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0bcc3csm49931555ad.158.2024.10.22.21.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 21:23:15 -0700 (PDT)
Date: Wed, 23 Oct 2024 12:23:11 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/161: adapt the test case for LBS filesystem
Message-ID: <20241023042311.apfuq73crvlblxoe@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
 <172912045624.2583984.16971966548333767345.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172912045624.2583984.16971966548333767345.stgit@frogsfrogsfrogs>

On Wed, Oct 16, 2024 at 04:15:32PM -0700, Darrick J. Wong wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
> system(see LBS efforts[1]). Adapt the blksz so that we create more than
> one block for the testcase.
> 
> Cap the blksz to be at least 64k to retain the same behaviour as before
> for smaller filesystem blocksizes.
> 
> [1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/161 |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/161 b/tests/xfs/161
> index 002ee7d800dcf1..948121c0569484 100755
> --- a/tests/xfs/161
> +++ b/tests/xfs/161
> @@ -37,7 +37,11 @@ _scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
>  _scratch_mount >> $seqres.full
>  
>  
> -blksz=$(_get_file_block_size "$SCRATCH_MNT")
> +min_blksz=65536
> +file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
> +blksz=$(( 2 * $file_blksz))
> +
> +blksz=$(( blksz > min_blksz ? blksz : min_blksz ))

Just to be curious, is there any machine with pagesize bigger than 65536 :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  # Write more than one block to exceed the soft block quota limit via
>  # xfs_quota.
>  filesz=$(( 2 * $blksz))
> 

