Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50086371877
	for <linux-xfs@vger.kernel.org>; Sat,  8 Aug 2026 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786232433; cv=none; b=IiARa+BHwjs3xd/WGQQ07rApK8qpX/m4BhNr7Hp/DfVpAAAxHPa1/2sRVd513qUPbRgp+yUxcsEBymVdkcH8FxqxlVV22g5WA7aakEs8FRgDieFZbBvLZdwCFFl3C+BU+8cSKsSv6ockNOfu42oynphSqt6m0J960q/1kDKVK/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786232433; c=relaxed/simple;
	bh=bXl+qTSekfMI76nQMOaAgji96J8fMd0LAgDdt+hbuRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMPOuAKvYn4klYFgU3YAt5P4Ea3y1rn8mP9EyBQI/dRkqIYttDuJOS1RXDvSqJ7Ok4D50uaErVH7t+IfqMXibxdJ5bo0U//efVeV1urQlSHdmh4eRXSFV1crYBGaJHd8V2zNdckjXiFwYOtY4X9KsWsVXueG7usUNMGxg3/cX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=iZdG2NgZ; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="iZdG2NgZ"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5bfa60aa6caso14632e0c.2
        for <linux-xfs@vger.kernel.org>; Sat, 08 Aug 2026 16:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786232431; x=1786837231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JfnxvWXI36e8f0gw6H7fpo1CGOl18GKzKKkOiq2dJb0=;
        b=iZdG2NgZyHyAblm6FTxW0Jj8ZNCo2SDtUxAtjI8IwBjO365aGN887uzXb/sA2q9Tq/
         8ohfjKaDSbiiojbnJ9tuugYZixn8ZEW2L7o7OJnnZZhIcdb93466ReJLh/Y52b9PG8qO
         rqVeDfFAZRdtXvDXTsEawojpjyUFwvY8gqaSCQIMJyHktDFvXK6ZfC19CGwg4b27Hkxh
         UkilaW+QcFGKa747KvijGhIpo/NBITGF+GEdDW959MaZ9F4+Zym/Ycs2majUXxAxMVJy
         Ziu1gY/2akoHv4ImqPylATc0sS0Fwa7xqdbo7ZN2XobypGvSGlXwfIPyyhGE3X3UJ5q7
         ZWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786232431; x=1786837231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JfnxvWXI36e8f0gw6H7fpo1CGOl18GKzKKkOiq2dJb0=;
        b=ealJEq5bcVmAaUQh9oY7x2ZB069IkknBvQSg323kLatszlHfW4JgAHxIz8guCxH45I
         WZc94UjNdWumo712IH7vZWjYzQiCIIsxHjCiS7rAGnY5fonP5rrVAbEuvq9imoGMuF9Z
         hiRY0ZCZdDSIOfFeEyDCWZ1EZrVdrJBqo+lhKzpxKKAcAvRdRuLDZO4xx+hfWnlB1U53
         dZsO3iL37HCROUMlQhEHKlqLXAzlpE/e+TIYbiNeWdtXR0jOFsskebN5RsYieSNgfim0
         pnU7OuhVXhz9mkUP1zVp6wP05hVe0+nwuN5uZNm22bqToDSYEI2HtOztk+vzUukfeugt
         nbcA==
X-Forwarded-Encrypted: i=1; AHgh+RpbuHmrxI7hKkRxrD26ivoQkyD5pUZKFJeqdynPAI6ypJLUZFTbQk+oZ1+KU2bku7VEP65JKFRpHFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQQxF7YiOXBF5sp23M+rHWUmUQRwbKcaxRCzy8vOVWtYmN5hVU
	zg6blyGDZD7fDJlcTbCCMa/bt4PgMVaJ+WMxiyZRfvzh4VwIhhXwjazz5bcJkQ80DZI=
X-Gm-Gg: AR+sD10E6zga+o1DZ9oNkMB3TzB9Ma4iNugWZhHTlv54ISIR1KIxWUSjhEhacT0dpC4
	GJ1coQaq3qL+EfbweooTEA5oDq2hq4u8qN6NoXWuVQz0bBgHJ5YDCSjU0Hsfua9xDGPmhte4qli
	3+IrpewpaTN4EK9917olhUO4rBX1lfgotrtFL/vzHxm/lv0xVIdrtIFRHErMtAb4BQ87zV4hSSj
	VQvqxcrHZcsFsXyAEHzcIcYChg/f70IqlXunXlJXRt2GkT6/tDH2O6wyOv4WY39dbA5A7vVbvAT
	ABDX1BAsXx0WJ0q5OjVVo5bE87mckhdnz8Muwc99QjVDK6Y8JgPbWlxU8XeLvze9EJGYC6DOMaX
	468ZDiktT1j8zY9RNAJ9ooZ15+jO9gT2dBoGuGfm2kPav8vJcyHO/de6TdcKBYXwGpq7HgXUt7H
	8l+mKP1NNuhKYLjF4yA2xc1mYFeFWRauN+w/2dvan6qANKJVNvbHeG6bBVtc4JE5FR
X-Received: by 2002:a05:6122:6b8d:10b0:5c3:6e8a:4a22 with SMTP id 71dfb90a1353d-5c3d940b089mr2617912e0c.3.1786232431272;
        Sat, 08 Aug 2026 16:40:31 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c40b1a7e95sm2634346e0c.12.2026.08.08.16.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 16:40:30 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] xfs: correct the parent pointer space reservation comment
