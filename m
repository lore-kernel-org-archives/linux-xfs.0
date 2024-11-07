Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E141F428C;
	Thu,  7 Nov 2024 23:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731023602; cv=none; b=gs8lrvkZ+OxDrGb8bveqg8UBBWlcwYFBTsKNFzpQKN1xgKfVr1z6lAJOm3Y5iWhbJx0uAkxN8QXdo8He3H+x5h+7m9m+0BbetEXxdKAQRYCDW3qZYxMVTMT1ypiCwsrAw9eNEZsBZNn00nkIbm3x8nAurD/bhadlh3VlqP9r/Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731023602; c=relaxed/simple;
	bh=StxDeC/NoH8lAbCgnTAMyINFRSL9HwNJf6yflRxAYXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBjZ6Oxmn2TiUa1tpK8nS/a35UVa0Yzfss6mDkizoiMU/hOkeja+z5LIjToE9viUoOn5eLYLJEwbg4dcm/W0ncGOre3/9Df6bpPRlWNx/cML0vnJmaPJmUTBaB4ci26MsaxBobnA2eTHiBabcsF1BaFGaLgs69TvV5zdsaqVrVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKumCDrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKumCDrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45D9C4CECE;
	Thu,  7 Nov 2024 23:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731023601;
	bh=StxDeC/NoH8lAbCgnTAMyINFRSL9HwNJf6yflRxAYXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AKumCDrVlTRnwLSyhaT81QXOo+/EvPcVwbfQpFRsg1rvqzOmT1SYUZ2iMrV26ggSe
	 XLpYTK1DNjAgjVcPYv89GGftxgjkJ1czQP1B6zguhG4Xe4FIhZT/D3iejEtl6p83IO
	 J4Q7LYTkqw6yTmU6X8jCE5UvkgRkMBcXQdOZZq+W+/hB5VPrYo6/bwQeob7k8Ys/Hw
	 CpPReXXyfzzmrLFJm4fgl5cHPDfIByTbNI9OsoiZEt4E+Fze/dbJER9h1UZFMv6sS1
	 +lpAya7P/2veUhrIQwnsJSc3F7CKsHeSKb9pquwsyBrxvLU5JRvTJCdsRm1BAH7RMr
	 2Ly8oWQ8CVpEA==
Date: Thu, 7 Nov 2024 15:53:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <20241107235321.GX2386201@frogsfrogsfrogs>
References: <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
 <Zyh8yP-FJUHKt2fK@infradead.org>
 <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241104233426.GW21840@frogsfrogsfrogs>
 <ZynB+0hF1Bo6p0Df@dread.disaster.area>
 <Zyozgri3aa5DoAEN@infradead.org>
 <20241105154712.GJ2386201@frogsfrogsfrogs>
 <ZyxS0k6UWaHpooAo@dread.disaster.area>
 <20241107101011.2j5tel7zucn3rbbf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107101011.2j5tel7zucn3rbbf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Nov 07, 2024 at 06:10:11PM +0800, Zorro Lang wrote:
