Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6B742669A;
	Tue, 22 Sep 2026 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790064975; cv=none; b=ml2e0OhQ6qVD0yym63eBigx2ot/Nk3hHxP4ffNGBhrdpFsLTyR219g+7b1AByA5pODrejo9abDuXUDBAGN+C+Uud7s7r+XI/pQIk3yyKEqkRtN6HV2Ga7ymnUOk0MoZEc9In9dRBdfhEfvLLphINsTuu7iT4TvUXe2v0zwIU6Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790064975; c=relaxed/simple;
	bh=auunV/y9N1n6oeLRBWQXLkS6mNa7Qmirpv0pLEZMbaA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=VUDF3YoCHtO3iENtiuq83VTo8ZbFlvXRT4WtOv/mTtrS/+ipkLenEKdSkfj5WFRG1lTUZvrAxAUEFBFg8dqndLTKdXtJ929PyFGyqHn2xqbamt7iNY9nXXATJktHo+oPbq8shSX5bEAyfq+8qjMVeYpID1al0T8ZAvPvS7n5a78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=TvcWCrOf; arc=none smtp.client-ip=203.205.221.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="TvcWCrOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790064956; bh=gTMAuBymzwXbO4QhnxE1u8IF/SR9SGdLXudTQ8ga908=;
	h=From:To:Cc:Subject:Date;
	b=TvcWCrOf+5eIHNP0crKedfkzs/PI6fe0DxYha0FJcu5SusQGYaZ3KOkqdijmVOzhh
	 PSarbXuRNwnKMlzEyXsNA/QslNY4543ImFGX1rOXLA5svuGnJidjdMjkvP4TN+/gwG
	 gTPY8+s9P54j0Q/TXp4U05yzmXDNdDiS3DJxK+M0=
Received: from localhost.localdomain ([14.22.11.180])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 3A891A77; Tue, 22 Sep 2026 16:14:40 +0800
X-QQ-mid: xmsmtpt1790064880t24pduf66
Message-ID: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3Ju/YWiUVmyWq+p0LijjV/+Sxyvjhv7UyUTELPNjyURWALa3fsqNr
	 02KXGJk8YwB/vT1Fka20J8U1R41LL1gRxB/1kzpelFluJc18yxSmxM4d1xyMby22FbR0KwQMqiCf
	 he8oJiOXrmZ2AK3iqVoBIwkVVHXwy5WeUpkSJq8S0BUG2TwvtGdqbdFQqiYVtex7M1eZCHONIsS2
	 bFNn6s7P7z5a7tRcgCSGBdjKX3MadK+sG/sXJgKukbeSFtor/VAqp3VJR0NRBPCfYuFTKiK76e84
	 UhuhtpUGefgqt9/d3ayBkwSbGtQSGRFSRms1n+ScHo2sOIraJUU5fgKqYl0lTTVQFxTwigN1kPhG
	 yIGp361r96MjIH+7rFIMcHqXlVTlkQzGx6bp5Sna8lXO73OELtTdrDm3RWapmJlgYRxWjNfJ8hHv
	 nkty9GEc5Itm0Rmd6nSZQzxW4BphU6FUJvpzQtLQ+5b+37Et4YRsAgGi05uXHig1QuWevErnJ1SO
	 gRzjQSeNcI8McQCCjhG/Yr7HUpyaCKLFlbFX39r2UDW4JcjHMg2PSl+L2xBI7bXPzVDTvDADWpyI
	 z87QEJFUUFd6f7b3+EsGM3nNHCUtOMn1BcgP3KlHXaFUr5tAKaANC3Yb3Xmbmp1D7My/r3T9Ow59
	 Tcdsx25yanCujEUvplOOmXschEv7RXpngbC3aAtMRzv+OBB7Dd45Szm/AmX3lUX5d3Ap2I8g+Qxw
	 yLF3t+Ho8Icg2vrfT7w16WmAVkH11XMnrbYbrckGdm/JjbDMs+o0P8QmVayFFjTIfZzo+dXW1S3V
	 sRPz1kIlu55741a6P1kuACv+qaA0hjY0uDVe7CrEsdLhw97NkU2H/MZPX2gCnLpFlAUCD4moi4Xr
	 MsJm8G7ixt8vd5xnGTSLXTjIEYwk1zV02OEfoKmpPASLAmRHEUG3QKT+0Ho9CnVOG2A7aABcRHfe
	 CoI55pyD6jq+lB5Z7tjEQhpgntff11x3YSGMRwHtsdmRjNZAokk0nleYbwD9WgHFDg1Zivs+hiBi
	 2zfRRzS4LHoAt1rZofHZ0CcsZ6YRgf+rn3d7eKDTCux0cxPrGOGDDjBB5Wfbr4AO/09w4PXi1iNK
	 MKYg8hooo674kAlrU=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: MingTao Huang <1037827920@qq.com>
To: Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	MingTao Huang <mintaohuang@tencent.com>
Subject: [PATCH] xfs: fix skipped flushing items not counted in xfsaild_push()
Date: Tue, 22 Sep 2026 16:14:29 +0800
X-OQ-MSGID: <20260922081429.627321-1-1037827920@qq.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: MingTao Huang <mintaohuang@tencent.com>

Commit f3f7ae68a4ea ("xfs: skip flushing log items during push")
introduced a fast path in xfsaild_push() that uses
test_bit(XFS_LI_FLUSHING) to skip log items already being
flushed.  However, the fast path jumps directly to the
next_item label, bypassing flushing++, count++, and the
ail_last_pushed_lsn update.  This causes three problems:

1. The loop exit condition "count > 1000" becomes much harder to
   trigger.  count was meant to track every item visited, but now it
   only increments for non-flushing items that enter
   xfsaild_push_item().  Each such item typically triggers an inode
   cluster flush that marks dozens of neighbouring inodes as flushing,
   so count effectively counts cluster flushes rather than individual
   items.  The threshold shifts from 1000 items to ~1000 clusters,
   letting the loop scan an order of magnitude more items per round.
   Each cluster flush adds a buffer to ail_buf_list, and the resulting
   oversized list causes xfs_buf_delwri_submit_nowait() -- which runs
   list_sort() plus per-buffer trylock and IO submission -- to take so
   long that the watchdog fires.

2. The timeout decision "(stuck + flushing) * 100 / count > 90" is
   computed without the fast-path flushing items, so the flushing ratio
   is severely under-reported.  When most of the AIL is flushing, the
   ratio appears near 0%.  xfsaild therefore selects
   "tout = 0" when it should select "tout = 20" (20 ms
   back-off to let IO complete).  The zero-backoff tight loop compounds
   the ail_buf_list accumulation across rounds.

3. ail_last_pushed_lsn is not advanced past flushing items, so the
   next push round restarts scanning from the same position, repeatedly
   traversing items that are still in-flight.

We hit this as a soft lockup during stress testing on an internal
kernel that includes commit f3f7ae68a4ea ("xfs: skip flushing log
items during push").  The xfsaild kthread was stuck for
22 seconds inside xfs_buf_delwri_submit_nowait(), called from
xfsaild_push(), processing an excessively large ail_buf_list:

  watchdog: BUG: soft lockup - CPU#48 stuck for 22s! [xfsaild/dm-1:4931]
  RIP: 0010:xfs_buf_delwri_submit_buffers+0xf2/0x250 [xfs]
  Call Trace:
   <TASK>
   xfsaild_push+0x19b/0x7d0 [xfs]
   xfsaild+0xb8/0x1a0 [xfs]
   kthread+0xcc/0x100
   ret_from_fork+0x5f/0xa0
   ret_from_fork_asm+0x1b/0x30
   </TASK>
  Kernel panic - not syncing: softlockup: hung tasks

Fix this by accounting for flushing items in the fast path -- increment
flushing and count, and update ail_last_pushed_lsn -- to match what the
XFS_ITEM_FLUSHING case in xfsaild_push_item() already does.  This
ensures the loop exit condition, the timeout ratio, and the resume
position all reflect the true state of the AIL.

Fixes: f3f7ae68a4ea ("xfs: skip flushing log items during push")
Signed-off-by: MingTao Huang <mintaohuang@tencent.com>
---
 fs/xfs/xfs_trans_ail.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 99a9bf3762b7..0f72cd4e6983 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -580,8 +580,12 @@ xfsaild_push(
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
 
-		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
+		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags)) {
+			flushing++;
+			count++;
+			ailp->ail_last_pushed_lsn = lsn;
 			goto next_item;
+		}
 
 		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
 		count++;
-- 
2.43.7

