Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DAE186E2D
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 19:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746560749; cv=none; b=YkiTyDyLvpr6sHQxFuJU8tVdoXKSFDcFAmzpj3/ZAWy0NHROFMppmgKIW96m+GWPBhA5dYx7B7tIUxDB2idx8eDvti6v+QEGX31UID+8pCQZMd2uzO7i9jP8Jk2IXPcz2wjPznwtXSE2aTf6WuUp4RPWsEaNu1P4UBLkK3D96jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746560749; c=relaxed/simple;
	bh=JbSCQsjRcT+jwXPcpjjQNlt6hZvTKgAziBUyXoBselA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHEbou3qDB9biCSmNuQOsLkpK9+zbiVZD6M2uBnmo6I/R3ZsFVAfsVtcNpUXlUfhe6jFZ7JPDUM+GHsjTfHSxu+WlVTyINM7um66heX3QAJAWKZjRxL00EWfzpjOpEE4Ld1Mt3Blfc0Vh7T4lkI8JH/hiF9FWIf3SHlMSo4o3oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkyUt4qn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkyUt4qn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746560747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+jxwcjxfxStn75+Bbmsu4HeZVlz6QrNxuBaWj1jWtxQ=;
	b=gkyUt4qnc5d5Zo1MoXYx9Q6HZANwPDhW173OUhw8Hn1sWQ2Vq8pzhXK0JOm3AnFXhccksr
	oCOS5K0tdiAVzaez+lmshUnf9g7of2JAYJF4QyTPJgQACObUZ19VXogni2i+Lt2nQE9cVj
	n44E8E37Tqa8k/kc20pQM83HcJXVE7k=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-RiQWV2BkMyiksIBc6Yn_sw-1; Tue, 06 May 2025 15:45:45 -0400
X-MC-Unique: RiQWV2BkMyiksIBc6Yn_sw-1
X-Mimecast-MFC-AGG-ID: RiQWV2BkMyiksIBc6Yn_sw_1746560745
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-736c7d0d35aso7044724b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 12:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746560745; x=1747165545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jxwcjxfxStn75+Bbmsu4HeZVlz6QrNxuBaWj1jWtxQ=;
        b=A+YCNeqYQBKDDokrENITW5kZcSFg5lp/SfIJIIxf562y3ymxZPzyq6szKnNDyb745X
         FL5bBdgOZgcSeQdBlTrGiaKEFZMgxGB4l+fKwLrwdkUggFvFTF6wprg7YuVBalC2PDLb
         HG12rGSYilkjpmPotk3LjYSoF/dy0ocvP32WJW13+oJN3VI7pA4d0m7uHwVbxinfApbc
         f509MhAUj7MWfjlcvl9bF0J22dSWzTz4vsA23RJeYV6otkYWUzpXTyUjisFosOYg7bUQ
         Kyi5CwAnLpz7feKlpfEknwx/KDw2Nxhng2fftygJFsVroDfmsCyclRom4gginZLzZ1Gn
         MLwg==
X-Forwarded-Encrypted: i=1; AJvYcCV0bMglO14iwDxOUlZQPBS6N6KGn5jL8Bx9gKcdmpfxV9ws9GddFwYniPW+3zE1ZeoHMclbIIF6a+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOE4RMTbkqsrfYUHX2IkI+ScY+ObuCvhKyQSgsjTaAcDeblh2E
	9XH6wyFUUzeZLXxLF8Blv6PzV2AW3cCGx17OStYMijM6pQFNaOep+5T40OECggvQbhkeiO+Lw1U
	SRUFNNB5jW+PFVU0xG1qR2WOjVDwh+BLiPCkcKaX5rMctJ1mYXhPS/2VyHw==
