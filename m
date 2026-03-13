Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F06F1A00F0
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773429570; cv=none; b=AEAfydhBkoIK4LlzbUs7V1OMjBUhq3YmyRX0OFySXtP4hjXJ92o3nSh2Dpt9ttK2AQgQNhdfL++NmnIlsMw+vZdF9hxtbDMAkyeo0o0xdpHD9OPSLTFBR/lQDAhJIxH4mZIqITVBHe0m4FI/iX1mEK1Bm+giExVIx70p6mBqWyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773429570; c=relaxed/simple;
	bh=DgLDJwjfN9POXB2fAoyI8G2QRiauMXnd+TBYRBSCsBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTDMbybleF72Qe1YSq17PajdA69Raooz/QTAkB3SA3B9iy3tMIqKbzx+nSTyOWMCecvmDQYJoArVQo8YNST6+zODT7oEgtY7yomRLbI4X5JsOFiD+UL7zA0fwZcn1/6qVmamzZ5Rh4JfIK3i8T28UEvkOyLuH1XmOVfnQXvO0dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPrVlBLi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sECpfZgm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPrVlBLi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sECpfZgm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773429568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KbAhGVPsBTRCoKAt+2dGuvMTR2ct/lDm5/NumNxug0c=;
	b=iPrVlBLi+8yEl2Srxc0ZTbZNUxSNOyMcB3IZ6OAHV3cta4IM4HLeZfGqkR7m55iu/ky2HK
	LV6MQMWD0XgSimL1zq5ivZGFaIT+H9ifwfgXU+jSfIKTnztZaLe+8nUJZjcFRBTo8aoBLD
	f9zuAl1R5ovJ9GWBghDHIw9gaZ8EsHc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-x17o7rfNPHOinYQ8AAfaVw-1; Fri, 13 Mar 2026 15:19:27 -0400
X-MC-Unique: x17o7rfNPHOinYQ8AAfaVw-1
X-Mimecast-MFC-AGG-ID: x17o7rfNPHOinYQ8AAfaVw_1773429566
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-359f31809a0so11353933a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773429565; x=1774034365; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KbAhGVPsBTRCoKAt+2dGuvMTR2ct/lDm5/NumNxug0c=;
        b=sECpfZgm8qonCimGdNXoWFDl3G5PVQMXYic7XcjWge8+f7nwBlqUajbqhaS0Fa93qe
         cegelbM0OiYf2H91fsXAAyQF8L+eIRQW4Do6X7ExNXlf9pXlsyy85404VTdsa2k6o16+
         FaO+f+QJLeeOZnsAmAKuul1KfPzfi7VVgtxuP+qH4KCRRvx+OB2hExVah2+WhZGnRyjQ
         naftW/MV/OYYqhbtErZW7hl28jjA/+QykuI66gvolvw0vD24mW0bhz4mB9OB5gbBBVbu
         3utFgOer1RMM0/7mhCD4V0Hh6nERU6Ejm7nX/zEmBZmyvk1W0sz+NF+LJogiGcpXNyxq
         toVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773429565; x=1774034365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KbAhGVPsBTRCoKAt+2dGuvMTR2ct/lDm5/NumNxug0c=;
        b=AhVHywy/80FUeadnLSLR5k0Pty1tq2A/9nruIHUtdyuFUhDfMJ6lBNtrjysjedUeO8
         0PM1gvFDLXG+Dasdliat4tzQNtIVSDx2vXuaUak9M+g4+QB7GsqbJMBx9mF6eJaXwBe6
         lGBhmys3GVP49e6VDkCnfcrYTonuShtdgDX0pZ0QPjPgWlx7Q5wFTc9CbRpReyh0Mpz4
         U6FjR6fahmHY6oGVn8j8ux4wo7hrGnuUGuBQjGGpv56jAeHOIErU7twsBbtZKuO2y8UY
         icX/DRa3Gm9uEw7q4b94n1PRO9wfIkYMv4QXUtTjCkg336YFmfWlWiuBEjQZB9ujhXwX
         SqVg==
