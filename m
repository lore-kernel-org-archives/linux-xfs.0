Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6E91F131A
	for <linux-xfs@vger.kernel.org>; Sat, 14 Mar 2026 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773507873; cv=none; b=Yaq2Pfewac5BcjjWU1rD1vkVxBkxYxOPk82yY4ZPU1HX+f/m+pMoD51cZoXgtw0v16Juy491w2foIE214u336AZN6leexzrqzOWBfvQ/uotbNtahRCAcNESDZPy6fk8VTan2XZiFtTIfca+yJHT3Iw56Pn2yI7/08A1pqnuMKCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773507873; c=relaxed/simple;
	bh=+ysvLkOY/6j/R/TWM/XeHYspBYMAFmbYe1y4eHA9qLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyBAxPi0RPP/0RXmKJMuUPMb2UY26YovbvXLEHg+B4Mmiej8chjFYT7JA0QcXpHhXkDy5Ivu9s7fhXO6u0mwXbyY5+6deaNgHUw6s+69WVCJkLxQyAK2tn1o9TpuI5MzEPEVkujzbxS/n0aQJ4PMFqBxhOBDm01weA3BiO/iMbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EY8UBmPA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OZjPWx1p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EY8UBmPA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZjPWx1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773507870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TY2RZifNMA2+PGDu5d8zIqDKxVt19EdeEHnDXNRBqlI=;
	b=EY8UBmPAdqvTBSxaTTtpC06V4Bgb7/f4THV1WTi1dvzgZauR9CJPXiSJsZlxcx8V7D9ecA
	Q8c/W9uJwM/YXZgIWubhXNzrFDDh+6DPJjow5GMB1nPA0bcWdO5f+Zr8YC/ujdXoitjmKT
	h6tpQ4+IRmzUVfHByVA8AwtZh07MkMA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-iXhF5O1sP1iD-yWPEbB71A-1; Sat, 14 Mar 2026 13:04:29 -0400
X-MC-Unique: iXhF5O1sP1iD-yWPEbB71A-1
X-Mimecast-MFC-AGG-ID: iXhF5O1sP1iD-yWPEbB71A_1773507868
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aec805eec4so13152955ad.1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Mar 2026 10:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773507868; x=1774112668; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TY2RZifNMA2+PGDu5d8zIqDKxVt19EdeEHnDXNRBqlI=;
        b=OZjPWx1pr3ATCwsqXFldQaaMg0jHR3FcYdl4U1d7djGcjDIsz3rjZZnXn+8yFJuyl8
         YEW+6H2fs4kM4wIyIM0KuEgoYJYXHbM2p+b12NHJp4PwnoYJaPOriyNb2BRxR7DK7ZPe
         121McMA2KZ7EECJ3LmlV3BmQU7PzhTOaLTnxLGTWnxqdJjvj6s+HXSYKQPAZpcQ83YQf
         gAqyx15XyqjSEJB/eTLxlvcGDMFzZh3f4zofMG9I1CAMIyVVbpxSJzJMRVANRKzCI9WS
         HMO96eNQAYIo94bvngQFTEMHvQEFU4TS+fmT3sRxNzEKgyLQuZGTLPQrz5P07pdkoXGj
         Vwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773507868; x=1774112668;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TY2RZifNMA2+PGDu5d8zIqDKxVt19EdeEHnDXNRBqlI=;
        b=iCmvJ5xckpFXaPuTGfW8yBuQGIQTiJjqXalusUcDllBN6esxaUGfyz0vJRpKL1nWbz
         OnrzfHQnVa683zMMngMJRbgFOGE8dP2mMeSDrPtYYUbjzOOli1wZAPkI+ZzWRfdrfY2l
         85PTmWQPKbyV2KolFAdq7DE5vVHupCOiqG5f3iNjvlIUyGKPvPYT62x+nQQQ6oJM++2j
         t5V7hrZdETf0o46hD6Baod9St/3c4dhQJHNn2bFv5LK4zRW1mk1+EFVR9g3rd1EH6oeh
         0YC1dFOmMsxqARj93KG6x2swJqrFa5Y36BVGg56fi2u4uGVmAqs/UM039sSg2brJ3Q3e
         q9jA==
X-Forwarded-Encrypted: i=1; AJvYcCUixRVGHp4EnHWw+QrnzkJqdxRBIBxyp0wwmrRTt7DZ97IqWVSZx21uFpSR7ozkFB61GHPsS+Tg0rU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7JhjeeuBXG+s2dV+fCuMZWlXReSYqIg2ziw1Jy4Gf45JZoli1
	Vh1o3Mxc3CRXRfqAbiNAU1/H1g18WPtZs/wpVyCpK58/wclyi92+qtcDD2Z3UKNrcOaZi3wTiLP
	pRtdFmD4rdykRoSDLodqv7YfRVrakMSqm7JNqfcn+gK9OwRXwOECcpXyqBK3DbQ==
