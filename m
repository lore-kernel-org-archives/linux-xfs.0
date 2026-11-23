Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467664;
	b=bYJnXm/YNyGvPEW7r6jB/XtBgLi+leyr5CK9nk9rH6E1awM+Rzbu/T/2VQwNNwI9Q08V
	 8plqVmmc/y86dsAvmxR1MDQmWGQ2AylK/Ehkjio0OKFLJ+91eXbQsbJmIYtm9NMeNHm0i
	 1aYaJqUtvlSZZHlJiUfjbImwEaHIeXRg1cNUDdngc4TOlcgkH/LkjVrGFlwtEQWKfjcO3
	 ra9qYmUS8qCEyKQSGSq5/P48D06NbHHiy10m2KzxHjko2KLiBzEToMcR0vYrfZRCf+D8s
	 Y9C5A/xq+2PmEKMWtpRKzqRNT69i/W+aGwC7mtUrq4ht8QhQ6eqmNKEUbPwKiu9aHQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467664;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=J9Opdh6yJ1qIz1G0SDFryCdOUkdl0P/HGHSXDd7vrNc=;
	b=hFiPIkL7TNj2eZmLHK6GWmM8HxPa4wZ8uNkaUwqEBUG5MKaMu9hoLO8XJqVmHGl+gZ7U
	 bPGZdtBrncuwnBavvLQ4nAk6o9w1kee7zGlpBPD7TsjgnfDemNmnJPVM3TYUa8YgFaTAO
	 VvXE5lCJv80O2f7qXxllHH4uFzlJy+W5vLC0331Yml2Yo6x/9S5/r14iiS/ToCHwAF3iY
	 wCXTGo2Y4h25O4bopuCxJLnvvtOHZZf6ascapBdZuUrd8TxiPflRvoP/S7C0P/pXmDksI
	 N/WRHgpyNQUdutUf2k2aXq7E2TCA3sLvropxwJD5ursOQ2T3SibqlNcyKtiIxHXYnBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VWspVJZ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06264606A321
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 21:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VWspVJZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAA11F000CA;
	Mon, 23 Nov 2026 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795467663;
	bh=J9Opdh6yJ1qIz1G0SDFryCdOUkdl0P/HGHSXDd7vrNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VWspVJZ7k99IPWLioYiY+cHFnGX+PV5IhNlf+p0kOr4nOn0/QlXl78fZG1NzWfTmz
	 tMgRaXuS3mCWpBUGZb1YZxD+EYY1/kn9ysuXJUTf4MtVYH51R6/3nMiJiXxMgd9Ldz
	 r63eucKeHSADBgCTz4b1nK8F2MhTcboyXMFoHggC9mvOTX6zGpk1nj2wnJtzgDvb0l
	 ik5+4TjxjlBpxRQ1mLD8P4uAv5KOM4qdQurLmPp+wCHiLo7uCEu/oZ76CWG2IX6lVh
	 Qw9P7k51LzhIC7LgekxzJRIXppqkZESa1NW0sVm9ol5gFC+rFTmQ6d92zD4hYwb6US
	 lbyFLbnemdIVQ==
Date: Tue, 24 Nov 2026 08:00:55 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 07/59] xfs: update the rt geometry when recovering a
 superblock change
Message-ID: <awSphzZ8c-aeqVxh@dread>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-8-dgc@kernel.org>
 <awB3BHsu97cNiCki@infradead.org>
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
In-Reply-To: <awB3BHsu97cNiCki@infradead.org>

On Fri, Nov 20, 2026 at 08:36:20AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 17, 2026 at 10:14:24AM +1100, Dave Chinner wrote:
> > Recovering a growfs can change the realtime geometry. Adding the first
> > realtime volume can change the realtime extent size. It also brings the rt
> > rmap and rt refcount btrees into use. Changing the data device size changes
> > the height those btrees can reach. Superblock recovery does not update the
> > realtime geometry, the mount features or the realtime btree maximum heights.
> > 
> > The rest of recovery then runs with the old geometry. New rtgroups are set up
> > with the wrong layout. Valid realtime btree blocks can fail verification and
> > abort recovery. A realtime device needs to be defined to recover realtime
> > metadata. Abort superblock recovery if it adds a realtime volume but no device
> > exists.
> 
> Do you have a testcase for this?  I'd hate to add all this code without
> actually being exercise as that introduces the chance of even more
> issues due to untested code.

Yes, I do. Three test cases in this script, two of them fail to
mount after the growfs-shutdown with corruption warnings during
recovery, the other succeeds when it should fail because the
root btree block is completely empty and we don't check for that
at all.

