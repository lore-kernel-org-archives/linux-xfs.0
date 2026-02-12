Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431D0346E5A
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904957; cv=none; b=NDTXSbRBfJD/m0al3y3Hw21Li+jD3PeI9Pw6WTAbBxwXPzdHrPVT1G6MmMKK5u9gOu7pffZlNrWvAmFa9AEzieisfumOjuNZTDL0R3UnV79UB3IGWv3Y90GX+N/1LMnQ83eLyJYlXjmq0+7Kh2Shydx65rwx0FXtYl/2+Ylo+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904957; c=relaxed/simple;
	bh=Cy5x7pNkqHtFPs38K4LJr+4QTFKIiI34X2JeBe3avwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFpUF00X4b5EzDJEasJSnbsABMDCKvpPSyDg3Igcp9ul8g/FPI6u4X3CwwUiESjHLoZiP1ZebmBf6Th6GNdRVQY751RuekkSlx6vaKudC8UBqUpEx7kKW+rWUhZQ2eYfE/dmjfg22k3gROqLq1EXHSTzyJ5AQHab/jIQSWhy91I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N8I8A2zM; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8I8A2zM"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so3253979a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 06:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770904955; x=1771509755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Bg4Xi5n+PMmeyuEfeACeqqg53wdKugMTHDGl5jgKX8=;
        b=N8I8A2zMQlb8JfzZKTLVskQA3YjKxrjzd0Aa91UmQ8VtfAH+RnS0q2k0ZgxYH2FlPZ
         14LiOBDo3fbttayuIhjDylEXe23KrfVPXfQ39D3umWROzSUusbXRvRv637/btXrS1n8m
         5FLzICNBZQkIuyaWvAhdLruGSrfStjb7QlqtRirvBbgnZLsmAERAyGoA8tIBU6lAPncS
         06x4/XhSd5ch1bQBNdHAT9kE8aMx7uc80qUNI1K/wQWG+TeO1Mq9syLYLggdwnCONs4J
         8lJSezZ6OSdlRW9nOGIfqb0XmwNmMqrWmZcbergWJE6kp5iBxj0h9kC85ulgAOEPcSs2
         GahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770904955; x=1771509755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Bg4Xi5n+PMmeyuEfeACeqqg53wdKugMTHDGl5jgKX8=;
        b=EFkMWW6CjIKLvtcMhDuV4kncs/cpdm+SPfA28nCuVURIHXFkc+MGIYQdkSJLXgHopf
         wpJ7QrltAZ4YtyX/7N8ihIITOgWNclDWreNWqoH6HDyB/8aZl+pWpbxLa6zWL04RAgz1
         OPVSqCtBE0obFI+ANXpJ28uU8K7X/V3sGJqN7Lm3TlgCBirHp/WkA6xov1TxoMkWN4S5
         4L7stFQDYG54MBqtCvfhBWeKWmuXyJLmgRRUjldugYVdLBFRQQ65s/DSDNnI+G8K8UeA
         4T5TIgn/b4ZFh3126dE6FKaT5hxnwtMLTfNwGB+DT2PpNQMKjIHbNscxLbk+zT39vXJL
         1LRg==
X-Gm-Message-State: AOJu0Yz2Hczy/a7k95uZAIh/K5qH2kbXbPRi+cSlHOzQnZ5uvlgNf9OE
	HaajX4seLLBm/971UtZSThmP8W5NyzP0qgst1V1C1dVNRJYCYIwUmMfV
X-Gm-Gg: AZuq6aJibRLNpwOTf9YiEgsh6uXZLgABIFPGY+1SQO+Q8A1naSkJCsxKpJgW8c7gYhR
	rGD+5YSC1HnSzdx5FIkE4H9DEu9NjQ7suuHXxuLDfnDJNlyEpO0ZbTjrBXee3in106DU/+oWzp6
	O7izMh2B7mn3p2lzyah9AJqjWRnoW0xGHKu5aZvhLq5IVOl6GMElSfS/rY+SDO45hJrgf3IC02V
	tx35+jZ+mCYNypk/pqwi8DWS6JC698rS/PU59L/bCZtSEBZfuoD9MtBetS3FgtYlcFZQkwag45I
	tYe5Y9enCogEr7TNPW4IEq89YVH0XvZW0qItk+3K0L7mCVj0VsMellTyCFBd5BzRFY+jiZihSDw
	VUeM/L9JHuXkvFJMeIl8T53R2y8NGkc2PFOdx4Qhp5OTjWJv3KRJUoPsCaxuZlVVy5zEkBQTJQ0
	3N9dN+KbpzF0/4v+53fr+zelb5e2BJ0C+udpX7u1NFLd5ID2urQEXauQeh/fr+1CsqW/jY2I2A6
	uOeDcd+TQ==
