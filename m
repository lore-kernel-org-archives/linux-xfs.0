Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F961E008E
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728404850; cv=none; b=e9ohzUXEnLqWQfdVyXSAeycxg6LWczLK0amToEGQNLR1JOCalaFdBcDJe1FgGm6E1zYFsEnPouOg5xpm7qC/1v8A1eMsH0TXSjI9+r49NVCYfyhmUV74s+d9W2zbjQdh9ctdHA67zfPGOiqTK2B5vpG+g535PEvPutl+nPx5rJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728404850; c=relaxed/simple;
	bh=NQcQiiohC+srGxx5UGMfwjaerCnAVCXvA3rwTWFKL/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDR9x8ydeDu6rtlOjJbaj5YXxl/MCjXSQDb1SskJHQFhLopog2Jw3xpETRED46Oqr+ebn8clwoCpcODoqp/QU4oE79KFUzaZhvKYyWkDsvnON+03WxteZ9UdXldYfGGItULkFCxpAXtQ/K4NmiKfhPICmEYccrWI2OHXWOFMM+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Skrtvunp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Skrtvunp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728404847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2f6vw4GUq07c24oJVc+v6LtvRaid+4S8euVvP+QP7E=;
	b=Skrtvunpa5bPzZPsx/Gd/ebXpYndTmTPZDW3w2dmfza58tBpeccPJV7gyfu7mweM9sgbSp
	z/Jc7Pmnocp3sq160k4jVgCe7eZmlun7FOYXmzxHMQT5KiGxkqQ4ijLUVh332mg4MBZPZP
	V2mmhYRRZM9tlRtjkOqybnBBC0bmysY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-mbUwGm-5OwSQLPVLGsz6Wg-1; Tue,
 08 Oct 2024 12:27:24 -0400
X-MC-Unique: mbUwGm-5OwSQLPVLGsz6Wg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93C38195608A;
	Tue,  8 Oct 2024 16:27:22 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65BCA19560AA;
	Tue,  8 Oct 2024 16:27:21 +0000 (UTC)
Date: Tue, 8 Oct 2024 12:28:37 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <ZwVdtXUSwEXRpcuQ@bfoster>
References: <20240910043127.3480554-1-hch@lst.de>
 <ZuBVhszqs-fKmc9X@bfoster>
 <20240910151053.GA22643@lst.de>
 <ZuBwKQBMsuV-dp18@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuBwKQBMsuV-dp18@bfoster>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Sep 10, 2024 at 12:13:29PM -0400, Brian Foster wrote:
> On Tue, Sep 10, 2024 at 05:10:53PM +0200, Christoph Hellwig wrote:
> > On Tue, Sep 10, 2024 at 10:19:50AM -0400, Brian Foster wrote:
> > > No real issue with the test, but I wonder if we could do something more
> > > generic. Various XFS shutdown and log recovery issues went undetected
> > > for a while until we started adding more of the generic stress tests
> > > currently categorized in the recoveryloop group.
> > > 
> > > So for example, I'm wondering if you took something like generic/388 or
> > > 475 and modified it to start with a smallish fs, grew it in 1GB or
> > > whatever increments on each loop iteration, and then ran the same
> > > generic stress/timeout/shutdown/recovery sequence, would that eventually
> > > reproduce the issue you've fixed? I don't think reproducibility would
> > > need to be 100% for the test to be useful, fwiw.
> > > 
> > > Note that I'm assuming we don't have something like that already. I see
> > > growfs and shutdown tests in tests/xfs/group.list, but nothing in both
> > > groups and I haven't looked through the individual tests. Just a
> > > thought.
> > 
> > It turns out reproducing this bug was surprisingly complicated.
> > After a growfs we can now dip into reserves that made the test1
> > file start filling up the existing AGs first for a while, and thus
> > the error injection would hit on that and never even reach a new
> > AG.
> > 
> > So while agree with your sentiment and like the highlevel idea, I
> > suspect it will need a fair amount of work to actually be useful.
> > Right now I'm too busy with various projects to look into it
> > unfortunately.
> > 
> 
> Fair enough, maybe I'll play with it a bit when I have some more time.
> 
> Brian
> 
> 

