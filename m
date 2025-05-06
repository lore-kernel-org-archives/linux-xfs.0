Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FCE1FBCB1
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 19:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746561290; cv=none; b=iwrnrB5eK57+TSJAtCbAi8+WQsDKU4AmeM62/0BVpu/ElU7E1R9BwL9QcWM5YJi3E9G1t4VCrbOaFGDly93FqUzrGvS8XAgk5OmHspgnksKvVaoNcm2QbUz1lNV5UkzPTaMVzLsblZh+UKjvczPIN5FJpEbDvLcMAI4NXNwGS6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746561290; c=relaxed/simple;
	bh=qOBf+I6QQQZBDMXtPERFZllywn1N2P9yWCe0qH5Njtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+IGDKiFEbOs9x1q7h/vaTCTy/1+3IzJ4z3pu5DYSwUliXkqq1oX+3ETx6bZ147dYaocPMH0rf/+IyvD/yAFCNYfFLFnvccIniypa7CflmH0F+nTJ9VeR77R9T9okyRlvgtpNdILpn7CByeGhf59TXnkbIPLrcGiICQDdp+ZU6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H385buyW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H385buyW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746561288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nTtBEGhm/lysd8OPY+qVgqqfEFpE8kDf1zO3CBYOOdw=;
	b=H385buyWnInEHBTSAzLqls4pKP/mJeh5gDENRwPQ/eeqTH1aumP2kYOjsjIVJewRFvUsNc
	Yxas3UoGzxwRMS7KBTSKiAaY6ZadjjlylxuHF+CMXA8UcOfU2Vj2tMDdb9CiiF3WFbMmDJ
	nzCyu8lBeoJAyD+2tddZ2lK0gXLUM6E=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-Gj1RLVzjMuGH540OrBriBg-1; Tue, 06 May 2025 15:54:46 -0400
X-MC-Unique: Gj1RLVzjMuGH540OrBriBg-1
X-Mimecast-MFC-AGG-ID: Gj1RLVzjMuGH540OrBriBg_1746561286
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ff58318acaso8455562a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 12:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746561285; x=1747166085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTtBEGhm/lysd8OPY+qVgqqfEFpE8kDf1zO3CBYOOdw=;
        b=h4FzKwJ/VSi73RFfXZnMNXeQ1BeYQeJ5KxRXQMs1VSu6w7+oCHoXPv+ydgljYMAZT5
         vaN0bDs/69u4xksIMBG/WEIaavhCnC+Q7ZKoLI6Y96A7orJBZ+nJHDSi4bV54Q6DUckU
         QuO408Tbd4NfPuoGBB3ZkY17xPXYN42eQJqLtu2tEnzScZXvfRL/7IuepaDWp46eWF0R
         GZlOm34+GN6m4RC+0rf/78Pm9OKdgAVa1x0uRZ0r2/vpJJlQHZHR3f+dagEdBQ8PUZG5
         hVN4Ffn37rGcxDUGNDJnmXuSOt752XtZq/W7bg60fmfEvB0A8zgt5A8CU02L8TSXnLpG
         YNiA==
X-Forwarded-Encrypted: i=1; AJvYcCXHOpPWDmd/y3tOEWKvi0ObJRmexJpXIoWVSR06gSHC4bjSvvirNxG8wfF7m9rxlMJ1Ws3i0eLXGUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHjdKmEiNHHFDz7IqBHLF3MExNKWGKtx9LN3xMkxYe9ItEac/8
	faWUmcQE1pfz1CMJumkIoiqH5fnB6Zt1VAgL2UYjY2JvBT95S8aNYFligjpEFicujz9DZjIpMOH
	fNiawbMwieQh4gNaTmYauv0AsY+G5wZbNZ4YxBMeK53peQFHxwWSZA+/N5jVBm7xlUw==
