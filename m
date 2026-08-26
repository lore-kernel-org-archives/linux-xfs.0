Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6058744E055;
	Wed, 26 Aug 2026 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757780; cv=none; b=dYQ1vF/Sj4S5J0dBp30CSG9OL/hTT7DsUv08oTlX8TF4PVwxVeu6joLhxmgTTlW4c+QaZ/T43yAv9H4ECQeRjYKTI6A7PPN9eO5vYrdTzgiRg2RPEOvRqHQOgJPpHDSGDA+wxiPgZVzZAnf22xkGEUMK3M4hEeDkZfjAevbdXbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757780; c=relaxed/simple;
	bh=We2MHXWIKmJiWTaFsDDpMHLcOZ4u794N+HBStPvU/rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMQzvPiHKPcUmbtLIlhS3p7I0e0CUNQuFExdUWhHAsip26SKxRZz6RAj7Uaeczs1CooT0Bk37xlq4qQtqF+RL8dU29KkbQ35SmFBs1vkqOxZcs8art8gkSP6WOau8AYjKvYIvb9Awjn1gqlgolgozqZHkLdZkNFrF/wP6rH8Tjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BL8nngVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BL8nngVD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 739E11F000E9;
	Wed, 26 Aug 2026 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757772;
	bh=d3JEDfk2vUsKMHydQ3jrYQcmj17REHhN3YoobNAmKUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BL8nngVDt1sOq6KRu81MjY1Z1D2+m+m90e5nds8k8py/aZZOyF4i0KizGalpnzz8Q
	 ZJe4p1IvwJ6yvt3Yyi9BD8pvdI461VT1Jj9GS/isilG/KwmJIr1h7PMy8JIyyTzO6N
	 ealbkjZtRA4c/Y1yHwKz80XoeHvc3OfCvJvGuqHgYhULLmyh4CpPVJKDGkeuZ8T1ya
	 I9KZjGIugnkovC+F2f45h4d1uf+mEqP+grPz5eLWbdiGleARbG/Hq3p5bvqD1EYH1o
	 MlzPxc55lLhSJQGSQr2/twdRycW0DJXk89X5aPmpkI0J0fMPhuEzB9Pu81tGp7EPM5
	 VxIIInliX5JQA==
Date: Wed, 26 Aug 2026 08:22:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Matt Fleming <matt@readmodwrite.com>, fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, kernel-team@cloudflare.com
Subject: Re: [PATCH] xfs: Test sparse inode allocation near AGFL limits
Message-ID: <20260826152252.GZ6072@frogsfrogsfrogs>
References: <20260730134520.3556786-1-matt@readmodwrite.com>
 <ao75xtB2oPDSr13n@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao75xtB2oPDSr13n@bfoster>

