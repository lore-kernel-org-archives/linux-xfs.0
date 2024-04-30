Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2267617167B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 13:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714482680; cv=none; b=jVCEfTAfvPWApb0kztuZnPJ0efcPc8y+dxAsrpwcZU7dB/pn7sBTBYTeoY/MrdIeCZQe+y2sVd/PjNrxaXMb3h/a/PG6E1IfXi3sF0C6YmAzIQ16w+fZSU5PnYg6eRd7caVc18DfHp3bYj7qH4URau3MyPsx9zspXQlb3bG0IrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714482680; c=relaxed/simple;
	bh=jtNGZMYeGP1LULY3KxazTWIjs2Ge50h78da8zXBzjd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqqxGrtlLNYzquA+zX0PnoLxVRgICubQvjEiVa0goy61g8EsWJ9iaL3YxF39uOdQP0K3528qNHyat+e/Uw5WPRjvo2Kn/sUnw+if5jhY8eUPlhLDs7qWy7GmpIJLcpgLJkHE7+BY22bOYxbGQzakQAAYYpCj8wwTFfNPPjtTX9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1gQYNoQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1gQYNoQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714482678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=95aBNjG/VN9MMv3xbdcOyGuKHpd3cXGecE4z+AQOn+M=;
	b=e1gQYNoQo3BO+LGyDYhiHKWnnALIGKRu2k8HigKXH4gplLp7AhxGQuep5qHWcYX9puCDym
	hpPr/7qc3LL2vMsIH9A50nP90T6xAT/6rdPyTFurlSQt++8JfeN6uePTO1UTX8pytGY5XX
	ivgli4tXuVVRs+E8+h+SpizyJbE8rxw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-tprOHflPN6u8kQCxQ_MIBA-1; Tue, 30 Apr 2024 09:11:14 -0400
X-MC-Unique: tprOHflPN6u8kQCxQ_MIBA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a58b9cf05afso311540666b.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 06:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714482673; x=1715087473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95aBNjG/VN9MMv3xbdcOyGuKHpd3cXGecE4z+AQOn+M=;
        b=WlSn7+AfF3IlUM/3veuCH2h4y8wdZh0iWAmq1KiJF9mbSMxalUr3KGH5Ji7oo+JwLI
         2IQoiMkZALmJjrQXCfOXlf3d9KB5jPJhdbtxb51ylwIgQViMp8Fe2rZILvc6CvxhV2If
         ZO6LfNLer9xkZBLBOU5XplhvpVpxhf678IX6EkLic+YfoHM+I+4YGSswy/YjbsiZsf2a
         e/zAnsxJAxYdeCSCtqNIQaugiEM5I/dF2DpXBzhDd5tWHhSebttodGKtDnYojBw62TBd
         bfyYksMBgI8PSB2//GnNpMDnP8tEFlrjJBvhKxQrzO/m3vKPGrSOLrnhFBxCFK7vBFg6
         eNUg==
X-Forwarded-Encrypted: i=1; AJvYcCUkGx+Xs9W/MxskfLc44zqRZENSQ1oQAiEHrRdySJOtdNn32iUEaHWZCQ6siAbAuILXwj047g/iOkJUfg6A/519hU3GjNIsTxVW
X-Gm-Message-State: AOJu0Yy08ABDDevSTdlLwPkeSYf/G7cyy7j9e0gqlAZkJbnFN21pljk3
	ezhB0M/tk5HZJBhGpP52ioFYdiSfkIOsBTGr9JC6kTIzcb243wKC27FJFtmK/Vjf3AZDUACrtFL
	xQeJMGEXshsTFTjbfi1d5dp4JfWN+e59gq/bWm5F+Vym6E9tgdrriXv8/
X-Received: by 2002:a17:907:94c3:b0:a58:eba0:b358 with SMTP id dn3-20020a17090794c300b00a58eba0b358mr9810638ejc.53.1714482673233;
        Tue, 30 Apr 2024 06:11:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhs/A48Qz54X3mYBA5gtCMrbov1Iyl9g0udCu4g4GEDilqAPcAFFgNWjC7tFTCHD5Bv7o4iA==
