Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE5515F40B
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718986487; cv=none; b=jm1aKoNYW1/k1g1U/zl8rSrb0Dtmhb+yLp+BhEbbX3F9PzGHYIUZWUkfsCG9maY1kHhrR8PeenJagfdWw6uzZcP3f6Uu3e3zO2Uymdwurx+AWE++rS9xUkRG//hwJAgfpoBmTZ391In5leKSeOujVKhXZ3u6Ah5dwnrIQoH2bMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718986487; c=relaxed/simple;
	bh=2cz7k6K8GshkV0eogK5vsJqd4R76vPiKd/DBi2DWEGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TPFyxB8NfPQzY3x/qDcU7ZVPdbbP6UZSJQzbwvNsyfmrxZQFjs1SgIVW/45nNCWfJM3mFKpqgn3yELADN5+o0GqO55EISuPEf+m2sTm/rXMYG2IfoRlXMROCz/l6rbmhplX+rSraHb1ltAqYg0O05mljimIrhvBObUlJyB+8kyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W9kwq7zL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9kwq7zL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718986484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9mwb5agojE9A02MYCkMXutzXsQgTluyUAQeiyIXx7E=;
	b=W9kwq7zLPIyYsNj9lJ6ImeOhpOR/hh5f2m1W5rpxqrCNKFTnxNf4u0GJHKykbUjJ6UdpDX
	N5Pc78jYa1tiHdCcGqY8jtyRsb/B75B40A+C40e9ZFpUWWQcYKa7RrGZBEkVMHnnLGC9r1
	+B0jBGl1+K097JaAnXKu31m72x6FhwY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-X3d3XscRO-i3_pq19AUAgA-1; Fri, 21 Jun 2024 12:14:42 -0400
X-MC-Unique: X3d3XscRO-i3_pq19AUAgA-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2c7a8a79cebso2373672a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 09:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718986482; x=1719591282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9mwb5agojE9A02MYCkMXutzXsQgTluyUAQeiyIXx7E=;
        b=LNOtP0cHGjJ+2q+OIA0Dbn1Q0oUgIE8CWJpd1jtIgSWfQTzYVUDzsJ+Xcc6ugW9sDl
         TTC9o38IJvM8mMUJQKpCASkh8JOjcXKW5HQSL2/1tSpXzmore7R2w37ZueCHX2dIW1RQ
         ShFi3bRk8JEIAxAcLintq/YOzCK3Aazh92K636cxDxlqjjZQ/GXjEqLRT1nfPAdT6LWf
         G95HmM1oTV5Il4lgD6vcL2T4AigM76Kg+qya31pV+f+aZwhwsy3hvR4g+De3b2BCIB0y
         EcRIQ8iXDjbx3CKgR1HG6VI1w4y7lejCkKtsZVRDenUucnj6uSVWCRwQXy1rPavVw/2V
         Ua3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWXlVYJVo3teF4IlVGfRN+KUCif5RgcqOlnxK7xQU9fXB8sdY+EPhBTWirEBZdtboqH7a3SIe6iuhvsHL/wdzX0v1F6WQ8DmV4G
X-Gm-Message-State: AOJu0Yx8V9/4kZhJ2LoLiJmesiP/sr6zB0NifkMoiCFdoRFKAtg7lvkh
	Bb4IpbjAySSrzdB0mwYKVnGPHQpa00XADcIh0+KooHCoMasJA2/eZwPvVUbeWz2bsGqGZ/kkbpl
	51AvRWY5TUPKhUULXFQYjzjPYp13vB5+IPnECXKt9WD4Ha2t4vaz/rEsF6A==
X-Received: by 2002:a17:90b:4a82:b0:2c7:f152:bc7d with SMTP id 98e67ed59e1d1-2c7f152bebfmr4563802a91.15.1718986481634;
        Fri, 21 Jun 2024 09:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBsAkSn3ykf/IVKWqk4HteevjtKe9dXBGlCN/UgVhHVvGRAq315QGHuFY8vofRYTVPL5SosQ==
X-Received: by 2002:a17:90b:4a82:b0:2c7:f152:bc7d with SMTP id 98e67ed59e1d1-2c7f152bebfmr4563768a91.15.1718986481042;
        Fri, 21 Jun 2024 09:14:41 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c819a7a557sm1799937a91.15.2024.06.21.09.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 09:14:40 -0700 (PDT)
Date: Sat, 22 Jun 2024 00:14:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] generic/711,xfs/537: actually fork these tests for
 exchange-range
Message-ID: <20240621161437.wn44gerhegmzn2q2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
 <171891669174.3034840.5584811354339983628.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171891669174.3034840.5584811354339983628.stgit@frogsfrogsfrogs>

On Thu, Jun 20, 2024 at 01:55:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fork these tests to check the same things with exchange-range as they do
> for swapext, since the code porting swapext to commit-range has been
> dropped.
> 
> I was going to fork xfs/789 as well, but it turns out that generic/714
> covers this sufficiently so for that one, we just strike fiexchange from
> the group tag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/1221     |   45 ++++++++++++++++++++++++
>  tests/generic/1221.out |    2 +
>  tests/generic/711      |    2 +
>  tests/xfs/1215         |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1215.out     |   13 +++++++
>  tests/xfs/789          |    2 +

Shouldn't the "xfs/537" (in subject) be xfs/789? I'll change that when
I merge it.

Thanks,
Zorro

