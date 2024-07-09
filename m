Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6697913D8A3
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 06:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720507446; cv=none; b=cWrDjyoQsmkEn655hps+Stapb//m2fooIfCVyjvUg5Rh/+ewEXWNh5Hx4LSOU6mnzuk+s7oUTKlJ0aVBhgr1HMee9aIGJf8zHocH2LMy0Al3OP2q0d7aSEKGyDUP34fFvGBDqhLm0WVJ9n/U3F3xzmMyhen7P2+sztW7X3MIK+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720507446; c=relaxed/simple;
	bh=1bXg+23lUrnFLlpHxjZ7rw0P7dybYKruMV00q9iROvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pKRB6kbDpQR4VChgCxNVMKajWUu3iG9pt8aW2BtVXI9F2MwgLi2X/khYJkH0D8Sr9NrIQel3dGuFfhre4ewSq73djyQSu4FIRCVdeard2fHJ7UqzmXc2UPQtX+gGZb2fP6RJeMcIitZDj4/8ZHATUTleuxBdVGMmguhQ9uXI0jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=skEbfeGA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="skEbfeGA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=IXd1SRl2OxP4mmT6CV8+20i7hEbRcc2MeWEFgOhSHwQ=; b=skEbfeGAHhEibF4nAOK3UsIK5d
	dn0yz+4d7ODkNb5GAaUUUGgqpNtGLoLq7bvK5InYz00ohVQJuOdSe4ghvwuXsyZGBoXXe2M98aXxr
	vJ+mEpjnmUxUREvli/mUdr6bwjy6W2rXvRp9dcFkgmaSEVdgtVtN1udCFkf53HHixyM6CvTBnCNhG
	0LtMSFC4P2GzZDX/Q4flgXMh7z7w+FSvcn/HnF3gpgdKBVkUc6sfsvKNukQJ6MNQG8ZaGt+vpyIsC
	wFLUyfQydqXMRYpKZkQQude8ih8roc641bNgi81oEa91wcQ3Oeu9D4D2C67t80GL9IJZd31IeQ6RR
	LqNt4YrA==;
Received: from 2a02-8389-2341-5b80-6f07-844f-67cc-150a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6f07:844f:67cc:150a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sR4a4-000000067sV-2sNQ;
	Tue, 09 Jul 2024 06:44:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: remove duplicate rtalloc declarations in libxfs.h
Date: Tue,  9 Jul 2024 08:44:01 +0200
Message-ID: <20240709064401.2998863-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These already come from xfs_rtbitmap.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h         |  5 -----
 man/man8/xfs_scrub_all.8 | 42 ----------------------------------------
 2 files changed, 47 deletions(-)
 delete mode 100644 man/man8/xfs_scrub_all.8

diff --git a/include/libxfs.h b/include/libxfs.h
index fb8efb696..40e41ea77 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -220,11 +220,6 @@ libxfs_bmbt_disk_get_all(
 		irec->br_state = XFS_EXT_NORM;
 }
 
-/* XXX: this is clearly a bug - a shared header needs to export this */
-/* xfs_rtalloc.c */
-int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
-bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-
 #include "xfs_attr.h"
 #include "topology.h"
 
diff --git a/man/man8/xfs_scrub_all.8 b/man/man8/xfs_scrub_all.8
deleted file mode 100644
index 74548802e..000000000
--- a/man/man8/xfs_scrub_all.8
+++ /dev/null
@@ -1,42 +0,0 @@
-.TH xfs_scrub_all 8
-.SH NAME
-xfs_scrub_all \- scrub all mounted XFS filesystems
-.SH SYNOPSIS
-.B xfs_scrub_all
-[
-.B \-hV
-]
-.SH DESCRIPTION
-.B xfs_scrub_all
-attempts to read and check all the metadata on all mounted XFS filesystems.
-The online scrub is performed via the
-.B xfs_scrub
-tool, either by running it directly or by using systemd to start it
-in a restricted fashion.
-Mounted filesystems are mapped to physical storage devices so that scrub
-operations can be run in parallel so long as no two scrubbers access
-the same device simultaneously.
-.SH OPTIONS
-.TP
-.B \-h
-Display help.
-.TP
-.B \-V
-Prints the version number and exits.
-.SH EXIT CODE
-The exit code returned by
-.B xfs_scrub_all
-is the sum of the following conditions:
-.br
-\	0\	\-\ No errors
-.br
-\	4\	\-\ File system errors left uncorrected
-.br
-\	8\	\-\ Operational error
-.br
-\	16\	\-\ Usage or syntax error
-.TP
-These are the same error codes returned by xfs_scrub.
-.br
-.SH SEE ALSO
-.BR xfs_scrub (8).
-- 
2.43.0

