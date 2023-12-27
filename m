Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9987FD;
	Mon,  1 Jan 2024 01:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSSyqdKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D2AC433C7;
	Mon,  1 Jan 2024 01:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071118;
	bh=pByeGkhsCivrIbR+n9n+uAAy1d+FpUiap/CXwMYVGYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kSSyqdKDBx+SCL9o3jDRuP6ubc48M9imfQONCdG55S2ac8Uc5Oqn8XsFr+mCwUIub
	 xYVt+Q8oTO4F87bR/1bigCXrmuaHC9VgvyZ73nZl4IooSUQY0YbhzNDOTqvYAgfKyS
	 unEyQVjsiis1wAmUVMP9+d+44FwZ4x6XSDBDc9YXuT/IfL9dkZAyXFIqZKAdBlq+kk
	 jVO1UFtk0t6JdqScfFQKeoQ5PShBfihMa+5015OnS4fLGq57FH+CS5KjwGdGRh8zyM
	 wyTojkkhSK2pLzwmp66XJSc4/PvHwueEqSoZniANrCxlcOpk+awLxysVDNqA/Bi25h
	 Oc2az/EN0mMQQ==
Date: Sun, 31 Dec 2023 17:05:17 +9900
Subject: [PATCH 5/5] generic/303: avoid test failures on weird rt extent sizes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032802.1827706.17351355710375259350.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032733.1827706.12312180709769839153.stgit@frogsfrogsfrogs>
References: <170405032733.1827706.12312180709769839153.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this test to skip the high offset reflink test if (on XFS) the rt
extent size isn't congruent with the chosen target offset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   23 +++++++++++++++++++++++
 tests/generic/303 |    8 +++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index f760eedc26..2d67f7dff1 100644
--- a/common/rc
+++ b/common/rc
@@ -4690,6 +4690,29 @@ _get_file_block_size()
 	esac
 }
 
+_test_congruent_file_oplen()
+{
+	local file="$1"
+	local alloc_unit=$(_get_file_block_size "$file")
+	local oplen="$2"
+
+	case $FSTYP in
+	nfs*|cifs|9p|virtiofs|ceph|glusterfs|overlay|pvfs2)
+		# Network filesystems don't know about (or tell the client
+		# about) the underlying file allocation unit and they generally
+		# pass the file IO request to the underlying filesystem, so we
+		# don't have anything to check here.
+		return
+		;;
+	esac
+
+	if [ $alloc_unit -gt $oplen ]; then
+		return 1
+	fi
+	test $((oplen % alloc_unit)) -eq 0 || return 1
+	return 0
+}
+
 # Given a file path and a byte length of a file operation under test, ensure
 # that the length is an integer multiple of the file's allocation unit size.
 # In other words, skip the test unless (oplen ≡ alloc_unit mod 0).  This is
diff --git a/tests/generic/303 b/tests/generic/303
index 95679569e4..ef88d2357b 100755
--- a/tests/generic/303
+++ b/tests/generic/303
@@ -48,7 +48,13 @@ echo "Reflink past maximum file size in dest file (should fail)"
 _reflink_range $testdir/file1 0 $testdir/file5 4611686018427322368 $len >> $seqres.full
 
 echo "Reflink high offset to low offset"
-_reflink_range $testdir/file1 $bigoff_64k $testdir/file6 1048576 65535 >> $seqres.full
+oplen=1048576
+if _test_congruent_file_oplen $testdir $oplen; then
+	_reflink_range $testdir/file1 $bigoff_64k $testdir/file6 $oplen 65535 >> $seqres.full
+else
+	# If we can't do the ficlonerange test, fake it in the output file
+	$XFS_IO_PROG -f -c 'pwrite -S 0x61 1114110 1' $testdir/file6 >> $seqres.full
+fi
 
 echo "Reflink past source file EOF (should fail)"
 _reflink_range $testdir/file2 524288 $testdir/file7 0 1048576 >> $seqres.full

