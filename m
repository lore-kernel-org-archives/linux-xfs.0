Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBDE4949ED
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353394; cv=none; b=NJ6b/A3zsTvMZgYrAn3wRWL8W5DSgNHGyNWWgiRo5AigHw6R0MK19DZAKPkU8MVZTaOds89O0B4BBVG1S/42eYwCaCOVybG20HxGR4jktqNxEAjDRV5kh2YlXJ1VZ/HbKtIBHFI4p3FH/BIp7Jbfex2KJ05h7gY1ZL5w7TfAi1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353394; c=relaxed/simple;
	bh=Vp11QT/0XbYaCBpKeV6yIhKanTWoDvDmVvwl/BDJxK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3PF5trnBEpW06mdVjiru9Bm61JXXgxXpC/YIGGK9uy6liGhpv5mLrmCGECX+YXv/xSyBEfBqSDsPT0QbK7TXkTzT9pSORcrIMe6LDb4OEZCIW7S3eTAQRg2uCaUIPhjgF48+jz57evKgWAVlw6jIaCG3wd68hiB8SVc9FoVv4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VAwL+yC0; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAwL+yC0"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ce7d2adef4so20247515ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353384; x=1785958184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmSJR2GgSO3TGzDFe0h5lMf1baXvMm5mznLJAPlA6WE=;
        b=VAwL+yC0Ued8kqFGT4RC3I6wmsQ2jkVi3Ck0RZdurA3JRvbocqjhecMiYUdLeDBj4s
         tgxnFF6CILfsBIg/fuKVzCOwKO+H6/6IcIiS7GhF+6FSrGDQqOFwS6FhUZ14S74fgDbi
         gYK1jF+EVtzFg32rIzJZBD269CR141PdV+BF8rUG7oIU14/Q+xMWErQAeoR8k9fTP4LH
         b0tzELOvzKJO5Ymud+8lqEfS0xuc4y/RAUv0LwgUhB5HzlvWnSQ0h5H3hoJXxJQEPfhR
         CAcx0WQPTM6UGd2MigXxUL5JlEAxFUA1/oOlihKQAwi1C+Wk1gn+WigNDlsWFnvMT/Up
         rJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353384; x=1785958184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmSJR2GgSO3TGzDFe0h5lMf1baXvMm5mznLJAPlA6WE=;
        b=TIvXWRtwVye6nwgHxSce2ANQz8T5dLWXUx6aWONH8gOp/PmQYeITpwR9NhQekaUlX+
         pV1nY4/Pn2y5NBx27XV+9M6UHIKFbN90Q5gbQVPWr/kkCNLxVzBa5osalabDngt8hcQB
         0vrEfI5ay8cUReaZbD8uecQ/go0pYrG0oYaWwcqSZ79trB8XD8o1g6YqwnRuCiUcKVHh
         s9vsnZConobr5TKhGitQPTkKL5ZUEtbezwW2YX9jUPphEljddJB3zSO+7OxNLOH7BQAA
         FSLTOMZuOLack/hpQ3MqAUhlDdL84l5BOey09LoK+JJAMvdJuAqygP9TC6YNzwntj8Tc
         mFPA==
X-Forwarded-Encrypted: i=1; AHgh+RrL/dLOLX+MYolcWWdAI+Z3XDgpF5QdmsZZEpRNXRs0ggkyQcmdHobDTzzJzx7ZL7oDPG5dUGOnu6w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/pMt5YiAjTc/bbTOd295kGFEn0DADWxt1PfAHfuhpF/NzMRTW
	zuBhzomivkJSvAv3Pt3sjlCCBSdQInlcCRUKxNCZ6TQ+aZ2NimpkJoft
X-Gm-Gg: AR+sD12NlM2oYj2YirnEUyP0uVglGQywClgHA2/OSSxiIJ8pDzOZXHbl69E4Kwe/gvp
	xaoTx66QmQDUjdqK9vua1bQb5A6Z4zIszgEaZizz6z5C585sQjazDAGjEs11qM8ccz0U/wycgGH
	IK7v5/MI9B/OKYgyb7g7UxE/Jtk00DWhLXgILggwEHoeZb4PLoLs03QkDBHJZqiCwgTBtLZ9yt3
	u8Tpj6U/7TYeumUd1c5tWFU7ew9ESxGXelvWPmrDZ9jTl6KvlxOr+63VvfvClpkp7BrS+91beVu
	QZIjfpiTAN7D/2QbaPUv2kaJNk2N4GpGvD2qmHNdEMsWTV79bYVsV7UAAjKsqtEzv69MpW0sYzB
	8dBSqgP5fX9kCiXqRnEFC6fVI8NVmyVY+ICkmAJwxN5QfoYI0a5Q5H1OuVvDL89R30dA4ly1RzS
	J8GrivffPcWcQnT2M8ceDWWeOyIqKw11hNmndKFwJ+K0cO13tO4kl16A2Lp1I7bqfQ5019iwKUL
	em68gHQnPveWKHDJu5nBdb1Qyccy0MRcXCIDTs=
X-Received: by 2002:a17:902:e845:b0:2ca:9ab:e725 with SMTP id d9443c01a7336-2d033994b84mr1930845ad.1.1785353383967;
        Wed, 29 Jul 2026 12:29:43 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a18abasm16069385ad.5.2026.07.29.12.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:29:43 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 01/22] iomap: release the folio batch on iomap callback failures
Date: Wed, 29 Jul 2026 12:27:16 -0700
Message-ID: <20260729192737.3190206-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Brian Foster <bfoster@redhat.com>

A sashiko review of an unrelated patch points out that the folio
batch mechanism used for iomap zero range fails to release the batch
in a couple error scenarios. If either calls to ->iomap_end() or
->iomap_begin() fail, the direct return paths bypass the batch
cleanup.

The ->iomap_end() case is not a practical issue at the moment
because there is no user of the mechanism that returns an error from
this path. The ->iomap_begin() case is theoretically possible
because XFS can invoke the fill helper and error out at various
points thereafter. This subtly complicates things because XFS does
not transfer iomap_flags to the iomap data structure in the error
path.

To deal with both of these issues, first make sure to invoke the
cleanup helper in the error path for either fs callback. Second,
update the helper to clear the flag unconditionally and release the
batch so long as it is populated. This more clearly delineates the
purpose of the flag to control the I/O path and not necessarily the
status of the fbatch, so add a comment around this as well.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/iter.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..63617ec48250 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,12 +6,18 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Release the iter folio batch. Note that the iomap flag is meant to control
+ * the I/O path for the mapping and may not be set in error situations.
+ */
 static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
 {
-	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
+	if (!iter->fbatch)
+		return;
+	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
+	if (folio_batch_count(iter->fbatch)) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
-		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
 	}
 }
 
@@ -79,7 +85,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 						  olen),
 				advanced, iter->flags, &iter->iomap);
 		if (ret < 0 && !advanced)
-			return ret;
+			goto error;
 	}
 
 	/* detect old return semantics where this would advance */
@@ -110,7 +116,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
-		return ret;
+		goto error;
 	iomap_iter_done(iter);
 	return 1;
+
+error:
+	iomap_iter_clean_fbatch(iter);
+	return ret;
 }
-- 
2.52.0

