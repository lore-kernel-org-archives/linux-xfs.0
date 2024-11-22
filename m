Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED3222339;
	Fri, 22 Nov 2024 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294275; cv=none; b=XcpliSjY8nRymePrmo9GXj30LvVpqtvzyPwOfIr/m/qcHn1ktZWrygGSb7HxSu3C1ITXc02j01vP5NxOXbe4LMRVi23d6jjW8VsvKb1kTe94vd1OH03/gJV53lgbXNF9th1NUYmDRjSx7V6O2a9zpT/lWujD+s4bvfKmr5SAkKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294275; c=relaxed/simple;
	bh=SrLOsJZykfMgnBXOHMK19RBxhkmcaAb8bJQxpR8wtwI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nNVOe2YmnKLzZhlCKtBZXC0yEMaj6S1gxoBbV8TvDtx7Am1dnl1J2mHYCjQWUXGSVrYsCehtthKgCocHDasAKlPgQc7GqhGQxmOmv0IsfKINKk+CPbGVDOZUmMfzFq30H4mxe48VudF+kbZtQIGdlyiw8gR0TmNRA+khuifwvvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcFVIlQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcFVIlQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73DAC4CECE;
	Fri, 22 Nov 2024 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294274;
	bh=SrLOsJZykfMgnBXOHMK19RBxhkmcaAb8bJQxpR8wtwI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XcFVIlQAgl1uHevfhD1jg6Fuj8TH6Y0dld9uem5DrgyPE9j/XohOHe9/17u5e3RBW
	 EX/b8QldjzilaN6/Bef3Yv91IRGq9X23j49T0sBVNM3sE+/RsRyaGw8dM396PMJgz/
	 4oSiWKp/DzhShgdQdR7JywzbHek6NXcWkwtd+gq53JxcvkrsatM/S2EX+AsRSBtIUf
	 W3BV2R+EJCD/5CDUK6SSQGhk5qd0koaPY3fj1f3XAINVCXHtpdGXb78ddB7TKm3JCj
	 fsSCYlVf8P8IsCT5kRlcYKTfIZ2B3tJq3MqHC+kfsivlio6vIw+Zb/70EK+0NLCACq
	 QFTwFdKk3OmNw==
Date: Fri, 22 Nov 2024 08:51:14 -0800
Subject: [PATCH 03/17] logwrites: warn if we don't think read after discard
 returns zeroes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420060.358248.11054238752146807489.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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
index c1c85de9dd43ac..24a8a25ace277f 100644
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

