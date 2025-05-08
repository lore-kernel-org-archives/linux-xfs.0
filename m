Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939738472;
	Thu,  8 May 2025 05:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682502; cv=none; b=Z9s6Y9y5nk/PkCavdSz1oSPLrFsLfIhCXdpyATr8BiJb6/8yUHkWuTUU6MwWWpHnhCKuplfSslsWlC9qFUhIBXJb309c0m0F7HV8Y97sKATNZ0lbj7tUVRS32KOcCNP4l/WDyOnI6x6Ek//Jp8i6eqfvL+Sxsrb3FtwLNdwvBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682502; c=relaxed/simple;
	bh=9DT52SDTV1D/oEOTe//sCQdbcqgRow5f2SRPIEMc9zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNjozUcNguEffxa2yZc79NXxCxIQaAhXL4CnAZAhClNEQLy2Kr2nzyobvZY1TrUqaYnhZYdoeP2Q/XJaRMg/Tsy0Ty7ekizPqKEAaUr2dire4APMU0C8kAqlh1ZkN7uYELlYO+KxIuE/duq1xotuu1r4u3KJUFzeOzkaLbsobzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1zI9Rkkc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1zI9Rkkc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gBQXKY/thpA6+sGy0nS2M6d0417cXEFeSrANhsQGiSY=; b=1zI9RkkcafCupvnLni2LAu1RaX
	76ah2LcNgKIA/BPoxvyKvTdIbDGleB/i5LboUBs0wb1mO2nXaBV6NL9aD64r1Bo+JcGyXIibeT1e+
	Ovb6SXy1ZnzL/a8BWc90kPy+eA2mBoJb74vuUWdVa/obUTDxNvwijmQsAWW0dW50sZcOEAmRsXMsb
	vWuRND5xjuww1EbaolhN6so7tXTAKCaud98lUuEUwbOH7RxbU471SIHR+oesJpET7dMteXrLSFBCw
	u9bDaLXLUwxOpvznN9Lknr+L1w41Fhbt3wf04Cy6XOHtAA/1TTZTkgPOBpa0zkhUQxayJDX9sM0Pp
	keUQSSFg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtuO-0000000HNcI-2srY;
	Thu, 08 May 2025 05:35:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/16] common: generalize _filter_agno
Date: Thu,  8 May 2025 07:34:30 +0200
Message-ID: <20250508053454.13687-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508053454.13687-1-hch@lst.de>
References: <20250508053454.13687-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Rename and move to common/xfs so that it can be reused for rgnos in new
zoned tests.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/filestreams | 11 +----------
 common/xfs         | 10 ++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/common/filestreams b/common/filestreams
index bb8459405b3e..ace8f3b74de6 100644
--- a/common/filestreams
+++ b/common/filestreams
@@ -42,19 +42,10 @@ _do_stream()
 	done
 }
 
-_filter_agno()
-{
-        # the ag number is in column 4 of xfs_bmap output
-        perl -ne '
-                $ag = (split /\s+/)[4] ;
-		if ($ag =~ /\d+/) {print "$ag "} ;
-        '
-}
-
 _get_stream_ags()
 {
         local directory_name=$1
-        local stream_ags=`xfs_bmap -vp ${directory_name}/* | _filter_agno`
+        local stream_ags=`xfs_bmap -vp ${directory_name}/* | _filter_bmap_gno`
         echo $stream_ags
 }
 
diff --git a/common/xfs b/common/xfs
index 39650bac6c23..061ca586c84f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2274,3 +2274,13 @@ _scratch_find_rt_metadir_entry() {
 
 	return 1
 }
+
+# extract the AG/RTG number from xfs_bmap output
+_filter_bmap_gno()
+{
+	# The AG/RG number is in column 4 of xfs_bmap output
+        perl -ne '
+                $ag = (split /\s+/)[4] ;
+		if ($ag =~ /\d+/) {print "$ag "} ;
+        '
+}
-- 
2.47.2