X-Gm-Gg: ASbGncv7D2WCfuQYUiEY8Z5cRWy4pReopNhO3VkFa09to8UlyzuIVxrzWasHKVa8MNn
	lxqf7bRgSyeRe7q+vWAFRIN+MRqocjXzHmNUNpTBs/HBQrB8cfRJyrqCy3j/DkaNWwjDAJNV7tJ
	DpZD9VxHye+tOQINhyQnns+tjvXKwJB3ov4/y3QbmNMBAOH/0toN9/84DFNvQKnqhYkhhb5t7V3
	m+4URvKfe7LXQDr9CYt/qCObX03zUWWIUG3TZfEVRn6XCD627kTTCU0via7lwIarq0vwqeLeeIF
	4nWBZ0kahXrZtFeebCbZ3HFn+fofJHV5Nm57oWbViXtDuSjkzRdF
X-Received: by 2002:a17:90b:3d8c:b0:2f2:a664:df1a with SMTP id 98e67ed59e1d1-30aac156361mr1187900a91.2.1746561285677;
        Tue, 06 May 2025 12:54:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEd/Bp/SJj/dFUii4g0ztMXnsqi74UFt0LA7wClWlUC30ZzHQTbvZ2ib92cDiv1RTLZbZvj5w==
X-Received: by 2002:a17:90b:3d8c:b0:2f2:a664:df1a with SMTP id 98e67ed59e1d1-30aac156361mr1187872a91.2.1746561285318;
        Tue, 06 May 2025 12:54:45 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30aaead24bdsm209096a91.32.2025.05.06.12.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:54:45 -0700 (PDT)
Date: Wed, 7 May 2025 03:54:40 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] xfs: test zone stream separation for two buffered
 writers
Message-ID: <20250506195440.ylqb6rgxi455zcpw@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-10-hch@lst.de>

On Thu, May 01, 2025 at 08:42:46AM -0500, Christoph Hellwig wrote:
> Check that two parallel buffered sequential writers are separated into
> different zones when writeback happens before closing the files.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4208     | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4208.out |  3 ++
>  2 files changed, 82 insertions(+)
>  create mode 100755 tests/xfs/4208
>  create mode 100644 tests/xfs/4208.out
> 
> diff --git a/tests/xfs/4208 b/tests/xfs/4208
> new file mode 100755
> index 000000000000..b85105704b65
> --- /dev/null
> +++ b/tests/xfs/4208
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4208
> +#
> +# Test that multiple buffered I/O write streams are directed to separate zones
> +# when written back with the file still open.
> +#
> +. ./common/preamble
> +_begin_fstest quick auto rw zone
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount >/dev/null 2>&1

Same review points with patch 8/15.

> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_require_scratch
> +
> +_filter_rgno()

Same review points with patch 8/15.

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
> +_require_xfs_scratch_zoned 3
> +
> +fio_config=$tmp.fio
> +fio_out=$tmp.fio.out
> +fio_err=$tmp.fio.err
> +
> +cat >$fio_config <<EOF
> +[global]
> +bs=64k
> +iodepth=16
> +iodepth_batch=8
> +size=1m
> +directory=$SCRATCH_MNT
> +rw=write
> +fsync_on_close=1
> +
> +[file1]
> +filename=file1
> +size=128m
> +
> +[file2]
> +filename=file2
> +size=128m
> +EOF
> +
> +_require_fio $fio_config
> +
> +$FIO_PROG $fio_config --output=$fio_out
> +cat $fio_out >> $seqres.full
> +
> +# Check the files only have a single extent each and are in separate zones
> +extents1=$(_count_extents $SCRATCH_MNT/file1)
> +extents2=$(_count_extents $SCRATCH_MNT/file2)
> +
> +echo "number of file 1 extents: $extents1"
> +echo "number of file 2 extents: $extents2"
> +
> +rg1=`xfs_bmap -v $SCRATCH_MNT/file1 | _filter_rgno`
> +rg2=`xfs_bmap -v $SCRATCH_MNT/file2 | _filter_rgno`
> +if [ "${rg1}" == "${rg2}" ]; then
> +	echo "same RG used for both files"
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4208.out b/tests/xfs/4208.out
> new file mode 100644
> index 000000000000..1aaea308fe6a
> --- /dev/null
> +++ b/tests/xfs/4208.out
> @@ -0,0 +1,3 @@
> +QA output created by 4208
> +number of file 1 extents: 1
> +number of file 2 extents: 1
> -- 
> 2.47.2
> 

