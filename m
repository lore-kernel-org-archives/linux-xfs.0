Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B6FC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyiEoTvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5677BC433C7;
	Sun, 31 Dec 2023 23:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066345;
	bh=0V1mRCQ+Bkkeq+VSeGRgrm1lRnbR85uvxH1EhYSQawc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XyiEoTvoS0T9PVycGx+ExmOD4brlI2N8BCx954uViKiT0ntg5+jXlpMiH+5JGBYl6
	 80mHGORTmiCrM4lCO9A9npcZpgBOMuohIx+xeQuprovCAxNr/HlmvjEqHUKH93It4I
	 Y2pbzSWeqwXX7wkukms20L4B5l+jJLQe0O4Wetk1vch0t+g4Fs0KJW15YqKE+zzg5z
	 318X3iBLoUUdP4/G7iUAbuuDYRJYc36d5Khh7+2Np5ihyNORJJqM4ytt0QDHp7sg/Z
	 PflrMX6X16zvlX2PRrHoGCf82H7ZzRh0pHOCR0xtrCIrN22VtsRTgKW17Lf/ERcVaw
	 OkZciuvpwxULw==
Date: Sun, 31 Dec 2023 15:45:44 -0800
Subject: [PATCH 4/8] xfs_db: access realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011073.1810817.1581926935535918090.stgit@frogsfrogsfrogs>
In-Reply-To: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
References: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the ability to point the io cursor at the realtime
device, let's make it so that the "dblock" command can walk the contents
of realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |   17 +++++++++++++++--
 db/faddr.c |    4 +++-
 2 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/db/block.c b/db/block.c
index d064fbed5aa..ae8744685b0 100644
--- a/db/block.c
+++ b/db/block.c
@@ -195,6 +195,13 @@ dblock_help(void)
 ));
 }
 
+static inline bool
+is_rtfile(
+	struct xfs_dinode	*dip)
+{
+	return dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+}
+
 static int
 dblock_f(
 	int		argc,
@@ -234,8 +241,14 @@ dblock_f(
 	ASSERT(typtab[type].typnm == type);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
-		nb * blkbb, DB_RING_ADD, nex > 1 ? &bbmap : NULL);
+	if (is_rtfile(iocur_top->data))
+		set_rt_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
+	else
+		set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
 	free(bmp);
 	return 0;
 }
diff --git a/db/faddr.c b/db/faddr.c
index ec4aae68bb5..fd65b86b5e9 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -323,7 +323,9 @@ fa_drtbno(
 		dbprintf(_("null block number, cannot set new addr\n"));
 		return;
 	}
-	/* need set_cur to understand rt subvolume */
+
+	set_rt_cur(&typtab[next], (int64_t)XFS_FSB_TO_BB(mp, bno), blkbb,
+			DB_RING_ADD, NULL);
 }
 
 /*ARGSUSED*/

