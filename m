Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C306E388379;
	Thu, 24 Sep 2026 06:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229767; cv=none; b=Ngw2iYcF7rUKiB1ifk0RzD/7q9SFfg55sCNh5J07T/SijGuefNAGe0CaK0nqfuAWD6yssbbjjzzw7MYpQoiWerDCyRHP1q6zE+u8+qgCYCb96sD4HpYjMHlUB2YJVo4VJP3yYgd5t1fUOy4trGx7758AKs48hl8MFgQjf8w7hd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229767; c=relaxed/simple;
	bh=i0rMfCvvnjp9D2hemkkNNK18LNWeAHTOmw/gURLeM1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WwpD7RaSkREGzg84p25zrFFu1vaApm+hg6TJHUAXr989Tdn2Zv23yBwbgEXUx0jLXhkQELKiv/4OkGOlMlpBNR6xHbTQVVrM4o+F/s4fVBUSfpY94Y89plRj/TB8bF/y+lf+DOK3VO7gIOnI8RvYyDxjRc28vTOD8ydGd+1eBeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Or7tWDNu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Or7tWDNu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 529B41F000FF;
	Thu, 24 Sep 2026 06:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790229766;
	bh=aJo1S2ivrLLrvbqU1yklrnHS1TL2duhZK6JLq5bz5y8=;
	h=Date:From:To:Cc:Subject;
	b=Or7tWDNu41n6i1jEeav5TFvKnQf+VgU3aB0lFQ/g65TqhsGht1yjgu1TaKG819nVU
	 9PytSWT/Gd0CUPpga1q0pTKA68Km2ezwTMLKRt6/MEOzZ8oMitsBOrz1Q5VlaxoLW5
	 uRFMO5rsJossjXNWwHDDUHh9fY6W/SPfFHEm8CfJg96TP/dws34ThEZ2quNN5k/50E
	 BiRpyYrkSJfOPn2ipnbA5VRJS0V6guM4K4VcCJmYgve7PdAs8oWyS4h/HdZfQUmjVF
	 AOcQpDXXJuCsEUYCTXgX1KZt5V4H0MVd49GZaqofgcCgoT4vI4kSv47wyFEYqit8P7
	 FuaPUEwxUYMJA==
Date: Wed, 23 Sep 2026 23:02:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic/805: skip this test if we can't mount the filesystem
Message-ID: <20260924060245.GE6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

This test doesn't work on filesystems with external devices (e.g. xfs
realtime) because the SCRATCH_DEV gets formatted with regular scratch fs
options but the filesystem is mounted with a bare _mount call, not
_scratch_mount.  Since SCRATCH_DEV is not the dm-linear device created
earlier in the test, we can't really use that either.

In any case, if we can't mount the filesystem immediately after
formatting it, then we're not satisfying a test precondition.  Change
the _fail to _notrun.

While we're at it, fix the cleanup function so that unmount failures
don't pollute the output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/805 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/805 b/tests/generic/805
index ae498f5c669808..403d36d383a973 100755
--- a/tests/generic/805
+++ b/tests/generic/805
@@ -25,7 +25,7 @@ _cleanup()
 {
 	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
 	$DMSETUP_PROG resume $lvdev >> $seqres.full 2>&1
-	_unmount -q $SCRATCH_MNT
+	_unmount -q $SCRATCH_MNT &>> $seqres.full
 	_dmsetup_remove $node
 	cd /
 	rm -f $tmp.*
@@ -47,7 +47,7 @@ table="0 $size_in_sector linear $SCRATCH_DEV 0"
 _dmsetup_create $node --table "$table" || \
 	_fail "failed to create dm device"
 
-_mount $lvdev $SCRATCH_MNT || _fail "failed to mount dm device"
+_mount $lvdev $SCRATCH_MNT || _notrun "failed to mount dm device"
 
 # Freeze the filesystem from userspace first, then nest a block device
 # initiated freeze/thaw cycle inside it via dm suspend/resume.
