Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC5F2773EE
	for <linux-xfs@vger.kernel.org>; Sun,  1 Mar 2026 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772370427; cv=none; b=RS8LfrAFAE4s+s9gWUAnmfaqmJoyT808vHc2zEsKFAyEhVn/mWSDBzOodEVwdvGSbYxCjM/kFXuohftPgN/0nxjUk6a0Aiq7abk+01xDEQDDjd46aoWRMxozHtglE7i3l5/eI6qrbt4sdrguMf0YApPCRzrqNuFZZ4cX81n5VOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772370427; c=relaxed/simple;
	bh=+b7IJmYsdPsiaWkABEc9hXLF8ekSKnQ2J1W6I/m5X0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzZ5CR09ey/yiJxTaMT885mJP27d2XW6+htgklxk7xUQqCb3JBVIU0HCAVUWDxHGKPVm9EifNLErO/WJdAr72v4zPnAEBnbE+6c1YIIbT/M8DJb6tocPoXdGqzRBTraT1fvk5WqQisO1j16T+uCwn5FTGKPNF3ltHFsBgQGETeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xyb+YWJv; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xyb+YWJv"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8f992167dcso376399666b.1
        for <linux-xfs@vger.kernel.org>; Sun, 01 Mar 2026 05:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772370424; x=1772975224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=21RpwEPOwVSx/Gfqd4huN5SHo5O6W1YNzF0HAagBVOE=;
        b=Xyb+YWJvPyIRXvmbSfYtg+omoN8nPN8x4A+5QXO2Vc8ofRNPt4N+wpQB8ZSgPPA0PZ
         nHwaGB1ZYGiDsquXgV/h46XgCBL6c2dRiA4UZnseDfrZ6zpNJACACZ0yn3g/524OcUft
         nfsaXpxhJ7RyllFTEK10S0yI//CIvg7rfzro7qCZB4bfPY2sJLBuwIwTNyFm1n/Xephe
         eoAX1fP2CsPrb21nDNnr+SkGAD04e0aw0i1zqvoEUsrsas38kWAL32jiif7wlnumXCqZ
         wxeTd0U7zz20WiF2gu00BzhJIsMDzSOMT5UdWNey/0DiYWpUhuP17NsFG81ofzeOpIsN
         yiWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772370424; x=1772975224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21RpwEPOwVSx/Gfqd4huN5SHo5O6W1YNzF0HAagBVOE=;
        b=NvWZ4H7WCiT/5h+lRayD/JK5nyNZN9LIXjNqiPavC1tB0rqMibDYYqwjJJIeBHHgbA
         KcsgF4X7VnEw4Fuav68fW9bsJqq3Vo+keaZnpcFoYgjfD2OV85DQGE4jHJKyCMV54NOl
         CgaTaklczOWWF1vHEEcnavRRuZFmyfsSvpK2TohzqY2AUHs3AV6ljXaVAwMxJSVwmOkv
         5PBvyPo+0Qphx+/lkQTB6r1Fep0x+ap+3ZiQA3RKIiS8GkH9B+372YzrER4XgRqlRgh0
         NKNKWejrAkvMxC/M49ukmR8EO9a3555It33CDp0a2pwU7N2rX4Ok8ijZoDdYSc+YKlzv
         U/CQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwWDYpaqV1GLofUj2N3RmvV2ekjcSDyTjKvfGKZhmOFjDDt1PnOe9mwbrKVmgsNi4tciCSBM9gHTU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq4iefRQmh1LPvNvXqVxIEiDWXbzgs9IEw5w5buNsgiEUwm+UD
	rnms55CZuug08d3T+45pyE211gWmqRa86iIXl/b4RCoRmy6Z/qrD1NKM
X-Gm-Gg: ATEYQzyZLY7BSChZ9zDTfW9mhj5NCxf92kKWFmkURC3wjVn8MV53adOZvJuOhZuQbi7
	w4k5u31th98ggYcjDRwKlEdg4jT9vbNS1UDmlmnEFtHkGGnxhRlwcjmnAv5xj16jLp0Sh9fMBiu
	Eh+NrQaw6Gum1JgaYUw8hBK1cdagSKN+JqQWfMn8hri0w2RF3+G7LNyaOs9aI6vClHVgFN0RJS6
	J/K2K4LKDMEZn3f3oW1qxgFCQpHUUXVe8WTVbwQdVHCZ0pK6FRADMYkaKTFEa8Z7lutOQR3rJgR
	l+zrtcvyb83t5ci8bISjpJbuMJ7a55Qtv+2s0R4SG7Z+XF61H3ea4n1KdOi+V3+2czGcmmu3XrU
	0BwwEDBrXjZfNQ3g+KKMEeNjTFsfXvIJ8HRTjZJ5b3uyYSMm6SS3uG0B+JwQJYa1GnGSFPwsMHD
	pthxhSFQkS7xjRMOggrb8v+Y1kvMqhnxuNHkcs/YG14g+6pRapjQXPUt6beQppt7q5nBGpUGC+I
	yrya/qa99aJ551BA3CiLf9GsAbV
