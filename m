Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E59313E3A
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769009683; cv=none; b=NozqUp/8Enx45fn3D8wm9liVwRj4/dLW0Bd040HxqHtG3n4/PgXy24L6/S21+BCg8wOhfeIle9K7qYrGAoHANwzeFRJ9B8M4WXwCU2RQf8lpLBybHMswVT0DK0Am51+X2+TdB8g7UN+IIAwn7FXmDXaWxTApmpEzdc/23k+zIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769009683; c=relaxed/simple;
	bh=p+ZlH5146VafKm2rb3sOigynS2wW/bwlJjmlRWGc5dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjjIW72Ys5opqODcvHufD6M0wOHarbVk4ol6ZE70olgj1+xlVQz4ASmFUbrp68LM1bS8u5r652WoG90GYseEeVZuG4PHhq/g80ljZlMWBVAr8WaPDmOMP+LV6xa0u7h+MZGbTfC3OvzAvP46Xn6Atdl4prRe8lo6zGnuCCqi39s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EyXBGcew; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTxb6pf7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EyXBGcew";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTxb6pf7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769009679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S6GOTOrdisoHe+Tk8YgZpixzHg0VjFSeaU2cx9ooOIg=;
	b=EyXBGcewYKQk5Qk/FDQCm1pV7Uv7Wq8Z+BTT3JVZiwLh6SV9AHHrZONF42kedigV3pdZZ1
	7Ki/AoRvsLwtHepM9skVBEICBKdyVO/FJ0KxzmW0sV3Cl5x8sXNw0hE2T5Eaxib4Z57sX+
	0IVtnvxgCBt3Z4V8jsmsaUMwGcFaPtE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-Rdwx0wZxN3mHdVCQp5NakA-1; Wed, 21 Jan 2026 10:34:36 -0500
X-MC-Unique: Rdwx0wZxN3mHdVCQp5NakA-1
X-Mimecast-MFC-AGG-ID: Rdwx0wZxN3mHdVCQp5NakA_1769009676
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso1146103a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769009676; x=1769614476; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S6GOTOrdisoHe+Tk8YgZpixzHg0VjFSeaU2cx9ooOIg=;
        b=UTxb6pf7jpOmM11ssgnpzF0gwXOAt/2S1rWiPjjXyarWe/BmjG14n75h3vvdIYhRg4
         n+NkLmwBNTnvuGeXr1hjuUBB9PTCb8H5rHITFFnibL8W3gXshVaT3gxU0MxArW4dYrx2
         AFo1Fc6bZmtWoJed7RSHqYdA4WEgYF7nILjc90hNz+OeBkqxNqq1lsF7IGJzbHKjPrUn
         LCHaM455IiKQ8kvx6n3uEwr9+mqnbbcF8qntPJQ23Q/R82dLDW7N6QXzjZJxAoBbbX56
         hxaKNjTUMSUIjwrtCPothJUynuzwCadIOUyp1Vf5gmaRfURGoMoE9SwXIw/TMPSzNCJr
         laEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769009676; x=1769614476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6GOTOrdisoHe+Tk8YgZpixzHg0VjFSeaU2cx9ooOIg=;
        b=kGGBvGESZ2MRAeflgdndLTGaY16jZn4xbdA86QI5uCDLSR0EvS8N8TGqdMVg74N+SC
         Qkx2ZlkP/QrM1/qct5zsqjB0tkuNbygSpOoU427ZMwLTpPM0DcDMOLw5ejjQb8gGHxiU
         ko7lVVylcwXSIFaJyQfJfe6Y4/c45ECdAQ6aCf/w2A9FqIE1UhL7airSzzP2TheEO7pW
         LbR/Wun/9e6iO51RTQQpdksRTCJg7AjGT0b8x3+QGd/ZaIUJa4AnIQvUPUI7TNUyq0hI
         HPJEo1iVyNFZjZKdG/TD9iQABWhWDz6pQoguNkEyYeo/CMX0vrWSh4Opa87xyQI9aBJn
         e21w==
X-Forwarded-Encrypted: i=1; AJvYcCWHEqsj4X2rCzT9rtjL/TI7vAUhmhkeU4kKkuqFsvIPy7zvrhIqWmHYxJNlu24wvYEm/ystOiKzinY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOP0YT9EwqgUpGqsJqViFHqx00W0Tml+iiKmxX9ec/ATwtCt/H
	ViTnamrb7sGOaj31+n7sJTc9N73I04p7idWe6yWNcaUIX/lsiz/jIsvtwYffMV3Hu0L42EEBECT
	imKUK14n2cZttusIZI6LMsGnrNETr6glNtpYQRSs0sZGu0A3zSgK1HibTWu9gXQ==
X-Gm-Gg: AZuq6aJ3KOa3K/hBA2SbaDxqb4Rpa1qdS9dut02nJb6U8zG68CzxT95JdE5t2+nP6zU
	6qkbHfSTG1U4CZcVz5dGt5SIkdpRr089GR0SFtnKcaTWiB5uDKxFC71hPKMkUkjjn9zAQOwZF0g
	We2oJmf5D/Kdf7y+yKfvKZhXIXmhkro60WwONi2iGsE46tAi0Cjy/lRpDhp+hYgteawO1F9Lk6v
	8Q/sDclilInc6foUqlroih+v1eGNrJg/Ecj0UVM8NUF+R/W8nn7mgjfif9kHA1EkctqW3ggcgay
	orWt2Y6yAEwjQ6mEoo1T0TUXaKE1eHP7ZKKKycdiYOqvijX/1qzebzzCuPJAOk3pe2nYw51SQZl
	SPugeAT2YXbbxmzg1fT+2q3PXbzXkaMEIqrog90INLw9ivdpK/w==
X-Received: by 2002:a17:90b:3890:b0:340:b501:7b83 with SMTP id 98e67ed59e1d1-35272c8e0damr15489673a91.10.1769009675302;
        Wed, 21 Jan 2026 07:34:35 -0800 (PST)
X-Received: by 2002:a17:90b:3890:b0:340:b501:7b83 with SMTP id 98e67ed59e1d1-35272c8e0damr15489654a91.10.1769009674632;
        Wed, 21 Jan 2026 07:34:34 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352d5a3ea3dsm4537315a91.3.2026.01.21.07.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 07:34:33 -0800 (PST)
Date: Wed, 21 Jan 2026 23:34:30 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/614: fix test for parent pointers
Message-ID: <20260121153430.fp47z2qucdwcsuen@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260121012700.GF15541@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121012700.GF15541@frogsfrogsfrogs>

