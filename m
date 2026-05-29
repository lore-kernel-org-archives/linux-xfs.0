Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4791A367B93;
	Fri, 29 May 2026 04:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780029409; cv=none; b=s7BMpBfM9qeAvhEq4MRnV58cHjloIKCzvKxrk5DrN9RF0G6C4WtNmPdXET6FD1vyUdrba6ZOFfv8OtkcU1jIegBHxNSX7A0eVyeX+3nIY38WzhYmlu5EbPTeUudCaxyVber2B8cE62EN1teYbpDYFNsc0nXHw6DtQc0N7yhce7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780029409; c=relaxed/simple;
	bh=ug4LQDEAtHEwkj6zgHaowpzlmnHb/SohmU45awpYy3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDQ2uHRTjargay31CgcwebBFGOeAaGoNo+I3peY+0gTEV+tGXIjg8UiJhdzCDXNTyp1U8LzNwcn2G+l5MOWTSX3dqc9TpXZzNoKLeZQoIDK/9jhtXaUfqsY+K01qTRJBqNaMLj0/IS+CiG3OnoXJGYcQLsBEUw+QCy7tpfoFZO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bP3VdQvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bP3VdQvX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 639141F00893;
	Fri, 29 May 2026 04:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780029407;
	bh=1uMh8kfIvxutRrHMPIbf15YuJx36+dkpPQHw/A5q6+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bP3VdQvXftHQsR7jhfCHYT7Z8vFofwrhnZ09wdEG2sKIPUHSQ2mDE7tpOsGnCC1F9
	 OR+bc5ki2aDqz5iuOXacUut65qSj+T6SQu6SM6VQjZQhCs+NfAdWnulUx3dDjrcg+O
	 wMpwmA8UtR03qqzQsA5ugdg5iZ6OJvutKNfZDm3UfDsPlI2iZRRXh541NBjztELS7G
	 zHikKv/ItfnyBlxY/Vzj1qmeEXi5y6CtYHR+0u1/ambXkm4iYeY7q4B+11fOXp3QLX
	 8hSTXNHtV5RDszTuQpBRdNWB6/x7VwGRWeTcdi2Atx13/qzMbceyIEWYGjD2UxuJWY
	 bRJJSqqLKvd1g==
Date: Thu, 28 May 2026 21:36:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v6 05/11] fstests: verify fanotify isolation on cloned
 filesystems
Message-ID: <20260529043647.GF6070@frogsfrogsfrogs>
References: <cover.1779939330.git.asj@kernel.org>
 <ef076b330a047d2f19ed48f5b7166f419433bb73.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef076b330a047d2f19ed48f5b7166f419433bb73.1779939330.git.asj@kernel.org>

