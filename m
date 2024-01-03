Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F7E1862E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dIo4HWAQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vVoQtZKk55rO4xv81RRfDMeBVcwce9ZJZyjeyjkymuE=; b=dIo4HWAQ4jBdBUrCa8HgcaHmqb
	cnkCOPKDa8/RKeP35BaIUuT3ZPL7yRiw4vyi8g0fGYsgR2JntH3l0eicoCFrDarQjT2QQ27wTl08Y
	NyMqFtK71zSKPu0wGjw+rHT9YJ6D5ABzxd5tMvd6Ih/QQtAuK3fdV66LvqtmwloHqXdnCu4y5nSEr
	g9jBFHyBsE6quFf9IL5MLZmx+gbrPk0rZ43mKr1/QPTNZtwoKxSNCwyZT6ZVSTqekcEyUrvDaCM1M
	DfJ/mYJbRXVn37v0wCL6kmSB21j9LGDfJBC0H+7xg4O691TOzLBvZn/rLkgxdNaTfpjEuS+N6HxHW
	HTzBi+bA==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpJ-00A6jx-0n;
	Wed, 03 Jan 2024 08:42:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/15] xfs: don't modify file and inode flags for shmem files
Date: Wed,  3 Jan 2024 08:41:19 +0000
Message-Id: <20240103084126.513354-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103084126.513354-1-hch@lst.de>
References: <20240103084126.513354-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_file_setup is explicitly intended for a file that can be
fully read and written by kernel users without restrictions.  Don't
poke into internals to change random flags in the file or inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index ec1be08937977a..e872f4f0263f59 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -74,22 +74,7 @@ xfile_create(
 		goto out_xfile;
 	}
 
-	/*
-	 * We want a large sparse file that we can pread, pwrite, and seek.
-	 * xfile users are responsible for keeping the xfile hidden away from
-	 * all other callers, so we skip timestamp updates and security checks.
-	 * Make the inode only accessible by root, just in case the xfile ever
-	 * escapes.
-	 */
-	xf->file->f_mode |= FMODE_PREAD | FMODE_PWRITE | FMODE_NOCMTIME |
-			    FMODE_LSEEK;
-	xf->file->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;
 	inode = file_inode(xf->file);
-	inode->i_flags |= S_PRIVATE | S_NOCMTIME | S_NOATIME;
-	inode->i_mode &= ~0177;
-	inode->i_uid = GLOBAL_ROOT_UID;
-	inode->i_gid = GLOBAL_ROOT_GID;
-
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
 	trace_xfile_create(xf);
-- 
2.39.2