X-Gm-Gg: ATEYQzzs7mq3zy5qTX9cvYwjZu/1hjrg6w6ksYfNXpFdVTnD1PQvYeNopuZ1JyCuoUd
	NOK1sCitQ64P7DwXCx30owFrkK4zEnIUWKeMK9bNYLitgFyjVD4E3wNhs9QHjzel6GI7j+Dgiur
	CnJJV0zNwTY7ZJeW/dYKP4eNYEoYEpTyO/jbWtMazlsbK4unfAbgOfzA1yj0tfuwezJEj+kruY5
	CLv+UF8PS3+PE74Zg+CusAQqEBK89KApBG0I8DBvdwxqQ0FgMIG1+ByekMMKLPnE/vUk/S4+tmK
	lyRlT60AtOU2z8LWUqVTW4i9BeSleKxMVBnmdfHUIrHHxP4LHSMT5wnGhmvw0sKC4n6hTlQPjeu
	J1ladhO+VQ5ZXF5tx9TgHus6GIgULe9z6BicKS7R7imGA0o7gwitkxKuGnjdaGg==
X-Received: by 2002:a17:902:ef07:b0:2ad:e02b:4629 with SMTP id d9443c01a7336-2aecac81c73mr90329805ad.50.1773507868279;
        Sat, 14 Mar 2026 10:04:28 -0700 (PDT)
X-Received: by 2002:a17:902:ef07:b0:2ad:e02b:4629 with SMTP id d9443c01a7336-2aecac81c73mr90329605ad.50.1773507867842;
        Sat, 14 Mar 2026 10:04:27 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed753sm73365325ad.45.2026.03.14.10.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 10:04:27 -0700 (PDT)
Date: Sun, 15 Mar 2026 01:04:22 +0800
From: Zorro Lang <zlang@redhat.com>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] fstests: add _mkfs_scratch_clone() helper
Message-ID: <20260314170422.a62qqwqe6agom443@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1772095513.git.asj@kernel.org>
 <254fdd3e212f6618ea33207ef24db2b316d2d8fc.1772095513.git.asj@kernel.org>
 <20260309191317.vxcjvqfpoqdiycki@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <43710dd2-4282-4475-a29d-983295fab86f@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43710dd2-4282-4475-a29d-983295fab86f@gmail.com>

On Wed, Mar 11, 2026 at 10:32:18AM +0800, Anand Jain wrote:
> 
> > What about if ${#devs[@]} > 2 ?
> 
> On purpose- so tests using _scratch_mkfs_sized_clone() don't
> pick a random higher number. If a test needs more than two
> devices, opens an opportunity to critically review this function.
> >> +	fi
> >> +
> >> +	case "$FSTYP" in
> >> +	"btrfs")
> >> +		_scratch_mkfs_sized $size
> >> +		_scratch_mount
> >> +		$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/sv1
> >> +		_scratch_unmount
> >> +		;;
> >> +	"xfs"|"ext4")
> >> +		_scratch_mkfs_sized $size
> >> +		;;
> >> +	*)
> >> +		_notrun "fstests clone op unsupported for FS $FSTYP"
> >> +		;;
> >> +	esac
> >> +
> >> +	# clone SCRATCH_DEV devs[0] to devs[1].
> >> +	dd if=$SCRATCH_DEV of=${devs[1]} bs=$size status=none count=1 || \
> >> +							_fail "Clone failed"
> > 
> > I'm wondering if we absolutely need to use SCRATCH_DEV_POOL for this test. Could we clone SCRATCH_DEV
> > to an image file instead? Or would it be feasible to simply run the test using two image files?
> 
> Using a config file and testing directly on block devices lets
> us cover a wider range of devices.
> 
> When I wrote this test case, I was also considering whether a
> serial-number–based mount without extra mount option, would be
> better in the kernel.
> 
> The downside is that xfs/ext4 testers now need to use
> SCRATCH_DEV_POOL. Let me know what you prefer.

I'm concerned that testers from other filesystems might not be familiar
with SCRATCH_DEV_POOL, as it's typically not a requirement for their
testing. I'm not sure if they would be willing to configure and switch
to SCRATCH_DEV_POOL, just for these few test cases. If we can avoid making
the pool to be a hard requirement, it might be more user-friendly for other
fs list. Welcome feedback and review points from other filesystem mailing
lists :)

Thanks,
Zorro

> 
> 
> 
> 

