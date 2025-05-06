Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2D6202C44
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 19:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746560641; cv=none; b=qEMgSS/G0YgZkO+HjZ0zSGwKvOZwoJvLUUl5HrGbINb5azMGhOxDZmOfSiYNHyIXCtPNyULODpzc5NfQVmyHPbbtJdjpzsiB9RyIw+EPMqDNnDDXQAMEMmm9n/zcxJWmJHsRVmqcIRbCV7Xi9MYYrcQUYMFFkUjiSKcqJgHzKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746560641; c=relaxed/simple;
	bh=aDHnmJoUM+mK/o5/vIQ8b+YC+F5PBeV7QWtqiLwxwQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAAYRbTZ9OdhnN7AVG0aLYulKFiq2rE9f4MQlT3SA7jt6QRGoqBiDO1+VasEvHy4dBToVG6pSZ6+2uZd/Zmr3Bd9iqRmxi6fYtVvuP3mUAcGZPCll76oQ+a6aKBfWIyFLmUJPtWqRZsolGDMW7NBfBz6E36vA3EUucVk+Lz6PGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cqNpG/e8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqNpG/e8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746560638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3KE5pGkvRI7NimGve0sFl4yhasEooOR6ozOlBx/sWA=;
	b=cqNpG/e8ep20MHgNzH4bUolKU5xejYq5y4EclGFQB2WXSJCBKH+SUCLOyzrcYqcGr6+Ppl
	bV6Hss40i/wJ7G7yvY2LVnkzyJGM4W3p8tNB2jBHzUE/DljiB3o5eBe4SJqHZgrA5UReiH
	adOJupG4HfkvCsKribXb7swK0zK2l4A=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-kf9ui6ghN-mofEPG1105Jw-1; Tue, 06 May 2025 15:43:02 -0400
X-MC-Unique: kf9ui6ghN-mofEPG1105Jw-1
X-Mimecast-MFC-AGG-ID: kf9ui6ghN-mofEPG1105Jw_1746560581
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-736cb72efd5so4805988b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 12:43:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746560581; x=1747165381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3KE5pGkvRI7NimGve0sFl4yhasEooOR6ozOlBx/sWA=;
        b=m90nqGhvHXjdFTnZJ02GB1lRGZwhCU9tlJKvYncuWy+31aBuX7a5BB37fJTJSB1xYs
         MMBzyv5TGK18fioCoC1S6zxwhPHjE2C6MTyq1UWPkJMGg0AHeuWvqR3Hr1HscNXyPczh
         CxpvImuKYO5ivKfgqZ6mxxjbaCfCXT8KIgYtrMhUwo/GsBp3j+EGfBskWDR/eS/2Bwuj
         UyTC/wzZ0bfCU6LaMW2MzI7YAdrQgVTtNSwcQmkeMY4grf0U7wv5aFDUi81kO8gr0cMs
         o0a6y8YVVZSUQp1HeGJRK/r1+Ay8LrqPdTfhGNa+bRzDF8EoPmzinnzhwN5NViAKdltn
         2vsw==
X-Forwarded-Encrypted: i=1; AJvYcCUMWi54yHH6NPgZL0Ec1DU3G6EYE3wMXQG0Rbr3S1Zl6z1xZEZw/I4GpyCERjqesXlbqG+pf0xvg1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/ibG5q6eu4828nMk9gIPXTcqfBzTXOnfW9S8nCYIZVO/MJHNo
	VxKXfLffBcutsr6HYrspQz47DvRvPbxXi9wse54sJjrZ6Nl0Ts4Mx/i0ESn1OazI6RmuZNee4Jn
	phiwLcUc+bhBmnsfOpzLZgXO+H5qEdF3Kb9lLCPjsC2K0hzzi3jGga6fO8A==
X-Gm-Gg: ASbGncuFx10PGnF2puMwzqcVm2B7Ku7o1Th3+1m4J+8l7gNZMsU1+aGwaBxWRgAYZYJ
	V9gLecHFDRCRBpbLRud/0yw1bHFIFhR8Am8v/M875AVlWRNpUdWAxv7XQZXEUEpGCzTstHE84f9
	mviBwjzW6+ouT7eXt81aCEX1REoeNWiStsmqJdjzbo8Om7nkTzztkNuPPww1DVgAntmWTwObnPV
	8iehLpdAvPFUEuQVp0aiPmrybtXpD7BNglRWjwuSggj1+2B/px8xAQWQZlAXP1Mbd9nuPM1r9Zd
	XdBtwW/tagb4HZeXT6wFHj7TOmNlRyrpQk3BZPGtHPvOoqYVNvXy
X-Received: by 2002:a05:6a00:3001:b0:740:5977:7efd with SMTP id d2e1a72fcca58-7409cf479c9mr455912b3a.13.1746560580962;
        Tue, 06 May 2025 12:43:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIiGovGX/Kbdz9RCfFjRyJiPUy11sU6RtZW3tj1F5CKYvo9uvO1wtwDRAsGQgA2jzXMB/49Q==
