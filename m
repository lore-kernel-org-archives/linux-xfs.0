Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF94C1C62B1;
	Tue,  3 Sep 2024 07:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725349213; cv=none; b=iv/WVW4eh1mGudkO4DbR4Vqf6sirKjvabRnJpvS1N94eOo1844xvvnOPLI7jZ47pke9TMyxlAZX8bflsxYttM+lQt4TAQsjxNncKjcOn8cjbPdi6U1dGzRqnMEUWRqba4sIjwbrbe27XcbDkhIMjUYzelTz3VDrpn08h3psX0y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725349213; c=relaxed/simple;
	bh=8cidSUX7dYCBHzErI7ec7JRJK9m47LPdDqDX0W1QFWY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kPqeq3f+a19QdZvQSeN/79ukn/qfyUP4qGX+HgUcWr5TawzeDtDx7Z/Xb7ZhdZUuYz/LiLJYbJ0f0JkWVFUaUpn7Qk8xDYIxm3524HRqbFoshliqlBXlHbL3ScsAFhDzv3o7KhqNum4BLw4wCJXvxWx5ebAD4HytVa/QD+OTQT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowADHz39QvdZmWjvAAA--.34400S2;
	Tue, 03 Sep 2024 15:40:00 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: chandan.babu@oracle.com,
	djwong@kernel.org,
	aalbersh@redhat.com,
	willy@infradead.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] xfs: convert comma to semicolon
Date: Tue,  3 Sep 2024 15:39:31 +0800
Message-Id: <20240903073931.781113-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHz39QvdZmWjvAAA--.34400S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4UZF15Zr47GrWDAr18Xwb_yoW3uwc_Ja
	1Ik3yxG3yUtFnrA3ZrtrsYvF45XFyIyrs3ua4SqFyYy34UJF1UXF1kXr1jgFn8WFy5W343
	CryjqF1akFyFyjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbskFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
	IFyTuYvjfUnrWFUUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace a comma between expression statements by a semicolon.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4c44ce1c8a64..5a55819f50f3 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -525,7 +525,7 @@ xfs_attr_rmtval_set_value(
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
 
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
 		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
-- 
2.25.1

