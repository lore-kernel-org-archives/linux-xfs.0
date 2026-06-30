Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B87D17B418
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781477; cv=none; b=d+z5YNFKpfKrVh+MM+2XQmVyUKh28GDMp8bGKZaeGUfh4LopwIF8E0auoD6zoOFeXVVDw+UvAqsLU5w2hEtD7pG1IEC4rLhrELl9xyfKDYZCDPVKrN5Q64K/rBrApX5KpejsqwjR9DhDrZToKdrpWjb8J+Qk82dXg+sRNts7rI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781477; c=relaxed/simple;
	bh=c+jmQ7iPlyabFIvZ6X5JN1Eij09otlOaI+Dm3j/qgwg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZFRKLIdNOaEQMYa3OssLec8hZVNP/irXfxc9b26NweFjRgJ3sbX6iQcibqZVcTqbwxFC0ObX37KaSc3Nfe1SRFWjQqEQT6LSCx3hmv+RyEu29yppBsKCo8jbje6zmGARprfUY7CazpU8c4j3NQH99jV68DXhT5Q2On/j2yHOGmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMOw0Pr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMOw0Pr/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D7E051F000E9;
	Tue, 30 Jun 2026 01:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781468;
	bh=TrNFsR3GsD9rWG9AVCV1yexhlxkx12vOsS3Dqm6Yszw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HMOw0Pr/MIhxCpLfpBCTVTKohD80oVWT9wvJI9GHNyXfK5hzqhdVaJELJxQKJYwhu
	 oJ9mGw+gqT8TXkegOd5rDnZEtwykwVjRBFtZ3K7o7LGyHvGjEXVKOZPYtLgxlZhmkK
	 sbG52pTqkSH8aN+Sah31mkGgV20ApwS+Y1WSCF643n9UqJ0MxmzjALJA/4gbXYx8nE
	 zt0VgJcUv8+iTC8IFlyP1iVntxgaCcEVBI/yvNXQBtkmrKPHYzamTsNNNOpaTg+c8F
	 ovE1z1hH7ZNtmBaT9gfgWappr+63yTQN7NfKBr9AvDfzXFLAyol85CIfkjtW38mDyC
	 smJAjhWqtpBlA==
