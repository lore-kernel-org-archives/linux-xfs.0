Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45E195F22
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 10:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974222; cv=none; b=Dk7aNqlLWUERLq0Ztej75cGeFbT6KRvNkXA5iD3rZFZH3X1Kx2ZDq1wOQg5jbXkeXfpfy5CvPFdNXVoaNKYmyymZ9y4R3OY+f38VBFGI6BkdKFVGqrZGvNqWJTNRxHno5UbHzyUv0g5jiLUMKHar+C4Y2GiET8dtgz616kYZVEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974222; c=relaxed/simple;
	bh=E2v8HUJmMnQ3KoryqbVKwv86XxW3c6YN4H9DWh5+KdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzSny61YHSzYGXatC/SBU60okCppjtdKgszuOBopb0oaQ6wunhDeVPEDlDU0DibwRXQiyOM6AE6KeMTbYZdTBqADrC9fH6n7Q96nRWpUNHymBMi94mJufOsNu3xXpnqJBVbenMY/SbCzxmJRvhqXj8LwBVMpWIK0Mg2ALxDt9bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cwbKPqa/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cwbKPqa/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730974219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DcV+qywenHHV4LbOZpbC6C/hOfYr5Tnqe6Cbi5gbgmE=;
	b=cwbKPqa/f1YCHt++snzxkyFXQv5Fo4WF8rkQ3M+Xe8R+htEmNLHDq8bz6iv8UxwG1M5hYY
	rReRpDA27+dyXu54G8Lk4BmdoE0qPbez5nsjpfDjenuAsUjTUwOQpyIRao7sDpoyFKV8ny
	cRYIdjZ1Pzg1LIFefvptS8X1mCZF2mE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-PIB_JwNGNL2yDozvxPllYQ-1; Thu, 07 Nov 2024 05:10:17 -0500
X-MC-Unique: PIB_JwNGNL2yDozvxPllYQ-1
X-Mimecast-MFC-AGG-ID: PIB_JwNGNL2yDozvxPllYQ
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-71e49ae1172so712751b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2024 02:10:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730974216; x=1731579016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcV+qywenHHV4LbOZpbC6C/hOfYr5Tnqe6Cbi5gbgmE=;
        b=udDVcQH7WytWqKlaeC0pBxtOoFmgKPVBe9hi3yhwz7neFGgV96Pxoh6eMe/iW135Ry
         4PuiGgKcMcVn6qrPxPweErlwGK2Lt1HucmPKWyBlOetaNro6K4MlrflgisSe7vGOqGZt
         zqAWZk/DWzsSX+9sl3zV/7bi2DP4KztLgY/X/mXh2kfQ/TFOqfAQQjj4WaaPE4jnzwUD
         fN1liXzfYpmJxOPzI0htUKWQ8YXDQLrgaF/AlOOIdPGxkYo7qLyh1Y0Aop/MMXmO3Pu9
         CHRtH7kEj1woV7a2/zAio5iYgkGY0bZnaOgeqt7epqaq2V0RUwDtuEJi1fLkAEgo4W5+
         NL5g==
X-Forwarded-Encrypted: i=1; AJvYcCW8IkkaRrEUe4fKTvtb+eS2lplHonZySvlBSjLps6c36Wh6hmIAkKBDm1YEoCZkcoRa8LxPetnGWO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpYxu2mYQq6M79PE4MzFgHCQmNR7fj4G+NoJq+k0VZmyfSWzsf
	y+5t8VDgMCDcbKXo6sL6w9iI7t1/UidmiKStLwZkn7sFCB+FmZM7QSc7qUDOSGTu8aO5Hjk0R6n
	BfzbNVRc/5gnW0KwRtysHUUXzHqp7HsaoEEI0+4JdW2larS+pcRfLsIkbG1/ZRstweMwK
X-Received: by 2002:a05:6a00:cc4:b0:71e:79a8:1d84 with SMTP id d2e1a72fcca58-72062eccf33mr57756126b3a.3.1730974216356;
        Thu, 07 Nov 2024 02:10:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4SW01H6wVjw5NR4JDr23twdKCB1U+6WTICOyNV25vQZ1KqBgeaj6Frs67xQKFLKH8RmAHlA==
X-Received: by 2002:a05:6a00:cc4:b0:71e:79a8:1d84 with SMTP id d2e1a72fcca58-72062eccf33mr57756095b3a.3.1730974215917;
        Thu, 07 Nov 2024 02:10:15 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72407a571besm1098488b3a.194.2024.11.07.02.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 02:10:15 -0800 (PST)
Date: Thu, 7 Nov 2024 18:10:11 +0800
From: Zorro Lang <zlang@redhat.com>
To: Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <20241107101011.2j5tel7zucn3rbbf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
 <Zyh8yP-FJUHKt2fK@infradead.org>
 <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241104233426.GW21840@frogsfrogsfrogs>
 <ZynB+0hF1Bo6p0Df@dread.disaster.area>
 <Zyozgri3aa5DoAEN@infradead.org>
 <20241105154712.GJ2386201@frogsfrogsfrogs>
 <ZyxS0k6UWaHpooAo@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyxS0k6UWaHpooAo@dread.disaster.area>

