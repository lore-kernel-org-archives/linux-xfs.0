Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A6C3ECBCF
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773076884; cv=none; b=VEDh7J4cBmzLP0bm+qCb/3x3j5gZ1tRj87D57uXVDTL6XYuavsTISGzL1iBCoT5vhi9d2k70FSVYX5jLqC/D5ZLfAfi5zF5a04AaVJJNrOWxGU3fSO2QxSbU5A4QFqyg4ZFgvmnDYU4cF32Bq7HNysZEE0LJ+iMqvKf9LhLc9Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773076884; c=relaxed/simple;
	bh=gINU3ll/SVvBIUMOU2bnewKP+K+46wFgDLuQyc8zPpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBvkewrW621GMob+KDaSv1kwQUHfr2xxNpySV81hHhRhsZy7IFD9Edi1lSSB8j4F5YTby+fbZ4EEojDcjV4NdLd6GV9L9OonC/k2CebEmn15OkeSa91pUbCJl9VOijb/ofql7jsg7bZUgBzHp4jTqUfqJzG5yVmF0xAJ+r4QesA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KSNAkoQx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QUIFA9Bx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KSNAkoQx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QUIFA9Bx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773076882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jHOFx7v+1K59pH4DGgR8PGGUszHIyjfXE3Oibz4IWbI=;
	b=KSNAkoQxnnE8JeHvoiTWKQwVP0QGL7rKbHCXZKM5AQSK9ZBHX/g0RfejQ1/hGIitoZ14Hl
	xVLgnjXtw80cq1u1O7y500bBLcVfB11MOBBmXoRDtBQInOm0AH0n4Y9q+Vc6xaZ5OtKPgR
	od7phbRahdFTdp5I+jzBNzLs7aChRsk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-bQmt5dC6PM-OGqLuaMRQtQ-1; Mon, 09 Mar 2026 13:21:20 -0400
X-MC-Unique: bQmt5dC6PM-OGqLuaMRQtQ-1
X-Mimecast-MFC-AGG-ID: bQmt5dC6PM-OGqLuaMRQtQ_1773076880
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35449510446so11137443a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Mar 2026 10:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773076879; x=1773681679; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jHOFx7v+1K59pH4DGgR8PGGUszHIyjfXE3Oibz4IWbI=;
        b=QUIFA9Bx6iVjxZIw2tO8QWY77jKrpLkfK0SQUr3rMYMGCAxoDcqghCnz8ov/5uNhF+
         LflEZ5Xv04AbZ2FrklE35MzGg/5x2lITyG6/KZFlcT+RCY+1XCbM9NtwOYsYmtqLUBrP
         R1Q6QOAApfxiI3amBmGk8C3Ys+7yDhH6dlKgknu9XdX5/D1RCCsi39Aa5UJPyFe3MNLS
         nD1qIqSAzVYG16kHIIP04Jk32ucihZwumfhVjDhDFm7rzux3Lv2RwqcFzi8RhyvD5O0x
         PtO+B0NT1Gj1ViGaLoGSSEee1Qyd54IsKe/YJmbP1wm82ZkyAppFNRzTE9pzNmRraP6e
         zACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773076879; x=1773681679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHOFx7v+1K59pH4DGgR8PGGUszHIyjfXE3Oibz4IWbI=;
        b=foevGcpjLgtmjOyHnT9URy3c2ebF/6peVmeuIJMXSxy8A4l966AR3h3c8rNvjPlWjt
         dQYy7wvo0MKHsmEr+D9H0WEoRoNCL7wDjJ92/6sY32mfgjnVcW91J+209TAa46cbKts3
         6IFMxnNXPpWxlzDSn7hG2mYsMLSYw4Ihaa1QxSRyx3pN1Aq+M8jsoZNx1P9hVUZHwKjs
         IWt/Ak0LvQhEtRDPLe1k2ccjN8p5kt59+hZMaGR0evyWUSsNtJRPABs0ToOwWlsoIIzG
         hB8EQwANhEVM3e4kWOfwUQzVLc/5lEScDhnVXsJ6tnkzH2UWXMuyDr7g+1+osfjk5+vk
         2cNg==
X-Forwarded-Encrypted: i=1; AJvYcCWJu6cMTJFWIQCP9GyUJoR5Fw/i9Lu4n8yvgEPv2xbHe1y0t4FQmhj69iN0igb9LsE+v6J8gGpDQqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIknkQ+fNqjyEOlY3NdjYJqZIqYFXp9XvrbOpOOqDQxGkWQjA6
	gccb1/LNgG6zrKekYj/DD0vy24eiUu1add8Lt2cnlp0rkiUgU5Fj2oKFw3IL82WVizWFGmVVXUQ
	ZCWAKzyyPmChuhN/P4DcApZNdyXjyY6vQFVJkul0D7pgLpwihgS0DhrS3xDaQlzu93E9olw==