On Wed, Aug 26, 2026 at 10:35:50AM -0400, Brian Foster wrote:
> On Thu, Jul 30, 2026 at 02:45:20PM +0100, Matt Fleming wrote:
> > From: Matt Fleming <mfleming@cloudflare.com>
> > 
> > Add a regression test for a shutdown in the sparse inode allocation
> > path. The test builds an AG with no free inodes, a full inobt leaf, full
> > bnobt/cntbt leaves, and little allocatable space outside the AG
> > reservations.
> > 
> > The final create reaches the sparse inode fallback. Removing that extent
> > from free space can grow the free-space btrees and drain the AGFL. The
> > subsequent inobt insert currently trips a corruption check and shuts
> > down the filesystem:
> > 
> >   Internal error i != 1 at line 3768 of file fs/xfs/libxfs/xfs_btree.c.
> > 
> > Link: https://lore.kernel.org/linux-xfs/20260717130429.1838767-1-matt@readmodwrite.com/
> > Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
> > ---
> 
> First off thanks for the test. Whether you end up getting this included
> or not, it is very useful to have a reproducer for the prospective
> fixes.
> 
> One thing of note.. it doesn't appear able to reproduce with
> CONFIG_XFS_DEBUG enabled. I haven't dug into why, but it doesn't end up
> passing the "one full inobt leaf" stage.
> 
> >  .gitignore            |   1 +
> >  src/Makefile          |   2 +-
> >  src/xfs_inode_alloc.c | 285 +++++++++++++++++++++++++++++++++++
> >  tests/xfs/842         | 341 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/842.out     |   2 +
> >  5 files changed, 630 insertions(+), 1 deletion(-)
> >  create mode 100644 src/xfs_inode_alloc.c
> >  create mode 100755 tests/xfs/842
> >  create mode 100644 tests/xfs/842.out
> > 
> > diff --git a/.gitignore b/.gitignore
> > index dd77ee30..7c92e5eb 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -185,6 +185,7 @@ tags
> >  /src/uuid_ioctl
> >  /src/writemod
> >  /src/writev_on_pagefault
> > +/src/xfs_inode_alloc
> >  /src/xfsctl
> >  /src/xfsfind
> >  /src/aio-dio-regress/aio-dio-append-write-fallocate-race
> > diff --git a/src/Makefile b/src/Makefile
> > index 31ac43b2..9e26ebd1 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
> >  	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
> >  	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
> > -	rw_hint fs-monitor
> > +	rw_hint fs-monitor xfs_inode_alloc
> >  
> >  EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
> >  	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> > diff --git a/src/xfs_inode_alloc.c b/src/xfs_inode_alloc.c
> > new file mode 100644
> > index 00000000..9995a047
> > --- /dev/null
> > +++ b/src/xfs_inode_alloc.c
> ...
> 
> The thing that stands out most with this supporting helper program is
> that it seems to duplicate or reimplement a bunch of functionality. For
> example, the inode creation should be easy enough to do in a bash loop,

Don't use bash loops if you can avoid it, they're very slow as compared
to...

> the punch and consume commands look like they could be reduced to single
> xfs_io falloc or fpunch commands, and trigger is also just another
> simple file creation.
> 
> The fill and fragment commands look potentially more unique, but I still
> wonder if we have mechanisms that can be reused. For fragment, we have
> src/punch-alternating, which looks to me it could achieve the same basic
> results. I.e., rather than alloc and free single blocks across inodes,
> alloc a bunch of blocks to a single file and punch out every other and
> fragment free space that way. We also have _fill_fs() under
> common/populate that looks like it can consume space in general.

...src/pop{dir,attr}.pl, where you only pay the exec overhead once.

--D