X-Forwarded-Encrypted: i=1; AJvYcCWuRuBpaEd8ZBTaKn3VHp22R7KeQRixWdxNUU5fCxMnWRG9FI/Qakqoh6Y5htcTMz7cv7/vjbLP9LU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYK2jP3bfBTHHKdMDg+u416VeCgiVlbB3a2mr9gs9mWmpNnMEo
	5ShTI22K++ee6hAjdr6+MzuhhVC7nlF/Rnu6/sbZQUF/gqHE6KMtCKHMdZUCkFAwCspi6TDkBMW
	iSkxBd3g603zYOtuzoMs+1fVyM9jrNqgkmU0lxW2oeRM2sJwqb4kN8iasD+XTcfAXXYn8pg==
X-Gm-Gg: ATEYQzxANoU9KV+kOEgfvtoMFa8zvk7Gbyjy8AbqMX7VP8V7weFFZvrCXm/EohICB9z
	wFo2dziuwnz1BYLalGgLuVHnD85Ad4Km7iMRfBDj3qyXLGB5l5HzPL3NJ5teOPnvw+yg/YniDtX
	14ITVFsG2sXEfz4z2Qs7Z7uLdE+NmVcCY80zYWHWz62TX91R5MIqcXGJMfWtqlPLioBqlESIT3D
	BAlS2Q57wbn3qfxwuDbrbp9eDJmtSr7NA5LeY2fgiv1sGeCZrGlxRLQvNoy6KgG3HkPwhfoF7za
	KY/E95HXXZTTRSnuRbN8VNnOxss9gzNd9Et2qjWANBBl2RooriA5sslD8YeQi5Lgj9rQ/r2374H
	TMtSzl3hzdYu8iICR7CB2ZYlWFEcRVLebG89+rEQhlOFt3LxRncC32DUbNxavEA==
X-Received: by 2002:a17:90b:574f:b0:359:fe72:3559 with SMTP id 98e67ed59e1d1-35a21fdd3b7mr3916129a91.21.1773429565363;
        Fri, 13 Mar 2026 12:19:25 -0700 (PDT)
X-Received: by 2002:a17:90b:574f:b0:359:fe72:3559 with SMTP id 98e67ed59e1d1-35a21fdd3b7mr3916116a91.21.1773429564998;
        Fri, 13 Mar 2026 12:19:24 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02ffe078sm9596873a91.13.2026.03.13.12.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:19:24 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:19:20 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: test xfs_healer's event handling
Message-ID: <20260313191920.nuec3vcexb44yt3c@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403867.1186408.18154501598966372334.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403867.1186408.18154501598966372334.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:51:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that xfs_healer can handle every type of event that the kernel
> can throw at it by initiating a full scrub of a test filesystem.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1882     |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1882.out |    2 ++
>  2 files changed, 46 insertions(+)
>  create mode 100755 tests/xfs/1882
>  create mode 100644 tests/xfs/1882.out
> 
> 
> diff --git a/tests/xfs/1882 b/tests/xfs/1882
> new file mode 100755
> index 00000000000000..2fb4589418401e
> --- /dev/null
> +++ b/tests/xfs/1882
> @@ -0,0 +1,44 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1882
> +#
> +# Make sure that xfs_healer correctly handles all the reports that it gets
> +# from the kernel.  We simulate this by using the --everything mode so we get
> +# all the events, not just the sickness reports.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing
> +
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/systemd
> +. ./common/populate
> +
> +_require_scrub
> +_require_xfs_io_command "scrub"		# online check support
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +_require_scratch
> +
> +# Does this fs support health monitoring?
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +_require_xfs_healer $SCRATCH_MNT
> +_scratch_unmount
> +
> +# Create a sample fs with all the goodies
> +_scratch_populate_cached nofill &>> $seqres.full
> +_scratch_mount
> +
> +_scratch_invoke_xfs_healer "$tmp.healer" --everything
> +
> +# Run scrub to make some noise
> +_scratch_scrub -b -n >> $seqres.full
> +
> +_scratch_kill_xfs_healer
> +cat $tmp.healer >> $seqres.full
> +
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/1882.out b/tests/xfs/1882.out
> new file mode 100644
> index 00000000000000..9b31ccb735cabd
> --- /dev/null
> +++ b/tests/xfs/1882.out
> @@ -0,0 +1,2 @@
> +QA output created by 1882
> +Silence is golden
> 

