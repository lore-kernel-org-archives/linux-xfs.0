Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECA23E4103;
	Tue,  6 Oct 2026 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276995; cv=none; b=eG6nO4JTWXke4f9KUcnd12qyrBhRkmsfrZ8pIrRRvTws2CHcZfs3366JTB0KLbwp23e/m4v7+y/0i532zXaxe5q0wdbDLNea3h/HOauC2Rr9vtcg9dmKQQ/d4I9dWxo0Co4ABYMHa/P2vbZp8SIpiPb2uOcsJ9WqnxWJMFrJMJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276995; c=relaxed/simple;
	bh=9YcVcR7qSggzEPGHn0KxitYhfMlGVAmAa1ULNudWemk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMQBbldpxvre61AN/fgEGO8a4eFPoRSdDKj2Ng5Chn40ffYxU36/JMs/2nu3wOcQFSkdFGL6buyf9nsJ4YJN8BEl6wn6oKME6Vg3fMfqpxPer3CZ+yjUGBPdxkPqFcmqmn1BTz6iDyDiK0k5EnJnGg/38nqLQLaLzKqlz1qvjeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GppjjWuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GppjjWuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70C11F000FF;
	Tue,  6 Oct 2026 08:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276994;
	bh=BD6FjAil+klUl/B92wFX4626qlQPjWtPvce521aRaFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GppjjWuCx65jeD0IRgXCGIUHvEC6MoPtu4ymvdD1mqTDYG59a9/gIYodZCLlKi9IX
	 5sKNMKi7SlU7GZQ9P1I8ojiWactOOrmnkh/LaYg+0+TiKsdT7vxhd4rIg+1I46vHKi
	 dCRmnDnNMNT6mcc2qYQ0Yj3rD7dCfxsOcH1kdCzhc0MFNmrOedSY8PcNUJb1FDvb7Y
	 /XLMrEBNNkPC6ewlxZ5IIg3RcyWF72Fy3bZeVRUpYajfz2o6ttk+5vdTlyp5X314nw
	 diyLP7NyEbGmUcRz+bvgldKPzJ1k3cXaRsMlsOxCnpIFNgl368CwQGOUr2ptqljD9N
	 T4/f8RP2veYgQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 10/21] fstests: add helpers to verify the expected f_fsid
Date: Tue,  6 Oct 2026 16:55:36 +0800
Message-ID: <d33f55ca2c1b13426dd27c1c9921b2a60c3afbf2.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two helpers to common/rc:

_require_uuid_based_fsid() skips the test unless the filesystem derives
statfs f_fsid from the UUID alone (currently btrfs and ext4).

_scratch_expected_fsid() prints the f_fsid expected for a filesystem
created with the fixed test UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/common/rc b/common/rc
index 37df780f64ef..a11235ec03b8 100644
--- a/common/rc
+++ b/common/rc
@@ -6065,6 +6065,37 @@ hexdump()
 	_fail "Use _hexdump(), please!"
 }
 
+# Require a filesystem whose statfs f_fsid is derived from the filesystem
+# UUID only, so that it is stable across devices and mounts.
+_require_uuid_based_fsid()
+{
+	case $FSTYP in
+	btrfs|ext4)
+		;;
+	*)
+		_notrun "Require a filesystem that derives f_fsid from the UUID only"
+		;;
+	esac
+}
+
+# Print the statfs f_fsid expected for a filesystem created with the test
+# UUID 12345678-1234-1234-1234-123456789abc.
+# Must be guarded by _require_uuid_based_fsid.
+_scratch_expected_fsid()
+{
+	case $FSTYP in
+	ext4)
+		echo "4c44000088884c44"
+		;;
+	btrfs)
+		echo "444c444c888d"
+		;;
+	*)
+		return 1
+		;;
+	esac
+}
+
 # Try to create a file with inode->i_blocks >= (length / blocksize).
 # There may be some small overhead, e.g. ext2 filesystem allocates a
 # substantial number of blocks to store block mappings. Those are accounted
-- 
2.43.0