X-Received: by 2002:a05:6a00:3001:b0:740:5977:7efd with SMTP id d2e1a72fcca58-7409cf479c9mr455890b3a.13.1746560580594;
        Tue, 06 May 2025 12:43:00 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905d011sm9321301b3a.121.2025.05.06.12.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:43:00 -0700 (PDT)
Date: Wed, 7 May 2025 03:42:55 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] xfs: add a test for write lifetime hints
Message-ID: <20250506194255.5hny5vgfe7ct647i@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-7-hch@lst.de>

On Thu, May 01, 2025 at 08:42:43AM -0500, Christoph Hellwig wrote:
> Test that the zone allocator actually places by temperature bucket.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4205     | 105 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4205.out |   4 ++
>  2 files changed, 109 insertions(+)
>  create mode 100755 tests/xfs/4205
>  create mode 100644 tests/xfs/4205.out
> 
> diff --git a/tests/xfs/4205 b/tests/xfs/4205
> new file mode 100755
> index 000000000000..be508806ec0a
> --- /dev/null
> +++ b/tests/xfs/4205
> @@ -0,0 +1,105 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4205
> +#
> +# Test data placement by write hints.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw zone
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount >/dev/null 2>&1

Is this unmount necessary here? If not, this _cleanup can be removed.

> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_require_scratch
> +
> +_filter_rgno()
> +{
> +	# the rg number is in column 4 of xfs_bmap output
> +	perl -ne '
> +		$rg = (split /\s+/)[4] ;
> +		if ($rg =~ /\d+/) {print "$rg "} ;
> +	'
> +}
> +
> +_test_placement()

I think we don't remind using "_" prefix for local function of each test case :)

> +{
> +	xfs_io_opts=$1
> +
> +	_scratch_mkfs_xfs >>$seqres.full 2>&1
> +	_scratch_mount
> +	_require_xfs_scratch_zoned 3
> +
> +	# Create a bunch of files for the three major temperature buckets
> +	for i in `seq 1 100`; do
> +		for hint in "short" "medium" "long"; do
> +			file=$SCRATCH_MNT/$hint.$i
> +
> +			touch $file
> +			$here/src/rw_hint $file $hint
> +			$XFS_IO_PROG ${xfs_io_opts} \
> +				-c 'pwrite 0 1m' \
> +				$file >>$seqres.full
> +		done
> +	done
> +
> +	sync
> +
> +	# Check that all short lifetime files are placed together
> +	short_rg=`xfs_bmap -v $SCRATCH_MNT/short.1 | _filter_rgno`
> +	for i in `seq 2 100`; do
> +		file=$SCRATCH_MNT/short.$i
> +		rg=`xfs_bmap -v $file | _filter_rgno`
> +		if [ "${rg}" != "${short_rg}" ]; then
> +			echo "short RG mismatch for file $i: $short_rg/$rg"
> +		fi
> +	done
> +
> +	# Check that all medium lifetime files are placed together,
> +	# but not in the short RG
> +	medium_rg=`xfs_bmap -v $SCRATCH_MNT/medium.1 | _filter_rgno`
> +	if [ "${medium}" == "${short_rg}" ]; then
> +		echo "medium rg == short_rg"
> +	fi
> +	for i in `seq 2 100`; do
> +		file=$SCRATCH_MNT/medium.$i
> +		rg=`xfs_bmap -v $file | _filter_rgno`
> +		if [ "${rg}" != "${medium_rg}" ]; then
> +			echo "medium RG mismatch for file $i: $medium_rg/$rg"
> +		fi
> +	done
> +
> +	# Check that none of the long lifetime files are colocated with
> +	# short and medium ones
> +	for i in `seq 1 100`; do
> +		file=$SCRATCH_MNT/long.$i
> +		rg=`xfs_bmap -v $file | _filter_rgno`
> +		if [ "${rg}" == "${short_rg}" ]; then
> +			echo "long file $i placed into short RG "
> +		fi
> +		if [ "${rg}" == "${medium_rg}" ]; then
> +			echo "long file $i placed into medium RG"
> +		fi
> +	done
> +
> +	_scratch_unmount
> +}
> +
> +echo "Testing buffered I/O:"
> +_test_placement ""
> +
> +echo "Testing synchronous buffered I/O:"
> +_test_placement "-s"
> +
> +echo "Testing direct I/O:"
> +_test_placement "-d"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4205.out b/tests/xfs/4205.out
> new file mode 100644
> index 000000000000..3331e361a36d
> --- /dev/null
> +++ b/tests/xfs/4205.out
> @@ -0,0 +1,4 @@
> +QA output created by 4205
> +Testing buffered I/O:
> +Testing synchronous buffered I/O:
> +Testing direct I/O:
> -- 
> 2.47.2
> 

