Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020B3B71C4
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 13:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900031; cv=none; b=dVE2qcYvEx5AxMsskb1niCxwHxePebtkURBa3o/Ru8G3TFPHUtdvFnCGiorsnvW0V7KHo7JFkbF3D8tY5qn0TBPkGmWmTUnf/Nvv8XTB/fhXzNfOfTraIiOZ4uyZ3s9VbWBfD6lQH6uqX9JvUkt1DAjA2MDiHcl85t5pmUGZcfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900031; c=relaxed/simple;
	bh=3qA0qNzFSqhJtmRigeE31QAA80I/TMU91Yu0te4c2QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7uLSJMjesOJM4H9xPbUHZFpL+hE2PCUBvaoQV4JFQBtcOaVAdkvYfSw8kj/XS4ODQM794zLPjeJzwjTCnVLxgI2CpbRExQ+DVQVxM86SR+Bc1XcZ7y0qAKcrdGesLCCdokdlHl/A9zQR9357Lvd9yR9pIZb3nvaFJ+Ih4SZb68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pFockn/J; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lUdjYZKf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pFockn/J";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lUdjYZKf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E69957B854;
	Fri, 24 Jul 2026 13:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVwAI1hSkCaUpLf6ewphBAqD/y8icd57r1c7QrNLrio=;
	b=pFockn/JE1rMxCwIc8CsG2PVy4MzcOv/GNP5+eA7sMxjSWot88p0tBlRzC8scyJBlzXZTL
	+J10VByxpmn2QL+WxAB0S48a1X6keyPzu0FwTXe+P9uPnQfaPyJ9jYfCIfE0ZjuACSftyJ
	H+vzRNO5h6u/K5Cq1/DXEGwJos+UuUs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVwAI1hSkCaUpLf6ewphBAqD/y8icd57r1c7QrNLrio=;
	b=lUdjYZKfW0xSceH0I10RGjE9R5CVpGBjpZLKntbuwway5jEjevayT5G+8Q+KL120cphCpb
	qCGdRQAy0+RVI1bDc5ExsXUHkeU50WtH02ods4kPUhcuEPYRPWlZc65NwMZpsLC0RhfERE
	ZUAtutiOJSCXwtbOoIkkPrm6NImlaqM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92B81779BA;
	Fri, 24 Jul 2026 13:33:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6GnKGrVpY2pIJgAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 24 Jul 2026 13:33:41 +0000
From: Daniel Vacek <neelx@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org,
	David Sterba <dsterba@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 01/12] common/encrypt: separate data and inode nonces
Date: Fri, 24 Jul 2026 15:33:17 +0200
Message-ID: <20260724133328.1837318-2-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724133328.1837318-1-neelx@suse.com>
References: <20260724133328.1837318-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

btrfs will have different inode and data nonces, so we need to be
specific about which nonce each use needs. For now, there is no
difference in the two functions.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 common/encrypt    | 33 ++++++++++++++++++++++++++-------
 tests/f2fs/002    |  2 +-
 tests/generic/613 |  4 ++--
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index c9e0853d..8f664518 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -548,7 +548,7 @@ _add_fscrypt_provisioning_key()
 # Retrieve the encryption nonce of the given inode as a hex string.  The nonce
 # was randomly generated by the filesystem and isn't exposed directly to
 # userspace.  But it can be read using the filesystem's debugging tools.
-_get_encryption_nonce()
+_get_encryption_file_nonce()
 {
 	local device=$1
 	local inode=$2
@@ -592,15 +592,34 @@ _get_encryption_nonce()
 			}'
 		;;
 	*)
-		_fail "_get_encryption_nonce() isn't implemented on $FSTYP"
+		_fail "_get_encryption_file_nonce() isn't implemented on $FSTYP"
 		;;
 	esac
 }
 
-# Require support for _get_encryption_nonce()
+# Retrieve the encryption nonce used to encrypt the data of the given inode as
+# a hex string.  The nonce was randomly generated by the filesystem and isn't
+# exposed directly to userspace.  But it can be read using the filesystem's
+# debugging tools.
+_get_encryption_data_nonce()
+{
+	local device=$1
+	local inode=$2
+
+	case $FSTYP in
+	ext4|f2fs)
+		_get_encryption_file_nonce $device $inode
+		;;
+	*)
+		_fail "_get_encryption_data_nonce() isn't implemented on $FSTYP"
+		;;
+	esac
+}
+
+# Require support for _get_encryption_*nonce()
 _require_get_encryption_nonce_support()
 {
-	echo "Checking for _get_encryption_nonce() support for $FSTYP" >> $seqres.full
+	echo "Checking for _get_encryption_*nonce() support for $FSTYP" >> $seqres.full
 	case $FSTYP in
 	ext4)
 		_require_command "$DEBUGFS_PROG" debugfs
@@ -614,7 +633,7 @@ _require_get_encryption_nonce_support()
 		# the test fail in that case, as it was an f2fs-tools bug...
 		;;
 	*)
-		_notrun "_get_encryption_nonce() isn't implemented on $FSTYP"
+		_notrun "_get_encryption_*nonce() isn't implemented on $FSTYP"
 		;;
 	esac
 }
@@ -827,7 +846,7 @@ _do_verify_ciphertext_for_encryption_policy()
 	echo "Verifying encrypted file contents" >> $seqres.full
 	for f in "${test_contents_files[@]}"; do
 		read -r src inode blocklist <<< "$f"
-		nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+		nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
 		_dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.actual_contents
 		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
 			--file-nonce=$nonce --inode-number=$inode \
@@ -846,7 +865,7 @@ _do_verify_ciphertext_for_encryption_policy()
 	echo "Verifying encrypted file names" >> $seqres.full
 	for f in "${test_filenames_files[@]}"; do
 		read -r name inode dir_inode padding <<< "$f"
-		nonce=$(_get_encryption_nonce $SCRATCH_DEV $dir_inode)
+		nonce=$(_get_encryption_file_nonce $SCRATCH_DEV $dir_inode)
 		_get_ciphertext_filename $SCRATCH_DEV $inode $dir_inode \
 			> $tmp.actual_name
 		echo -n "$name" | \
diff --git a/tests/f2fs/002 b/tests/f2fs/002
index d2f6e413..ec83c81b 100755
--- a/tests/f2fs/002
+++ b/tests/f2fs/002
@@ -126,7 +126,7 @@ blocklist=$(_get_ciphertext_block_list $file)
 _scratch_unmount
 
 echo -e "\n# Getting file's encryption nonce"
-nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
 
 echo -e "\n# Dumping the file's raw data"
 _dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.raw
diff --git a/tests/generic/613 b/tests/generic/613
index 499af18e..6a120c13 100755
--- a/tests/generic/613
+++ b/tests/generic/613
@@ -66,10 +66,10 @@ echo -e "\n# Getting encryption nonces from inodes"
 echo -n > $tmp.nonces_hex
 echo -n > $tmp.nonces_bin
 for inode in "${inodes[@]}"; do
-	nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+	nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
 	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
 	then
-		_fail "Expected nonce to be 16 bytes (32 hex characters), but got \"$nonce\""
+		_fail "Expected nonce for inode $inode to be 16 bytes (32 hex characters), but got \"$nonce\""
 	fi
 	echo $nonce >> $tmp.nonces_hex
 	echo -ne "$(echo $nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \
-- 
2.53.0

