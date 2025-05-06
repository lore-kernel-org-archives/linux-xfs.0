Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441114B1E58
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746561674; cv=none; b=tbcvrPJqgsyztdDh1hmo9trESiKj3MCwpEeCmMpn8Jc6ZqkPqIz85ncowkfGacvyXfMUNRqbgBIg6BTuW7+pXKjOwOR+ueVigHtLatPWRM5akIfsGwE5T/7PAfxv9lTpLdXHsuzddG8P/XX33GkNypFNPpp6TznjEPhoXNpgWsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746561674; c=relaxed/simple;
	bh=e9Nx29McDIOaH1b3XML0MNUycb7rPwVRyUHkArzgfhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q42gioeBpuWBWslhw19nz8E6dH8tu+Uu7fvSK1+6D7j6GkcvZJbH+xH9lWoN47e+29lGwIC2g/RThSILCuQuEhQ29jUZBwZq9WN2kHz2W7sbABrx7+mbqh+PXn2lSgjU/RpcO7oQlkB1jD5QlsXku2+95yGT8kIN0Z1LtNTGL6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avXsIvV8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avXsIvV8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746561670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XyjqCp34h880u9gSBdSkyO+ZNrvrvM19O7+yIgz8NBA=;
	b=avXsIvV8rcIQM9X18d40Biy+U4U2//bJjR7+V1+2/IfYn+efsUJ8oe3ZfBDkO7k7ybRvid
	+wMAvh1wCNGT3VOjFsPgrpmi3Vrc1G4/1fYIYGRLawAF6+BibqBqyM7lhCbdGUKpkbcPq4
	DDylF020gop2mC8iTpoRj7tqRyTE7HM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-IfNk1ws7MbW2h14xGxakyw-1; Tue, 06 May 2025 16:01:08 -0400
X-MC-Unique: IfNk1ws7MbW2h14xGxakyw-1
X-Mimecast-MFC-AGG-ID: IfNk1ws7MbW2h14xGxakyw_1746561666
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7401179b06fso4724916b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 13:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746561666; x=1747166466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XyjqCp34h880u9gSBdSkyO+ZNrvrvM19O7+yIgz8NBA=;
        b=PIgx+EeKO3x3smWKrbvvOzazx8UKR7p82wOJMXf879F/ukJycEty+YZyvIZ4n/NfTZ
         mn36RU8Tiyxzn8D3K9mVAaiP4WRhBE3C/COqeM0lpUFzv+LL331LhErp0W6eLRj8ILBt
         MyMOZS2zHsaL8ZDsZPaSrdite/u56cG2iAMgjBBeyC6wh5RGajB+WwO/lfvmSOB/VPMQ
         fVUbmYGQh7SmgdOmWxpDtVScEk7sYmp+RIz7nTwqThU8+4bMvJuOxbpy6N+qEFmg2oP/
         rfOsce5ezVU+lBS0KY1AXNuVR8v6DEMI81xWx5phfvVFDusCocqd/SGrfBb2YiRBgH/c
         7vRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0SKYgBJ+GCqC2wRlBZ1OwiywX+CGLo3aRt7AkrPo4zI1Cp3IjwbZ2j0nvPLkqssFYJhWzF4CwA0g=@vger.kernel.org
X-Gm-Message-State: AOJu0YweicWX+Qc5sUnUptRGAsRrheI3A72mmiJvddtQSHkbaZuYi1Fx
	WP1enCSUADtNlEH/7RFfrjRMPiyUYIxbdlRn37wXgXpTTvwiD9QzY7gfUZhQTFZH3okCLhidz7+
	J8jH67pMNIFataYp1DN2ABjMyj+1FYOfhdU6Hf1knlsEDEJe6tLc83iwctg==
X-Gm-Gg: ASbGnctjOq1mMdljmgZEjJcTgX2ZvOfhJ3f707fETv/2vKXbMYfBZI4kLSTZAvNnjCo
	0fpDp8EaICgAiWeeEt0LIpwv9yZhfNvQmPodMRQSA+/KcFr0Xzmd5wNky+RcLtDPJP7eI1sKo6D
	X1O8fwoZjSJredb88aeUgzDbZZQqrFYk941stx2MHg9zGVfPGYhmpcuU8LnhUa7RTzvlwZK8brD
	KCJiZe9IoRii8DPdAY1IehCuQqXNXQXmExucqLN0gyOAoS2wSpIypQ79BgElOjpFDNx+TtY6lxH
	DErd2YuoZqQygCGGd6TAQKjqKngQu8n7oFwVgPnmdpQJofk32k7a
X-Received: by 2002:a05:6a00:3003:b0:73e:2d76:9eb1 with SMTP id d2e1a72fcca58-7409cf01a8cmr538081b3a.10.1746561666223;
        Tue, 06 May 2025 13:01:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHK4bbsFQaHaG5GxZVx6Mk732R6xm4F5U9eFxuF7SWICRrPkslBKbVbTgCVSTkzNJ4uBtTWCA==