Date: Mon, 29 Jun 2026 18:04:28 -0700
Subject: [PATCH 1/2] xfs_db: fix type conversions
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278130137.858605.8332495915212788608.stgit@frogsfrogsfrogs>
In-Reply-To: <178278130113.858605.5206441223016436305.stgit@frogsfrogsfrogs>
References: <178278130113.858605.5206441223016436305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While debugging rtrefcount problems, I noticed the following brokenness
in the debugger:

 # xfs_db /dev/sdf -c 'path -m /rtgroups/0.refcount' -c 'type text' -c print -c stack
 000:  24 84 4b 15 74 55 00 00 c0 5d 40 15 74 55 00 00  ..K.tU......tU..
 010:  48 9c 4b 15 74 55 00 00 00 00 00 00 00 00 00 00  H.K.tU..........
 020:  50 f3 41 15 74 55 00 00 01 00 00 00 01 00 00 00  P.A.tU..........
 030:  00 00 00 00 00 00 00 00 61 9c 4b 15 74 55 00 00  ........a.K.tU..
 040:  4f 9c 4b 15 74 55 00 00 00 00 00 00 00 00 00 00  O.K.tU..........
 050:  43 9e 4b 15 74 55 00 00 00 00 00 00 00 00 00 00  C.K.tU..........
 060:  c0 fc 41 15 74 55 00 00 00 00 00 00 00 00 00 00  ..A.tU..........
 070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 080:  f1 9d 4b 15 74 55 00 00 90 f7 41 15 74 55 00 00  ..K.tU....A.tU..
 090:  c4 9e 4b 15 74 55 00 00 00 00 00 00 00 00 00 00  ..K.tU..........
 0a0:  80 0f 42 15 74 55 00 00 00 00 00 00 ff ff ff ff  ..B.tU..........
 0b0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 0c0:  d5 9e 4b 15 74 55 00 00 00 0c 42 15 74 55 00 00  ..K.tU....B.tU..
 0d0:  d0 06 00 00 00 00 00 00 40 00 00 00 00 00 00 00  ................
 0e0:  90 87 fe 23 74 55 00 00 01 00 00 00 ad 7f 00 00  ....tU..........
 0f0:  00 00 00 00 00 00 00 00 80 83 fe 23 74 55 00 00  ............tU..
 100:  c0 7f fe 23 74 55 00 00 00 00 00 00 00 00 00 00  ....tU..........
 110:  00 00 00 00 00 00 22 9d 41 00 00 00 00 00 00 00  ........A.......
 120:  2f 75 73 72 2f 73 68 61 72 65 2f 6c 6f 63 61 6c  .usr.share.local
 130:  65 2f 65 6e 2e 55 54 46 2d 38 2e 75 74 66 38 2f  e.en.UTF.8.utf8.
 140:  4c 43 5f 4d 45 53 53 41 47 45 53 2f 78 66 73 70  LC.MESSAGES.xfsp
 150:  72 6f 67 73 2e 6d 6f 00 51 00 00 00 00 00 00 00  rogs.mo.Q.......
 160:  20 95 fe 23 74 55 00 00 01 00 00 00 ad 7f 00 00  ....tU..........
 170:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 180:  80 83 fe 23 74 55 00 00 e0 94 fe 23 74 55 00 00  ....tU......tU..
 190:  c0 7f fe 23 74 55 00 00 00 00 00 00 00 00 00 00  ....tU..........
 1a0:  00 00 00 00 00 00 22 9d 41 00 00 00 00 00 00 00  ........A.......
 1b0:  e9 3f 42 57 05 00 00 00 5a 01 d3 41 44 71 76 92  ..BW....Z..ADqv.
 1c0:  65 2f 65 6e 5f 55 53 2e 55 54 46 2d 38 2f 4c 43  e.en.US.UTF.8.LC
 1d0:  5f 4d 45 53 53 41 47 45 53 2f 78 66 73 70 72 6f  .MESSAGES.xfspro
 1e0:  67 73 2e 6d 6f 00 00 28 21 00 00 00 00 00 00 00  gs.mo...........
 1f0:  09 48 bc 74 71 55 00 00 5a 01 d3 41 44 71 76 92  .H.tqU..Z..ADqv.
 1:
         byte offset 2642479104, length 512
         buffer block 5161088 (fsbno 1064976), 1 bb
         inode 8519812, dir inode -1, type text

The rtrefcount btree inode is not *so* corrupt that it's full of random
i18n garbage; valgrind confirms that we're walking off the end of
iocur_top->buf.  Looking at what set_iocur_type does, I think it should
be (re)reading the existing buffer while preserving the existing
boff/len fields.  Instead, it resets the buffer size to 1 fssector, but,
oddly, preserving boff (and not len).  This is why we go off the end of
the buffer.

After fixing, I get:

 # xfs_db /dev/sdf -c 'path -m /rtgroups/0.refcount' -c 'type text' -c print -c stack
 000:  49 4e 80 00 03 05 00 08 00 00 00 00 00 00 00 00  IN..............
 010:  00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
 020:  35 ed d7 36 1e e0 aa 20 35 ed d7 36 1e e0 aa 20  5..6....5..6....
 030:  35 ed d7 36 1e e0 ae 08 00 00 00 00 00 00 00 00  5..6............

Truncated for brevity; this is much better.

Cc: <linux-xfs@vger.kernel.org> # v5.18.0
Fixes: 0d376f6cf1799b ("xfs_db: take BB cluster offset into account when using 'type' cmd")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/io.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/db/io.c b/db/io.c
index 3841c0dcb86ead..fc9a25d4102482 100644
--- a/db/io.c
+++ b/db/io.c
@@ -682,8 +682,9 @@ set_iocur_type(
 	const typ_t	*type)
 {
 	/* type's size in basic blocks */
-	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
+	int		bb_count = iocur_top->blen;
 	int		boff = iocur_top->boff;
+	int		len = iocur_top->len;
 
 	/*
 	 * Inodes are special; verifier checks all inodes in the chunk, the
@@ -704,11 +705,15 @@ set_iocur_type(
 	}
 
 	/* adjust buffer size for types with fields & hence fsize() */
-	if (type->fields)
+	if (type->fields) {
 		bb_count = BTOBB(byteize(fsize(type->fields,
 				       iocur_top->data, 0, 0)));
+		len = BBTOB(bb_count);
+	}
+
 	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
 	set_cur_boff(boff);
+	iocur_top->len = len;
 }
 
 static void