$ cat test-rt-growfs-recovery.sh
#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# Recovery of a growfs that adds the FIRST realtime volume to an rtgroups
# filesystem.
#
# xfs_mountfs() computes m_rtrmap_maxlevels / m_rtrefc_maxlevels (and the
# XFS_FEAT_REALTIME feature bit) from the superblock BEFORE log recovery. On a
# filesystem with no realtime section these are all zero. Log recovery replays
# the growfs superblock change (sb_rblocks/sb_rgcount become non-zero) but does
# not recompute them, and xfs_rtmount_inodes() then loads the new rtgroup
# inodes with the stale zero values.
#
# Predictions:
#   reflink=1          mount FAILS: xfs_iformat_rtrefcount() rejects every
#                      level when m_rtrefc_maxlevels == 0 (level >= 0).
#   reflink=0          mount SUCCEEDS: xfs_iformat_rtrmap() uses level > 0,
#                      so an empty level 0 rtrmap root passes.
#   reflink=0 + frag   mount FAILS: enough rt allocations before the crash
#                      push the rtrmap root above level 0, which is rejected.
#
# Must run as root. Uses loop devices over sparse files.

set -u

WORKDIR=${WORKDIR:-/tmp/rtgrow}
MNT=${MNT:-/mnt/rtgrow}
SIZE=${SIZE:-4g}
FRAG_EXTENTS=${FRAG_EXTENTS:-2000}

DATA=""
RT=""

die() { echo "FATAL: $*" >&2; cleanup; exit 1; }

cleanup()
{
	mountpoint -q "$MNT" && umount "$MNT" 2>/dev/null
	[ -n "$DATA" ] && losetup -d "$DATA" 2>/dev/null
	[ -n "$RT" ] && losetup -d "$RT" 2>/dev/null
	DATA=""
	RT=""
}
trap cleanup EXIT

kmsg() { echo "rtgrow-test: $*" > /dev/kmsg; }

# Print the kernel log lines emitted since the marker for this case.
dmesg_since()
{
	dmesg | sed -n "/rtgrow-test: BEGIN $1\$/,\$p"
}

[ "$(id -u)" -eq 0 ] || die "must run as root"
for c in mkfs.xfs xfs_growfs xfs_io xfs_db losetup; do
	command -v $c >/dev/null || die "$c not found"
done
mkdir -p "$WORKDIR" "$MNT" || die "cannot create $WORKDIR or $MNT"

# Write every other block of a realtime file so each allocation is a separate
# extent and a separate rtrmap record, growing the rtrmap btree.
fragment_rt()
{
	local f="$MNT/rtfile"
	local i

	touch "$f" || return 1
	# The realtime flag can only be set on an empty file.
	xfs_io -c "chattr +r" "$f" || return 1
	for ((i = 0; i < FRAG_EXTENTS; i++)); do
		echo "pwrite -q $((i * 8192)) 4096"
	done | xfs_io "$f" >/dev/null || return 1
	xfs_io -c fsync "$f" || return 1
	echo "  rt file extents: $(xfs_io -c 'fiemap' "$f" | grep -vc hole)"
}

run_case()
{
	local name=$1 reflink=$2 frag=$3
	local data_img="$WORKDIR/$name-data.img"
	local rt_img="$WORKDIR/$name-rt.img"

	echo
	echo "=== case $name: reflink=$reflink frag=$frag"
	kmsg "BEGIN $name"

	rm -f "$data_img" "$rt_img"
	truncate -s "$SIZE" "$data_img" "$rt_img" || die "truncate"

	# No -r option: the filesystem has rtgroups but no realtime section.
	mkfs.xfs -q -f -m metadir=1,rmapbt=1,reflink=$reflink "$data_img" ||
		die "mkfs"

	DATA=$(losetup -f --show "$data_img") || die "losetup data"
	RT=$(losetup -f --show "$rt_img") || die "losetup rt"

	mount -o rtdev="$RT" "$DATA" "$MNT" || die "initial mount"
	echo "  before growfs: $(xfs_info "$MNT" | grep -E '^realtime')"

	xfs_growfs -r "$MNT" >/dev/null || die "growfs -r"
	echo "  after growfs:  $(xfs_info "$MNT" | grep -E '^realtime')"

	if [ "$frag" = 1 ]; then
		fragment_rt || die "fragmenting rt file"
	fi

	# Force the log to disk but write no metadata back, so the next mount
	# has to recover the growfs.
	xfs_io -x -c "shutdown -f" "$MNT" || die "shutdown"
	umount "$MNT" || die "umount after shutdown"

	kmsg "RECOVERY MOUNT $name"
	if mount -o rtdev="$RT" "$DATA" "$MNT"; then
		echo "  RESULT: recovery mount SUCCEEDED"
		echo "  after recovery: $(xfs_info "$MNT" | grep -E '^realtime')"
		umount "$MNT"
	else
		echo "  RESULT: recovery mount FAILED"
	fi

	echo "  --- kernel log for case $name ---"
	dmesg_since "$name" | sed 's/^/  /'

	echo "  --- rtgroup 0 btree inodes (xfs_db) ---"
	for f in rmap refcount; do
		xfs_db -r -R "$RT" -c "path -m /rtgroups/0.$f" -c "print core.format" \
			"$DATA" 2>&1 | sed "s/^/  0.$f: /"
	done

	cleanup
}

run_case reflink1 1 0
run_case reflink0 0 0
run_case reflink0-frag 0 1

-- 
Dave Chinner
dgc@kernel.org