X-Received: by 2002:a05:6a00:3003:b0:73e:2d76:9eb1 with SMTP id d2e1a72fcca58-7409cf01a8cmr538035b3a.10.1746561665830;
        Tue, 06 May 2025 13:01:05 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059020dedsm9704252b3a.91.2025.05.06.13.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 13:01:05 -0700 (PDT)
Date: Wed, 7 May 2025 04:01:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs: test zoned GC file defragmentation for random
 writers
Message-ID: <20250506200101.6u4ww65kpu34eqlg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-13-hch@lst.de>

On Thu, May 01, 2025 at 08:42:49AM -0500, Christoph Hellwig wrote:
> Test that zoned GC defragments sequential writers forced into the same
> zone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Same review points with patch 10/15

>  tests/xfs/4211     | 129 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4211.out |   5 ++
>  2 files changed, 134 insertions(+)
>  create mode 100755 tests/xfs/4211
>  create mode 100644 tests/xfs/4211.out
> 
> diff --git a/tests/xfs/4211 b/tests/xfs/4211
> new file mode 100755
> index 000000000000..9679da72a4eb
> --- /dev/null
> +++ b/tests/xfs/4211
> @@ -0,0 +1,129 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4211
> +#
> +# Test that GC defragments randomly written files.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw zone
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount >/dev/null 2>&1
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/zoned
> +
> +_require_scratch
> +
> +_scratch_mkfs_sized $((256 * 1024 * 1024))  >>$seqres.full 2>&1
> +
> +# limit to two max open zones so that all writes get thrown into the blender
> +export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
> +_try_scratch_mount || _notrun "mount option not supported"
> +_require_xfs_scratch_zoned
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
> +directory=$SCRATCH_MNT
> +ioengine=libaio
> +rw=randwrite
> +direct=1
> +size=30m
> +
> +[file1]
> +filename=file1
> +
> +[file2]
> +filename=file2
> +
> +[file3]
> +filename=file3
> +
> +[file4]
> +filename=file4
> +
> +[file5]
> +filename=file5
> +
> +[file6]
> +filename=file6
> +
> +[file7]
> +filename=file7
> +
> +[file8]
> +filename=file8
> +EOF
> +
> +_require_fio $fio_config
> +
> +# create fragmented files
> +$FIO_PROG $fio_config --output=$fio_out
> +cat $fio_out >> $seqres.full
> +
> +# fill up all remaining user capacity
> +dd if=/dev/zero of=$SCRATCH_MNT/fill bs=4k >> $seqres.full 2>&1
> +
> +sync
> +
> +# all files should be badly fragmented now
> +extents2=$(_count_extents $SCRATCH_MNT/file2)
> +echo "number of file 2 extents: $extents2" >>$seqres.full
> +test $extents2 -gt 200 || _fail "fio did not fragment file"
> +
> +extents4=$(_count_extents $SCRATCH_MNT/file4)
> +echo "number of file 4 extents: $extents4" >>$seqres.full
> +test $extents4 -gt 200 || _fail "fio did not fragment file"
> +
> +extents6=$(_count_extents $SCRATCH_MNT/file6)
> +echo "number of file 6 extents: $extents6" >>$seqres.full
> +test $extents6 -gt 200 || _fail "fio did not fragment file"
> +
> +extents8=$(_count_extents $SCRATCH_MNT/file8)
> +echo "number of file 8 extents: $extents8" >>$seqres.full
> +test $extents8 -gt 200 || _fail "fio did not fragment file"
> +
> +# remove half of the files to create work for GC
> +rm $SCRATCH_MNT/file1
> +rm $SCRATCH_MNT/file3
> +rm $SCRATCH_MNT/file5
> +rm $SCRATCH_MNT/file7
> +
> +#
> +# Fill up all remaining user capacity a few times to force GC.
> +#
> +# This needs to be a very large number of larger zones sizes that have a lot
> +# of OP for the small file system size
> +#
> +for i in `seq 1 200`; do
> +	dd if=/dev/zero of=$SCRATCH_MNT/fill bs=4k >> $seqres.full 2>&1
> +	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/fill >> $seqres.full 2>&1
> +done
> +
> +#
> +# All files should have a no more than a handful of extents now
> +#
> +extents2=$(_count_extents $SCRATCH_MNT/file2)
> +_within_tolerance "file 2 extents" $extents2 3 2 -v
> +extents4=$(_count_extents $SCRATCH_MNT/file4)
> +_within_tolerance "file 4 extents" $extents4 3 2 -v
> +extents6=$(_count_extents $SCRATCH_MNT/file6)
> +_within_tolerance "file 6 extents" $extents6 3 2 -v
> +extents8=$(_count_extents $SCRATCH_MNT/file8)
> +_within_tolerance "file 8 extents" $extents8 3 2 -v
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4211.out b/tests/xfs/4211.out
> new file mode 100644
> index 000000000000..348e59950a47
> --- /dev/null
> +++ b/tests/xfs/4211.out
> @@ -0,0 +1,5 @@
> +QA output created by 4211
> +file 2 extents is in range
> +file 4 extents is in range
> +file 6 extents is in range
> +file 8 extents is in range
> -- 
> 2.47.2
> 
> 