X-Gm-Gg: ASbGncsIhiFr4A+FuHzro4jy1w3sy9Y1/ooKWldBCnAJXM2WIchUn6ZZ8qMeHo/kqKN
	Avixr2PDMeeDaTMyuQ9aPxBe3mBtxmPDYMUMDQ6WeiR0G9ZWegS3J+Yw4aeNEHHahfQ8KXGPMPr
	iTr7exfbQwn5EjDzKEgipA2nwIj4a2OA9icmwMAtdsgpy+ZPyAt8fNbapK8QgwpotwGEW9/Y+wQ
	rZGpWMqVuNykISjFEe/PQyZteaYUn3Xt0p9HuCg3+JQUnRJ289yQXPPdCKm5iTSfGhhhHnfvDsf
	gBMPueCfVqaiEfA1RpKN5+UJusl5iPEMdkwrsomOSY1Cqu4QzI9O
X-Received: by 2002:a05:6a00:ab0d:b0:73b:ef0a:f9dc with SMTP id d2e1a72fcca58-7409cedc7d8mr573793b3a.4.1746560744786;
        Tue, 06 May 2025 12:45:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6+3BD2CzoQHKGWWt5caIb2pdgKCjbZ3DgVGCkUgZRwx+Kn6oYUUvEOyJh7fN/5OxTmolt4w==
X-Received: by 2002:a05:6a00:ab0d:b0:73b:ef0a:f9dc with SMTP id d2e1a72fcca58-7409cedc7d8mr573771b3a.4.1746560744433;
        Tue, 06 May 2025 12:45:44 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590631a7sm9348025b3a.152.2025.05.06.12.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:45:44 -0700 (PDT)
Date: Wed, 7 May 2025 03:45:39 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] xfs: add a test for writeback after close
Message-ID: <20250506194539.u7scbp4rsipibza6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-8-hch@lst.de>

On Thu, May 01, 2025 at 08:42:44AM -0500, Christoph Hellwig wrote:
> Test that files written back after closing are packed tightly instead of
> using up open zone resources.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4206     | 57 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4206.out |  1 +
>  2 files changed, 58 insertions(+)
>  create mode 100755 tests/xfs/4206
>  create mode 100644 tests/xfs/4206.out
> 
> diff --git a/tests/xfs/4206 b/tests/xfs/4206
> new file mode 100755
> index 000000000000..63e6aebeaeec
> --- /dev/null
> +++ b/tests/xfs/4206
> @@ -0,0 +1,57 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4206
> +#
> +# Test that data is packed tighly for writeback after the files were
> +# closed.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw zone
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount >/dev/null 2>&1

Same, is this unmount necessary?

> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_require_scratch
> +
> +_filter_rgno()

If this filter is useful for 1+ case, how about moving it to common/filter?
Or remove the "_" prefix of a local function.

> +{
> +	# the rg number is in column 4 of xfs_bmap output
> +	perl -ne '
> +		$rg = (split /\s+/)[4] ;
> +		if ($rg =~ /\d+/) {print "$rg "} ;
> +	'
> +}
> +
> +_scratch_mkfs_xfs >>$seqres.full 2>&1
> +_scratch_mount
> +_require_xfs_scratch_zoned
> +
> +# Create a bunch of small files
> +for i in `seq 1 100`; do
> +	file=$SCRATCH_MNT/$i
> +
> +	$XFS_IO_PROG -f -c 'pwrite 0 8k' $file >>$seqres.full
> +done
> +
> +sync
> +
> +# Check that all small files are placed together
> +short_rg=`xfs_bmap -v $SCRATCH_MNT/1 | _filter_rgno`
> +for i in `seq 2 100`; do
> +	file=$SCRATCH_MNT/$i
> +	rg=`xfs_bmap -v $file | _filter_rgno`
> +	if [ "${rg}" != "${short_rg}" ]; then
> +		echo "RG mismatch for file $i: $short_rg/$rg"
> +	fi
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4206.out b/tests/xfs/4206.out
> new file mode 100644
> index 000000000000..4835b5053ae5
> --- /dev/null
> +++ b/tests/xfs/4206.out
> @@ -0,0 +1 @@
> +QA output created by 4206
> -- 
> 2.47.2
> 
> 