X-Gm-Gg: ATEYQzwYZ/zAlex7kZFTM98mb6vvWpk1+NurMHwfr1IV4C7Ed7Z+wsogxzF9voZddmX
	6L9AgJFI7JhXRedOnpOwn6g/9HezUhGTFEclj8Szpz0TW8YiikvvkrfYbOQWFQolQl54AfdnVx3
	4ACOR0BOirKRM7id8yqNtS+WaPxktyK/CXlpH9kasAJjsd/0ZhglN+Kx0E0xYU6SPtF+jSXkRaj
	Kz3SeTqGRYchnLfeydTHq2Vnv/RyjBrTjK8vKqp5UxZHM5Vl9BzHd5dLFcFvu5yPKdpbtZLqHyM
	TKdpmMDKTM9/gHwJYXUIEoL6DXWd0kBZqJvCb6HDqsvnkO78i9mE9RJvOnLlp35axS5NyZN71/x
	MbsiLEW46JDUil7ebL4PgzyX4D7HFAsCTU0u2//7wCPYBqOrhVwbrTloTdIZ7aA==
X-Received: by 2002:a17:90b:4e83:b0:359:8d38:cdf5 with SMTP id 98e67ed59e1d1-359be21a6fbmr10381782a91.2.1773076879380;
        Mon, 09 Mar 2026 10:21:19 -0700 (PDT)
X-Received: by 2002:a17:90b:4e83:b0:359:8d38:cdf5 with SMTP id 98e67ed59e1d1-359be21a6fbmr10381761a91.2.1773076878819;
        Mon, 09 Mar 2026 10:21:18 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359f05ebde1sm210850a91.4.2026.03.09.10.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 10:21:18 -0700 (PDT)
Date: Tue, 10 Mar 2026 01:21:14 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: test health monitoring code
Message-ID: <20260309172114.4pi7d4y4n2pprfzm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
 <177249785787.483507.3326797286262755687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249785787.483507.3326797286262755687.stgit@frogsfrogsfrogs>

On Mon, Mar 02, 2026 at 04:41:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some functionality tests for the new health monitoring code.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  doc/group-names.txt |    1 +
>  tests/xfs/1885      |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1885.out  |    5 +++++
>  3 files changed, 59 insertions(+)
>  create mode 100755 tests/xfs/1885
>  create mode 100644 tests/xfs/1885.out
> 
> 
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index 10b49e50517797..158f84d36d3154 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -117,6 +117,7 @@ samefs			overlayfs when all layers are on the same fs
>  scrub			filesystem metadata scrubbers
>  seed			btrfs seeded filesystems
>  seek			llseek functionality
> +selfhealing		self healing filesystem code
>  selftest		tests with fixed results, used to validate testing setup
>  send			btrfs send/receive
>  shrinkfs		decreasing the size of a filesystem
> diff --git a/tests/xfs/1885 b/tests/xfs/1885
> new file mode 100755
> index 00000000000000..1d75ef19c7c9d9
> --- /dev/null
> +++ b/tests/xfs/1885
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1885
> +#
> +# Make sure that healthmon handles module refcount correctly.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing

I found this test is quick enough, how about add it into "quick" group.

> +
> +. ./common/filter
> +. ./common/module

Which helper is this "module" file being included for?

> +
> +refcount_file="/sys/module/xfs/refcnt"
> +test -e "$refcount_file" || _notrun "cannot find xfs module refcount"

Or did you intend to add this part as a helper into common/module?

> +
> +_require_test
> +_require_xfs_io_command healthmon
> +
> +# Capture mod refcount without the test fs mounted
> +_test_unmount
> +init_refcount="$(cat "$refcount_file")"
> +
> +# Capture mod refcount with the test fs mounted
> +_test_mount
> +nomon_mount_refcount="$(cat "$refcount_file")"
> +
> +# Capture mod refcount with test fs mounted and the healthmon fd open.
> +# Pause the xfs_io process so that it doesn't actually respond to events.
> +$XFS_IO_PROG -c 'healthmon -c -v' $TEST_DIR >> $seqres.full &
> +sleep 0.5
> +kill -STOP %1
> +mon_mount_refcount="$(cat "$refcount_file")"
> +
> +# Capture mod refcount with only the healthmon fd open.
> +_test_unmount
> +mon_nomount_refcount="$(cat "$refcount_file")"
> +
> +# Capture mod refcount after continuing healthmon (which should exit due to the
> +# unmount) and killing it.
> +kill -CONT %1
> +kill %1
> +wait

We typically ensure that background processes are handled within the _cleanup function.

> +nomon_nomount_refcount="$(cat "$refcount_file")"
> +
> +_within_tolerance "mount refcount" "$nomon_mount_refcount" "$((init_refcount + 1))" 0 -v
> +_within_tolerance "mount + healthmon refcount" "$mon_mount_refcount" "$((init_refcount + 2))" 0 -v
> +_within_tolerance "healthmon refcount" "$mon_nomount_refcount" "$((init_refcount + 1))" 0 -v
> +_within_tolerance "end refcount" "$nomon_nomount_refcount" "$init_refcount" 0 -v
> +
> +status=0
> +exit

_exit 0

> diff --git a/tests/xfs/1885.out b/tests/xfs/1885.out
> new file mode 100644
> index 00000000000000..f152cef0525609
> --- /dev/null
> +++ b/tests/xfs/1885.out
> @@ -0,0 +1,5 @@
> +QA output created by 1885
> +mount refcount is in range
> +mount + healthmon refcount is in range
> +healthmon refcount is in range
> +end refcount is in range
> 

