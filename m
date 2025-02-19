Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91BB186294;
	Wed, 19 Feb 2025 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926189; cv=none; b=kJG9zrsE2+vDLvciJpitfdB2vNlb4d84rtBm3DiVFzHU9rz6veQuAXLjzGXW02Q80jWC7/XlRUmuvLGk81Fbffg4z9TEehSKk9XOdzoubO25yVdT7gHVsU63ShpNvQ1hDQB7Zg0dHdaQJy8gzV/GVyTWloPhHfj0YmyB0MThry4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926189; c=relaxed/simple;
	bh=vY1gfLO5bZF2Cl00vzdm0c5onlHSrw/mq5Hnh/8rccw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b1PiEwClmg74OMQRkq0vbF2HsIqvfSFHl8dTGZCwKn6MvEs5OwCAQKQ8ne8MHRKyx1NSlMvYlSu3WnmY1E4igP4zgO/ClSDh1ZD4JEnRN5ZsX59HMlI7+WPs5AyyFwbdD2H7bkz5EvEvCURQJMW+uQfaVb3piVogtwFv35yt2yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4DMfgPa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4DMfgPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5754C4CEE2;
	Wed, 19 Feb 2025 00:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926188;
	bh=vY1gfLO5bZF2Cl00vzdm0c5onlHSrw/mq5Hnh/8rccw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y4DMfgPacZNp3HX5/3lO0rlCYpjvN9icZGHcqwbHECeCkZh/+BG+FrHBZGjWwY16a
	 j8T9loImTzp8FHyqW/wCPiaJfXtg5wPtpY0JUlsyhyfJG2LM3bolYXOtfIWNrm1Hsa
	 j0vQMLThx2HQlqov3bmH9/DGf1DYuQzKXHuEEppi/M9LxXmoq0ATo5mcNDa4a1xFVE
	 yIL/P9nqkZFD8n0TGnxRco5f/QuItYUKc08bOWhPH7g+vCOfpwdZMYAIOJtND9szSk
	 gpv6WxPA49frM5dY5M0MLHZc16K4t/ZGp1+EEel8ciYaodvX998XiDjyfKh6l2aLMF
	 8OdhkQcHzlUqw==
Date: Tue, 18 Feb 2025 16:49:48 -0800
Subject: [PATCH 1/3] logwrites: warn if we don't think read after discard
 returns zeroes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992586985.4078081.2930161551208349551.stgit@frogsfrogsfrogs>
In-Reply-To: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
References: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The logwrites replay program expects that it can issue a DISCARD against
the block device passed to _log_writes_init and that will cause all
subsequent reads to return zeroes.  This is required for correct log
recovery on filesystems such as XFS that skip recovering buffers if
newer ones are found on disk.

Unfortunately, there's no way to discover if a device's discard
implementation actually guarantees zeroes.  There used to be a sysfs
knob keyed to an allowlist, but it is now hardwired to return 0.  So
either we need a magic device that does discard-and-zero, or we need to
do the zeroing ourselves.  The logwrites program does its own zeroing if
there is no discard support, and some tests do their own zeroing.

The only devices we know to work reliably are the software defined ones
that are provided by the kernel itself -- which means dm-thinp.  Warn if
we have a device that supports discard that isn't thinp and the test
fails.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/dmlogwrites |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)


diff --git a/common/dmlogwrites b/common/dmlogwrites
index a27e1966a933a6..96101d53c38b4a 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -59,6 +59,35 @@ _require_log_writes_dax_mountopt()
 	fi
 }
 
+_log_writes_check_bdev()
+{
+	local sysfs="/sys/block/$(_short_dev $1)"
+
+	# Some filesystems (e.g. XFS) optimize log recovery by assuming that
+	# they can elide replay of metadata blocks if the block has a higher
+	# log serial number than the transaction being recovered.  This is a
+	# problem if the filesystem log contents can go back in time, which is
+	# what the logwrites replay program does.
+	#
+	# The logwrites replay program begins by erasing the block device's
+	# contents.  This can be done very quickly with DISCARD provided the
+	# device guarantees that all reads after a DISCARD return zeroes, or
+	# very slowly by writing zeroes to the device.  Fast is preferable, but
+	# there's no longer any way to detect that DISCARD actually unmaps
+	# zeroes, so warn the user about this requirement if the test happens
+	# to fail.
+
+	# No discard support means the logwrites will do its own zeroing
+	test "$(cat "$sysfs/queue/discard_max_bytes")" -eq 0 && return
+
+	# dm-thinp guarantees that reads after discards return zeroes
+	dmsetup status "$blkdev" 2>/dev/null | grep -q '^0.* thin ' && return
+
+	echo "HINT: $blkdev doesn't guarantee that reads after DISCARD will return zeroes" >> $seqres.hints
+	echo "      This is required for correct journal replay on some filesystems (e.g. xfs)" >> $seqres.hints
+	echo >> $seqres.hints
+}
+
 # Set up a dm-log-writes device
 #
 # blkdev: the specified target device
@@ -84,6 +113,8 @@ _log_writes_init()
 	LOGWRITES_NAME=logwrites-test
 	LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
 	LOGWRITES_TABLE="0 $BLK_DEV_SIZE log-writes $blkdev $LOGWRITES_DEV"
+
+	_log_writes_check_bdev "$blkdev"
 	_dmsetup_create $LOGWRITES_NAME --table "$LOGWRITES_TABLE" || \
 		_fail "failed to create log-writes device"
 }