X-Received: by 2002:a17:906:4fc6:b0:b8e:d04e:e4fc with SMTP id a640c23a62f3a-b93763b7090mr565823366b.22.1772370424268;
        Sun, 01 Mar 2026 05:07:04 -0800 (PST)
Received: from localhost (2001-1c00-570d-ee00-d118-5ff5-6236-8e43.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:d118:5ff5:6236:8e43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9399ec5460sm145609966b.15.2026.03.01.05.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 05:07:03 -0800 (PST)
Date: Sun, 1 Mar 2026 14:07:02 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/9] fstests: add test for inotify isolation on cloned
 devices
Message-ID: <aaQ59uL3rG7_WYHJ@amir-ThinkPad-T480>
References: <cover.1772095513.git.asj@kernel.org>
 <78014ba3d564004081dca3c1d7e69cec8943f629.1772095513.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78014ba3d564004081dca3c1d7e69cec8943f629.1772095513.git.asj@kernel.org>

On Thu, Feb 26, 2026 at 10:41:45PM +0800, Anand Jain wrote:
> Add a new test, to verify that the kernel correctly differentiates between
> two block devices sharing the same FSID/UUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/config         |  1 +
>  tests/generic/790     | 78 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/790.out |  7 ++++
>  3 files changed, 86 insertions(+)
>  create mode 100644 tests/generic/790
>  create mode 100644 tests/generic/790.out
> 
> diff --git a/common/config b/common/config
> index 1420e35ddfee..c08f828575a2 100644
> --- a/common/config
> +++ b/common/config
> @@ -228,6 +228,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
>  export PARTED_PROG="$(type -P parted)"
>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
> +export INOTIFYWAIT_PROG="$(type -P inotifywait)"
>  
>  # udev wait functions.
>  #
> diff --git a/tests/generic/790 b/tests/generic/790
> new file mode 100644
> index 000000000000..3809fced622d
> --- /dev/null
> +++ b/tests/generic/790
> @@ -0,0 +1,78 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 790
> +#
> +# Verify if the kernel or userspace becomes confused when two block devices
> +# share the same fid/fsid/uuid. Create inotify on both original and cloned
> +# filesystem. Monitor the notification in the respective logs.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick mount clone
> +
> +_require_test
> +_require_scratch_dev_pool 2
> +_require_command "$INOTIFYWAIT_PROG" inotifywait
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	umount $mnt1 $mnt2 2>/dev/null
> +	_scratch_dev_pool_put
> +}
> +
> +_scratch_dev_pool_get 2
> +_scratch_mkfs_sized_clone >$seqres.full 2>&1
> +devs=($SCRATCH_DEV_POOL)
> +mnt2=$TEST_DIR/mnt2
> +mkdir -p $mnt2
> +
> +_scratch_mount $(_clone_mount_option)
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +log1=$tmp.inotify1
> +log2=$tmp.inotify2
> +
> +echo "Setup inotify watchers on both SCRATCH_MNT and mnt2"
> +$INOTIFYWAIT_PROG -m -e create --format '%f' $SCRATCH_MNT > $log1 2>&1 &
> +pid1=$!
> +$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt2 > $log2 2>&1 &
> +pid2=$!
> +sleep 2
> +
> +echo "Trigger file creation on SCRATCH_MNT"
> +touch $SCRATCH_MNT/file_on_scratch_mnt
> +sync
> +sleep 1
> +
> +echo "Trigger file creation on mnt2"
> +touch $mnt2/file_on_mnt2
> +sync
> +sleep 1
> +
> +echo "Verify inotify isolation"
> +kill $pid1 $pid2
> +wait $pid1 $pid2 2>/dev/null

I think you also need to take care of killing the bg process
in _cleanup() so that the test could be cleanly aborted.

Thanks,
Amir.

> +
> +if grep -q "file_on_scratch_mnt" $log1 && ! grep -q "file_on_mnt2" $log1; then
> +	echo "SUCCESS: SCRATCH_MNT events isolated."
> +else
> +	echo "FAIL: SCRATCH_MNT inotify confusion!"
> +	[ ! -s $log1 ] && echo "  - SCRATCH_MNT received no events."
> +	grep -q "file_on_mnt2" $log1 && echo "  - SCRATCH_MNT received event from mnt2."
> +fi
> +
> +if grep -q "file_on_mnt2" $log2 && ! grep -q "file_on_scratch_mnt" $log2; then
> +	echo "SUCCESS: mnt2 events isolated."
> +else
> +	echo "FAIL: mnt2 inotify confusion!"
> +	[ ! -s $log2 ] && echo "  - mnt2 received no events."
> +	grep -q "file_on_scratch_mnt" $log2 && echo "  - mnt2 received event from SCRATCH_MNT."
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/generic/790.out b/tests/generic/790.out
> new file mode 100644
> index 000000000000..3c92c34ffbda
> --- /dev/null
> +++ b/tests/generic/790.out
> @@ -0,0 +1,7 @@
> +QA output created by 790
> +Setup inotify watchers on both SCRATCH_MNT and mnt2
> +Trigger file creation on SCRATCH_MNT
> +Trigger file creation on mnt2
> +Verify inotify isolation
> +SUCCESS: SCRATCH_MNT events isolated.
> +SUCCESS: mnt2 events isolated.
> -- 
> 2.43.0
> 
