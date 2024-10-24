Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F45F1E32D0
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 13:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729776300; cv=none; b=b71qe0LYCvO8OZVGDv4+t1tEazcDim7slqaRJKTmwrgRqfLeD/e2wTS6TiJaUY32OoutMLbzsI57ViXpsqAyjZq6rLPWfeqBM2eloZq+f14nT1eoguw+uQb7FlkTi8kIrGaxMm95WleK2TagdioYGNHzSE3IeW/f7oGie7ifoeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729776300; c=relaxed/simple;
	bh=sCPp8eNkui5TGNkGrJxN0F/c58rwd7lkBJs+tCntlQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZ5HAYwWZgVEjKzJj+RuZPUZWdIYAhpeA1MAy2Y+SF1c3Ji5EXcdzHPGU5Kgh4IWGU7H5BHNvRSIHYLpUkk/KA5Ud3gxWIC1eDupvI79LKrmWrxMT+zmHF7U2q4yMkxUwjZKrfPvyvUU2Ty3fcCE70KP1c79NPaVsbGi6x0MLdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bfk6uYLJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bfk6uYLJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729776296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LV+oh1RkjuJCTI87bth73hem1xdoRNhxaUyaCPHSaOE=;
	b=Bfk6uYLJOeGqLC3IClNIUo68qzNfCnJmyn7EH16Q00lWeDFWHfiMleq+8dZZNi2Tc4W3fc
	hgaMHjW8eWuMMRsTcF6Iris07WQOZC+/NEZdkAoo1smTkhHxZQHj0msMGWaOBUyVxWmN+M
	5I6H7vSbynHvvTneFrtr6bAoF1SvHsI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-R0B1Q3bSPZCbVbK-b2KEyw-1; Thu, 24 Oct 2024 09:24:54 -0400
X-MC-Unique: R0B1Q3bSPZCbVbK-b2KEyw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-71e6a7f3b67so1037246b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 06:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729776293; x=1730381093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LV+oh1RkjuJCTI87bth73hem1xdoRNhxaUyaCPHSaOE=;
        b=r+NqqV1UfxHLTeS8J3MuiD0OQNHPHIHzSSbFphRHtmrVO1RfeMXJSHMGWBwu5YELac
         egTHaJIG5PLORWFWVgvzHwcLmNhHZzz6qsez4g6eTyIkkVHPyt8DkohSyp0+96+4cG2P
         W2mG44flgmLQ2rF8tEPxwOW7C2PeT496Fhi7E85zJgNow+9rLoF+fJY7likA6WWT63Ns
         ftLZrVg25Mpwf85OOoW4WxU20hbPSYng8iItyaBY5Y8PDS9KDYXxccCZ0g8WgctKDNjT
         W4J1tuSgx4c0psO6jOMGWwPwQ8b1webD0RD2IFTasaYmTt0s6UBk+Jr5eSUae8ZN7Dgj
         03eQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4yBhY3uo9zvB/lXsgPSgR6S+x8ynMi1nOHgKmhTNMej3YNXGEXDY/JhiNpEYajRGBNmkI8Me9V/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGjVyq1q3OVY7Tv5bPEYs5h2iQy/iL0kIB2NcpciQFqiZ0mhGM
	cjSu3Mgx+gyR/5qc48hblc+rpsjTnIYl0itCZJqg+8YJDBx1DjquSnDxJ4i17/5HCefuC51b3Bx
	kfMSWBFb44YTRC8REFo0NGGVMmsqTsvJNSFfAgKGDsOGoR/03w3Qu7SSLAQ==
X-Received: by 2002:a05:6a00:1995:b0:71e:6046:87c2 with SMTP id d2e1a72fcca58-72045fa867emr2321576b3a.26.1729776293594;
        Thu, 24 Oct 2024 06:24:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaEabVORN+hZYi8D+0zykQc3dA+B8iN1SxPjM6E0B/i4J8uOChVFt1q02hrMCsdVmx93i2gQ==
X-Received: by 2002:a05:6a00:1995:b0:71e:6046:87c2 with SMTP id d2e1a72fcca58-72045fa867emr2321543b3a.26.1729776293103;
        Thu, 24 Oct 2024 06:24:53 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab1dc6bsm8546749a12.23.2024.10.24.06.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 06:24:52 -0700 (PDT)
