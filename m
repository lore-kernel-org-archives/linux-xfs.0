Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18EB3815E8;
	Fri, 16 Oct 2026 03:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121697; cv=none; b=KA2XsTS2hgtrovk0NOFvkRC0pnm4QKTcgXo9JQWPJNBCTkWlsySRwEvG1T5J9xOcquzSkI32qZ5ReEp178PanYov18YdJxqwHfF0XLFOEV1bKHnMfdgruEsf/UnKmT4QNCRMscIGnr4wwidIaZZrSID30LDRABamj0MLwl4UQhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121697; c=relaxed/simple;
	bh=OvLr/KqyPvIPbHR+gRfcxe7WLcbVuuGenvpQHMIemK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYX/P73z74xfTnO1cMauh5jjdsC4njN7THR8Qqe8o1IQ4WRhWQAK0ZSjp9Vl7/V5JnkAavrx6+l7EOkTS03dOu4TApmBvHofXTe9HOiYwKJed8uMkRUqWLl8QXBugpD3ckuLhg019Gejqkgxn9cAJcL1fuVP04qqx+U6mBRXwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jvIdsN38; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="jvIdsN38"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=oP
	lmG3wk4/to/Srmi671CJ/RkvKJSHEyuw0l2n+CfWw=; b=jvIdsN385HvKDAvO07
	9iFJI/JI8q/DuwdwEGfyWKgHxzLMb+mnSQ4dY946gEPPHerBeRe2j8za1Ze2+JrB
	K0GZwqpLxkCJ1aClRKMATl7Hm7hddrSktcycs9LZTEHerMCMiFXxeaNISKowc5uC
	Rqk3pt3I39rA1vL0UBiPdKOi4=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S7;
	Fri, 16 Oct 2026 11:34:23 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v3 5/8] exfat: validate cached iomaps during buffered writes
Date: Fri, 16 Oct 2026 11:33:46 +0800
Message-ID: <20261016033349.3104509-6-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016033349.3104509-1-chizhiling@163.com>
References: <20261016033349.3104509-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S7
X-Coremail-Antispam: 1Uf129KBjvJXoWxury8JFyUAw17Aw1DJrWDArb_yoW5AF45pw
	4DK3s8GrZ7Xw17Wr13JryrZF1ak34IgF4xArWfG3sxAF1Yyw47KFy8Ka42kF15X34DCr1I
	qa1vkr48WFn7Cr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jetCwUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2x8FomrRmz+AqwAA3X

From: Chi Zhiling <chizhiling@kylinos.cn>

The next patch, "exfat: drop i_rwsem from exfat_page_mkwrite()", allows a
fault to advance valid_size under the folio lock without serializing
against an in-flight buffered write. As a result, valid_size may advance
into a folio covered by a cached iomap. Reusing that iomap would cause
__iomap_write_begin() to zero the wrong part of the block.

Add an ->iomap_valid callback that compares ->validity_cookie against the
current valid_size and forces a remap if valid_size has advanced into the
locked folio, whose pointer is stored in ->private by ->get_folio.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/exfat/iomap.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 10416335e8ee..b25d149f8004 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -57,6 +57,7 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 			iomap->addr = IOMAP_NULL_ADDR;
 			iomap->offset = offset;
 			iomap->length = length;
+			iomap->validity_cookie = valid_size;
 			return 0;
 		}
 
@@ -145,7 +146,7 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 		}
 	}
 
-	iomap->flags |= IOMAP_F_MERGED;
+	iomap->validity_cookie = valid_size;
 out:
 	mutex_unlock(&sbi->s_lock);
 	return err;
@@ -232,6 +233,17 @@ const struct iomap_ops exfat_write_iomap_ops = {
 	.iomap_next	= exfat_write_iomap_next,
 };
 
+static struct folio *exfat_iomap_get_folio(struct iomap_iter *iter, loff_t pos,
+			unsigned int len)
+{
+	struct folio *folio = iomap_get_folio(iter, pos, len);
+
+	if (!IS_ERR(folio))
+		iter->iomap.private = folio;
+
+	return folio;
+}
+
 static void exfat_iomap_put_folio(struct inode *inode, loff_t pos,
 		unsigned int copied, struct folio *folio)
 {
@@ -244,6 +256,28 @@ static void exfat_iomap_put_folio(struct inode *inode, loff_t pos,
 	folio_put(folio);
 }
 
+static bool exfat_iomap_valid(struct inode *inode, const struct iomap *iomap)
+{
+	struct folio *folio = iomap->private;
+	loff_t old_valid_size = iomap->validity_cookie;
+	loff_t valid_size = exfat_get_valid_size(EXFAT_I(inode));
+
+	if (valid_size == old_valid_size)
+		return true;
+
+	if (!folio)
+		return false;
+
+	/* Still valid for this folio. */
+	if (old_valid_size >= folio_next_pos(folio))
+		return true;
+
+	if (valid_size <= folio_pos(folio))
+		return true;
+
+	return false;
+}
+
 /*
  * exfat_iomap_read_folio_range - Read a block range during a buffered write
  *
@@ -273,7 +307,9 @@ static int exfat_iomap_read_folio_range(const struct iomap_iter *iter,
 }
 
 const struct iomap_write_ops exfat_iomap_write_ops = {
+	.get_folio	= exfat_iomap_get_folio,
 	.put_folio	= exfat_iomap_put_folio,
+	.iomap_valid	= exfat_iomap_valid,
 	.read_folio_range = exfat_iomap_read_folio_range,
 };
 
-- 
2.53.0

