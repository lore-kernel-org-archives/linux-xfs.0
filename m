Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795459298;
	b=cgE335zlW3HNp3cQY/TW0fdQQPnK6wjIJmGuOor5hzIQQ83b7P2PFdT+wXfkD1GXByEM
	 5/251KhZv/p1GjnCGxdGJe3B14eNdZiG0m4cObvEq9pbQXqdX0/ubso3QDyOQM8pzAZCg
	 kTMSB47QwUAWTYHzLcrsEAYLPReUIGiT4s3TKHqBWJt3e+xiGTRbf/R7LGEV9dXvoSwwB
	 D+Z6ayH7zBeJ8bJSUS0KCpkVDhynj1/SDA2LciC2eKPCYjRx9NrmuDl6vNqsSOjhKxgLz
	 xx4mTX/3ff+p8t9CqPvaxVYkUwgCvDt0ibY5pgIkGfVuj4pn49kz9jq8OxaA10gh2Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459298;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4VO8F3U/dtfGXLJ+ZMIuL6gywEtbM2dxyT5Jo0mMaU0=;
	b=YSgNv3byDU4sbIkS5u1GDaIS86301urJK4PKhw1c6gPrJXMjYJew/U/o4Arj1J72lRzP
	 44pLAUHC56EOQy8fRKLPlwqY3Cif2BsOGkLL876mS3+HJ2WzBcwN571hfTdahRGqE4I5V
	 hZHKnvnjwDyUM5NPgaTHC8A/djN1v5q7gH4bzHoDcBzjJm9M6BVKGFXYWmFg8szBLNamv
	 kzik2dQ0m6NGHKg/VkW4wCL+EAvublri1JkQ7mZ1S9EOrTy30K2E8qVuAz5HSEb1oNC7q
	 cAMQmjsyeVLxDuUTMPdznkIJv8z3QJiyjzZj+9uXwU2GIIiEu+PyNYiN9v4ylQfonHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nI26Hc0s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D75F606A31F;
	Mon, 23 Nov 2026 18:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nI26Hc0s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D674E1F01571;
	Mon, 23 Nov 2026 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459297;
	bh=4VO8F3U/dtfGXLJ+ZMIuL6gywEtbM2dxyT5Jo0mMaU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nI26Hc0sD07mmTxYV/WsCk016Q5avrKz1CR4PpGm04LZU+UJB0nmslgxc0OOAJ0Mt
	 cpmouaARJqZ9VhQL0rgqcQ1K4mWzwmINXyIcx7JANZlqbwSkx6OmqNkIeB7Ufp/wkV
	 du1UjJYic7VC0YeufKeRh6DKUSUPWNDkZYdboahXcU5E7YvNLOf8lqOZKUH4UuQPoi
	 U/POI7FM9rXzP1xfPLug5LAX6WwNJ0/gGl1GrwOSSibZnzQ2GEusT2AjX+7tVsU4Oj
	 jOv7/8OSDxKl4g5u6M31vtE1xNZ6IcshUJY4oXY7WF8289wwq5BV9+iw8d4D2NoN69
	 YP4mahw91/UvA==
Date: Tue, 24 Nov 2026 02:41:28 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/21] fstests: verify fanotify isolation on cloned
 filesystems
Message-ID: <awSGKRKg8w5BJwB2@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <4a9b0540afb1af06b37a47b9171a0ca2b840da17.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a9b0540afb1af06b37a47b9171a0ca2b840da17.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:34PM +0800, Anand Jain wrote:
> Verify that fanotify events are correctly routed to the appropriate
> watcher when cloned filesystems are mounted.
> Helps verify kernel's event notification distinguishes between devices
> sharing the same FSID/UUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/901     | 142 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/901.out |   7 +++
>  2 files changed, 149 insertions(+)
>  create mode 100644 tests/generic/901
>  create mode 100644 tests/generic/901.out
> 
> diff --git a/tests/generic/901 b/tests/generic/901
> new file mode 100644
> index 000000000000..55be6c10cf46
> --- /dev/null
> +++ b/tests/generic/901
> @@ -0,0 +1,142 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test No. 901
> +# Verify fanotify FID functionality on cloned filesystems by setting up
> +# watchers and making sure notifications are in the correct logs files.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick mount tempfsid
> +
> +_require_test
> +_require_loop
> +_require_command "$SEMANAGE_PROG" semanage

You already defined SEMANAGE_PROG, but you only use "semanage" below.

> +_require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
> +_require_fanotify_function
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
> +	umount $mnt1 $mnt2 >/dev/null 2>&1
    ^^^^^^
   _unmount

> +	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
> +	rm -r -f $tmp.*
> +}
> +
> +# Run fsnotifywait in unbuffered mode to watch filesystem-wide create events
> +monitor_fanotify()
> +{
> +	local mmnt=$1
> +	exec stdbuf -oL $FSNOTIFYWAIT_PROG -m -F -S -e create "$mmnt" 2>&1
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
> +rm -rf $TEST_DIR/$seq 2>/dev/null
> +mkdir -p $TEST_DIR/$seq
> +# Create base loop device and its clone
> +devs=()
> +_create_cloned_loop_devs devs
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Mount both base and clone filesystems using required clone mount options
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
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

use tabs instead of spaces.

> +fi
> +
> +# Start asynchronous fanotify monitors
> +( monitor_fanotify "$mnt1" > "$log1" ) &
> +pid1=$!
> +( monitor_fanotify "$mnt2" > "$log2" ) &
> +pid2=$!
> +sleep 2
> +
> +if ! kill -0 "$pid1" 2>/dev/null || ! kill -0 "$pid2" 2>/dev/null; then
> +	cat "$log1"
> +	cat "$log2"
> +	_fail "$FSNOTIFYWAIT_PROG setup failed"
> +fi
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
> +_exit 0
> diff --git a/tests/generic/901.out b/tests/generic/901.out
> new file mode 100644
> index 000000000000..414e12d10b27
> --- /dev/null
> +++ b/tests/generic/901.out
> @@ -0,0 +1,7 @@
> +QA output created by 901
> +Setup FID fanotify watchers on both mnt1 and mnt2
> +Trigger file creation on mnt1
> +Trigger file creation on mnt2
> +Verify fsid in the fanotify
> +SUCCESS: mnt1 events found
> +SUCCESS: mnt2 events found
> -- 
> 2.43.0
> 
