Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.58.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245608;
	b=aPQc398+b5d8dJUjPD5JPCcH3RIcXJHcbP5mwe904R+i54XUWz7G1IwIq9c2IN7an72L
	 yxLdPV5JlIQg0AB4/J1Hc3uFRX1UwGA1aaWOVuDxrPgsSaX8K3XFtogvIy81yWwRIqymZ
	 v74i7gmZAwuthCpiquTNZgh7qRYozaOlaa0iqryZzeUdNxlOvPLJf6UiG1JyvAVvMWY+S
	 C5wURUEepjdep0LaJ0JCoanRqdKHMAP59koP9gl6twURX4FGa/cxXnjuKDo8EPjEHP1l0
	 omzuGZIGcc7yJ5VltnKnbERcv/36A7JMlLJuZvqzuI9KQfdK+VlKZLQ7UC33YnDdGPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245608;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dUKIJ/XyzMoGqH+elSoxlwUX6nrAsxgspguzZjb2vhk=;
	b=a2vx5WxmH2X96uPqOPBUUwQpY4Nq5wkXs4bpJYcb+77TIHBUzR5r2oF/3Pho1sJdv27d
	 1+Twb5M4fIqlpFmtw4wOgx3r1kyG7FuQodwSh4pTCkTWI+0xZ97WHk2tNbkeEb7ZHubdo
	 oB8ZSD52yYQkz8Mr56miEf010i55+21fuPpuY4hKmz4CJFu41EqGVK63tSMN1cupxIptk
	 ppNdMdeprI99IDN6cFP7SyPKtcvVsympz7O5p/LB04OaKcr/JT00FGUKRLg41CPehIvTD
	 gadG61KwEKhGNi5qk3iMuLBAO11qJrXk9daR7ftXStJ4A1EtpLBa+LDo1nzsRaDCkQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=qHnCBDEa;
	arc=none smtp.remote-ip=162.62.58.216
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F20606A321;
	Mon,  9 Nov 2026 17:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0F20606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=qHnCBDEa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794245602; bh=dUKIJ/XyzMoGqH+elSoxlwUX6nrAsxgspguzZjb2vhk=;
	h=From:To:Cc:Subject:Date;
	b=qHnCBDEaAMLH7Q8XddFhi6oOved6PquxyDIUwl8+9AIWoqByFUcFMZmAHaRWSjKdA
	 fvzy5cYzk3vXPTjkMDwLfoqMyu3tAwwblKNMj2jctCSV7GR0cJnTGhlr8dRKNW4d91
	 Y/czNTh1lvM49f7325fqoP3kea+a4RlNkt+urZCs=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 854B44ED; Tue, 10 Nov 2026 01:33:20 +0800
X-QQ-mid: xmsmtpt1794245600t9mvu9umj
Message-ID: <tencent_184425A5E27EBF8CC03B3D988647BDFA5C0A@qq.com>
X-QQ-XMAILINFO: OeJ9zRfntlNP6oALGb+HWo7FwJX7ssaY9/P9tD1Q1dyMM789M2YlwG88Lst9FJ
	 b5qrfnGB8RoTi+7j/o4OqE/r5WMMW8GiS+wzIs+yzjjKdMN1gA6U0qeZ/SomCtN8iPWhD0pLKPwf
	 SM/rwT8v4+rutNMzJhR2Qt8ogzkiew5BFfq9ezc+vv53GTqIMnvC2CyVAH7lzDfes3QmfCrcejqU
	 FKKHj/TvX9v47ZugT9bsOKZ9mRLpmVj6V34gGRP8/DV36dE0wvh6NKUs80TRPv2h1uSSZEtRfs7r
	 z9KhJZbd4KSY1a308Kd2/KqAywBfBZ1rWgyHU+D1fLXlG9kWEv2NwmCggh/C2PyZeMG8J5T+VA65
	 IhNHxw30o/wnAL25DpCaFtf674ehv9KdKzJpfRJIaKbM4a1uidHK/YDEewGvKSqX1/240FaPIWBL
	 7G3z5KQEyIRSXB/IbVGHc7/RRt7XeSuFcCBVk57t0JIIguQpMpyi6QJ+57GlBVkcvRJH2y6MQTwu
	 Wwc23VF6i3dacbvzKRSIdKPo3wziPz4asscfJILB0xUNFsP5Wad9AINiw4ZhKkgDZxhX8VKCUh2Z
	 0spjsNf6IInzo5aJSL3as/e3XYAKPDoTZouC+6XjcSKd3RMCorncUPo6UoUtuUzEEvinE2egC1Zb
	 23lVgX/lMS4hLmxBawtbWLsYIn2ComnHjW7uRnZyBBJSME6I3oGllETc4zDpqVgWGoRR6fGcP69K
	 GFlIWrT/Nq0COIjHMSQ/nS7SNrVJHZO9diiutoTbQfWdbd1gvwESQvlnCD8vAFN8pQp0KS3sg1WE
	 mFTm2+/U0cgdthj+GMRnlsLC0TLCDGdCTaYc9lsJRk9R8s4iWREzXhSqre8vfVW6qI27Vo8RWwbb
	 boIDFykhpO9tztjxPywoHURtukuIG/Z1O+47WQRRHAXl7++nFiHTel08PdCO6U1+jB7lw2YYpN01
	 U4BlpvIbwbGyMdjrnJl7mY9LipD/MqZ3p0Lxt3NG/V62F8zWfST1s+ssrnCBuovBulkyBuu+NE9P
	 JF5wqtO+ojeToxgtuh7Zs66UhkWxsNxlNQyJLhSMzXYZ79zGGrTKtv3Sh2MBSSJ+Jb10g0ReodjQ
	 nFVTlq0j8y2uUd92nRJLoOL4XkifOgEG3p8fkdAsK4TqHw/WHrOg2QPXx3Dg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject:
 [PATCH] xfs: reject a continuation op with no buffered region in log recovery