>  6 files changed, 151 insertions(+), 2 deletions(-)
>  create mode 100755 tests/generic/1221
>  create mode 100644 tests/generic/1221.out
>  create mode 100755 tests/xfs/1215
>  create mode 100644 tests/xfs/1215.out
> 
> 
> diff --git a/tests/generic/1221 b/tests/generic/1221
> new file mode 100755
> index 0000000000..5569f59734
> --- /dev/null
> +++ b/tests/generic/1221
> @@ -0,0 +1,45 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1221
> +#
> +# Make sure that exchangerange won't touch a swap file.
> +
> +. ./common/preamble
> +_begin_fstest auto quick fiexchange
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	test -e "$dir/a" && swapoff $dir/a
> +	rm -r -f $tmp.* $dir
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_require_xfs_io_command exchangerange
> +_require_test
> +
> +dir=$TEST_DIR/test-$seq
> +mkdir -p $dir
> +
> +# Set up a fragmented swapfile and a dummy donor file.
> +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
> +$here/src/punch-alternating $dir/a
> +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
> +$MKSWAP_PROG $dir/a >> $seqres.full
> +
> +$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 32m -b 1m' $dir/b >> $seqres.full
> +
> +swapon $dir/a || _notrun 'failed to swapon'
> +
> +# Now try to exchangerange.
> +$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1221.out b/tests/generic/1221.out
> new file mode 100644
> index 0000000000..698ac87303
> --- /dev/null
> +++ b/tests/generic/1221.out
> @@ -0,0 +1,2 @@
> +QA output created by 1221
> +exchangerange: Text file busy
> diff --git a/tests/generic/711 b/tests/generic/711
> index b107f976ef..792136306c 100755
> --- a/tests/generic/711
> +++ b/tests/generic/711
> @@ -7,7 +7,7 @@
>  # Make sure that swapext won't touch a swap file.
>  
>  . ./common/preamble
> -_begin_fstest auto quick fiexchange swapext
> +_begin_fstest auto quick swapext
>  
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/xfs/1215 b/tests/xfs/1215
> new file mode 100755
> index 0000000000..5e7633c5ea
> --- /dev/null
> +++ b/tests/xfs/1215
> @@ -0,0 +1,89 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1215
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# exchanging ranges between files
> +. ./common/preamble
> +_begin_fstest auto quick collapse fiexchange
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/inject
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_xfs_scratch_rmapbt
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "exchangerange"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Exchange extent forks"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +donorfile=${SCRATCH_MNT}/donorfile
> +
> +echo "Create \$donorfile having an extent of length 67 blocks"
> +$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
> +       >> $seqres.full
> +
> +# After the for loop the donor file will have the following extent layout
> +# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
> +echo "Fragment \$donorfile"
> +for i in $(seq 5 10); do
> +	start_offset=$((i * bsize))
> +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
> +done
> +
> +echo "Create \$srcfile having an extent of length 18 blocks"
> +$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
> +       >> $seqres.full
> +
> +echo "Fragment \$srcfile"
> +# After the for loop the src file will have the following extent layout
> +# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
> +for i in $(seq 1 7); do
> +	start_offset=$((i * bsize))
> +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
> +done
> +
> +echo "Collect \$donorfile's extent count"
> +donor_nr_exts=$(_xfs_get_fsxattr nextents $donorfile)
> +
> +echo "Collect \$srcfile's extent count"
> +src_nr_exts=$(_xfs_get_fsxattr nextents $srcfile)
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Exchange \$srcfile's and \$donorfile's extent forks"
> +$XFS_IO_PROG -f -c "exchangerange $donorfile" $srcfile >> $seqres.full 2>&1
> +
> +echo "Check for \$donorfile's extent count overflow"
> +nextents=$(_xfs_get_fsxattr nextents $donorfile)
> +
> +if (( $nextents == $src_nr_exts )); then
> +	echo "\$donorfile: Extent count overflow check failed"
> +fi
> +
> +echo "Check for \$srcfile's extent count overflow"
> +nextents=$(_xfs_get_fsxattr nextents $srcfile)
> +
> +if (( $nextents == $donor_nr_exts )); then
> +	echo "\$srcfile: Extent count overflow check failed"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1215.out b/tests/xfs/1215.out
> new file mode 100644
> index 0000000000..48edd56376
> --- /dev/null
> +++ b/tests/xfs/1215.out
> @@ -0,0 +1,13 @@
> +QA output created by 1215
> +* Exchange extent forks
> +Format and mount fs
> +Create $donorfile having an extent of length 67 blocks
> +Fragment $donorfile
> +Create $srcfile having an extent of length 18 blocks
> +Fragment $srcfile
> +Collect $donorfile's extent count
> +Collect $srcfile's extent count
> +Inject reduce_max_iextents error tag
> +Exchange $srcfile's and $donorfile's extent forks
> +Check for $donorfile's extent count overflow
> +Check for $srcfile's extent count overflow
> diff --git a/tests/xfs/789 b/tests/xfs/789
> index 00b98020f2..e3a332d7cf 100755
> --- a/tests/xfs/789
> +++ b/tests/xfs/789
> @@ -7,7 +7,7 @@
>  # Simple tests of the old xfs swapext ioctl
>  
>  . ./common/preamble
> -_begin_fstest auto quick fiexchange swapext
> +_begin_fstest auto quick swapext
>  
>  # Override the default cleanup function.
>  _cleanup()
> 
> 

