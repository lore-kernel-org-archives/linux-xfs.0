Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD6712BE85;
	Wed, 31 Jan 2024 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706709966; cv=none; b=jkrLKzXU4JKmzgO9v9ZfAhcKtS5aMh1Pj6LMWGb4BbCXulrKM0ZsmW/RP1MVjABRn65isw5UTE+Go+vuepSQ7jGy85IEKByHCeyCXo3yy+Bg7L937PnFGPZXz6tZ/shsbHQBPdGbdFz5dqfmMqJvP4PSfTPbf/GSiy3S5hTx0hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706709966; c=relaxed/simple;
	bh=u6FwHn7WhnR9ROREZV+ZYdHfTnDQvxkw0SDKrUmRK/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUN7YInOqrpWMw0townBSJKj0xyZhdjHbs6ffBqFmjG1YdfcTsuuUPnkbFKSeyGl2X5shj1TUwqZVIwey1Id42hflsof4y2PkoQmBot5f4QWHMnfLPufKXcFXwkkcvYUl+da1MiRLtW/nsTByugwQW7BYJsdQS4urYrZz+Et8Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=L4gws3am; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="L4gws3am"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4TQ3jC2GqDz9sX2;
	Wed, 31 Jan 2024 15:05:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1706709951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ar5fQCg/cJO2Ous7H7aQfFx25ShS2dugAIyrSkTQg4=;
	b=L4gws3amkZUoKapL/+h9JS/9PjFFxVarv3HNKML8nwaU/e5jB+pxcM8EfWCO+SicaiEy0X
	feKsiLhUw8/IzQwBTNHpKTHrgI/vw7oiWXlcP3Tojv2IZuNiL42LLlG0BJ68ziAHhMkM83
	aDFKvm75pCexpxsy/UceOyex9n/c09/Yt0QTUeOdE2TRtD2RYYdbRgmfSxrECklL5wPWHf
	ySkSJTIyAJIJjQ4zovcLiz5IYFfQ7XTrBhom63DLQZRyuD57Zmjhw8YjtaM3mCQujmWnqF
	g+O5ZA1AuDJt767j1kdFQRdTzA83DgDnCgHQE7/bpn11GYKimTvu4L/d3gHdrg==
Date: Wed, 31 Jan 2024 15:05:48 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, fstests@vger.kernel.org, 
	zlang@redhat.com, Dave Chinner <david@fromorbit.com>, mcgrof@kernel.org, 
	gost.dev@samsung.com, linux-xfs@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
Message-ID: <yhuvl7u466fc6zznulfirtg35m7fteutzhar2dhunrxleterym@3qxydiupxnsx>
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
 <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
 <20240130195602.GJ1371843@frogsfrogsfrogs>
 <6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>
 <20240131034851.GF6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131034851.GF6188@frogsfrogsfrogs>

> > 
> > Thanks for the reply. So we can have a small `if` conditional block for xfs
> > to have fs size = 500M in generic test cases.
> 
> I'd suggest creating a helper where you pass in the fs size you want and
> it rounds that up to the minimum value.  That would then get passed to
> _scratch_mkfs_sized or _scsi_debug_get_dev.
> 
> (testing this as we speak...)

I would be more than happy if you send a patch for
this but I also know you are pretty busy, so let me know if you want me
to send a patch for this issue.

You had something like this in mind?

diff --git a/common/config b/common/config
index c9771ff9..216e8e06 100644
--- a/common/config
+++ b/common/config
@@ -168,6 +168,7 @@ export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
 export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
 export XFS_PARALLEL_REPAIR_PROG="$(type -P xfs_prepair)"
 export XFS_PARALLEL_REPAIR64_PROG="$(type -P xfs_prepair64)"
+export MIN_XFS_FS_SZ_MB=600
 export __XFSDUMP_PROG="$(type -P xfsdump)"
 if [ -n "$__XFSDUMP_PROG" ]; then
 	export XFSDUMP_PROG="$__XFSDUMP_PROG -e"
diff --git a/common/rc b/common/rc
index 524ffa02..8d148105 100644
--- a/common/rc
+++ b/common/rc
@@ -916,6 +916,22 @@ _check_minimal_fs_size()
 	fi
 }
 
+# takes size in MB
+_get_optimal_fs_size()
+{
+	local fssize=$1
+
+	case "$FSTYP" in
+	xfs)
+		[ $MIN_XFS_FS_SZ_MB -gt "$fssize" ] && fssize=$MIN_XFS_FS_SZ_MB
+		;;
+	*)
+		;;
+	esac
+
+	echo "$fssize"
+}
+
 # Create fs of certain size on scratch device
 # _scratch_mkfs_sized <size in bytes> [optional blocksize]
 _scratch_mkfs_sized()
diff --git a/tests/generic/081 b/tests/generic/081
index 22ac94de..650c38be 100755
--- a/tests/generic/081
+++ b/tests/generic/081
@@ -62,13 +62,15 @@ snapname=snap_$seq
 mnt=$TEST_DIR/mnt_$seq
 mkdir -p $mnt
 
-# make sure there's enough disk space for 256M lv, test for 300M here in case
+size=$(_get_optimal_fs_size 300)
 # lvm uses some space for metadata
-_scratch_mkfs_sized $((300 * 1024 * 1024)) >>$seqres.full 2>&1
+lvmsize=$((size - 50))
+# make sure there's enough disk space for 256M lv, test for 300M here in case
+_scratch_mkfs_sized $(($size * 1024 * 1024)) >>$seqres.full 2>&1
 $LVM_PROG vgcreate -f $vgname $SCRATCH_DEV >>$seqres.full 2>&1
 # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
 # (like 2.02.95 in RHEL6) don't support --yes option
-yes | $LVM_PROG lvcreate -L 256M -n $lvname $vgname >>$seqres.full 2>&1
+yes | $LVM_PROG lvcreate -L "$lvmsize"M -n $lvname $vgname >>$seqres.full 2>&1
 # wait for lvcreation to fully complete
 $UDEV_SETTLE_PROG >>$seqres.full 2>&1
 
diff --git a/tests/generic/108 b/tests/generic/108
index efe66ba5..a17ee435 100755
--- a/tests/generic/108
+++ b/tests/generic/108
@@ -45,8 +45,11 @@ vgname=vg_$seq
 physical=`blockdev --getpbsz $SCRATCH_DEV`
 logical=`blockdev --getss $SCRATCH_DEV`
 
+size=$(_get_optimal_fs_size 300)
+# lvm uses some space for metadata
+lvmsize=$((size - 50))
 # _get_scsi_debug_dev returns a scsi debug device with 128M in size by default
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 300`
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
 echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
 
@@ -55,7 +58,7 @@ $LVM_PROG pvcreate -f $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
 $LVM_PROG vgcreate -f $vgname $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
 # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
 # (like 2.02.95 in RHEL6) don't support --yes option
-yes | $LVM_PROG lvcreate -i 2 -I 4m -L 275m -n $lvname $vgname \
+yes | $LVM_PROG lvcreate -i 2 -I 4m -L "$lvmsize"m -n $lvname $vgname \
 	>>$seqres.full 2>&1
 # wait for lv creation to fully complete
 $UDEV_SETTLE_PROG >>$seqres.full 2>&1