Date: Tue, 10 Nov 2026 21:00:00 +0800
X-OQ-MSGID: <patch-xfs-wascont-v2-20261110@qq.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

xlog_recover_add_to_cont_trans() takes the tail item of the transaction
and indexes ri_buf[ri_cnt - 1] without checking that the item has any
region buffered:

	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
			  ri_list);
	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;

An item created by xlog_recover_add_item() has ri_cnt == 0 and
ri_buf == NULL - the transaction header itself is copied into
trans->r_theader, not into the item - so this evaluates to NULL[-1].
xlog_recovery_process_trans() dispatches to this function for any op
whose header carries XLOG_WAS_CONT_TRANS, and nothing on the way
checks that flag sequence against the item state; the only related
assertion in the recovery code is XFS_DEBUG-only.

A crafted dirty log with a valid transaction header followed by an op
header with XLOG_WAS_CONT_TRANS therefore faults at mount time on a
stock kernel, without any sanitizer enabled:

  BUG: unable to handle page fault for address: fffffffffffffff0
  #PF: supervisor read access in kernel mode
  Oops: 0000 [#1] SMP
  RIP: xlog_recover_add_to_cont_trans+0xf9/0x460
   xlog_recovery_process_trans
   xlog_recover_process_ophdr
   xlog_recover_process_data
   xlog_recover_process
   xlog_do_recovery_pass

Note that reaching it does not require an actual split region: a single
continuation op right after the transaction header is enough, because
the dispatcher never checks that the previous region had a buffer
attached.

Treat it as log corruption and fail recovery, matching the other
-EFSCORRUPTED paths in this file.

Reported-by: Guikun Yang <yangguikun19@qq.com>
Signed-off-by: Guikun Yang <yangguikun19@qq.com>
---
Tested on a crafted dirty-log image (real mkfs.xfs, files, sync, crash,
then the first region op after the transaction header gets oh_flags
0x08 and the v2 record CRC is recomputed): the modified image now fails
recovery with the new message, while the unmodified image still
recovers and mounts. The same image reproduced the NULL deref 3/3
before the patch.

 fs/xfs/xfs_log_recover.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1111111..2222222 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2147,6 +2147,11 @@ xlog_recover_add_to_cont_trans(
 	/* take the tail entry */
 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
 			  ri_list);
+	if (XFS_IS_CORRUPT(log->l_mp, item->ri_cnt == 0)) {
+		xfs_warn(log->l_mp,
+			 "%s: continuation with no buffered region", __func__);
+		return -EFSCORRUPTED;
+	}
 
 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
 	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
--
2.43.0

Resend note: the first posting went out with a truncated Subject line and
without linux-kernel on Cc - a defect in the tooling that sent it, no
content changed.

