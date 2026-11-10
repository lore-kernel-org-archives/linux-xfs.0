Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.252
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245569;
	b=06oWzhNSIgwbuSrvZGFN4K8HLxTj2pLix2jh07Oo4DI4eHZYLSEi2XING6ZNe/ulMsOt
	 SJH0Ia9xUJEzjCyCzvro1cBJylFRfP5xinns/9fzS8hoB1XQkwipaaYykfC2p94tKlpro
	 XISvg+tTelqiFINcw7HkEFMlCihuF+DgpP+0V9xC80FsupINEzSyUjwdRV6xmVt+7ySi+
	 nQM4F4r3n5CIX/wwjrjRESkC445d/hh+EUgq52bSVVlSFb5Pis+rvwMyyT69IdakfvUbD
	 joT+0XLpsaTJPFtWbLVLNBrkH9WBYPdtwz1gzRAc0QxSVaDfFhSscpBCjLjGFT+mAiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245569;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tdN3CeEg68uIJzhvzT/ph7W8qSxkZkgZnCBjalX1+ro=;
	b=raCNwBZM8pkroMlLyHcgbdo5xlSRiNLUoqvesgrWyzyOmDzyy5ypKhneeU5jseNtmsuY
	 NQZJEFnAElWXo2wwe3tHjuRIfb9MunBG2lXV6Qoo3WaWCGlJlmEhbfP/2mNsGyZfo7qH2
	 qIV7x+XCWkZvLiVb3nnLNq3OfkjNDtdwJwCchsqsBnv9k9aHN4JxzaJBlc6FgpLSpChC/
	 j7Z6VfwLAb66TLb2xoWjd4uqIvVSmCe2NEY7hWcsBSgPFNKGd6pUs5RPFCDkpkaEgpBbA
	 55b2T/l07sx3yyWsTtGg0Ii5EXmpa/lsmU2zsZi8vZ9jspgcT0NKmWZTTrHcVgVJ83A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=yon9H9XH;
	arc=none smtp.remote-ip=162.62.57.252
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAE4606A331
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 17:32:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EAE4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=yon9H9XH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794245563; bh=tdN3CeEg68uIJzhvzT/ph7W8qSxkZkgZnCBjalX1+ro=;
	h=From:To:Cc:Subject:Date;
	b=yon9H9XHOWgOU32Ka6/7O4dwu7CWyVFmauGNYpsflanCMiJ3spPfVg3yxiAostBRk
	 sy0cWLQg7/wMgrku+BbpELp7gPtd3F4zCdjuS4ptGKmo0kU6CMqTSN67tV6KxhPzRb
	 n8lGcvKoahAgVyj9nxsZQxINP7yIszjD5MrGfQwQ=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 829A0ED6; Tue, 10 Nov 2026 01:32:41 +0800
X-QQ-mid: xmsmtpt1794245561tl4qf4eo7
Message-ID: <tencent_C48E4451F8984465A7BA7D338D003925980A@qq.com>
X-QQ-XMAILINFO: NwU6Bou9okj/iuWBvmoGAcHMc4pKxD3DIEL12NOOWeM9caeA9vCLLFxvTPMLJb
	 cNKEzefFA1yJe4794gWMEupLKqstSDmI2c1/rwIb/Y4xcSQlT3oTE5tHqwM26ACNHPTScBfrs2Ai
	 zf+juPHBIPY3qy/L79+5RUlgm+jE7XYjnxJZeDbaX5vBDS8EUGR1SccxGgzzrG7lqF5on4fXxNCx
	 tEh8cNApGM3iAAMdjkQdnXMxcVtfb8scuC/nhGLbwQt33BdeZsgsQwjOr1r2K51ht8WZ40GEDTTi
	 Xsr/inzqv32L6RzDEH/7jZstDM4oTAt06uVAKirMRQx+dHXo42LcCOK0jGr+9WaZUTPfDccH4RRI
	 M9XRX/4G76uUSkvMIpdyvuKLM7fyQEk9so3heqqCOcVzTYPm2vpE7GGn6E6tdhGE9myWgFDNJTk6
	 yMLqc9Lrti00+/X5bUpBG/tQHS99ewYSZolXd67nSI7uS1EtIsDrQvWYxEnAKTwmU/FQm4oiWctn
	 5sER4lN2p2Y6iHA3ILn43tl+LoOTje3FU75h7CyMir/JJfnleLTRgLzfm5OFhNQC8vpSspc4D2B6
	 scTlm8EsD9D8bbIbA/snuVlAcypPESDypZ73BdPs+fZD/71mIovxjaNkfuQTFsKYgnT2O6bWhews
	 CO0h92HM69nAeD4gzIQcdUFH283EJLbgTSw5Nlnokvs5mNUdUPtiEBMFRKfp6u0JrRrf1MLR8g8V
	 A0MgcjIPFUsxdoPSo8xtErpO5SoC30vja+cxFEuT5tAKs8+aPGzeiARKn1sH+pUE100RnEaAo+AM
	 bKjV9nNV2L5cbfT170sfYS2rXvqGsuENzUv9KbSyZyugSEQzLX87FBLzLCMm4bEr/dmkGajwOc65
	 hHJvm5QkBdMuccazBQ/rFhT+66LeUBAWI1x1gDD/3gfBCxLpQLgD0CodfCXH14Nb2UgviZGaSROU
	 Horu6UN9EdJphNFTsn46eRlNrp/TYAOknDRKF0G9fNY9FLh7940vpRe9dF8s8jCg7HvyAqR+Lwsq
	 t9/W0K/eUh7JdnMNF0l1/SFZBoIKQJFp1ty09p31OFo/SdCPe7Foubaj0FHCc=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
Subject: [PATCH] xfs: reject a continuation op with no buffered region in log
Date: Tue, 10 Nov 2026 20:00:00 +0800
X-OQ-MSGID: <patch-xfs-wascont-20261110@qq.com>
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

