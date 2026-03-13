Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4429A3CF02F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773430102; cv=none; b=G4ErKi4Z5DR+3jMzASL3o2bRfxTuA9GTTAZ2vCeXOfwopntA+KYJnvsH152VeYoguMIHz26w/+KvTV1H6NtZVZi9WsfIdARP3BzCnGhp49IoRzsktOuISe7SLUSiFXVOtziUWNYrn4aRdr5MlMG9TKSWIu0caJs2XlAcvkKK/6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773430102; c=relaxed/simple;
	bh=eFg5Ud/pXw9BgN+ZKi4E7gdnqHZnxs7PcavZ3SnTYmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqbRSe/wX9ZRHyC7tBbkBUTkqv+ktcBS5RO/qiEEDAXZE7sQRH6u72pXJhXIPX1pQiVX7AeZjJ+eEaKAtpEU3fUIzUBe9YxBnBi8dSp4ifuLjH756w6/zNM1+vWC61WVKwWr9WHS8nch48MGNXeKYtnz+hYdLpq8nRhkqzBDmhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fXUxPtED; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AnN9yml6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXUxPtED";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AnN9yml6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773430098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SU195nWeFaO4HZwLZPKAG3hBwqIIai7MC9ln7TpUlOk=;
	b=fXUxPtEDrdwbx4ShhXclrmd7nCD8jpw1zjRKvv5kKq9JxxEns6CmvGLcrqPqCQGoU6SiSj
	BHzUKYWwCAl2TxJwOnA2M+Hq1PvMUDVRYFATOILFp2UyyGcdSYxkbM2I0Ia528MN0ymDCv
	Lf62CP/Mka/JohNqwOpiKm2AD0f451U=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-5o9RITOANh6YS8_sD0dA0Q-1; Fri, 13 Mar 2026 15:28:16 -0400
X-MC-Unique: 5o9RITOANh6YS8_sD0dA0Q-1
X-Mimecast-MFC-AGG-ID: 5o9RITOANh6YS8_sD0dA0Q_1773430095
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso15396430a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773430095; x=1774034895; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SU195nWeFaO4HZwLZPKAG3hBwqIIai7MC9ln7TpUlOk=;
        b=AnN9yml66O45BaZ56vwGhwfHxcPFJNYWpRKy5uRacPj/Kep8KfpEAFHzogfYRV2Pga
         CJw8oewYQL3SoRIlvKIhwSu3RYOg/wlYcvyQPRHWHSGi5k3S8CiPrBpj7z2Yms9HNSpE
         JJWPoY6zHBzk4cjQXNZKCMqF2M2HroYuddIqw7xGLEiPwvDbD3hQMnzpJb/42//adjHv
         M41wb3jLp1O0JG2NYtATqPMK7I0jwZ1OhNi4CNEaWtFS5L8dm9nd1fXFWJ9UQq4ND83A
         0wt5IjmxbWAFMRcwxg+8NHVFO7HXaT+ntDpi6l0l2QbZPeEx20Fke9OlkFg1ENXVyAt5
         p6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773430095; x=1774034895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SU195nWeFaO4HZwLZPKAG3hBwqIIai7MC9ln7TpUlOk=;
        b=WM9h/yHwZrtchUmAZZPfzKUnXuX75YdeWj3r4TLMhHyCZDJu8z+5ro5riNVK/jxP76
         jjLUC6lYoV2nNq2hk2mv1fPGIqCyU6pWr0dY+TW97mxMXu9LvOrwOXjWohMQ375AGC+i
         x27D76pbvuo/7py+6QzNWVAO/RutWDRqHshsMxBTpGxm6mu4Ykvtv5dgYeZw0w1799IX
         OeJLzx1eJBqcC4gbBgSQbF08TbpOu9x7M7yfsrcK425g5OmAE3YQLHqr3j7t0CpSjRrE
         gYWKnJxIrTl6RrTKI4FgQBBj9dex+Q36vnAAjpQLkzuSoUe9pFybfsS3HSkooJt0nljp
         gDYg==
X-Forwarded-Encrypted: i=1; AJvYcCWaqOjAlk9vi0gCi5YI7HLPDINkZPzbwpaJoHgFPwFOIIFsNTzagTyBqTk0llG2OUt8BUZTzelKfv4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp/c8PCCUSmOBYDd4LE2SmBNosg/P6991Slmu30km1eGQAfEXI
	dLInyxidHe9BZHiK4La+pAYM8YkWRnRMO6BIMu1an9HvLZYOyksKCTOU+6h1wqJmfij0tInQu5i
	QM1Ypeq2wvVbghq5WwcKQz9RvANPQUTDZm6OOTB9UgB+fvj16xe2le0sXW/zPIQ==
