Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773591B813
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275761; cv=none; b=lJdkOKnxSf1IUeCwFfKfdpw0T6Q0UaPU3FSiYrmIVceuAMcPAFTyc5jpvE5hNbEc3Svpich9QQOBbQiX99K4g9ozGJ/Fd8Is18GkiiAZ1PNzd1Us21FeXggmkX02gCcEHiJ9MJzhzXHgWYazXh1kk331WJPbvYIXOwdIUuG1mDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275761; c=relaxed/simple;
	bh=ZflRcOysh24612c9VFVFYawqgN0vHbVjUtTuXVd3dqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GsdarEpeAB53kFWOqvhHnlbkAzSMWZGpn1RhaiSTcuYGzV5fm5eYrMd/KCp0HrttTp0bJwEtDAryiNZhaATEgUCVzT2rVCAjsm5CWqU9tmbKyOMeu6gpgaVrYDjhhIEjqORfRNQs9lkktpF3U5i8JywihbHR8itvYq/tkjpvyes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mQKrs4ng; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mQKrs4ng"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ai62sSrlh2/pqyKEZx0ovGIMBLUhqMYLKAXhWcyLh60=; b=mQKrs4ngo4qu6BMNq52g3Xoh7/
	O1zh9BQRalb2rgsldg+P4cm3P79MSZ374U5u2xMs9aaCXSTKGh03bTGb/fEr3qiMyn8guEcmy+SRw
	JHIN6C8IUSYHKbj2Es1IUtbK5021qHQt+HfO7TM71CzncgPPbJt7BWwm/rZtDZAM7uumax6KLUJ6G
	ghdizB1jiJ3qdlvd0MqYA3bxJufSlmzYMLnhqB9xerL7YZP7mRcNamDKWenB/tltXQ14lteiYxVHx
	AWFrf20QD1Np/CHZ+sEpXUp1sShnsCrrSaPHyLxPfA4KaCH1MKn+lzrpxVLgTrH1CiMDOwTHL1g41
	DcUeU/mA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMGk-00000004CbH-2wFk;
	Fri, 26 Jan 2024 13:29:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/21] shmem: set a_ops earlier in shmem_symlink
Date: Fri, 26 Jan 2024 14:28:45 +0100
Message-Id: <20240126132903.2700077-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Set the a_aops in shmem_symlink before reading a folio from the mapping
to prepare for asserting that shmem_get_folio is only called on shmem
mappings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f607b0cab7e4e2..1900916aa84d13 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3506,10 +3506,10 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		inode->i_op = &shmem_short_symlink_operations;
 	} else {
 		inode_nohighmem(inode);
+		inode->i_mapping->a_ops = &shmem_aops;
 		error = shmem_get_folio(inode, 0, &folio, SGP_WRITE);
 		if (error)
 			goto out_remove_offset;
-		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
 		folio_mark_uptodate(folio);
-- 
2.39.2