> I could be missing some details, but all in all I suspect this whole
> helper program could be simplified away.
> 
> > diff --git a/tests/xfs/842 b/tests/xfs/842
> > new file mode 100755
> > index 00000000..fdab240a
> > --- /dev/null
> > +++ b/tests/xfs/842
> > @@ -0,0 +1,341 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Cloudflare, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 842
> > +#
> > +# Regression test for an inode allocation failure after a sparse inode extent
> > +# grows full free-space btrees and raises the AGFL minimum.  The subsequent
> > +# inobt leaf split must not trip the i != 1 corruption check.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto enospc punch prealloc
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	_scratch_unmount 2>/dev/null
> > +	rm -f "$tmp".*
> > +}
> > +
> > +. ./common/filter
> > +
> > +_require_scratch
> > +_require_scratch_size $((1024 * 1024))
> > +_require_check_dmesg
> > +_require_xfs_db_command agresv
> > +_require_xfs_io_command bmap
> > +_require_xfs_io_command fsync
> > +
> > +# The state builder depends on an internal log and no realtime section.
> > +unset SCRATCH_LOGDEV
> > +unset SCRATCH_RTDEV
> > +
> > +_require_xfs_sparse_inodes
> > +_require_xfs_mkfs_finobt
> > +
> > +REPRO=$here/src/xfs_inode_alloc
> > +TARGET_ALLOCATED=16128 # 252 inode records * 64 inodes
> > +INOBT_MAXLEVELS=2
> > +FRAGMENT_FILES=1002
> > +
> > +[[ -x $REPRO ]] || _notrun "xfs_inode_alloc helper is not built"
> > +
> > +mkfs_opts="-q -K -s size=4096 \
> > +	-m crc=1,finobt=1,rmapbt=1,reflink=1,inobtcount=1,bigtime=1 \
> > +	-i size=512,sparse=1,maxpct=25,nrext64=1 \
> > +	-d size=1g,agcount=2,su=512k,sw=2"
> > +_scratch_mkfs_xfs_supported $mkfs_opts >/dev/null 2>&1 || \
> > +	_notrun "mkfs.xfs does not support the required feature set"
> > +
> > +min_value()
> > +{
> > +	if [ "$1" -lt "$2" ]; then
> > +		printf '%s\n' "$1"
> > +	else
> > +		printf '%s\n' "$2"
> > +	fi
> > +}
> > +
> > +min_freelist()
> > +{
> > +	local bno_level=$1 cnt_level=$2 rmap_level=$3
> > +	local alloc_maxlevels=$4 rmap_maxlevels=$5 has_rmap=$6
> > +	local bno_next cnt_next rmap_next total
> > +
> > +	bno_next=$(min_value $((bno_level + 1)) "$alloc_maxlevels")
> > +	cnt_next=$(min_value $((cnt_level + 1)) "$alloc_maxlevels")
> > +	total=$((bno_next * 2 - 2 + cnt_next * 2 - 2))
> > +	if [ "$has_rmap" -ne 0 ]; then
> > +		rmap_next=$(min_value $((rmap_level + 1)) "$rmap_maxlevels")
> > +		total=$((total + rmap_next * 2 - 2))
> > +	fi
> > +	printf '%s\n' "$total"
> > +}
> > +
> > +space_available()
> > +{
> > +	local freeblks=$1 flcount=$2 reservation=$3 min_free=$4 minleft=$5
> > +	local agflcount
> > +
> > +	agflcount=$(min_value "$flcount" "$min_free")
> > +	printf '%s\n' $((freeblks + agflcount - reservation - min_free - minleft))
> > +}
> > +
> > +agi_field()
> > +{
> > +	local field=$1
> > +	$XFS_DB_PROG -r -c 'agi 0' -c "p $field" "$SCRATCH_DEV" 2>/dev/null |
> > +		awk -v key="$field" '$1 == key { print $3; exit }'
> > +}
> > +
> > +inobt_root_field()
> > +{
> > +	local field=$1
> > +	$XFS_DB_PROG -r -c 'agi 0' -c 'addr root' -c "p $field" \
> > +		"$SCRATCH_DEV" 2>/dev/null |
> > +		awk -v key="$field" '$1 == key { print $3; exit }'
> > +}
> > +
> > +agf_field()
> > +{
> > +	local field=$1
> > +	$XFS_DB_PROG -r -c 'agf 0' -c "p $field" "$SCRATCH_DEV" 2>/dev/null |
> > +		awk -v key="$field" '$1 == key { print $3; exit }'
> > +}
> > +
> > +alloc_root_field()
> > +{
> > +	local root=$1 field=$2
> > +	$XFS_DB_PROG -r -c 'agf 0' -c "addr $root" -c "p $field" \
> > +		"$SCRATCH_DEV" 2>/dev/null |
> > +		awk -v key="$field" '$1 == key { print $3; exit }'
> > +}
> > +
> > +ag0_reservation_state()
> > +{
> > +	$XFS_DB_PROG -r -c agresv "$SCRATCH_DEV" 2>/dev/null |
> > +		awk '$1 == "AG" && $2 == "0:" { print $6, $8, $10; exit }'
> > +}
> 
> Seems like a lot of these helpers could be replaced with calls to
> _scratch_xfs_get_metadata_field()..?
> 
> > +
> > +free_record_covering()
> > +{
> > +	local agbno=$1
> > +	$XFS_DB_PROG -r -c 'agf 0' -c 'addr bnoroot' -c 'type bnobt' \
> > +		-c 'btdump -i' "$SCRATCH_DEV" 2>/dev/null |
> > +		awk -v target="$agbno" '/^[0-9]+:\[/ {
> > +			record = $0
> > +			sub(/^[^[]*\[/, "", record)
> > +			sub(/\].*$/, "", record)
> > +			split(record, value, /,/)
> > +			start = value[1] + 0
> > +			blocks = value[2] + 0
> > +			if (start <= target && target < start + blocks) {
> > +				print 0, start, blocks
> > +				exit
> > +			}
> > +		}'
> > +}
> > +
> > +largest_ag0_free_extent()
> > +{
> > +	$XFS_DB_PROG -r -c 'agf 0' -c 'addr bnoroot' -c 'type bnobt' \
> > +		-c 'btdump -i' "$SCRATCH_DEV" 2>/dev/null |
> > +		awk '/^[0-9]+:\[/ {
> > +			record = $0
> > +			sub(/^[^[]*\[/, "", record)
> > +			sub(/\].*$/, "", record)
> > +			split(record, value, /,/)
> > +			if (value[2] + 0 > max) {
> > +				start = value[1] + 0
> > +				max = value[2] + 0
> > +			}
> > +		} END { if (max) print start, max }'
> > +}
> > +
> > +inspect_unmounted()
> > +{
> > +	sync -f "$SCRATCH_MNT"
> > +	_scratch_unmount
> > +}
> > +
> > +mount_fs()
> > +{
> > +	_scratch_mount -o noatime,inode64,logbufs=8,logbsize=32k,noquota
> > +}
> > +
> 
> Both of the above seem kind of spurious. Could they just be replaced
> with direct calls to the underlying helpers?
> 
> > +release_ag1()
> > +{
> > +	local cutoff bytes
> > +
> > +	cutoff=$($XFS_IO_PROG -r -c 'bmap -v' "$SCRATCH_MNT/filler" |
> > +		awk '$4 == 1 {
> > +			range = $2
> > +			gsub(/[\[\]:]/, "", range)
> > +			split(range, sector, /\.\./)
> > +			printf "%.0f\n", sector[1] / 8
> > +			exit
> > +		}')
> > +	[[ -n $cutoff ]] || return 1
> > +	bytes=$((cutoff * 4096))
> > +	truncate -s "$bytes" "$SCRATCH_MNT/filler"
> > +	$XFS_IO_PROG -c fsync "$SCRATCH_MNT/filler"
> > +}
> > +
> > +align_filler_eof()
> > +{
> > +	local target=$1 cutoff current bytes
> > +
> > +	cutoff=$($XFS_IO_PROG -r -c 'bmap -v' "$SCRATCH_MNT/filler" 2>/dev/null |
> > +		awk -v target="$target" '$4 == 0 {
> > +			file_range = $2
> > +			ag_range = $5
> > +			gsub(/[\[\]:]/, "", file_range)
> > +			gsub(/[()]/, "", ag_range)
> > +			split(file_range, file_sector, /\.\./)
> > +			split(ag_range, ag_sector, /\.\./)
> > +			if (int(ag_sector[2] / 8) + 1 == target) {
> > +				printf "%.0f\n", (file_sector[2] + 1) / 8
> > +				exit
> > +			}
> > +		}')
> > +	[[ -n $cutoff ]] || return 1
> > +	current=$(( $(_get_filesize "$SCRATCH_MNT/filler") / 4096 ))
> > +	if (( cutoff < current )); then
> > +		bytes=$((cutoff * 4096))
> > +		truncate -s "$bytes" "$SCRATCH_MNT/filler"
> > +		$XFS_IO_PROG -c fsync "$SCRATCH_MNT/filler"
> > +	fi
> > +}
> > +
> > +find_trigger_hole_offset()
> > +{
> > +	$XFS_IO_PROG -r -c 'bmap -v' "$SCRATCH_MNT/filler" |
> > +		awk '$4 == 0 {
> > +			file_range = $2
> > +			ag_range = $5
> > +			gsub(/[\[\]:]/, "", file_range)
> > +			gsub(/[()]/, "", ag_range)
> > +			split(file_range, f, /\.\./)
> > +			split(ag_range, a, /\.\./)
> > +			file_start = f[1] / 8
> > +			ag_start = a[1] / 8
> > +			map_blocks = (f[2] - f[1] + 1) / 8
> > +			delta = (2 - (ag_start % 8) + 8) % 8
> > +			if (map_blocks >= delta + 16) {
> > +				printf "%.0f %.0f\n", file_start + delta, ag_start + delta
> > +				exit
> > +			}
> > +		}'
> > +}
> > +
> > +consume_ag0_headroom()
> > +{
> > +	local values free reserved used outside
> > +
> > +	values=$(ag0_reservation_state)
> > +	read -r free reserved used <<<"$values"
> > +	outside=$((free - (reserved - used)))
> > +	(( outside <= 0 )) && return 0
> > +
> > +	mount_fs
> > +	"$REPRO" consume "$SCRATCH_MNT/filler" "$outside" >>"$seqres.full" 2>&1 || true
> > +	inspect_unmounted
> > +}
> > +
> > +_scratch_mkfs_xfs $mkfs_opts >>"$seqres.full" 2>&1
> > +mount_fs
> > +: > "$SCRATCH_MNT/filler"
> > +inspect_unmounted
> > +
> > +count=$(agi_field count)
> > +freecount=$(agi_field freecount)
> > +allocated=$((count - freecount))
> > +need=$((TARGET_ALLOCATED - allocated))
> > +(( need > 0 )) || _fail "invalid initial inode state"
> > +
> 
> This check doesn't seem all that useful.. verify we need to allocate
> inodes on a newly formatted fs..?
> 
> > +mount_fs
> > +"$REPRO" create "$SCRATCH_MNT" "$need" >>"$seqres.full" 2>&1 || \
> > +	_fail "inode population failed"
> > +inspect_unmounted
> > +
> > +count=$(agi_field count)
> > +freecount=$(agi_field freecount)
> > +inobt_level=$(inobt_root_field level)
> > +inobt_recs=$(inobt_root_field numrecs)
> > +if (( count != TARGET_ALLOCATED || freecount != 0 ||
> > +      inobt_level != 0 || inobt_recs != 252 )); then
> > +	_fail "failed to build one full inobt leaf"
> > +fi
> > +
> 
> Something I'm curious about in general is whether this can be made more
> generic beyond creating/expecting a very specific geometry and
> allocation state, but I understand this is quite hard to reproduce and
> may not be possible.
> 
> That aside, I think some brief comments for some of the helpers used
> below would be helpful to review/maintain this sort of test long term.
> I.e., things like release_ag1, consume_ag0_headroom, etc. aren't very
> self explanatory.
> 
> > +mount_fs
> > +"$REPRO" fragment "$SCRATCH_MNT" "$FRAGMENT_FILES" >>"$seqres.full" 2>&1 || \
> > +	_fail "free-space fragmentation failed"
> > +"$REPRO" fill "$SCRATCH_MNT/filler" >>"$seqres.full" 2>&1 || \
> > +	_fail "free-space fill failed"
> > +release_ag1 || _fail "failed to release AG1 filler mappings"
> > +inspect_unmounted
> > +
> > +consume_ag0_headroom
> > +read -r largest_start _ <<<"$(largest_ag0_free_extent)"
> > +mount_fs
> > +align_filler_eof "$largest_start" || _fail "cannot align filler EOF"
> > +inspect_unmounted
> > +consume_ag0_headroom
> > +
> > +mount_fs
> > +read -r file_offset agblock <<<"$(find_trigger_hole_offset)"
> > +[[ -n $file_offset && -n $agblock ]] || _fail "no suitable sparse inode extent"
> > +"$REPRO" punch "$SCRATCH_MNT/filler" "$file_offset" 8 >>"$seqres.full" 2>&1 || \
> > +	_fail "failed to create sparse inode extent"
> > +inspect_unmounted
> > +
> > +read -r free reserved used <<<"$(ag0_reservation_state)"
> > +reservation=$((reserved - used))
> > +outside=$((free - reservation))
> > +bno_level=$(agf_field bnolevel)
> > +cnt_level=$(agf_field cntlevel)
> > +rmap_level=$(agf_field rmaplevel)
> > +flcount=$(agf_field flcount)
> > +bno_recs=$(alloc_root_field bnoroot numrecs)
> > +cnt_recs=$(alloc_root_field cntroot numrecs)
> > +inobt_level=$(inobt_root_field level)
> > +inobt_recs=$(inobt_root_field numrecs)
> > +minfree=$(min_freelist "$bno_level" "$cnt_level" "$rmap_level" 5 5 1)
> > +pagf_free=$((free - flcount))
> > +available=$(space_available "$pagf_free" "$flcount" "$reservation" \
> > +	"$minfree" "$INOBT_MAXLEVELS")
> > +cover=$(free_record_covering "$agblock")
> > +
> > +printf 'gate free=%d reservation=%d outside=%d fl=%d minfree=%d available=%d levels=%d/%d/%d alloc_recs=%d/%d inobt=%d/%d hole=%d record="%s"\n' \
> > +	"$free" "$reservation" "$outside" "$flcount" "$minfree" \
> > +	"$available" "$bno_level" "$cnt_level" "$rmap_level" \
> > +	"$bno_recs" "$cnt_recs" "$inobt_level" "$inobt_recs" \
> > +	"$agblock" "$cover" >>"$seqres.full"
> > +
> > +if (( available < 7 || available >= 15 || bno_level != 1 ||
> > +      cnt_level != 1 || bno_recs != 505 || cnt_recs != 505 ||
> > +      inobt_level != 0 || inobt_recs != 252 || flcount != minfree )) ||
> > +   [[ $cover != "0 $agblock 8" ]]; then
> > +	_fail "combined inode allocation precondition not met"
> > +fi
> 
> This is kind of where I wonder if we've made this so specific and
> targeted that while it works right now, some future change to allocation
> behavior, geometry, etc. could render it ineffective long term. This
> somewhat relates to the question of why this doesn't seem to work for
> XFS_DEBUG.
> 
> Also FWIW it might not be worth having these various setup condition
> failures trigger an actual test failure like this. Perhaps we could
> replace some or most of these with _notrun?
> 
> Getting back to sparse inodes in general, it looks like we only really
> have one other test in xfs/076, and that looks like a basic
> functionality test. It fills up the fs, punches out fragments of free
> space, then confirms we can allocate inodes into the fragmented space.
> Clearly that hasn't been sufficient to reproduce this insert failure
> problem, even though it repeatedly runs into ENOSPC. It would be great
> IMO if we could come up with something generic to better test these
> boundary conditions, even if it wasn't an immediate reproducer. Hmm..
> maybe there's something we could do in kernel (i.e. debug mode or with
> injection knobs) that would help produce more AGFL and/or allocbt
> split/merge activity at < max levels or something. More thought
> required...
> 
> Anyways, I'm not opposed to having a super specific test like this on
> its own. I do think this will probably require a few rounds of
> significant simplification and whatnot though to make it a bit more
> palatable for upstream merge. Thanks.
> 
> Brian
> 
> > +
> > +mount_fs
> > +set +e
> > +"$REPRO" trigger "$SCRATCH_MNT" >>"$seqres.full" 2>&1
> > +trigger_status=$?
> > +set -e
> > +sleep 1
> > +
> > +if _check_dmesg_for 'Internal error i != 1|invalid sparse inode record|Shutting down filesystem'; then
> > +	_fail "sparse inode allocation shut down the filesystem"
> > +fi
> > +(( trigger_status == 0 )) || _fail "inode allocation failed with an unexpected error"
> > +
> > +# Verify that the filesystem remains usable after the allocation attempt.
> > +$XFS_IO_PROG -c stat "$SCRATCH_MNT" >>"$seqres.full" 2>&1 || \
> > +	_fail "filesystem is not usable after inode allocation"
> > +
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> > new file mode 100644
> > index 00000000..643d0528
> > --- /dev/null
> > +++ b/tests/xfs/842.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 842
> > +Silence is golden
> > -- 
> > 2.43.0
> > 
> 
> 