On Thu, May 28, 2026 at 12:05:36PM +0800, Anand Jain wrote:
> Verify that fanotify events are correctly routed to the appropriate
> watcher when cloned filesystems are mounted.
> Helps verify kernel's event notification distinguishes between devices
> sharing the same FSID/UUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/801     | 135 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/801.out |   7 +++
>  2 files changed, 142 insertions(+)
>  create mode 100644 tests/generic/801
>  create mode 100644 tests/generic/801.out
> 
> diff --git a/tests/generic/801 b/tests/generic/801
> new file mode 100644
> index 000000000000..3bfb87d41922
> --- /dev/null
> +++ b/tests/generic/801
> @@ -0,0 +1,135 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 801
> +# Verify fanotify FID functionality on cloned filesystems by setting up
> +# watchers and making sure notifications are in the correct logs files.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick mount clone
> +
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_loop
> +_require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
> +_require_unique_f_fsid
> +
> +_cleanup()
> +{
> +	cd /
> +	[[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; }
> +	[[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; }
> +
> +	if [ "$semanage_added" = "yes" ]; then
> +		semanage permissive -d unconfined_t >/dev/null 2>&1 || true
> +	fi
> +
> +	umount $mnt1 $mnt2 2>/dev/null
> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
> +	rm -r -f $tmp.*
> +}
> +
> +# Run fsnotifywait in unbuffered mode to watch filesystem-wide create events
> +monitor_fanotify()
> +{
> +	local mmnt=$1
> +	exec stdbuf -oL $FSNOTIFYWAIT_PROG -m -F -S -e create "$mmnt" 2>&1

I guess you need stdbuf to force fsnotifywait to run in linebuffered
mode even if you pipe/redirect it somewhere?

> +}
> +
> +# Transform f_fsid into the hi.lo format used in fanotify FID logs
> +fsid_to_fid_parts()
> +{
> +	local fsid=$1
> +	# Pad to 16 hex chars (64-bit), then split into two 32-bit halves
> +	local padded=$(printf '%016x' "0x${fsid}")
> +	local hi=$(printf '%x' "0x${padded:0:8}")   # strips leading zeros
> +	local lo=$(printf '%x' "0x${padded:8:8}")   # strips leading zeros
> +	echo "${hi}.${lo}"
> +}
> +
> +# Create base loop device and its clone
> +devs=()
> +_loop_image_create_clone devs
> +mkdir -p $TEST_DIR/$seq
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Mount both base and clone filesystems using required clone mount options
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +# Fetch filesystem IDs to verify the kernel can differentiate between them
> +fsid1=$(stat -f -c "%i" $mnt1)
> +fsid2=$(stat -f -c "%i" $mnt2)
> +
> +log1=$tmp.fanotify1
> +log2=$tmp.fanotify2
> +
> +pid1=""
> +pid2=""
> +echo "Setup FID fanotify watchers on both mnt1 and mnt2"
> +
> +# Permit unconfined_t domains when SELinux is enforcing to prevent fanotify
> +# blockages
> +semanage_added="no"
> +if [ "$(getenforce 2>/dev/null)" = "Enforcing" ]; then
> +    if ! semanage permissive -l | grep -q "unconfined_t"; then
> +        semanage permissive -a unconfined_t >/dev/null 2>&1 && semanage_added="yes"
> +    fi
> +fi

Is there a cleaner way to manage setting up and automatically undoing
this step?

There might not be, since iirc the suggestion to register cleanup
functions in a cleanups=() array and call them all in reverse order
didn't go anywhere.

> +
> +# Start asynchronous fanotify monitors
> +( monitor_fanotify "$mnt1" > "$log1" ) &
> +pid1=$!
> +( monitor_fanotify "$mnt2" > "$log2" ) &
> +pid2=$!
> +sleep 2
> +
> +echo "Trigger file creation on mnt1"
> +touch $mnt1/file_on_mnt1
> +sync
> +sleep 1
> +
> +echo "Trigger file creation on mnt2"
> +touch $mnt2/file_on_mnt2
> +sync
> +sleep 1
> +
> +echo "Verify fsid in the fanotify"
> +kill $pid1 $pid2
> +wait $pid1 $pid2 2>/dev/null
> +pid1=""
> +pid2=""
> +
> +e_fsid1=$(fsid_to_fid_parts "$fsid1")
> +e_fsid2=$(fsid_to_fid_parts "$fsid2")
> +
> +# Dump debug details to the full log
> +echo $fsid1 $e_fsid1 $fsid2 $e_fsid2 >> $seqres.full
> +cat $log1 >> $seqres.full
> +cat $log2 >> $seqres.full
> +
> +# Ensure monitor 1 only captured events belonging to mnt 1 and fsid 1
> +if grep -qF "$e_fsid1" "$log1" && ! grep -qF "$e_fsid2" "$log1"; then
> +	echo "SUCCESS: mnt1 events found"
> +else
> +	[ ! -s "$log1" ] && echo "  - mnt1 received no events."
> +	grep -qF "$e_fsid2" "$log1" && echo "  - mnt1 received event from mnt2."
> +fi
> +
> +# Ensure monitor 2 only captured events belonging to mnt 2 and fsid 2
> +if grep -qF "$e_fsid2" "$log2" && ! grep -qF "$e_fsid1" "$log2"; then
> +	echo "SUCCESS: mnt2 events found"
> +else
> +	[ ! -s "$log2" ] && echo "  - mnt2 received no events."
> +	grep -qF "$e_fsid1" "$log2" && echo "  - mnt2 received event from mnt1."
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/generic/801.out b/tests/generic/801.out
> new file mode 100644
> index 000000000000..d7b318d9f27c
> --- /dev/null
> +++ b/tests/generic/801.out
> @@ -0,0 +1,7 @@
> +QA output created by 801
> +Setup FID fanotify watchers on both mnt1 and mnt2
> +Trigger file creation on mnt1
> +Trigger file creation on mnt2
> +Verify fsid in the fanotify
> +SUCCESS: mnt1 events found
> +SUCCESS: mnt2 events found
> -- 
> 2.43.0
> 
> 