X-Received: by 2002:a17:907:94c3:b0:a58:eba0:b358 with SMTP id dn3-20020a17090794c300b00a58eba0b358mr9810596ejc.53.1714482672568;
        Tue, 30 Apr 2024 06:11:12 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id be11-20020a1709070a4b00b00a5588a9fe66sm13528382ejc.86.2024.04.30.06.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 06:11:12 -0700 (PDT)
Date: Tue, 30 Apr 2024 15:11:11 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, ebiggers@kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: test disabling fsverity
Message-ID: <cjwdgeptjooy65czttyopop4ipkxmdxgdkxxdpfsmtdtzr5jbj@6bu7ql72wtue>
References: <171444687971.962488.18035230926224414854.stgit@frogsfrogsfrogs>
 <171444688055.962488.12884471948592949028.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171444688055.962488.12884471948592949028.stgit@frogsfrogsfrogs>

On 2024-04-29 20:42:05, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a test to make sure that we can disable fsverity on a file that
> doesn't pass fsverity validation on its contents anymore.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/1881     |  111 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1881.out |   28 +++++++++++++
>  2 files changed, 139 insertions(+)
>  create mode 100755 tests/xfs/1881
>  create mode 100644 tests/xfs/1881.out
> 
> 
> diff --git a/tests/xfs/1881 b/tests/xfs/1881
> new file mode 100755
> index 0000000000..411802d7c7
> --- /dev/null
> +++ b/tests/xfs/1881
> @@ -0,0 +1,111 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1881
> +#
> +# Corrupt fsverity descriptor, merkle tree blocks, and file contents.  Ensure
> +# that we can still disable fsverity, at least for the latter cases.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick verity
> +
> +_cleanup()
> +{
> +	cd /
> +	_restore_fsverity_signatures
> +	rm -f $tmp.*
> +}
> +
> +. ./common/verity
> +. ./common/filter
> +. ./common/fuzzy
> +
> +_supported_fs xfs
> +_require_scratch_verity
> +_disable_fsverity_signatures
> +_require_fsverity_corruption
> +_require_xfs_io_command noverity
> +_require_scratch_nocheck	# corruption test
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +_require_xfs_has_feature "$SCRATCH_MNT" verity
> +VICTIM_FILE="$SCRATCH_MNT/a"
> +_fsv_can_enable "$VICTIM_FILE" || _notrun "cannot enable fsverity"
> +
> +create_victim()
> +{
> +	local filesize="${1:-3}"
> +
> +	rm -f "$VICTIM_FILE"
> +	perl -e "print 'moo' x $((filesize / 3))" > "$VICTIM_FILE"
> +	fsverity enable --hash-alg=sha256 --block-size=1024 "$VICTIM_FILE"
> +	fsverity measure "$VICTIM_FILE" | _filter_scratch
> +}
> +
> +disable_verity() {
> +	$XFS_IO_PROG -r -c 'noverity' "$VICTIM_FILE" 2>&1 | _filter_scratch
> +}
> +
> +cat_victim() {
> +	$XFS_IO_PROG -r -c 'pread -q 0 4096' "$VICTIM_FILE" 2>&1 | _filter_scratch
> +}
> +
> +echo "Part 1: Delete the fsverity descriptor" | tee -a $seqres.full
> +create_victim
> +_scratch_unmount
> +_scratch_xfs_db -x -c "path /a" -c "attr_remove -f vdesc" -c 'ablock 0' -c print >> $seqres.full
> +_scratch_mount
> +cat_victim
> +
> +echo "Part 2: Disable fsverity, which won't work" | tee -a $seqres.full
> +disable_verity
> +cat_victim
> +
> +echo "Part 3: Corrupt the fsverity descriptor" | tee -a $seqres.full
> +create_victim
> +_scratch_unmount
> +_scratch_xfs_db -x -c "path /a" -c 'attr_modify -f "vdesc" -o 0 "BUGSAHOY"' -c 'ablock 0' -c print >> $seqres.full
> +_scratch_mount
> +cat_victim
> +
> +echo "Part 4: Disable fsverity, which won't work" | tee -a $seqres.full
> +disable_verity
> +cat_victim
> +
> +echo "Part 5: Corrupt the fsverity file data" | tee -a $seqres.full
> +create_victim
> +_scratch_unmount
> +_scratch_xfs_db -x -c "path /a" -c 'dblock 0' -c 'blocktrash -3 -o 0 -x 24 -y 24 -z' -c print >> $seqres.full
> +_scratch_mount
> +cat_victim
> +
> +echo "Part 6: Disable fsverity, which should work" | tee -a $seqres.full
> +disable_verity
> +cat_victim
> +
> +echo "Part 7: Corrupt a merkle tree block" | tee -a $seqres.full
> +create_victim 1234 # two merkle tree blocks
> +_fsv_scratch_corrupt_merkle_tree "$VICTIM_FILE" 0

