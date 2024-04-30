Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467A17592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481409; cv=none; b=u8fO19RO6/Sz03V+DNrrN82xGHSUiSQADj00XPugsc/oJ+IWkYtTMSLVA6NWZl3YEQKedHyhDQTZA6S7fdfmDNpH4i6aQhdGBeki5rRuRWCTpkxVq0W6lJVlUhHsiTF/dwDjbU5zn8D6JeqiPi6w/7Mf44Fn9k8KTN5XxXACK/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481409; c=relaxed/simple;
	bh=KPOSobdFkerCSfJbqro8mOllXms6vtzwTDwYeMzTLuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V595dkp8qhCbJU2rVdJDE7ODGjufbulri1Wd3t/YxXY8HSA8iUCt6Z6dvoa6kYiXDD6dvgCytNBOu1VhMBpCO46k7Yofjs8svYzaR8hlkKkrXuySbbGd/DPQUlve6j2IYInxe7k5YzgfeF0CRlO8R1+kGE5IwEF/2DQ3/P/14vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g15/CVyA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g15/CVyA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0PQ7PESzKuPBQt0IS2ScfQ84wdpyn7pNlRDUpcZD9cA=; b=g15/CVyAjV+R0XkVqFCAjeJZMn
	pwpq/o+JZF6NI4BDj8u74Ly72ZPMIp+795GB/bQG1/0AMwXjxaj/Q1DuMuxDiVS0rUo3epF1np0V5
	0yZp4OGNLFU7mdtm5imbw+D12dYAsFlb5wv+sUH4Vz40yyPdziGYuxLjBD/z433rqg3YHRhyM2Tdk
	l1nUN+KAxxdMcKLq/kZKzjdttl3qpK9akh8sOaUWWNh+05CE+GzEuXhhc+J6WfZ8Zt8hcwil/Ix+C
	Im+JcrqWF9Oy2Fxwdv4IjSIytucoGskEQd4ZXepaT3HPfs68ZI3HvdLo2ILJ0X+lMz6sgTK9ENgZS
	QYc9ExdQ==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvw-00000006NoV-06jx;
	Tue, 30 Apr 2024 12:50:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/16] xfs: move common code into xfs_dir2_sf_addname
Date: Tue, 30 Apr 2024 14:49:23 +0200
Message-Id: <20240430124926.1775355-14-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move updating the inode size and the call to xfs_dir2_sf_check from
xfs_dir2_sf_addname_easy and xfs_dir2_sf_addname_hard into
xfs_dir2_sf_addname.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 43e1090082b45d..a9d614dfb9e43b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -465,6 +465,9 @@ xfs_dir2_sf_addname(
 			xfs_dir2_sf_toino8(args);
 		xfs_dir2_sf_addname_hard(args, objchange, new_isize);
 	}
+
+	dp->i_disk_size = new_isize;
+	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 	return 0;
 }
@@ -498,8 +501,6 @@ xfs_dir2_sf_addname_easy(
 	 */
 	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
 	xfs_dir2_sf_addname_common(args, sfep, offset, false);
-	dp->i_disk_size = new_isize;
-	xfs_dir2_sf_check(args);
 }
 
 /*
@@ -583,8 +584,6 @@ xfs_dir2_sf_addname_hard(
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
 	kfree(buf);
-	dp->i_disk_size = new_isize;
-	xfs_dir2_sf_check(args);
 }
 
 /*
-- 
2.39.2