Date: Thu, 24 Oct 2024 21:24:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the post-EOF prealloc tests from the auto
 and quick groups
Message-ID: <20241024132448.uoms7lvnaanoysfi@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241023103930.432190-1-hch@lst.de>
 <20241023172351.GG21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023172351.GG21853@frogsfrogsfrogs>

On Wed, Oct 23, 2024 at 10:23:51AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 23, 2024 at 12:39:30PM +0200, Christoph Hellwig wrote:
> > These fail for various non-default configs like DAX, alwayscow and
> > small block sizes.
> 
> Shouldn't we selectively _notrun these tests for configurations where
> speculative/delayed allocations don't work?
> 
> I had started on a helper to try to detect the situations where the
> tests cannot ever pass, but never quite finished it:
> 
> diff --git a/common/xfs b/common/xfs
> index 557017c716e32c..5cb2c102e2c04f 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2238,3 +2238,34 @@ _scratch_xfs_scrubbed() {
>  
>  	$XFS_SCRUBBED_PROG "${scrubbed_args[@]}" "$@" $SCRATCH_MNT
>  }
> +
> +# Will this filesystem create speculative post-EOF preallocations for a file?
> +_require_speculative_prealloc()
> +{
> +	local file="$1"
> +	local tries
> +	local overage
> +
> +	# Now that we have background garbage collection processes that can be
> +	# triggered by low space/quota conditions, it's possible that we won't
> +	# succeed in creating a speculative preallocation on the first try.
> +	for ((tries = 0; tries < 5; tries++)); do
> +		rm -f $file
> +
> +		# a few file extending open-write-close cycles should be enough
> +		# to trigger the fs to retain preallocation. write 256k in 32k
> +		# intervals to be sure
> +		for i in $(seq 0 32768 262144); do
> +			$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
> +
> +			# Do we have more blocks allocated than what we've
> +			# written so far?
> +			overage="$(stat -c '%b * %B - %s' $file | bc)"
> +			test "$overage" -gt 0 && return 0
> +		done
> +	done
> +
> +	_notrun "Warning: No speculative preallocation for $file after " \
> +			"$tries iterations." \
> +			"Check use of the allocsize= mount option."
> +}

Before we remove these cases from auto group, if above function can help these
test cases to be stable passed as expected. I'm glad to consider it at first :)

Thanks,
Zorro

> 
> --D
> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/xfs/629 | 2 +-
> >  tests/xfs/630 | 2 +-
> >  tests/xfs/631 | 2 +-
> >  tests/xfs/632 | 2 +-
> >  4 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tests/xfs/629 b/tests/xfs/629
> > index 58beedc03a8b..e2f5af085b5f 100755
> > --- a/tests/xfs/629
> > +++ b/tests/xfs/629
> > @@ -8,7 +8,7 @@
> >  #
> >  
> >  . ./common/preamble
> > -_begin_fstest auto quick prealloc rw
> > +_begin_fstest prealloc rw
> >  
> >  . ./common/filter
> >  
> > diff --git a/tests/xfs/630 b/tests/xfs/630
> > index 939d8a4ac37f..df7ca60111d6 100755
> > --- a/tests/xfs/630
> > +++ b/tests/xfs/630
> > @@ -8,7 +8,7 @@
> >  #
> >  
> >  . ./common/preamble
> > -_begin_fstest auto quick prealloc rw
> > +_begin_fstest prealloc rw
> >  
> >  . ./common/filter
> >  
> > diff --git a/tests/xfs/631 b/tests/xfs/631
> > index 55a74297918a..1e50bc033f7c 100755
> > --- a/tests/xfs/631
> > +++ b/tests/xfs/631
> > @@ -8,7 +8,7 @@
> >  #
> >  
> >  . ./common/preamble
> > -_begin_fstest auto quick prealloc rw
> > +_begin_fstest prealloc rw
> >  
> >  . ./common/filter
> >  
> > diff --git a/tests/xfs/632 b/tests/xfs/632
> > index 61041d45a706..3b1c61fdc129 100755
> > --- a/tests/xfs/632
> > +++ b/tests/xfs/632
> > @@ -9,7 +9,7 @@
> >  #
> >  
> >  . ./common/preamble
> > -_begin_fstest auto prealloc rw
> > +_begin_fstest prealloc rw
> >  
> >  . ./common/filter
> >  
> > -- 
> > 2.45.2
> > 
> > 
> 