Date: Sat,  8 Aug 2026 17:40:21 -0600
Message-ID: <20260808234016.246054-11-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808234016.246054-7-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3996; i=floss@jetm.me; h=from:subject; bh=bXl+qTSekfMI76nQMOaAgji96J8fMd0LAgDdt+hbuRA=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqd75hXV/oVr9sQgFq7E3EglP/MSpHHLC6rElVU hYYMxeQqv+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCane+YQAKCRC17sMLqGd3 H2YUDACYGG0Qp9hRvlYZATPjI/4J5lecxM8q0DoyWscsNAk1JlErH1M+ZCNQys/8OIDIhJdfl8q 39K8/JvCt/0zJ3kyqvh02sjgjXvOGlBcTxsWMjwBociHdquHOOm8jJ4ndyhmU1MUljzmSdvhlV/ d6x/e0Fc8Yaq3eXpcW8h6Q/qsDhBymaX4jTyln9rf1whFvQTWoqHAUILbkJ+vIVbMiJeg9MpmcY Xli3O890Q+YZorxAi1tVb3+D9XRD2FB6eJQpgQD0OjFCLclxh5ksOAU43bkzsjHO2FFkDQwbnDu KySMlUWapWyQ82CKUx5BhdUe8d/llcyVkiNbkfuEc80sjZGhSMWhoKjr/dT/5eH8r394q0jHl4I z/VQJfkxBX//DDI98uphQUIBEzU3lGXWLybnkQA6sz7UTjMEtme8tuMlHyVSC+N/gDz2KuxXRPx 6sjk/VZO9AHd//amClYQxSpHsEvLE6Ip8Fscjqt7wO143u+UaaiIByAyYlMpJVg9hWlMs=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

The comment on xfs_parent_calc_space_res() claims parent pointers are
"always the first attr in an attr tree".  They are not: a parent pointer
is recorded per dirent, so an inode with N hardlinks carries N of them,
and `xfs_io -c "parent -p"` on a 31-link file lists 31.  By the Nth link
the attr fork is in leaf or node format and the insert is not into a
fresh tree.

The reservation itself is fine, which is what makes the comment worth
fixing rather than the code.  XFS_DAENTER_SPACE_RES() reserves
XFS_DA_NODE_MAXDEPTH blocks plus a bmap allowance for each, i.e. enough
to split every level of a maximum-depth attr dabtree.  That depth is a
format ceiling, not a runtime property, so the result cannot depend on
the format the fork happens to be in.  Anyone auditing a reservation
shortfall here reads the comment, concludes the sizing rests on an
assumption that demonstrably does not hold, and goes looking for a bug
that is not there.

Record why no double split allowance is needed either, since that is one
of two visible differences from xfs_attr_calc_size() and is not obvious
from the expression: a parent pointer's name is a dirent name and its
value is a struct xfs_parent_rec, so the leaf entry is local and at most
round_up(3 + 255 + 12, 4) = 272 bytes.  Parent pointers require V5 and
therefore XFS_MIN_CRC_BLOCKSIZE, so the smallest half-block this can be
compared against is 512 and the double split branch is unreachable on
every mountable geometry.  Locality is decided against a different
threshold, xfs_attr_leaf_entsize_local_max() at three quarters of a
block, which the 272 bytes also clears.

Record the other difference too.  The second term hands a byte count to
XFS_NEXTENTADD_SPACE_RES(), whose parameter counts mappings, so it asks
for more extent-add allowance than the one mapping a parent pointer
adds.  The factor depends on the block size, because the macro divides
by XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(), so the comment says only that it
over-reserves - a patch whose whole point is that the old comment stated
a geometry-dependent thing as invariant should not do the same.  That it
over-reserves is why it is not a bug and why this patch leaves it alone.

Signed-off-by: Javier Tia <floss@jetm.me>
---
 fs/xfs/libxfs/xfs_trans_space.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index 9b8f495c9049..c4cd547033e5 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -22,8 +22,23 @@ xfs_parent_calc_space_res(
 	unsigned int		namelen)
 {
 	/*
-	 * Parent pointers are always the first attr in an attr tree, and never
-	 * larger than a block
+	 * A parent pointer is recorded per dirent, so an inode with N links
+	 * carries N of them and the attr fork can already be in leaf or node
+	 * format when one is added.  That does not affect the reservation:
+	 * XFS_DAENTER_SPACE_RES covers a split at every level of a
+	 * maximum-depth attr dabtree, whatever format the fork is in now.
+	 *
+	 * The name is a dirent name and the value is a struct xfs_parent_rec,
+	 * so the leaf entry is always local and never exceeds 272 bytes.
+	 * Parent pointers require V5, hence a 1k minimum block size, so the
+	 * entry always stays under half a block and this needs none of the
+	 * double split allowance that xfs_attr_calc_size() makes.
+	 *
+	 * The second term hands a byte count to a macro whose parameter counts
+	 * mappings, so it asks for more extent-add allowance than the single
+	 * mapping a parent pointer adds - how much more depends on the block
+	 * size.  It over-reserves either way, which is why it is left alone:
+	 * correcting the unit would shrink a reservation that is only generous.
 	 */
 	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
-- 
Javier Tia