On Thu, Nov 07, 2024 at 04:40:34PM +1100, Dave Chinner wrote:
> On Tue, Nov 05, 2024 at 07:47:12AM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 05, 2024 at 07:02:26AM -0800, Christoph Hellwig wrote:
> > > On Tue, Nov 05, 2024 at 05:58:03PM +1100, Dave Chinner wrote:
> > > > When the two conflict, _scratch_mkfs drops the global MKFS_OPTIONS
> > > > and uses only the local parameters so the filesystem is set up with
> > > > the configuration the test expects.
> > > > 
> > > > In this case, MKFS_OPTIONS="-m rmapbt=1" which conflicts with the
> > > > local RTDEV/USE_EXTERNAL test setup. Because the test icurrently
> > > > overloads the global MKFS_OPTIONS with local test options, the local
> > > > test parameters are dropped along with the global paramters when
> > > > there is a conflict. Hence the mkfs_scratch call fails to set the
> > > > filesystem up the way the test expects.
> > > 
> > > But the rmapbt can be default on, in which case it does not get
> > > removed.  And then without the _sized we'll run into the problem that
> > > Hans' patches fixed once again.
> > 
> > Well we /could/ make _scratch_mkfs_sized pass options through to the
> > underlying _scratch_mkfs.
> 
> That seems like the right thing to do to me.

OK, thanks for all of these suggestions, how about below (draft) change[1].
If it's good to all of you, I'll send another patch.

Thanks,
Zorro

diff --git a/common/rc b/common/rc
index 2af26f23f..673f056fb 100644
--- a/common/rc
+++ b/common/rc
@@ -1027,7 +1027,9 @@ _small_fs_size_mb()
 _try_scratch_mkfs_sized()
 {
        local fssize=$1
-       local blocksize=$2
+       shift
+       local blocksize=$1
+       shift
        local def_blksz
        local blocksize_opt
        local rt_ops
@@ -1091,10 +1093,10 @@ _try_scratch_mkfs_sized()
                # don't override MKFS_OPTIONS that set a block size.
                echo $MKFS_OPTIONS |grep -E -q "b\s*size="
                if [ $? -eq 0 ]; then
-                       _try_scratch_mkfs_xfs -d size=$fssize $rt_ops
+                       _try_scratch_mkfs_xfs -d size=$fssize $rt_ops $@
                else
                        _try_scratch_mkfs_xfs -d size=$fssize $rt_ops \
-                               -b size=$blocksize
+                               -b size=$blocksize $@
                fi
                ;;
        ext2|ext3|ext4)
@@ -1105,7 +1107,7 @@ _try_scratch_mkfs_sized()
                                _notrun "Could not make scratch logdev"
                        MKFS_OPTIONS="$MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"
                fi
-               ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+               ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
                ;;
        gfs2)
                # mkfs.gfs2 doesn't automatically shrink journal files on small
@@ -1120,13 +1122,13 @@ _try_scratch_mkfs_sized()
                        (( journal_size >= min_journal_size )) || journal_size=$min_journal_size
                        MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
                fi
-               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
+               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $@ $SCRATCH_DEV $blocks
                ;;
        ocfs2)
-               yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+               yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
                ;;
        udf)
-               $MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+               $MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
                ;;
        btrfs)
                local mixed_opt=
@@ -1134,33 +1136,33 @@ _try_scratch_mkfs_sized()
                # the device is not zoned. Ref: btrfs-progs: btrfs_min_dev_size()
                (( fssize < $((256 * 1024 * 1024)) )) &&
                        ! _scratch_btrfs_is_zoned && mixed_opt='--mixed'
-               $MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
+               $MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $@ $SCRATCH_DEV
                ;;
        jfs)
-               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
+               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $@ $SCRATCH_DEV $blocks
                ;;
        reiserfs)
-               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+               ${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $@ $SCRATCH_DEV $blocks
                ;;
        reiser4)
                # mkfs.resier4 requires size in KB as input for creating filesystem
-               $MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $SCRATCH_DEV \
+               $MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $@ $SCRATCH_DEV \
                                   `expr $fssize / 1024`
                ;;
        f2fs)
                # mkfs.f2fs requires # of sectors as an input for the size
                local sector_size=`blockdev --getss $SCRATCH_DEV`
-               $MKFS_F2FS_PROG $MKFS_OPTIONS $SCRATCH_DEV `expr $fssize / $sector_size`
+               $MKFS_F2FS_PROG $MKFS_OPTIONS $@ $SCRATCH_DEV `expr $fssize / $sector_size`
                ;;
        tmpfs)
                local free_mem=`_free_memory_bytes`
                if [ "$free_mem" -lt "$fssize" ] ; then
                   _notrun "Not enough memory ($free_mem) for tmpfs with $fssize bytes"
                fi
-               export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
+               export MOUNT_OPTIONS="-o size=$fssize $@ $TMPFS_MOUNT_OPTIONS"
                ;;
        bcachefs)
-               $MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $SCRATCH_DEV
+               $MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $@ $SCRATCH_DEV
                ;;
        *)
                _notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
@@ -1170,7 +1172,7 @@ _try_scratch_mkfs_sized()
 
 _scratch_mkfs_sized()
 {
-       _try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
+       _try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($@)"
 }
 
 # Emulate an N-data-disk stripe w/ various stripe units
diff --git a/tests/xfs/157 b/tests/xfs/157
index 9b5badbae..f8f102d78 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -66,8 +66,7 @@ scenario() {
 }
 
 check_label() {
-       MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
-               >> $seqres.full
+       _scratch_mkfs_sized "$fs_size" "" "-L oldlabel" >> $seqres.full 2>&1
        _scratch_xfs_db -c label
        _scratch_xfs_admin -L newlabel "$@" >> $seqres.full
        _scratch_xfs_db -c label




> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