On Tue, Jan 20, 2026 at 05:27:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Almost a decade ago, the initial rmap/reflink patches were merged with
> hugely overestimated log space reservations.  Although we adjusted the
> actual runtime reservations a few years ago, we left the minimum log
> size calculations in place to avoid compatibility problems between newer
> mkfs and older kernels.
> 
> With the introduction of parent pointers, we can finally use the more
> accurate reservations for minlog computations and mkfs can format
> smaller logs as a result.  This causes the output of this test to
> change, though it wasn't needed until parent pointers were enabled by
> default.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

1. Use 614.cfg to support two kinds of outputs (with or without parent=1)
2. or write a seperated (similar) test case for parent pointer only.

Both 2 ways are good me, as you prefer the former one, I'll merge this one :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/xfs                       |    3 +
>  tests/xfs/614                    |    1 
>  tests/xfs/614.cfg                |    4 +
>  tests/xfs/614.out.lba1024_parent |  177 ++++++++++++++++++++++++++++++++++++++
>  tests/xfs/614.out.lba2048_parent |  177 ++++++++++++++++++++++++++++++++++++++
>  tests/xfs/614.out.lba4096_parent |  177 ++++++++++++++++++++++++++++++++++++++
>  tests/xfs/614.out.lba512_parent  |  177 ++++++++++++++++++++++++++++++++++++++
>  7 files changed, 716 insertions(+)
>  create mode 100644 tests/xfs/614.out.lba1024_parent
>  create mode 100644 tests/xfs/614.out.lba2048_parent
>  create mode 100644 tests/xfs/614.out.lba4096_parent
>  create mode 100644 tests/xfs/614.out.lba512_parent
> 
> diff --git a/common/xfs b/common/xfs
> index 8b1b87413659ad..7fa0db2e26b4c9 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1732,6 +1732,9 @@ _xfs_filter_mkfs()
>  		print STDERR "dirversion=$1\ndirbsize=$2\n";
>  		print STDOUT "naming   =VERN bsize=XXX\n";
>  	}
> +	if (/^naming\s+=.*parent=(\d+)/) {
> +		print STDERR "parent=$1\n";
> +	}
>  	if (/^log\s+=(internal log|[\w|\/.-]+)\s+bsize=(\d+)\s+blocks=(\d+),\s+version=(\d+)/ ||
>  		/^log\s+=(internal log|[\w|\/.-]+)\s+bsize=(\d+)\s+blocks=(\d+)/) {
>  		print STDERR "ldev=\"$1\"\nlbsize=$2\nlblocks=$3\nlversion=$4\n";
> diff --git a/tests/xfs/614 b/tests/xfs/614
> index e182f073fddd64..21a4e205847fc3 100755
> --- a/tests/xfs/614
> +++ b/tests/xfs/614
> @@ -32,6 +32,7 @@ rm -f "$loop_file"
>  truncate -s 16M "$loop_file"
>  $MKFS_XFS_PROG -f -N "$loop_file" | _filter_mkfs 2>$tmp.mkfs >/dev/null
>  . $tmp.mkfs
> +test "$parent" = 1 && sectsz="${sectsz}_parent"
>  seqfull=$0
>  _link_out_file "lba${sectsz}"
>  
> diff --git a/tests/xfs/614.cfg b/tests/xfs/614.cfg
> index 0678032432540b..e824a2feed9988 100644
> --- a/tests/xfs/614.cfg
> +++ b/tests/xfs/614.cfg
> @@ -2,3 +2,7 @@ lba512: lba512
>  lba1024: lba1024
>  lba2048: lba2048
>  lba4096: lba4096
> +lba512_parent: lba512_parent
> +lba1024_parent: lba1024_parent
> +lba2048_parent: lba2048_parent
> +lba4096_parent: lba4096_parent
> diff --git a/tests/xfs/614.out.lba1024_parent b/tests/xfs/614.out.lba1024_parent
> new file mode 100644
> index 00000000000000..90b9f8bd70a58f
> --- /dev/null
> +++ b/tests/xfs/614.out.lba1024_parent
> @@ -0,0 +1,177 @@
> +QA output created by 614
> +sz 16M cpus 2 agcount 1 logblocks 1650
> +sz 16M cpus 4 agcount 1 logblocks 1650
> +sz 16M cpus 8 agcount 1 logblocks 1650
> +sz 16M cpus 16 agcount 1 logblocks 1650
> +sz 16M cpus 32 agcount 1 logblocks 1650
> +sz 16M cpus 40 agcount 1 logblocks 1650
> +sz 16M cpus 64 agcount 1 logblocks 1650
> +sz 16M cpus 96 agcount 1 logblocks 1650
> +sz 16M cpus 160 agcount 1 logblocks 1650
> +sz 16M cpus 512 agcount 1 logblocks 1650
> +-----------------
> +sz 512M cpus 2 agcount 4 logblocks 16384
> +sz 512M cpus 4 agcount 4 logblocks 16384
> +sz 512M cpus 8 agcount 4 logblocks 16384
> +sz 512M cpus 16 agcount 4 logblocks 16384
> +sz 512M cpus 32 agcount 4 logblocks 16384
> +sz 512M cpus 40 agcount 4 logblocks 16384
> +sz 512M cpus 64 agcount 4 logblocks 16384
> +sz 512M cpus 96 agcount 4 logblocks 16384
> +sz 512M cpus 160 agcount 4 logblocks 16384
> +sz 512M cpus 512 agcount 4 logblocks 16384
> +-----------------
> +sz 1G cpus 2 agcount 4 logblocks 16384
> +sz 1G cpus 4 agcount 4 logblocks 16384
> +sz 1G cpus 8 agcount 4 logblocks 16384
> +sz 1G cpus 16 agcount 4 logblocks 16384
> +sz 1G cpus 32 agcount 4 logblocks 25087
> +sz 1G cpus 40 agcount 4 logblocks 31359
> +sz 1G cpus 64 agcount 4 logblocks 50175
> +sz 1G cpus 96 agcount 4 logblocks 65524
> +sz 1G cpus 160 agcount 4 logblocks 65524
> +sz 1G cpus 512 agcount 4 logblocks 65524
> +-----------------
> +sz 2G cpus 2 agcount 4 logblocks 16384
> +sz 2G cpus 4 agcount 4 logblocks 16384
> +sz 2G cpus 8 agcount 4 logblocks 16384
> +sz 2G cpus 16 agcount 4 logblocks 16384
> +sz 2G cpus 32 agcount 4 logblocks 25087
> +sz 2G cpus 40 agcount 4 logblocks 31359
> +sz 2G cpus 64 agcount 4 logblocks 50175
> +sz 2G cpus 96 agcount 4 logblocks 75262
> +sz 2G cpus 160 agcount 4 logblocks 125437
> +sz 2G cpus 512 agcount 4 logblocks 131060
> +-----------------
> +sz 16G cpus 2 agcount 4 logblocks 16384
> +sz 16G cpus 4 agcount 4 logblocks 16384
> +sz 16G cpus 8 agcount 4 logblocks 16384
> +sz 16G cpus 16 agcount 4 logblocks 16384
> +sz 16G cpus 32 agcount 4 logblocks 25087
> +sz 16G cpus 40 agcount 4 logblocks 31359
> +sz 16G cpus 64 agcount 4 logblocks 50175
> +sz 16G cpus 96 agcount 4 logblocks 75262
> +sz 16G cpus 160 agcount 4 logblocks 125437
> +sz 16G cpus 512 agcount 4 logblocks 401400
> +-----------------
> +sz 64G cpus 2 agcount 4 logblocks 16384
> +sz 64G cpus 4 agcount 4 logblocks 16384
> +sz 64G cpus 8 agcount 8 logblocks 16384
> +sz 64G cpus 16 agcount 16 logblocks 16384
> +sz 64G cpus 32 agcount 16 logblocks 25087
> +sz 64G cpus 40 agcount 16 logblocks 31359
> +sz 64G cpus 64 agcount 16 logblocks 50175
> +sz 64G cpus 96 agcount 16 logblocks 75262
> +sz 64G cpus 160 agcount 16 logblocks 125437
> +sz 64G cpus 512 agcount 16 logblocks 401400
> +-----------------
> +sz 256G cpus 2 agcount 4 logblocks 32768
> +sz 256G cpus 4 agcount 4 logblocks 32768
> +sz 256G cpus 8 agcount 8 logblocks 32768
> +sz 256G cpus 16 agcount 16 logblocks 32768
> +sz 256G cpus 32 agcount 32 logblocks 32768
> +sz 256G cpus 40 agcount 40 logblocks 32767
> +sz 256G cpus 64 agcount 64 logblocks 50175
> +sz 256G cpus 96 agcount 64 logblocks 75262
> +sz 256G cpus 160 agcount 64 logblocks 125437
> +sz 256G cpus 512 agcount 64 logblocks 401400
> +-----------------
> +sz 512G cpus 2 agcount 4 logblocks 65536
> +sz 512G cpus 4 agcount 4 logblocks 65536
> +sz 512G cpus 8 agcount 8 logblocks 65536
> +sz 512G cpus 16 agcount 16 logblocks 65536
> +sz 512G cpus 32 agcount 32 logblocks 65536
> +sz 512G cpus 40 agcount 40 logblocks 65535
> +sz 512G cpus 64 agcount 64 logblocks 65536
> +sz 512G cpus 96 agcount 96 logblocks 75262
> +sz 512G cpus 160 agcount 128 logblocks 125437
> +sz 512G cpus 512 agcount 128 logblocks 401400
> +-----------------
> +sz 1T cpus 2 agcount 4 logblocks 131072
> +sz 1T cpus 4 agcount 4 logblocks 131072
> +sz 1T cpus 8 agcount 8 logblocks 131072
> +sz 1T cpus 16 agcount 16 logblocks 131072
> +sz 1T cpus 32 agcount 32 logblocks 131072
> +sz 1T cpus 40 agcount 40 logblocks 131071
> +sz 1T cpus 64 agcount 64 logblocks 131072
> +sz 1T cpus 96 agcount 96 logblocks 131071
> +sz 1T cpus 160 agcount 160 logblocks 131071
> +sz 1T cpus 512 agcount 256 logblocks 401400
> +-----------------
> +sz 2T cpus 2 agcount 4 logblocks 262144
> +sz 2T cpus 4 agcount 4 logblocks 262144
> +sz 2T cpus 8 agcount 8 logblocks 262144
> +sz 2T cpus 16 agcount 16 logblocks 262144
> +sz 2T cpus 32 agcount 32 logblocks 262144
> +sz 2T cpus 40 agcount 40 logblocks 262143
> +sz 2T cpus 64 agcount 64 logblocks 262144
> +sz 2T cpus 96 agcount 96 logblocks 262143
> +sz 2T cpus 160 agcount 160 logblocks 262143
> +sz 2T cpus 512 agcount 512 logblocks 401400
> +-----------------
> +sz 4T cpus 2 agcount 4 logblocks 521728
> +sz 4T cpus 4 agcount 4 logblocks 521728
> +sz 4T cpus 8 agcount 8 logblocks 521728
> +sz 4T cpus 16 agcount 16 logblocks 521728
> +sz 4T cpus 32 agcount 32 logblocks 521728
> +sz 4T cpus 40 agcount 40 logblocks 521728
> +sz 4T cpus 64 agcount 64 logblocks 521728
> +sz 4T cpus 96 agcount 96 logblocks 521728
> +sz 4T cpus 160 agcount 160 logblocks 521728
> +sz 4T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 16T cpus 2 agcount 16 logblocks 521728
> +sz 16T cpus 4 agcount 16 logblocks 521728
> +sz 16T cpus 8 agcount 16 logblocks 521728
> +sz 16T cpus 16 agcount 16 logblocks 521728
> +sz 16T cpus 32 agcount 32 logblocks 521728
> +sz 16T cpus 40 agcount 40 logblocks 521728
> +sz 16T cpus 64 agcount 64 logblocks 521728
> +sz 16T cpus 96 agcount 96 logblocks 521728
> +sz 16T cpus 160 agcount 160 logblocks 521728
> +sz 16T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 64T cpus 2 agcount 64 logblocks 521728
> +sz 64T cpus 4 agcount 64 logblocks 521728
> +sz 64T cpus 8 agcount 64 logblocks 521728
> +sz 64T cpus 16 agcount 64 logblocks 521728
> +sz 64T cpus 32 agcount 64 logblocks 521728
> +sz 64T cpus 40 agcount 64 logblocks 521728
> +sz 64T cpus 64 agcount 64 logblocks 521728
> +sz 64T cpus 96 agcount 96 logblocks 521728
> +sz 64T cpus 160 agcount 160 logblocks 521728
> +sz 64T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 256T cpus 2 agcount 256 logblocks 521728
> +sz 256T cpus 4 agcount 256 logblocks 521728
> +sz 256T cpus 8 agcount 256 logblocks 521728
> +sz 256T cpus 16 agcount 256 logblocks 521728
> +sz 256T cpus 32 agcount 256 logblocks 521728
> +sz 256T cpus 40 agcount 256 logblocks 521728
> +sz 256T cpus 64 agcount 256 logblocks 521728
> +sz 256T cpus 96 agcount 256 logblocks 521728
> +sz 256T cpus 160 agcount 256 logblocks 521728
> +sz 256T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 512T cpus 2 agcount 512 logblocks 521728
> +sz 512T cpus 4 agcount 512 logblocks 521728
> +sz 512T cpus 8 agcount 512 logblocks 521728
> +sz 512T cpus 16 agcount 512 logblocks 521728
> +sz 512T cpus 32 agcount 512 logblocks 521728
> +sz 512T cpus 40 agcount 512 logblocks 521728
> +sz 512T cpus 64 agcount 512 logblocks 521728
> +sz 512T cpus 96 agcount 512 logblocks 521728
> +sz 512T cpus 160 agcount 512 logblocks 521728
> +sz 512T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 1P cpus 2 agcount 1024 logblocks 521728
> +sz 1P cpus 4 agcount 1024 logblocks 521728
> +sz 1P cpus 8 agcount 1024 logblocks 521728
> +sz 1P cpus 16 agcount 1024 logblocks 521728
> +sz 1P cpus 32 agcount 1024 logblocks 521728
> +sz 1P cpus 40 agcount 1024 logblocks 521728
> +sz 1P cpus 64 agcount 1024 logblocks 521728
> +sz 1P cpus 96 agcount 1024 logblocks 521728
> +sz 1P cpus 160 agcount 1024 logblocks 521728
> +sz 1P cpus 512 agcount 1024 logblocks 521728
> +-----------------
> diff --git a/tests/xfs/614.out.lba2048_parent b/tests/xfs/614.out.lba2048_parent
> new file mode 100644
> index 00000000000000..b66afe566891ac
> --- /dev/null
> +++ b/tests/xfs/614.out.lba2048_parent
> @@ -0,0 +1,177 @@
> +QA output created by 614
> +sz 16M cpus 2 agcount 1 logblocks 1650
> +sz 16M cpus 4 agcount 1 logblocks 1650
> +sz 16M cpus 8 agcount 1 logblocks 1650
> +sz 16M cpus 16 agcount 1 logblocks 1650
> +sz 16M cpus 32 agcount 1 logblocks 1650
> +sz 16M cpus 40 agcount 1 logblocks 1650
> +sz 16M cpus 64 agcount 1 logblocks 1650
> +sz 16M cpus 96 agcount 1 logblocks 1650
> +sz 16M cpus 160 agcount 1 logblocks 1650
> +sz 16M cpus 512 agcount 1 logblocks 1650
> +-----------------
> +sz 512M cpus 2 agcount 4 logblocks 16384
> +sz 512M cpus 4 agcount 4 logblocks 16384
> +sz 512M cpus 8 agcount 4 logblocks 16384
> +sz 512M cpus 16 agcount 4 logblocks 16384
> +sz 512M cpus 32 agcount 4 logblocks 16384
> +sz 512M cpus 40 agcount 4 logblocks 16384
> +sz 512M cpus 64 agcount 4 logblocks 16384
> +sz 512M cpus 96 agcount 4 logblocks 16384
> +sz 512M cpus 160 agcount 4 logblocks 16384
> +sz 512M cpus 512 agcount 4 logblocks 16384
> +-----------------
> +sz 1G cpus 2 agcount 4 logblocks 16384
> +sz 1G cpus 4 agcount 4 logblocks 16384
> +sz 1G cpus 8 agcount 4 logblocks 16384
> +sz 1G cpus 16 agcount 4 logblocks 16384
> +sz 1G cpus 32 agcount 4 logblocks 25087
> +sz 1G cpus 40 agcount 4 logblocks 31359
> +sz 1G cpus 64 agcount 4 logblocks 50175
> +sz 1G cpus 96 agcount 4 logblocks 65523
> +sz 1G cpus 160 agcount 4 logblocks 65523
> +sz 1G cpus 512 agcount 4 logblocks 65523
> +-----------------
> +sz 2G cpus 2 agcount 4 logblocks 16384
> +sz 2G cpus 4 agcount 4 logblocks 16384
> +sz 2G cpus 8 agcount 4 logblocks 16384
> +sz 2G cpus 16 agcount 4 logblocks 16384
> +sz 2G cpus 32 agcount 4 logblocks 25087
> +sz 2G cpus 40 agcount 4 logblocks 31359
> +sz 2G cpus 64 agcount 4 logblocks 50175
> +sz 2G cpus 96 agcount 4 logblocks 75262
> +sz 2G cpus 160 agcount 4 logblocks 125437
> +sz 2G cpus 512 agcount 4 logblocks 131059
> +-----------------
> +sz 16G cpus 2 agcount 4 logblocks 16384
> +sz 16G cpus 4 agcount 4 logblocks 16384
> +sz 16G cpus 8 agcount 4 logblocks 16384
> +sz 16G cpus 16 agcount 4 logblocks 16384
> +sz 16G cpus 32 agcount 4 logblocks 25087
> +sz 16G cpus 40 agcount 4 logblocks 31359
> +sz 16G cpus 64 agcount 4 logblocks 50175
> +sz 16G cpus 96 agcount 4 logblocks 75262
> +sz 16G cpus 160 agcount 4 logblocks 125437
> +sz 16G cpus 512 agcount 4 logblocks 401400
> +-----------------
> +sz 64G cpus 2 agcount 4 logblocks 16384
> +sz 64G cpus 4 agcount 4 logblocks 16384
> +sz 64G cpus 8 agcount 8 logblocks 16384
> +sz 64G cpus 16 agcount 16 logblocks 16384
> +sz 64G cpus 32 agcount 16 logblocks 25087
> +sz 64G cpus 40 agcount 16 logblocks 31359
> +sz 64G cpus 64 agcount 16 logblocks 50175
> +sz 64G cpus 96 agcount 16 logblocks 75262
> +sz 64G cpus 160 agcount 16 logblocks 125437
> +sz 64G cpus 512 agcount 16 logblocks 401400
> +-----------------
> +sz 256G cpus 2 agcount 4 logblocks 32768
> +sz 256G cpus 4 agcount 4 logblocks 32768
> +sz 256G cpus 8 agcount 8 logblocks 32768
> +sz 256G cpus 16 agcount 16 logblocks 32768
> +sz 256G cpus 32 agcount 32 logblocks 32768
> +sz 256G cpus 40 agcount 40 logblocks 32767
> +sz 256G cpus 64 agcount 64 logblocks 50175
> +sz 256G cpus 96 agcount 64 logblocks 75262
> +sz 256G cpus 160 agcount 64 logblocks 125437
> +sz 256G cpus 512 agcount 64 logblocks 401400
> +-----------------
> +sz 512G cpus 2 agcount 4 logblocks 65536
> +sz 512G cpus 4 agcount 4 logblocks 65536
> +sz 512G cpus 8 agcount 8 logblocks 65536
> +sz 512G cpus 16 agcount 16 logblocks 65536
> +sz 512G cpus 32 agcount 32 logblocks 65536
> +sz 512G cpus 40 agcount 40 logblocks 65535
> +sz 512G cpus 64 agcount 64 logblocks 65536
> +sz 512G cpus 96 agcount 96 logblocks 75262
> +sz 512G cpus 160 agcount 128 logblocks 125437
> +sz 512G cpus 512 agcount 128 logblocks 401400
> +-----------------
> +sz 1T cpus 2 agcount 4 logblocks 131072
> +sz 1T cpus 4 agcount 4 logblocks 131072
> +sz 1T cpus 8 agcount 8 logblocks 131072
> +sz 1T cpus 16 agcount 16 logblocks 131072
> +sz 1T cpus 32 agcount 32 logblocks 131072
> +sz 1T cpus 40 agcount 40 logblocks 131071
> +sz 1T cpus 64 agcount 64 logblocks 131072
> +sz 1T cpus 96 agcount 96 logblocks 131071
> +sz 1T cpus 160 agcount 160 logblocks 131071
> +sz 1T cpus 512 agcount 256 logblocks 401400
> +-----------------
> +sz 2T cpus 2 agcount 4 logblocks 262144
> +sz 2T cpus 4 agcount 4 logblocks 262144
> +sz 2T cpus 8 agcount 8 logblocks 262144
> +sz 2T cpus 16 agcount 16 logblocks 262144
> +sz 2T cpus 32 agcount 32 logblocks 262144
> +sz 2T cpus 40 agcount 40 logblocks 262143
> +sz 2T cpus 64 agcount 64 logblocks 262144
> +sz 2T cpus 96 agcount 96 logblocks 262143
> +sz 2T cpus 160 agcount 160 logblocks 262143
> +sz 2T cpus 512 agcount 512 logblocks 401400
> +-----------------
> +sz 4T cpus 2 agcount 4 logblocks 521728
> +sz 4T cpus 4 agcount 4 logblocks 521728
> +sz 4T cpus 8 agcount 8 logblocks 521728
> +sz 4T cpus 16 agcount 16 logblocks 521728
> +sz 4T cpus 32 agcount 32 logblocks 521728
> +sz 4T cpus 40 agcount 40 logblocks 521728
> +sz 4T cpus 64 agcount 64 logblocks 521728
> +sz 4T cpus 96 agcount 96 logblocks 521728
> +sz 4T cpus 160 agcount 160 logblocks 521728
> +sz 4T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 16T cpus 2 agcount 16 logblocks 521728
> +sz 16T cpus 4 agcount 16 logblocks 521728
> +sz 16T cpus 8 agcount 16 logblocks 521728
> +sz 16T cpus 16 agcount 16 logblocks 521728
> +sz 16T cpus 32 agcount 32 logblocks 521728
> +sz 16T cpus 40 agcount 40 logblocks 521728
> +sz 16T cpus 64 agcount 64 logblocks 521728
> +sz 16T cpus 96 agcount 96 logblocks 521728
> +sz 16T cpus 160 agcount 160 logblocks 521728
> +sz 16T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 64T cpus 2 agcount 64 logblocks 521728
> +sz 64T cpus 4 agcount 64 logblocks 521728
> +sz 64T cpus 8 agcount 64 logblocks 521728
> +sz 64T cpus 16 agcount 64 logblocks 521728
> +sz 64T cpus 32 agcount 64 logblocks 521728
> +sz 64T cpus 40 agcount 64 logblocks 521728
> +sz 64T cpus 64 agcount 64 logblocks 521728
> +sz 64T cpus 96 agcount 96 logblocks 521728
> +sz 64T cpus 160 agcount 160 logblocks 521728
> +sz 64T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 256T cpus 2 agcount 256 logblocks 521728
> +sz 256T cpus 4 agcount 256 logblocks 521728
> +sz 256T cpus 8 agcount 256 logblocks 521728
> +sz 256T cpus 16 agcount 256 logblocks 521728
> +sz 256T cpus 32 agcount 256 logblocks 521728
> +sz 256T cpus 40 agcount 256 logblocks 521728
> +sz 256T cpus 64 agcount 256 logblocks 521728
> +sz 256T cpus 96 agcount 256 logblocks 521728
> +sz 256T cpus 160 agcount 256 logblocks 521728
> +sz 256T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 512T cpus 2 agcount 512 logblocks 521728
> +sz 512T cpus 4 agcount 512 logblocks 521728
> +sz 512T cpus 8 agcount 512 logblocks 521728
> +sz 512T cpus 16 agcount 512 logblocks 521728
> +sz 512T cpus 32 agcount 512 logblocks 521728
> +sz 512T cpus 40 agcount 512 logblocks 521728
> +sz 512T cpus 64 agcount 512 logblocks 521728
> +sz 512T cpus 96 agcount 512 logblocks 521728
> +sz 512T cpus 160 agcount 512 logblocks 521728
> +sz 512T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 1P cpus 2 agcount 1024 logblocks 521728
> +sz 1P cpus 4 agcount 1024 logblocks 521728
> +sz 1P cpus 8 agcount 1024 logblocks 521728
> +sz 1P cpus 16 agcount 1024 logblocks 521728
> +sz 1P cpus 32 agcount 1024 logblocks 521728
> +sz 1P cpus 40 agcount 1024 logblocks 521728
> +sz 1P cpus 64 agcount 1024 logblocks 521728
> +sz 1P cpus 96 agcount 1024 logblocks 521728
> +sz 1P cpus 160 agcount 1024 logblocks 521728
> +sz 1P cpus 512 agcount 1024 logblocks 521728
> +-----------------
> diff --git a/tests/xfs/614.out.lba4096_parent b/tests/xfs/614.out.lba4096_parent
> new file mode 100644
> index 00000000000000..452891d1aa1270
> --- /dev/null
> +++ b/tests/xfs/614.out.lba4096_parent
> @@ -0,0 +1,177 @@
> +QA output created by 614
> +sz 16M cpus 2 agcount 1 logblocks 1650
> +sz 16M cpus 4 agcount 1 logblocks 1650
> +sz 16M cpus 8 agcount 1 logblocks 1650
> +sz 16M cpus 16 agcount 1 logblocks 1650
> +sz 16M cpus 32 agcount 1 logblocks 1650
> +sz 16M cpus 40 agcount 1 logblocks 1650
> +sz 16M cpus 64 agcount 1 logblocks 1650
> +sz 16M cpus 96 agcount 1 logblocks 1650
> +sz 16M cpus 160 agcount 1 logblocks 1650
> +sz 16M cpus 512 agcount 1 logblocks 1650
> +-----------------
> +sz 512M cpus 2 agcount 4 logblocks 16384
> +sz 512M cpus 4 agcount 4 logblocks 16384
> +sz 512M cpus 8 agcount 4 logblocks 16384
> +sz 512M cpus 16 agcount 4 logblocks 16384
> +sz 512M cpus 32 agcount 4 logblocks 16384
> +sz 512M cpus 40 agcount 4 logblocks 16384
> +sz 512M cpus 64 agcount 4 logblocks 16384
> +sz 512M cpus 96 agcount 4 logblocks 16384
> +sz 512M cpus 160 agcount 4 logblocks 16384
> +sz 512M cpus 512 agcount 4 logblocks 16384
> +-----------------
> +sz 1G cpus 2 agcount 4 logblocks 16384
> +sz 1G cpus 4 agcount 4 logblocks 16384
> +sz 1G cpus 8 agcount 4 logblocks 16384
> +sz 1G cpus 16 agcount 4 logblocks 16384
> +sz 1G cpus 32 agcount 4 logblocks 25087
> +sz 1G cpus 40 agcount 4 logblocks 31359
> +sz 1G cpus 64 agcount 4 logblocks 50175
> +sz 1G cpus 96 agcount 4 logblocks 65521
> +sz 1G cpus 160 agcount 4 logblocks 65521
> +sz 1G cpus 512 agcount 4 logblocks 65521
> +-----------------
> +sz 2G cpus 2 agcount 4 logblocks 16384
> +sz 2G cpus 4 agcount 4 logblocks 16384
> +sz 2G cpus 8 agcount 4 logblocks 16384
> +sz 2G cpus 16 agcount 4 logblocks 16384
> +sz 2G cpus 32 agcount 4 logblocks 25087
> +sz 2G cpus 40 agcount 4 logblocks 31359
> +sz 2G cpus 64 agcount 4 logblocks 50175
> +sz 2G cpus 96 agcount 4 logblocks 75262
> +sz 2G cpus 160 agcount 4 logblocks 125437
> +sz 2G cpus 512 agcount 4 logblocks 131057
> +-----------------
> +sz 16G cpus 2 agcount 4 logblocks 16384
> +sz 16G cpus 4 agcount 4 logblocks 16384
> +sz 16G cpus 8 agcount 4 logblocks 16384
> +sz 16G cpus 16 agcount 4 logblocks 16384
> +sz 16G cpus 32 agcount 4 logblocks 25087
> +sz 16G cpus 40 agcount 4 logblocks 31359
> +sz 16G cpus 64 agcount 4 logblocks 50175
> +sz 16G cpus 96 agcount 4 logblocks 75262
> +sz 16G cpus 160 agcount 4 logblocks 125437
> +sz 16G cpus 512 agcount 4 logblocks 401400
> +-----------------
> +sz 64G cpus 2 agcount 4 logblocks 16384
> +sz 64G cpus 4 agcount 4 logblocks 16384
> +sz 64G cpus 8 agcount 8 logblocks 16384
> +sz 64G cpus 16 agcount 16 logblocks 16384
> +sz 64G cpus 32 agcount 16 logblocks 25087
> +sz 64G cpus 40 agcount 16 logblocks 31359
> +sz 64G cpus 64 agcount 16 logblocks 50175
> +sz 64G cpus 96 agcount 16 logblocks 75262
> +sz 64G cpus 160 agcount 16 logblocks 125437
> +sz 64G cpus 512 agcount 16 logblocks 401400
> +-----------------
> +sz 256G cpus 2 agcount 4 logblocks 32768
> +sz 256G cpus 4 agcount 4 logblocks 32768
> +sz 256G cpus 8 agcount 8 logblocks 32768
> +sz 256G cpus 16 agcount 16 logblocks 32768
> +sz 256G cpus 32 agcount 32 logblocks 32768
> +sz 256G cpus 40 agcount 40 logblocks 32767
> +sz 256G cpus 64 agcount 64 logblocks 50175
> +sz 256G cpus 96 agcount 64 logblocks 75262
> +sz 256G cpus 160 agcount 64 logblocks 125437
> +sz 256G cpus 512 agcount 64 logblocks 401400
> +-----------------
> +sz 512G cpus 2 agcount 4 logblocks 65536
> +sz 512G cpus 4 agcount 4 logblocks 65536
> +sz 512G cpus 8 agcount 8 logblocks 65536
> +sz 512G cpus 16 agcount 16 logblocks 65536
> +sz 512G cpus 32 agcount 32 logblocks 65536
> +sz 512G cpus 40 agcount 40 logblocks 65535
> +sz 512G cpus 64 agcount 64 logblocks 65536
> +sz 512G cpus 96 agcount 96 logblocks 75262
> +sz 512G cpus 160 agcount 128 logblocks 125437
> +sz 512G cpus 512 agcount 128 logblocks 401400
> +-----------------
> +sz 1T cpus 2 agcount 4 logblocks 131072
> +sz 1T cpus 4 agcount 4 logblocks 131072
> +sz 1T cpus 8 agcount 8 logblocks 131072
> +sz 1T cpus 16 agcount 16 logblocks 131072
> +sz 1T cpus 32 agcount 32 logblocks 131072
> +sz 1T cpus 40 agcount 40 logblocks 131071
> +sz 1T cpus 64 agcount 64 logblocks 131072
> +sz 1T cpus 96 agcount 96 logblocks 131071
> +sz 1T cpus 160 agcount 160 logblocks 131071
> +sz 1T cpus 512 agcount 256 logblocks 401400
> +-----------------
> +sz 2T cpus 2 agcount 4 logblocks 262144
> +sz 2T cpus 4 agcount 4 logblocks 262144
> +sz 2T cpus 8 agcount 8 logblocks 262144
> +sz 2T cpus 16 agcount 16 logblocks 262144
> +sz 2T cpus 32 agcount 32 logblocks 262144
> +sz 2T cpus 40 agcount 40 logblocks 262143
> +sz 2T cpus 64 agcount 64 logblocks 262144
> +sz 2T cpus 96 agcount 96 logblocks 262143
> +sz 2T cpus 160 agcount 160 logblocks 262143
> +sz 2T cpus 512 agcount 512 logblocks 401400
> +-----------------
> +sz 4T cpus 2 agcount 4 logblocks 521728
> +sz 4T cpus 4 agcount 4 logblocks 521728
> +sz 4T cpus 8 agcount 8 logblocks 521728
> +sz 4T cpus 16 agcount 16 logblocks 521728
> +sz 4T cpus 32 agcount 32 logblocks 521728
> +sz 4T cpus 40 agcount 40 logblocks 521728
> +sz 4T cpus 64 agcount 64 logblocks 521728
> +sz 4T cpus 96 agcount 96 logblocks 521728
> +sz 4T cpus 160 agcount 160 logblocks 521728
> +sz 4T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 16T cpus 2 agcount 16 logblocks 521728
> +sz 16T cpus 4 agcount 16 logblocks 521728
> +sz 16T cpus 8 agcount 16 logblocks 521728
> +sz 16T cpus 16 agcount 16 logblocks 521728
> +sz 16T cpus 32 agcount 32 logblocks 521728
> +sz 16T cpus 40 agcount 40 logblocks 521728
> +sz 16T cpus 64 agcount 64 logblocks 521728
> +sz 16T cpus 96 agcount 96 logblocks 521728
> +sz 16T cpus 160 agcount 160 logblocks 521728
> +sz 16T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 64T cpus 2 agcount 64 logblocks 521728
> +sz 64T cpus 4 agcount 64 logblocks 521728
> +sz 64T cpus 8 agcount 64 logblocks 521728
> +sz 64T cpus 16 agcount 64 logblocks 521728
> +sz 64T cpus 32 agcount 64 logblocks 521728
> +sz 64T cpus 40 agcount 64 logblocks 521728
> +sz 64T cpus 64 agcount 64 logblocks 521728
> +sz 64T cpus 96 agcount 96 logblocks 521728
> +sz 64T cpus 160 agcount 160 logblocks 521728
> +sz 64T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 256T cpus 2 agcount 256 logblocks 521728
> +sz 256T cpus 4 agcount 256 logblocks 521728
> +sz 256T cpus 8 agcount 256 logblocks 521728
> +sz 256T cpus 16 agcount 256 logblocks 521728
> +sz 256T cpus 32 agcount 256 logblocks 521728
> +sz 256T cpus 40 agcount 256 logblocks 521728
> +sz 256T cpus 64 agcount 256 logblocks 521728
> +sz 256T cpus 96 agcount 256 logblocks 521728
> +sz 256T cpus 160 agcount 256 logblocks 521728
> +sz 256T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 512T cpus 2 agcount 512 logblocks 521728
> +sz 512T cpus 4 agcount 512 logblocks 521728
> +sz 512T cpus 8 agcount 512 logblocks 521728
> +sz 512T cpus 16 agcount 512 logblocks 521728
> +sz 512T cpus 32 agcount 512 logblocks 521728
> +sz 512T cpus 40 agcount 512 logblocks 521728
> +sz 512T cpus 64 agcount 512 logblocks 521728
> +sz 512T cpus 96 agcount 512 logblocks 521728
> +sz 512T cpus 160 agcount 512 logblocks 521728
> +sz 512T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 1P cpus 2 agcount 1024 logblocks 521728
> +sz 1P cpus 4 agcount 1024 logblocks 521728
> +sz 1P cpus 8 agcount 1024 logblocks 521728
> +sz 1P cpus 16 agcount 1024 logblocks 521728
> +sz 1P cpus 32 agcount 1024 logblocks 521728
> +sz 1P cpus 40 agcount 1024 logblocks 521728
> +sz 1P cpus 64 agcount 1024 logblocks 521728
> +sz 1P cpus 96 agcount 1024 logblocks 521728
> +sz 1P cpus 160 agcount 1024 logblocks 521728
> +sz 1P cpus 512 agcount 1024 logblocks 521728
> +-----------------
> diff --git a/tests/xfs/614.out.lba512_parent b/tests/xfs/614.out.lba512_parent
> new file mode 100644
> index 00000000000000..b77659059abb9d
> --- /dev/null
> +++ b/tests/xfs/614.out.lba512_parent
> @@ -0,0 +1,177 @@
> +QA output created by 614
> +sz 16M cpus 2 agcount 1 logblocks 2001
> +sz 16M cpus 4 agcount 1 logblocks 2001
> +sz 16M cpus 8 agcount 1 logblocks 2001
> +sz 16M cpus 16 agcount 1 logblocks 2001
> +sz 16M cpus 32 agcount 1 logblocks 2001
> +sz 16M cpus 40 agcount 1 logblocks 2001
> +sz 16M cpus 64 agcount 1 logblocks 2001
> +sz 16M cpus 96 agcount 1 logblocks 2001
> +sz 16M cpus 160 agcount 1 logblocks 2001
> +sz 16M cpus 512 agcount 1 logblocks 2001
> +-----------------
> +sz 512M cpus 2 agcount 4 logblocks 16384
> +sz 512M cpus 4 agcount 4 logblocks 16384
> +sz 512M cpus 8 agcount 4 logblocks 16384
> +sz 512M cpus 16 agcount 4 logblocks 16384
> +sz 512M cpus 32 agcount 4 logblocks 16384
> +sz 512M cpus 40 agcount 4 logblocks 16384
> +sz 512M cpus 64 agcount 4 logblocks 16384
> +sz 512M cpus 96 agcount 4 logblocks 16384
> +sz 512M cpus 160 agcount 4 logblocks 16384
> +sz 512M cpus 512 agcount 4 logblocks 16384
> +-----------------
> +sz 1G cpus 2 agcount 4 logblocks 16384
> +sz 1G cpus 4 agcount 4 logblocks 16384
> +sz 1G cpus 8 agcount 4 logblocks 16384
> +sz 1G cpus 16 agcount 4 logblocks 16384
> +sz 1G cpus 32 agcount 4 logblocks 25087
> +sz 1G cpus 40 agcount 4 logblocks 31359
> +sz 1G cpus 64 agcount 4 logblocks 50175
> +sz 1G cpus 96 agcount 4 logblocks 65524
> +sz 1G cpus 160 agcount 4 logblocks 65524
> +sz 1G cpus 512 agcount 4 logblocks 65524
> +-----------------
> +sz 2G cpus 2 agcount 4 logblocks 16384
> +sz 2G cpus 4 agcount 4 logblocks 16384
> +sz 2G cpus 8 agcount 4 logblocks 16384
> +sz 2G cpus 16 agcount 4 logblocks 16384
> +sz 2G cpus 32 agcount 4 logblocks 25087
> +sz 2G cpus 40 agcount 4 logblocks 31359
> +sz 2G cpus 64 agcount 4 logblocks 50175
> +sz 2G cpus 96 agcount 4 logblocks 75262
> +sz 2G cpus 160 agcount 4 logblocks 125437
> +sz 2G cpus 512 agcount 4 logblocks 131060
> +-----------------
> +sz 16G cpus 2 agcount 4 logblocks 16384
> +sz 16G cpus 4 agcount 4 logblocks 16384
> +sz 16G cpus 8 agcount 4 logblocks 16384
> +sz 16G cpus 16 agcount 4 logblocks 16384
> +sz 16G cpus 32 agcount 4 logblocks 25087
> +sz 16G cpus 40 agcount 4 logblocks 31359
> +sz 16G cpus 64 agcount 4 logblocks 50175
> +sz 16G cpus 96 agcount 4 logblocks 75262
> +sz 16G cpus 160 agcount 4 logblocks 125437
> +sz 16G cpus 512 agcount 4 logblocks 401400
> +-----------------
> +sz 64G cpus 2 agcount 4 logblocks 16384
> +sz 64G cpus 4 agcount 4 logblocks 16384
> +sz 64G cpus 8 agcount 8 logblocks 16384
> +sz 64G cpus 16 agcount 16 logblocks 16384
> +sz 64G cpus 32 agcount 16 logblocks 25087
> +sz 64G cpus 40 agcount 16 logblocks 31359
> +sz 64G cpus 64 agcount 16 logblocks 50175
> +sz 64G cpus 96 agcount 16 logblocks 75262
> +sz 64G cpus 160 agcount 16 logblocks 125437
> +sz 64G cpus 512 agcount 16 logblocks 401400
> +-----------------
> +sz 256G cpus 2 agcount 4 logblocks 32768
> +sz 256G cpus 4 agcount 4 logblocks 32768
> +sz 256G cpus 8 agcount 8 logblocks 32768
> +sz 256G cpus 16 agcount 16 logblocks 32768
> +sz 256G cpus 32 agcount 32 logblocks 32768
> +sz 256G cpus 40 agcount 40 logblocks 32767
> +sz 256G cpus 64 agcount 64 logblocks 50175
> +sz 256G cpus 96 agcount 64 logblocks 75262
> +sz 256G cpus 160 agcount 64 logblocks 125437
> +sz 256G cpus 512 agcount 64 logblocks 401400
> +-----------------
> +sz 512G cpus 2 agcount 4 logblocks 65536
> +sz 512G cpus 4 agcount 4 logblocks 65536
> +sz 512G cpus 8 agcount 8 logblocks 65536
> +sz 512G cpus 16 agcount 16 logblocks 65536
> +sz 512G cpus 32 agcount 32 logblocks 65536
> +sz 512G cpus 40 agcount 40 logblocks 65535
> +sz 512G cpus 64 agcount 64 logblocks 65536
> +sz 512G cpus 96 agcount 96 logblocks 75262
> +sz 512G cpus 160 agcount 128 logblocks 125437
> +sz 512G cpus 512 agcount 128 logblocks 401400
> +-----------------
> +sz 1T cpus 2 agcount 4 logblocks 131072
> +sz 1T cpus 4 agcount 4 logblocks 131072
> +sz 1T cpus 8 agcount 8 logblocks 131072
> +sz 1T cpus 16 agcount 16 logblocks 131072
> +sz 1T cpus 32 agcount 32 logblocks 131072
> +sz 1T cpus 40 agcount 40 logblocks 131071
> +sz 1T cpus 64 agcount 64 logblocks 131072
> +sz 1T cpus 96 agcount 96 logblocks 131071
> +sz 1T cpus 160 agcount 160 logblocks 131071
> +sz 1T cpus 512 agcount 256 logblocks 401400
> +-----------------
> +sz 2T cpus 2 agcount 4 logblocks 262144
> +sz 2T cpus 4 agcount 4 logblocks 262144
> +sz 2T cpus 8 agcount 8 logblocks 262144
> +sz 2T cpus 16 agcount 16 logblocks 262144
> +sz 2T cpus 32 agcount 32 logblocks 262144
> +sz 2T cpus 40 agcount 40 logblocks 262143
> +sz 2T cpus 64 agcount 64 logblocks 262144
> +sz 2T cpus 96 agcount 96 logblocks 262143
> +sz 2T cpus 160 agcount 160 logblocks 262143
> +sz 2T cpus 512 agcount 512 logblocks 401400
> +-----------------
> +sz 4T cpus 2 agcount 4 logblocks 521728
> +sz 4T cpus 4 agcount 4 logblocks 521728
> +sz 4T cpus 8 agcount 8 logblocks 521728
> +sz 4T cpus 16 agcount 16 logblocks 521728
> +sz 4T cpus 32 agcount 32 logblocks 521728
> +sz 4T cpus 40 agcount 40 logblocks 521728
> +sz 4T cpus 64 agcount 64 logblocks 521728
> +sz 4T cpus 96 agcount 96 logblocks 521728
> +sz 4T cpus 160 agcount 160 logblocks 521728
> +sz 4T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 16T cpus 2 agcount 16 logblocks 521728
> +sz 16T cpus 4 agcount 16 logblocks 521728
> +sz 16T cpus 8 agcount 16 logblocks 521728
> +sz 16T cpus 16 agcount 16 logblocks 521728
> +sz 16T cpus 32 agcount 32 logblocks 521728
> +sz 16T cpus 40 agcount 40 logblocks 521728
> +sz 16T cpus 64 agcount 64 logblocks 521728
> +sz 16T cpus 96 agcount 96 logblocks 521728
> +sz 16T cpus 160 agcount 160 logblocks 521728
> +sz 16T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 64T cpus 2 agcount 64 logblocks 521728
> +sz 64T cpus 4 agcount 64 logblocks 521728
> +sz 64T cpus 8 agcount 64 logblocks 521728
> +sz 64T cpus 16 agcount 64 logblocks 521728
> +sz 64T cpus 32 agcount 64 logblocks 521728
> +sz 64T cpus 40 agcount 64 logblocks 521728
> +sz 64T cpus 64 agcount 64 logblocks 521728
> +sz 64T cpus 96 agcount 96 logblocks 521728
> +sz 64T cpus 160 agcount 160 logblocks 521728
> +sz 64T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 256T cpus 2 agcount 256 logblocks 521728
> +sz 256T cpus 4 agcount 256 logblocks 521728
> +sz 256T cpus 8 agcount 256 logblocks 521728
> +sz 256T cpus 16 agcount 256 logblocks 521728
> +sz 256T cpus 32 agcount 256 logblocks 521728
> +sz 256T cpus 40 agcount 256 logblocks 521728
> +sz 256T cpus 64 agcount 256 logblocks 521728
> +sz 256T cpus 96 agcount 256 logblocks 521728
> +sz 256T cpus 160 agcount 256 logblocks 521728
> +sz 256T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 512T cpus 2 agcount 512 logblocks 521728
> +sz 512T cpus 4 agcount 512 logblocks 521728
> +sz 512T cpus 8 agcount 512 logblocks 521728
> +sz 512T cpus 16 agcount 512 logblocks 521728
> +sz 512T cpus 32 agcount 512 logblocks 521728
> +sz 512T cpus 40 agcount 512 logblocks 521728
> +sz 512T cpus 64 agcount 512 logblocks 521728
> +sz 512T cpus 96 agcount 512 logblocks 521728
> +sz 512T cpus 160 agcount 512 logblocks 521728
> +sz 512T cpus 512 agcount 512 logblocks 521728
> +-----------------
> +sz 1P cpus 2 agcount 1024 logblocks 521728
> +sz 1P cpus 4 agcount 1024 logblocks 521728
> +sz 1P cpus 8 agcount 1024 logblocks 521728
> +sz 1P cpus 16 agcount 1024 logblocks 521728
> +sz 1P cpus 32 agcount 1024 logblocks 521728
> +sz 1P cpus 40 agcount 1024 logblocks 521728
> +sz 1P cpus 64 agcount 1024 logblocks 521728
> +sz 1P cpus 96 agcount 1024 logblocks 521728
> +sz 1P cpus 160 agcount 1024 logblocks 521728
> +sz 1P cpus 512 agcount 1024 logblocks 521728
> +-----------------
> 