X-Received: by 2002:a17:902:ea0e:b0:2a7:c2d5:bcd7 with SMTP id d9443c01a7336-2ab399aebc2mr26253015ad.20.1770904955187;
        Thu, 12 Feb 2026 06:02:35 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.226.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e367b7esm5116590b3a.4.2026.02.12.06.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 06:02:34 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 1/4] xfs: Fix xfs_last_rt_bmblock()
Date: Thu, 12 Feb 2026 19:31:44 +0530
Message-ID: <8b93afb5feaef3fef206c5e4a6a5f83a6d63b53b.1770904484.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bug description:

If the size of the last rtgroup i.e, the rtg passed to
xfs_last_rt_bmblock() is such that the last rtextent falls in 0th word
offset of a bmblock of the bitmap file tracking this (last) rtgroup,
then in that case xfs_last_rt_bmblock() incorrectly returns the next
bmblock number instead of the current/last used bmblock number.
When xfs_last_rt_bmblock() incorrectly returns the next bmblock,
the loop to grow/modify the bmblocks in xfs_growfs_rtg() doesn't
execute and xfs_growfs basically does a nop in certain cases.

xfs_growfs will do a nop when the new size of the fs will have the same
number of rtgroups i.e, we are only growing the last rtgroup.

Reproduce:
$ mkfs.xfs -m metadir=0 -r rtdev=/dev/loop1 /dev/loop0 \
	-r rgsize=32768b,size=32769b -f
$ mount -o rtdev=/dev/loop1 /dev/loop0 /mnt/scratch
$ xfs_growfs -R $(( 32769 + 1 )) /mnt/scratch
$ xfs_info /mnt/scratch | grep rtextents
$ # We can see that rtextents hasn't changed

Fix:
Fix this by returning the current/last used bmblock when the last
rtgroup size is not a multiple xfs_rtbitmap_rtx_per_rbmblock()
and the next bmblock when the rtgroup size is a multiple of
xfs_rtbitmap_rtx_per_rbmblock() i.e, the existing blocks are
completely used up.
Also, I have renamed xfs_last_rt_bmblock() to
xfs_last_rt_bmblock_to_extend() to signify that this function
returns the bmblock number to extend and NOT always the last used
bmblock number.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a12ffed12391..a7a0859ed47f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1079,17 +1079,27 @@ xfs_last_rtgroup_extents(
 }
 
 /*
- * Calculate the last rbmblock currently used.
+ * This will return the bitmap block number (indexed at 0) that will be
+ * extended/modified. There are 2 cases here:
+ * 1. The size of the rtg is such that it is a multiple of
+ *    xfs_rtbitmap_rtx_per_rbmblock() i.e, an integral number of bitmap blocks
+ *    are completely filled up. In this case, we should return
+ *    1 + (the last used bitmap block number).
+ * 2. The size of the rtg is not an multiple of xfs_rtbitmap_rtx_per_rbmblock().
+ *    Here we will return the block number of last used block number. In this
+ *    case, we will modify the last used bitmap block to extend the size of the
+ *    rtgroup.
  *
  * This also deals with the case where there were no rtextents before.
  */
 static xfs_fileoff_t
-xfs_last_rt_bmblock(
+xfs_last_rt_bmblock_to_extend(
 	struct xfs_rtgroup	*rtg)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
 	xfs_fileoff_t		bmbno = 0;
+	unsigned int		mod = 0;
 
 	ASSERT(!mp->m_sb.sb_rgcount || rgno >= mp->m_sb.sb_rgcount - 1);
 
@@ -1097,9 +1107,16 @@ xfs_last_rt_bmblock(
 		xfs_rtxnum_t	nrext = xfs_last_rtgroup_extents(mp);
 
 		/* Also fill up the previous block if not entirely full. */
-		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext);
-		if (xfs_rtx_to_rbmword(mp, nrext) != 0)
-			bmbno--;
+		/* We are doing a -1 to convert it to a 0 based index */
+		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext) - 1;
+		div_u64_rem(nrext, xfs_rtbitmap_rtx_per_rbmblock(mp), &mod);
+		/*
+		 * mod = 0 means that all the current blocks are full. So
+		 * return the next block number to be used for the rtgroup
+		 * growth.
+		 */
+		if (mod == 0)
+			bmbno++;
 	}
 
 	return bmbno;
@@ -1204,7 +1221,8 @@ xfs_growfs_rtg(
 			goto out_rele;
 	}
 
-	for (bmbno = xfs_last_rt_bmblock(rtg); bmbno < bmblocks; bmbno++) {
+	for (bmbno = xfs_last_rt_bmblock_to_extend(rtg); bmbno < bmblocks;
+			bmbno++) {
 		error = xfs_growfs_rt_bmblock(rtg, nrblocks, rextsize, bmbno);
 		if (error)
 			goto out_error;
-- 
2.43.5