> On Thu, Nov 07, 2024 at 04:40:34PM +1100, Dave Chinner wrote:
> > On Tue, Nov 05, 2024 at 07:47:12AM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 05, 2024 at 07:02:26AM -0800, Christoph Hellwig wrote:
> > > > On Tue, Nov 05, 2024 at 05:58:03PM +1100, Dave Chinner wrote:
> > > > > When the two conflict, _scratch_mkfs drops the global MKFS_OPTIONS
> > > > > and uses only the local parameters so the filesystem is set up with
> > > > > the configuration the test expects.
> > > > > 
> > > > > In this case, MKFS_OPTIONS="-m rmapbt=1" which conflicts with the
> > > > > local RTDEV/USE_EXTERNAL test setup. Because the test icurrently
> > > > > overloads the global MKFS_OPTIONS with local test options, the local
> > > > > test parameters are dropped along with the global paramters when
> > > > > there is a conflict. Hence the mkfs_scratch call fails to set the
> > > > > filesystem up the way the test expects.
> > > > 
> > > > But the rmapbt can be default on, in which case it does not get
> > > > removed.  And then without the _sized we'll run into the problem that
> > > > Hans' patches fixed once again.
> > > 
> > > Well we /could/ make _scratch_mkfs_sized pass options through to the
> > > underlying _scratch_mkfs.
> > 
> > That seems like the right thing to do to me.
> 
> OK, thanks for all of these suggestions, how about below (draft) change[1].
> If it's good to all of you, I'll send another patch.
> 
> Thanks,
> Zorro
> 
> diff --git a/common/rc b/common/rc
> index 2af26f23f..673f056fb 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1027,7 +1027,9 @@ _small_fs_size_mb()
>  _try_scratch_mkfs_sized()
>  {
>         local fssize=$1
> -       local blocksize=$2
> +       shift
> +       local blocksize=$1
> +       shift
>         local def_blksz
>         local blocksize_opt
>         local rt_ops
> @@ -1091,10 +1093,10 @@ _try_scratch_mkfs_sized()
>                 # don't override MKFS_OPTIONS that set a block size.
>                 echo $MKFS_OPTIONS |grep -E -q "b\s*size="
>                 if [ $? -eq 0 ]; then
> -                       _try_scratch_mkfs_xfs -d size=$fssize $rt_ops
> +                       _try_scratch_mkfs_xfs -d size=$fssize $rt_ops $@
>                 else
>                         _try_scratch_mkfs_xfs -d size=$fssize $rt_ops \
> -                               -b size=$blocksize
> +                               -b size=$blocksize $@
>                 fi
>                 ;;
>         ext2|ext3|ext4)
> @@ -1105,7 +1107,7 @@ _try_scratch_mkfs_sized()
>                                 _notrun "Could not make scratch logdev"
>                         MKFS_OPTIONS="$MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"
>                 fi
> -               ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> +               ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
>                 ;;
>         gfs2)
>                 # mkfs.gfs2 doesn't automatically shrink journal files on small
> @@ -1120,13 +1122,13 @@ _try_scratch_mkfs_sized()
>                         (( journal_size >= min_journal_size )) || journal_size=$min_journal_size
>                         MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
>                 fi
> -               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
> +               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $@ $SCRATCH_DEV $blocks
>                 ;;
>         ocfs2)
> -               yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> +               yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
>                 ;;
>         udf)
> -               $MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> +               $MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
>                 ;;
>         btrfs)
>                 local mixed_opt=
> @@ -1134,33 +1136,33 @@ _try_scratch_mkfs_sized()
>                 # the device is not zoned. Ref: btrfs-progs: btrfs_min_dev_size()
>                 (( fssize < $((256 * 1024 * 1024)) )) &&
>                         ! _scratch_btrfs_is_zoned && mixed_opt='--mixed'
> -               $MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
> +               $MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $@ $SCRATCH_DEV
>                 ;;
>         jfs)
> -               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
> +               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $@ $SCRATCH_DEV $blocks
>                 ;;
>         reiserfs)
> -               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> +               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
>                 ;;
>         reiser4)
>                 # mkfs.resier4 requires size in KB as input for creating filesystem
> -               $MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $SCRATCH_DEV \
> +               $MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $@ $SCRATCH_DEV \
>                                    `expr $fssize / 1024`
>                 ;;
>         f2fs)
>                 # mkfs.f2fs requires # of sectors as an input for the size
>                 local sector_size=`blockdev --getss $SCRATCH_DEV`
> -               $MKFS_F2FS_PROG $MKFS_OPTIONS $SCRATCH_DEV `expr $fssize / $sector_size`
> +               $MKFS_F2FS_PROG $MKFS_OPTIONS $@ $SCRATCH_DEV `expr $fssize / $sector_size`
>                 ;;
>         tmpfs)
>                 local free_mem=`_free_memory_bytes`
>                 if [ "$free_mem" -lt "$fssize" ] ; then
>                    _notrun "Not enough memory ($free_mem) for tmpfs with $fssize bytes"
>                 fi
> -               export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
> +               export MOUNT_OPTIONS="-o size=$fssize $@ $TMPFS_MOUNT_OPTIONS"
>                 ;;
>         bcachefs)
> -               $MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $SCRATCH_DEV
> +               $MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $@ $SCRATCH_DEV
>                 ;;
>         *)
>                 _notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
> @@ -1170,7 +1172,7 @@ _try_scratch_mkfs_sized()
>  
>  _scratch_mkfs_sized()
>  {
> -       _try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
> +       _try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($@)"
>  }
>  
>  # Emulate an N-data-disk stripe w/ various stripe units
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 9b5badbae..f8f102d78 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -66,8 +66,7 @@ scenario() {
>  }
>  
>  check_label() {
> -       MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> -               >> $seqres.full
> +       _scratch_mkfs_sized "$fs_size" "" "-L oldlabel" >> $seqres.full 2>&1
>         _scratch_xfs_db -c label
>         _scratch_xfs_admin -L newlabel "$@" >> $seqres.full
>         _scratch_xfs_db -c label

Looks good to me, though you probably still need to fix the double -L
case:

From: Darrick J. Wong <djwong@kernel.org>
Subject: [PATCH] xfs/157: fix test failures when MKFS_OPTIONS has -L options

Zorro reports that this test now fails if the test runner set an -L
(label) option in MKFS_OPTIONS.  Fix the test to work around this with a
bunch of horrid sed filtering magic.

Cc: <fstests@vger.kernel.org> # v2024.10.14
Fixes: 2f7e1b8a6f09b6 ("xfs/157,xfs/547,xfs/548: switch to using _scratch_mkfs_sized")
---
 tests/xfs/157 |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/157 b/tests/xfs/157
index 9b5badbaeb3c76..30f8cc870b9af2 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -65,10 +65,35 @@ scenario() {
 	SCRATCH_RTDEV=$orig_rtdev
 }
 
+extract_mkfs_label() {
+	set -- $MKFS_OPTIONS
+	local in_l
+
+	for arg in "$@"; do
+		if [ "$in_l" = "1" ]; then
+			echo "$arg"
+			return 0
+		elif [ "$arg" = "-L" ]; then
+			in_l=1
+		fi
+	done
+	return 1
+}
+
 check_label() {
-	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
-		>> $seqres.full
-	_scratch_xfs_db -c label
+	local existing_label
+	local filter
+
+	# Handle -L somelabel being set in MKFS_OPTIONS
+	if existing_label="$(extract_mkfs_label)"; then
+		filter=(sed -e "s|$existing_label|oldlabel|g")
+		_scratch_mkfs_sized $fs_size >> $seqres.full
+	else
+		filter=(cat)
+		MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" \
+			_scratch_mkfs_sized $fs_size >> $seqres.full
+	fi
+	_scratch_xfs_db -c label | "${filter[@]}"
 	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
 	_scratch_xfs_db -c label
 	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
