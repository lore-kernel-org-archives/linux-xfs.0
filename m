Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D32430CC1
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900061; cv=none; b=K4YPm8hKGeiOWLP3JGxa9DSc16JEfdDzhOP96IWWpXpaE3lTssXrDL7BP8eAD/e5CD4/bT8FbEzWTm2IUZSnIvmI5P7GhRlXRWh5vdHaoR5wQcvvt9dLB86BaaubNWlP4EY/oKU/fesmkEhMhIe3vdsj4P9tXslQHnwsw4j8m7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900061; c=relaxed/simple;
	bh=5XN1wvBavFaxw4pMZYvS7pqShj4sCc9HROV3y40vo7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJzfPfunpkfHkR6TBuXJT1uUFhpkKov2OpMsDRfN+S02s97PdlEbMvJp/GuKDW0aBHNr/OHwcMzc2lqInSL/YxM3cJeDstCuX1kJHDXK8TFC38yQV6kbO6UHGWZbYIIFgGelsxAF4JRROxE7DgVhCT0b1proTIQBuzwmbPETeLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gXXi/BDS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gXXi/BDS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gXXi/BDS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gXXi/BDS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 169FB7B87D;
	Fri, 24 Jul 2026 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lLyCImeZqbnvg81x+S/4Hhuk20p+6e9u3KWDoA+Lz4=;
	b=gXXi/BDSOQttnhCzpJcx8/4/5jSxDpDlfQuj+dtaB/NKSzWtlTQtlfXhO/bKPuNa8FYaVV
	m0zLUNeFg3y7Kd6rcaORD+XkCExQ9/b6oxeUayzrt4i83CSNNcsk02CDBDOTtOs/kpPacM
	70g7aweqpB7hiqbuEATVvrL6/LDweNc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lLyCImeZqbnvg81x+S/4Hhuk20p+6e9u3KWDoA+Lz4=;
	b=gXXi/BDSOQttnhCzpJcx8/4/5jSxDpDlfQuj+dtaB/NKSzWtlTQtlfXhO/bKPuNa8FYaVV
	m0zLUNeFg3y7Kd6rcaORD+XkCExQ9/b6oxeUayzrt4i83CSNNcsk02CDBDOTtOs/kpPacM
	70g7aweqpB7hiqbuEATVvrL6/LDweNc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7649D779BA;
	Fri, 24 Jul 2026 13:33:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ENwlG79pY2pIJgAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 24 Jul 2026 13:33:51 +0000
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
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 11/12] fstests: split generic/613 into two tests
Date: Fri, 24 Jul 2026 15:33:27 +0200
Message-ID: <20260724133328.1837318-12-neelx@suse.com>
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
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLpqbuhkiw7hwm7jg9wcx4pbon)];
	RCVD_TLS_ALL(0.00)[]

From: Josef Bacik <josef@toxicpanda.com>

generic/613 tests v1 and v2 policies, but btrfs can only support v2
policies.  Split this into two different tests, 613 which will only test
v1 policies, and then 800 which will test v2 policies.

The 800 test will also add checks for the per-extent nonces to validate
they're all sufficiently random.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 tests/generic/613     |  20 ++------
 tests/generic/613.out |   5 +-
 tests/generic/800     | 115 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/800.out |  14 +++++
 4 files changed, 136 insertions(+), 18 deletions(-)
 create mode 100755 tests/generic/800
 create mode 100644 tests/generic/800.out

diff --git a/tests/generic/613 b/tests/generic/613
index 6a120c13..aee9f4db 100755
--- a/tests/generic/613
+++ b/tests/generic/613
@@ -20,22 +20,21 @@ _begin_fstest auto quick encrypt
 . ./common/filter
 . ./common/encrypt
 
-_require_scratch_encryption -v 2
+_require_scratch_encryption
 _require_get_encryption_nonce_support
 _require_command "$XZ_PROG" xz
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
-echo -e "\n# Adding encryption keys"
-_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+echo -e "\n# Adding encryption key"
 _add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" -d $TEST_KEY_DESCRIPTOR
 
 # Create a bunch of encrypted files and directories -- enough for the uniqueness
 # and randomness tests to be meaningful, but not so many that this test takes a
-# long time.  Test using both v1 and v2 encryption policies, and for each of
-# those test the case of an encryption policy that is assigned to an empty
-# directory as well as the case of a file created in an encrypted directory.
+# long time.  Test using the v1 encryption policy, test the case of an
+# encryption policy that is assigned to an empty directory as well as the case
+# of a file created in an encrypted directory.
 echo -e "\n# Creating encrypted files and directories"
 inodes=()
 for i in {1..50}; do
@@ -43,20 +42,11 @@ for i in {1..50}; do
 	mkdir $dir
 	inodes+=("$(stat -c %i $dir)")
 	_set_encpolicy $dir $TEST_KEY_DESCRIPTOR
-
-	dir=$SCRATCH_MNT/v2_policy_dir_$i
-	mkdir $dir
-	inodes+=("$(stat -c %i $dir)")
-	_set_encpolicy $dir $TEST_KEY_IDENTIFIER
 done
 for i in {1..50}; do
 	file=$SCRATCH_MNT/v1_policy_dir_1/$i
 	touch $file
 	inodes+=("$(stat -c %i $file)")
-
-	file=$SCRATCH_MNT/v2_policy_dir_1/$i
-	touch $file
-	inodes+=("$(stat -c %i $file)")
 done
 _scratch_unmount
 
diff --git a/tests/generic/613.out b/tests/generic/613.out
index 203a64f2..4a218d03 100644
--- a/tests/generic/613.out
+++ b/tests/generic/613.out
@@ -1,7 +1,6 @@
 QA output created by 613
 
-# Adding encryption keys
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Adding encryption key
 Added encryption key with descriptor 0000111122223333
 
 # Creating encrypted files and directories
@@ -12,5 +11,5 @@ Added encryption key with descriptor 0000111122223333
 Listing non-unique nonces:
 
 # Verifying randomness of nonces
-Uncompressed size is 3200 bytes
+Uncompressed size is 1600 bytes
 Nonces are incompressible, as expected
diff --git a/tests/generic/800 b/tests/generic/800
new file mode 100755
index 00000000..18377da4
--- /dev/null
+++ b/tests/generic/800
@@ -0,0 +1,115 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2023 Meta
+#
+# FS QA Test No. 800
+#
+# A variation of generic/613 that only tests v2, and checks data nonces for any
+# file system that supporst per-extent encryption.
+#
+# Test that encryption nonces are unique and random, where randomness is
+# approximated as "incompressible by the xz program".
+#
+# An encryption nonce is the 16-byte value that the filesystem generates for
+# each encrypted file.  These nonces must be unique in order to cause different
+# files to be encrypted differently, which is an important security property.
+# In practice, they need to be random to achieve that; and it's easy enough to
+# test for both uniqueness and randomness, so we test for both.
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt
+
+# Import common functions.
+. ./common/filter
+. ./common/encrypt
+
+_require_scratch_encryption -v 2
+_require_get_encryption_nonce_support
+_require_command "$XZ_PROG" xz
+
+_check_nonce()
+{
+	local nonce=$1
+
+	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
+	then
+		_fail "Expected nonce for inode $inode to be 16 bytes (32 hex characters), but got \"$nonce\""
+	fi
+}
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+echo -e "\n# Adding encryption key"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+
+# Create a bunch of encrypted files and directories -- enough for the uniqueness
+# and randomness tests to be meaningful, but not so many that this test takes a
+# long time.  Test using the v2 encryption policy, test the case of an
+# encryption policy that is assigned to an empty directory as well as the case
+# of a file created in an encrypted directory.
+echo -e "\n# Creating encrypted files and directories"
+inodes=()
+for i in {1..50}; do
+	dir=$SCRATCH_MNT/v2_policy_dir_$i
+	mkdir $dir
+	inodes+=("$(stat -c %i $dir)")
+	_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+done
+for i in {1..50}; do
+	file=$SCRATCH_MNT/v2_policy_dir_1/$i
+	$XFS_IO_PROG -f -c "pwrite 0 1m" $file > /dev/null
+	inodes+=("$(stat -c %i $file)")
+done
+_scratch_unmount
+
+# Build files that contain all the nonces.  nonces_hex contains them in hex, one
+# per line.  nonces_bin contains them in binary, all concatenated.
+echo -e "\n# Getting encryption nonces from inodes"
+echo -n > $tmp.nonces_hex
+echo -n > $tmp.nonces_bin
+for inode in "${inodes[@]}"; do
+	inode_nonce=$(_get_encryption_file_nonce $SCRATCH_DEV $inode)
+	_check_nonce $inode_nonce
+	
+	echo $inode_nonce >> $tmp.nonces_hex
+	echo -ne "$(echo $inode_nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \
+		>> $tmp.nonces_bin
+
+	data_nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
+
+	# If the inode is empty we won't have a data nonce
+	[ "$data_nonce" = "" ] && continue
+
+	# If the inode nonce and data nonce are the same continue
+	[ "$inode_nonce" = "$data_nonce" ] && continue
+
+	_check_nonce $data_nonce
+	
+	echo $data_nonce >> $tmp.nonces_hex
+	echo -ne "$(echo $data_nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \
+		>> $tmp.nonces_bin
+done
+
+# Verify the uniqueness and randomness of the nonces.  In theory randomness
+# implies uniqueness here, but it's easy enough to explicitly test for both.
+
+echo -e "\n# Verifying uniqueness of nonces"
+echo "Listing non-unique nonces:"
+sort < $tmp.nonces_hex | uniq -d
+
+echo -e "\n# Verifying randomness of nonces"
+uncompressed_size=$(stat -c %s $tmp.nonces_bin)
+echo "Uncompressed size is $uncompressed_size bytes" >> $seqres.full
+compressed_size=$($XZ_PROG -c < $tmp.nonces_bin | wc -c)
+echo "Compressed size is $compressed_size bytes" >> $seqres.full
+# The xz format has 60 bytes of overhead.  Go a bit lower to avoid flakiness.
+if (( compressed_size >= uncompressed_size + 55 )); then
+	echo "Nonces are incompressible, as expected"
+else
+	_fail "Nonces are compressible (non-random); compressed $uncompressed_size => $compressed_size bytes!"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/800.out b/tests/generic/800.out
new file mode 100644
index 00000000..5c477654
--- /dev/null
+++ b/tests/generic/800.out
@@ -0,0 +1,14 @@
+QA output created by 800
+
+# Adding encryption key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+
+# Creating encrypted files and directories
+
+# Getting encryption nonces from inodes
+
+# Verifying uniqueness of nonces
+Listing non-unique nonces:
+
+# Verifying randomness of nonces
+Nonces are incompressible, as expected
-- 
2.53.0