X-Gm-Gg: ATEYQzzBy5HyZ10V0hah2ps4p+apUNNWxouJ5SbpQSJ2EpvuSySiuoYdnUZRtoqvA3G
	xVW7QrwU6yIPtI8ffdPkPTsixm4Jc8CQgQOM2+5n9czhPV26T6J+iNu5lgu9mITs6rRSCYbR0bc
	QTqHpeHRCfbykIyIiLZxK3vh8G2HkbLkjrhCqofJQkrcD0PIoPe7CUY08izlOIymtV4n2hPxWB2
	L95bOKXnL567DeH9J8UWpkL1BO0mGFeRl8CgbCkTzp3Iejx1D0AJ0IIph3K1yN04hNjQhZOQv3k
	GqqyEetv4CksiuX43q5RV9oyT+5hWxlO03FLUTUCmWMXxZB/l8nDMVWdg08rttlx6wJnSRCql9b
	DHiDi71s105gec+iEyhk1B5m3EZHKXLOpEZgXSYqU63Lmr7Oum+24nbu+7TVesw==
X-Received: by 2002:a05:6a21:700d:b0:398:71f2:59d8 with SMTP id adf61e73a8af0-398ecda24a4mr4203659637.56.1773430095375;
        Fri, 13 Mar 2026 12:28:15 -0700 (PDT)
X-Received: by 2002:a05:6a21:700d:b0:398:71f2:59d8 with SMTP id adf61e73a8af0-398ecda24a4mr4203646637.56.1773430094920;
        Fri, 13 Mar 2026 12:28:14 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07382e6csm6608292b3a.54.2026.03.13.12.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:28:14 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:28:10 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: test xfs_healer can fix a filesystem
Message-ID: <20260313192810.2mwyyslm65kng3x5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403886.1186408.6888396407274716678.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403886.1186408.6888396407274716678.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:51:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that xfs_healer can actually fix an injected metadata corruption.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1884     |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1884.out |    2 +
>  2 files changed, 91 insertions(+)
>  create mode 100755 tests/xfs/1884
>  create mode 100644 tests/xfs/1884.out
> 
> 
> diff --git a/tests/xfs/1884 b/tests/xfs/1884
> new file mode 100755
> index 00000000000000..1fa6457ad25203
> --- /dev/null
> +++ b/tests/xfs/1884
> @@ -0,0 +1,89 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1884
> +#
> +# Ensure that autonomous self healing fixes the filesystem correctly.
> +#
> +. ./common/preamble
> +_begin_fstest auto selfhealing
> +
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/systemd
> +
> +_require_scrub
> +_require_xfs_io_command "repair"	# online repair support
> +_require_xfs_db_command "blocktrash"
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +_require_command "$XFS_PROPERTY_PROG" "xfs_property"
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +_xfs_has_feature $SCRATCH_MNT rmapbt || \
> +	_notrun "reverse mapping required to test directory auto-repair"
> +_xfs_has_feature $SCRATCH_MNT parent || \
> +	_notrun "parent pointers required to test directory auto-repair"
> +_require_xfs_healer $SCRATCH_MNT --repair
> +
> +# Configure the filesystem for automatic repair of the filesystem.
> +$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=repair >> $seqres.full
> +
> +# Create a largeish directory
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> +echo testdata > $SCRATCH_MNT/a
> +mkdir -p "$SCRATCH_MNT/some/victimdir"
> +for ((i = 0; i < (dblksz / 255); i++)); do
> +	fname="$(printf "%0255d" "$i")"
> +	ln $SCRATCH_MNT/a $SCRATCH_MNT/some/victimdir/$fname
> +done
> +
> +# Did we get at least two dir blocks?
> +dirsize=$(stat -c '%s' $SCRATCH_MNT/some/victimdir)
> +test "$dirsize" -gt "$dblksz" || echo "failed to create two-block directory"
> +
> +# Break the directory, remount filesystem
> +_scratch_unmount
> +_scratch_xfs_db -x \
> +	-c 'path /some/victimdir' \
> +	-c 'bmap' \
> +	-c 'dblock 1' \
> +	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
> +_scratch_mount
> +
> +_scratch_invoke_xfs_healer "$tmp.healer" --repair
> +
> +# Access the broken directory to trigger a repair, then poll the directory
> +# for 5 seconds to see if it gets fixed without us needing to intervene.
> +ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +_filter_scratch < $tmp.err
> +try=0
> +while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> +	echo "try $try saw corruption" >> $seqres.full
> +	sleep 0.1
> +	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +	try=$((try + 1))
> +done
> +echo "try $try no longer saw corruption or gave up" >> $seqres.full
> +_filter_scratch < $tmp.err
> +
> +# List the dirents of /victimdir to see if it stops reporting corruption
> +ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +try=0
> +while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> +	echo "retry $try still saw corruption" >> $seqres.full
> +	sleep 0.1
> +	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> +	try=$((try + 1))
> +done
> +echo "retry $try no longer saw corruption or gave up" >> $seqres.full
> +
> +# Unmount to kill the healer
> +_scratch_kill_xfs_healer
> +cat $tmp.healer >> $seqres.full
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1884.out b/tests/xfs/1884.out
> new file mode 100644
> index 00000000000000..929e33da01f92c
> --- /dev/null
> +++ b/tests/xfs/1884.out
> @@ -0,0 +1,2 @@
> +QA output created by 1884
> +ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning
> 

