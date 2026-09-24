Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0DA471406;
	Thu, 24 Sep 2026 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244570; cv=none; b=Lr0o2aZxsasMuFpfpNB/pRryf7BemVYXscESFk6NeFZFaTq9B+CQkYnSjuczSGh9ST7OuMs5EQ7jPmSFXLx5Vlb8ZChyuYoOSSS+ycHS8bSEKXv4BStBOSeYauN25Ox+pNlZZAtPqLjbJGyPPTKO+J5OG1hV+TOZMQWzZvpXj9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244570; c=relaxed/simple;
	bh=1Pt9xkLREIQnaWroRSPmJS6KMcIVlAM/9LAWhhipYno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXOXAYUzI8KWIWQJ0XWQ6haxlPGd8tC6p4Vb2hShIaml4c438lRfAu34IpCgUNImN9eqW/PD1Iny0OOe1Teru1iKXNYpuzoeWqr2alTOJCs9WT4z9ldvXoL796kCYTltXOsXg/Rmah6Bnx4EQxF7lVNDWLABLL+2wb9vvB9O9Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=as1nnRd6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="as1nnRd6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xtfYugKzLHBr5wVUma3LhlwkAS5PUmaNWu/zG3t5YF4=; b=as1nnRd6paxAKjIhJACJ7VKruJ
	KkQQFolYXrvPjRE05v+A7AVB0AqbCt8wOwSB1ng3G6xmNSvHizQIxNF1tan+8M4Sx84ZIG3vbnDoZ
	Z3b498UN7BkSJEguBcyZ2vrm1RPgFV8ACTOnMnkOSKV1o1rs8LjtJHAlalhV+X4G9mUu2a6ykqzrC
	ZE8IQZo5/b1c5j1YWSCuca/SDKy5ydvPcc7+qJSl4E4c9behKO86jDLnVCWsJNKEO43HrJxG3i4C0
	nR9tubsBPun4igaV3GzAY9b64JCdZM8yW/rCxq3HkQu2bjqUt79Au4NK7oEdrhC28YOKxZsq0F/CS
	n3N1U1Sw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gO9-0000000Afmj-3Smf;
	Thu, 24 Sep 2026 10:09:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/13] xfs: add a XFS_VERIFY_FILE_DATA variable
Date: Thu, 24 Sep 2026 12:07:44 +0200
Message-ID: <20260924100855.2734089-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100855.2734089-1-hch@lst.de>
References: <20260924100855.2734089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add an option to run the end of testt xfs_scrub call using the -x
option to also check file data validity.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 README     | 3 +++
 common/xfs | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/README b/README
index cc03f51e1ad3..0ce7d4463354 100644
--- a/README
+++ b/README
@@ -326,6 +326,9 @@ Extra XFS specification:
  - xfs_scrub, if present, will always check the test and scratch
    filesystems if they are still online at the end of the test. It is no
    longer necessary to set TEST_XFS_SCRUB.
+ - Set XFS_VERIFY_FILE_DATA option to also check file data integrity using the
+   -x option to xfs_scrub.  This makes the xfs_scrub based checks a lot slower,
+   but verifies the data checksum support in XFS.
 
 Tools specification:
  - dump:
diff --git a/common/xfs b/common/xfs
index 98981e624dda..8254e48603af 100644
--- a/common/xfs
+++ b/common/xfs
@@ -875,6 +875,12 @@ _check_xfs_filesystem()
 	# Run online scrub if we can.
 	mntpt="$(_is_dev_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
+		local xfs_scrub_opts="-v -d -n"
+
+		if [ -n "$XFS_VERIFY_FILE_DATA" ]; then
+			xfs_scrub_opts="$xfs_scrub_opts -x"
+		fi
+
 		can_scrub=1
 
 		# Tests can create a scenario in which a call to syncfs() issued
@@ -888,7 +894,7 @@ _check_xfs_filesystem()
 		# before executing a scrub operation.
 		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
 
-		"$XFS_SCRUB_PROG" -v -d -n $mntpt > $tmp.scrub 2>&1
+		"$XFS_SCRUB_PROG" $xfs_scrub_opts $mntpt > $tmp.scrub 2>&1
 		if [ $? -ne 0 ]; then
 			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
 			echo "*** xfs_scrub -v -d -n output ***" >> $seqres.full
-- 
2.53.0