FWIW, here's a quick hack at such a test. This is essentially a copy of
xfs/104, tweaked to remove some of the output noise and whatnot, and
hacked in some bits from generic/388 to do a shutdown and mount cycle
per iteration.

I'm not sure if this reproduces your original problem, but this blows up
pretty quickly on 6.12.0-rc2. I see a stream of warnings that start like
this (buffer readahead path via log recovery):

[ 2807.764283] XFS (vdb2): xfs_buf_map_verify: daddr 0x3e803 out of range, EOFS 0x3e800
[ 2807.768094] ------------[ cut here ]------------
[ 2807.770629] WARNING: CPU: 0 PID: 28386 at fs/xfs/xfs_buf.c:553 xfs_buf_get_map+0x184e/0x2670 [xfs]

... and then end up with an unrecoverable/unmountable fs. From the title
it sounds like this may be a different issue though.. hm?

Brian

--- 8< ---

diff --git a/tests/xfs/609 b/tests/xfs/609
new file mode 100755
index 00000000..b9c23869
--- /dev/null
+++ b/tests/xfs/609
@@ -0,0 +1,100 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 609
+#
+# XFS online growfs-while-allocating tests (data subvol variant)
+#
+. ./common/preamble
+_begin_fstest growfs ioctl prealloc auto stress
+
+# Import common functions.
+. ./common/filter
+
+_create_scratch()
+{
+	_scratch_mkfs_xfs $@ >> $seqres.full
+
+	if ! _try_scratch_mount 2>/dev/null
+	then
+		echo "failed to mount $SCRATCH_DEV"
+		exit 1
+	fi
+
+	# fix the reserve block pool to a known size so that the enospc
+	# calculations work out correctly.
+	_scratch_resvblks 1024 >  /dev/null 2>&1
+}
+
+_fill_scratch()
+{
+	$XFS_IO_PROG -f -c "resvsp 0 ${1}" $SCRATCH_MNT/resvfile
+}
+
+_stress_scratch()
+{
+	procs=3
+	nops=1000
+	# -w ensures that the only ops are ones which cause write I/O
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
+}
+
+_require_scratch
+_require_xfs_io_command "falloc"
+
+_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+. $tmp.mkfs	# extract blocksize and data size for scratch device
+
+endsize=`expr 550 \* 1048576`	# stop after growing this big
+incsize=`expr  42 \* 1048576`	# grow in chunks of this size
+modsize=`expr   4 \* $incsize`	# pause after this many increments
+
+[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
+
+nags=4
+size=`expr 125 \* 1048576`	# 120 megabytes initially
+sizeb=`expr $size / $dbsize`	# in data blocks
+logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
+_create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
+
+for i in `seq 125 -1 90`; do
+	fillsize=`expr $i \* 1048576`
+	out="$(_fill_scratch $fillsize 2>&1)"
+	echo "$out" | grep -q 'No space left on device' && continue
+	test -n "${out}" && echo "$out"
+	break
+done
+
+#
+# Grow the filesystem while actively stressing it...
+# Kick off more stress threads on each iteration, grow; repeat.
+#
+while [ $size -le $endsize ]; do
+	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
+	_stress_scratch
+	size=`expr $size + $incsize`
+	sizeb=`expr $size / $dbsize`	# in data blocks
+	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
+	xfs_growfs -D ${sizeb} $SCRATCH_MNT >> $seqres.full
+	echo AGCOUNT=$agcount >> $seqres.full
+	echo >> $seqres.full
+
+	sleep $((RANDOM % 3))
+	_scratch_shutdown
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		killall -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+	_scratch_cycle_mount || _fail "cycle mount failed"
+done > /dev/null 2>&1
+wait	# stop for any remaining stress processes
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/609.out b/tests/xfs/609.out
new file mode 100644
index 00000000..1853cc65
--- /dev/null
+++ b/tests/xfs/609.out
@@ -0,0 +1,7 @@
+QA output created by 609
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX

