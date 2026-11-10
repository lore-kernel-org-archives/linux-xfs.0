Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246690;
	b=onPxAJXf0jZV/SNvST47bn0y1lQsDLPF2+Z+Uckr8IEuUiG7pPFQTmhtLsjAgMaQ4aPk
	 +NBQKTM3RcKzd9GkXG3Hofwd1wHpATH9k9flwWP9Eal6QECC0pPTm87HuHcPC1DHDWDyp
	 6O9qYr/xoNR2KjB13D6RU7yVDoCVsgCAetaw7NWw9OSkOrmq++5ooK5CfSx+lNExoPAyi
	 ykuXfeOu+HKSbEACF7+veAL3Q8jA/Vrf5YiNX5csNwSQ6EkbhjOCdqGkQXqCfe/yNe9nZ
	 xsW/AmOkLuzjHClzyny6FQEV80l2PBQ5yVdm2mU7BC4vhQkFWXaOsPsUOjCh73jXpKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246690;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:In-Reply-To:
	 References:Date:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=CJ8xoLsujA6BYdAQSAFGg1S5b6h1Lafh7hjyTQPV7uk=;
	b=CNhKy4whZTNCpnir8i9u9SB4KfF0ij1WoJka54SaV4BHfoadV5Xes4Ff3mL+o5bERgQ7
	 rJvb8clY+5cj8NIW72vpP3wgPZVH2SUyAt1frps+plpso8YHRfSUoSZTzmimD2ZYYY1fF
	 K6uzvKle+ciT3QO/3J5+yQsN/yCLH2k5VOb8VQmb6pX5LNNH+ULI7eFAKfsYX5eb/5mXM
	 0vMPwDg37RyBOl/jKiKnKaKyd6tbqXHk2QZ58AWnwqHAzegdgEyK59OA20K/nLyAYC+JV
	 lwk8Vr2OMHMrL3uj1vC72oB8dRz0Vy2D2wLm+A2mAa74ZZS7TbNeiN1Sc7+GT7QKBqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Ayz3R91G;
	arc=none smtp.remote-ip=162.62.57.49
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE812606B54C;
	Mon,  9 Nov 2026 17:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE812606B54C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Ayz3R91G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794246678; bh=CJ8xoLsujA6BYdAQSAFGg1S5b6h1Lafh7hjyTQPV7uk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Ayz3R91G+9CQ8Zyn9CekA1GlB6AVz8sATMlE1Ofbo8ko8luo6EvaMju+T/LB13IdN
	 70tejbVaAGAFvtCzE0K2fT1lNLiUajNKKULAOVayciR7WXJMKStdrO5yxCZQ4qtBeP
	 7zqBybEJwgpCk3sb+LXvsPDVaUWESqtPviHaZBhY=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id CD102C1C; Tue, 10 Nov 2026 01:51:17 +0800
X-QQ-mid: xmsmtpt1794246677tyx02007z
Message-ID: <tencent_95938F7F54436AC677E38880538369551406@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuVH1jRJ41Adz4wUpg4A3/kAKRYd1Xc0g3CpMb4EHTj1l/6IDDI0
	 p9Mi++Rq94uvEhTtpBIgvmnF3eh4u77pBlDT4kmbuXNxkg7IH520TntMyeP+SFpzRPDOOQoCbPh6
	 5y6ZY7SWVkQ5nzBh3LXGcbt/LOXb0lWJZT57RL02M7uhwibz2a18A4f0cAYe78PQ4jIYRiz4c3ON
	 qB5IVJcvVqRCDcHx58oUSjMknHSCBgDuvj524jGxgJQI4T1/gP2NzmKHqkBD73hxqlBrwQI7l7yq
	 NY4MDifjEw/bYDrtVoLwjyuGh13A5TgjeauWziwiur3n52BkUnO1J5Tbv/leNabNrC0iV7DHfign
	 oJ4jZKljI2tN4WpDvZYA0PQt/fhq5HSimFVTl2F2zaP6pmk5tf7Mp6p3jHAhBa4sSwivp5zdL/im
	 kzt6PnFSQLxfrdxE/pvVloL9kX3OVlpmqJdXKYnzShdWLmJa2+KMTRVlnnyIPf4pc/THDs8W7yD3
	 NwJF8Gl/8HM8W2vIIR82llalwGeEyP3ZcRuhsC9E52nVH/b0E1TMS1Co8WYGsp6H0MC5RW9ijjN6
	 lZyXqJbp+gDsPDPR1VPYJtsiEPeFORm9LI1a427gdueeBn0VmH2UOAgvgLlAMDperWXL1MlGbVVG
	 9bJW8cKHQv5fm8QI+XaxazFXanIj2ZBQrItMvteKWGZ2hhBy06P49Own/TVBOd3GPDA9RWU4+cMb
	 s+kAbb8M1Cj5lG73oWOPREjXtWW2Ci+qDfZzyjMARkm1GWkMxRuS3yNzG/PNmb77pLrKqxqlhkay
	 MkgliCxrWHc6BwzsVG4p4fBbtjH8m4DPZrhYwE9YGM5Tb+hJe00Eca/G7siaRD++0aTkuoATcCMb
	 8wrmjNbac1iVJAF39jdnU+nT37isAVsLjotKLmH8UcmNxSQaZyEiDBJPKqHmt1RtDxD46niKIDsR
	 0S2Bz9E/svepFZiKrhcHZkKHNTqw0LrZA7RciOje6iUywmIqKaE+TYpUYPmDA1Al4+UIvmcn4CEi
	 +0xjZfHHAro9UkElkptFJW8BO3YdMtTIKk3e0fO7IYNMtc4GEwQI0nVAq/OD1NQtmeQU7dZwsTxN
	 SfqwY58kfB6+XPkfJlNAk4ubGoJsS/2nDQFAtuPeREQtG/enXGxa3aMhxyeg==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH v2] xfs: check the region index against ri_total in buffer log
 item recovery
X-OQ-MSGID: <patch-xfs-ritotal-v2-20261110@qq.com>
In-Reply-To: <avH-JslaJ4xlof4c@cronus.toxiclabs.cc>
References:
 <patch-xfs-ritotal-20261110@qq.com> <avH-JslaJ4xlof4c@cronus.toxiclabs.cc>
Date: Tue, 10 Nov 2026 23:30:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Carlos,

That was my mistake. I have fixed it: the version below is generated
with git diff from a clean tree and applies cleanly. No content
changes.

Both xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer()
walk the buffer data map run by run and index item->ri_buf[] with a
counter that is advanced once per run. The number of runs in the
on-disk bitmap has no relationship to the number of regions the log
item actually carries (ri_total, from blf_size), and the only bound on
the index is an ASSERT - either the mid-loop ASSERT on ri_buf[i] or the
trailing ASSERT(i == item->ri_total) - both of which compile away on
production kernels.

A crafted buffer log item with a data map that contains more runs than
blf_size claims regions walks the index past the end of ri_buf[] and
reads ri_buf[i].iov_base out of bounds. The destination side of
do_reg_buffer() is already validated for real since the CVE-2026-80536
fix ("... the only thing bounding the copy is an ASSERT(), which
compiles away on production kernels"); the source index was left to the
ASSERTs in both functions.

Validate the index before each ri_buf[] use, in both functions.

Tested with two crafted dirty-log images (mount(2) alone): one hits
do_reg_buffer (16 runs, blf_size 2), one hits do_inode_buffer
(alternating map, blf_size 2). Both previously produced
KASAN: slab-out-of-bounds; with this patch both fail recovery with the
new message, and the unmodified images still mount.

Reported-by: Guikun Yang <yangguikun19@qq.com>
Signed-off-by: Guikun Yang <yangguikun19@qq.com>
---
 fs/xfs/xfs_buf_item_recover.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 57929f115..ea749a8ab 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -486,6 +486,12 @@ xlog_recover_do_reg_buffer(
 		nbits = xfs_contig_bits(buf_f->blf_data_map,
 					buf_f->blf_map_size, bit);
 		ASSERT(nbits > 0);
+		if (XFS_IS_CORRUPT(mp, i >= item->ri_total)) {
+			xfs_alert(mp,
+	"Bad buffer log item dirty bitmap (region %d, %d regions) at daddr 0x%llx.",
+				i, item->ri_total, xfs_buf_daddr(bp));
+			return -EFSCORRUPTED;
+		}
 		ASSERT(item->ri_buf[i].iov_base != NULL);
 		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
 		/*
@@ -675,6 +681,13 @@ xlog_recover_do_inode_buffer(
 			nbits = xfs_contig_bits(buf_f->blf_data_map,
 						buf_f->blf_map_size, bit);
 			ASSERT(nbits > 0);
+			if (XFS_IS_CORRUPT(mp, item_index >= item->ri_total)) {
+				xfs_alert(mp,
+	"Bad inode buffer log item dirty bitmap (region %d, %d regions) at daddr 0x%llx.",
+					item_index, item->ri_total,
+					xfs_buf_daddr(bp));
+				return -EFSCORRUPTED;
+			}
 			reg_buf_offset = bit << XFS_BLF_SHIFT;
 			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
 			item_index++;