hmm, _fsv_scratch_corrupt_merkle_tree calls _scratch_xfs_repair, and
now with xfs_repair knowing about fs-verity is probably a problem. I
don't remember what was the problem with quota (why xfs_repiar is
there), I can check it.

> +cat_victim
> +
> +echo "Part 8: Disable fsverity, which should work" | tee -a $seqres.full
> +disable_verity
> +cat_victim
> +
> +echo "Part 9: Corrupt the fsverity salt" | tee -a $seqres.full
> +create_victim
> +_scratch_unmount
> +_scratch_xfs_db -x -c "path /a" -c 'attr_modify -f "vdesc" -o 3 #08' -c 'attr_modify -f "vdesc" -o 80 "BUGSAHOY"' -c 'ablock 0' -c print >> $seqres.full
> +_scratch_mount
> +cat_victim
> +
> +echo "Part 10: Disable fsverity, which should work" | tee -a $seqres.full
> +disable_verity
> +cat_victim
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1881.out b/tests/xfs/1881.out
> new file mode 100644
> index 0000000000..3e94b8001e
> --- /dev/null
> +++ b/tests/xfs/1881.out
> @@ -0,0 +1,28 @@
> +QA output created by 1881
> +Part 1: Delete the fsverity descriptor
> +sha256:bab5cfebae30d53e4318629d4ba0b4760d6aae38e03ae235741ed69a31873f1f SCRATCH_MNT/a
> +SCRATCH_MNT/a: Invalid argument
> +Part 2: Disable fsverity, which won't work
> +SCRATCH_MNT/a: Invalid argument
> +SCRATCH_MNT/a: Invalid argument
> +Part 3: Corrupt the fsverity descriptor
> +sha256:bab5cfebae30d53e4318629d4ba0b4760d6aae38e03ae235741ed69a31873f1f SCRATCH_MNT/a
> +SCRATCH_MNT/a: Invalid argument
> +Part 4: Disable fsverity, which won't work
> +SCRATCH_MNT/a: Invalid argument
> +SCRATCH_MNT/a: Invalid argument
> +Part 5: Corrupt the fsverity file data
> +sha256:bab5cfebae30d53e4318629d4ba0b4760d6aae38e03ae235741ed69a31873f1f SCRATCH_MNT/a
> +pread: Input/output error
> +Part 6: Disable fsverity, which should work
> +pread: Input/output error
> +Part 7: Corrupt a merkle tree block
> +sha256:c56f1115966bafa6c9d32b4717f554b304161f33923c9292c7a92a27866a853c SCRATCH_MNT/a
> +pread: Input/output error
> +Part 8: Disable fsverity, which should work
> +pread: Input/output error
> +Part 9: Corrupt the fsverity salt
> +sha256:bab5cfebae30d53e4318629d4ba0b4760d6aae38e03ae235741ed69a31873f1f SCRATCH_MNT/a
> +pread: Input/output error
> +Part 10: Disable fsverity, which should work
> +pread: Input/output error
> 

-- 
- Andrey

