Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567719;
	b=IWSCdGPD3QH6kvjQftGKOye5U9kujlbeFEnW7oudCVJyGCGKYrn7GhGMT464XHGjdoR/
	 uZ++dJ50FiKUlxAqut6YU5FUfnf+6PEazAo3TXwn09swKeK7kVE9jIoGDg4HmWGZ7Lxir
	 WX3ifQQZcyPJtJly6N6epSsX1l4tSGtGrijxpH9gv6BOd7GrDXP4Ny6OpSMMq0Vwlpiyj
	 RR+rXmLrZaCgmlqlO9fe97gyj/b8XQuHMOkGf/fbMqXEeo6DKhTxutONM0KMRKaY+PUlI
	 ErOPMWh/Uab+GDocEP5hVydaGUOSRvCjBR3UGJ8PwqkjChsJ72G2IhzquxjxrOwz3QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567719;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Mailer;
	bh=rWzmNEep0iX5uEZI1S/qGXTXdilbvqQY8SkirUZFpaM=;
	b=atT2b+AqlAh4rdrQdZjMZpHtxqKlRGnzLOWLBNQt468aLqqe461CvN7whwGhOsGUrU0R
	 ZEyJxmgz77BInxH3kQeYvQL1pHTQQWpCyvh7c5m/v1e2xp7NIh5VrQ8Df3q2Md05xGzOc
	 KKVM17LNOd+nRYWWpMfPjuGSN1hFhkNehAEIOeO0rt/3YC8EtVrGxH/tMolZo7Fq+ROUd
	 lgdF6J5jIhvATHHC5oAV2XgBVDSzU/UBdciL9XlewgW/dZSHtDHr3RSz/KY2kNoQFnb8p
	 ghnamtJHo98E/FFu1GbOlK3j7XRhhy9gwArsI+AtQss/SAGjN6Qm0p2E6+PufX/sXDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NeO4Av02;
	arc=none smtp.remote-ip=74.125.227.130
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2500C606A897
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 11:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2500C606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NeO4Av02
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-3b1478f06e3so168128a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 03:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794567718; x=1795172518; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rWzmNEep0iX5uEZI1S/qGXTXdilbvqQY8SkirUZFpaM=;
        b=NeO4Av02mt66gW5iSyZSWnxHKa5d3kti5aWxj9UnBPVzjlLCDPecR7obp/9NHPELUa
         7hEGjuL7LZjWSzgcTHZtgl+cLxmAZfDXJlXd+paPU+w6cOsv/RPzVHxYbwMSGCYs2Tcp
         zj81/ZAE/sOzZK/n8GVKrUkyl8Yz4pVKqkd3X+jkzdyibnjj8OGlpXmtLOeT0ozi+1rs
         yuWPtPXgMD/KYIdYzBQQEfwumoqPPhd7UbF4mbXFRgWvod12rEKU85cZ/P71g0kcTUwm
         46Qnr9/t6XHcBvMtkZ2Od3MZkpX4+Wha04q2DT6EPYGwpa/NB66eQ6F5T3WIb/E7PWyY
         LzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794567718; x=1795172518;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rWzmNEep0iX5uEZI1S/qGXTXdilbvqQY8SkirUZFpaM=;
        b=dhaSPburZ6oyytGpYQKR6WTn+A+J46RYknC1Vp5p153bKkYRJIoJF9YsL7+mnJ70aE
         /ZVQXTw8wuD5SKrOT3W6f0w6+iWVncWuWDRL/KzlOKacjGDA8RQj1EF5nIML/Zzp139d
         5MerAgULhRmnZESZQXKl7iNTqG7+bzJEy7n3QlM42blS6Tp/dKjaFPquBuTUm3Qiu0ai
         kqIwD27WwrqMwJWUH7XhcY7Sm8vTBMm+aMlIXJoXXORWwbn92NbjC+e/IJf+hXnvqFLr
         pOMbBazODhmcKYrGa50IVImpnNavhW7YlTxuO9GmtNVdKM2ChTDb2CONbWjxtGKWIciW
         dzXg==
X-Gm-Message-State: APuU4Z/gkubzvsMaypmQhoqGVPu5dJgiLpH0uppJdB5PeK5dxrDiRGSz
	kSFqM2cHqB+hk5C4JU1rKO3hJinhC+2XV7xjqCa7b9rDIQmgFGGcgy7b1904NrSk
X-Gm-Gg: AYBFou2WVdsv4ovQKUgDOWFsXTfSM8pdeUqe+7Ka690gKtkrbj0vSzdSEV5ZafqVlY9
	DNFzPaAB2x+s0sg8QZ4PaAdLbCF3Syyq3AOn64S38vYbFOYX5WrhlIfKbHRHSPl8QlNPVQEi+SP
	FLtTJiH4sMBLKLrA2goCMHd8ILpiLa/kkZ7+Ec1IlIkQ+sfULEQW3XXafARlPDY1Ck7GXlM88Sl
	slP+q0E+MKZz9oP2X4WbsJ1EafAY/UuO/C6NR1xnYDhYv/Ec9UCAK1AbpfulI/enNg46PQInCqW
	1xkND8KZkRJBAr6W9PVaTUMXoYjqvV5bN5iJkM0QzZf3WCkjefRunKBG8fLu5vGnpuib125G+jy
	J57bcpArV8NVyoVlBaQuc0GfwWuCLafXx3WS3KSgoG9Uf+ScRsGcNsj1e8XY3XeQjQH4FRqFfud
	2zz6N8Z1s3GUXUFmS1hD87Kq1nmENt5JApSjbxh18eQbmtnZ/9UZ9ntJ3WBD6vCRyYO0wsiw/vf
	1r1eUFRXWS+vNTbahMTW69qJqAl7ejt9wtw/VScU8eXcwMFfPdia/VbdiVsy8KVs8PmKs4Wd63X
	Vm5SKGAnpj6RCo5q7uK5
X-Received: by 2002:a17:90b:1d03:b0:3ac:c005:cf07 with SMTP id 98e67ed59e1d1-3b1b0b47a08mr1923159a91.42.1794567718314;
        Fri, 13 Nov 2026 03:01:58 -0800 (PST)
Received: from hhost ([120.231.212.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197ce460csm8992762a91.5.2026.11.13.03.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:01:57 -0800 (PST)
Date: Fri, 13 Nov 2026 19:01:47 +0800
From: Xingyuan Mo <hdthky0@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH] xfs: validate dquot buffer geometry in dquot log recovery
Message-ID: <20261113110128.4001610-1-hdthky0@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.43.0

xlog_recover_dquot_commit_pass2() has never really validated the dquot
log item. The only check on qlf_len is a DEBUG-only ASSERT, and
qlf_boffset goes straight into xfs_buf_offset() to pick the dquot slot
inside the chunk buffer:

        dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
        ...
        memcpy(ddq, recddq, item->ri_buf[1].iov_len);

Both the offset and the length of the memcpy come from the journal of
the filesystem being mounted, so a crafted log can make mount time
replay write past the end of the chunk buffer. Sub-page block sizes
get an exact-size kmalloc for the buffer, so an offset of one blocksize
lands right on the KASAN redzone; larger offsets are wild writes. On
CRC filesystems the dd_lsn load in between is out of bounds too. The
recovery regions are allocated to the logged length, so a short region
0 also turns the qlf_* dereferences into out-of-bounds reads.

Make this code validate the item like the rest of log recovery does:
both regions must be exactly the expected size, qlf_len must be 1, and
qlf_boffset must point inside the buffer that is about to be read.
The readahead path gets the region length and qlf_len checks too.

I reproduced this on a v4 filesystem with 512-byte blocks and user
quota enabled: force a few dquot transactions into the log, crash the
box so they stay dirty, rewrite qlf_boffset of the on-disk XFS_LI_DQUOT
items to 512 (one block past bp->b_addr) and mount. Without the fix,
replay trips KASAN:

BUG: KASAN: slab-out-of-bounds in xlog_recover_dquot_commit_pass2+0x32a/0x500
Write of size 104 at addr ffff88801c8b0200 by task mount/430
CPU: 0 UID: 0 PID: 430 Comm: mount Not tainted 7.4.0-rc2-00021-gb3dfbde62cf1 #44 PREEMPT(lazy)
Call Trace:
 <TASK>
 dump_stack_lvl+0x73/0xb0
 print_report+0xd1/0x610
 kasan_report+0xff/0x130
 kasan_check_range+0x10c/0x1c0
 __asan_memcpy+0x3f/0x70
 xlog_recover_dquot_commit_pass2+0x32a/0x500
 xlog_recover_items_pass2+0x7d/0x1b0
 xlog_recover_commit_trans+0x585/0x630
 xlog_recovery_process_trans+0xe2/0xf0
 xlog_recover_process_ophdr+0xf8/0x1d0
 xlog_recover_process_data+0x126/0x270
 xlog_recover_process+0x132/0x210
 xlog_do_recovery_pass+0x6be/0x8f0
 xlog_do_log_recovery+0x65/0x90
 xlog_do_recover+0x7d/0x2b0
 xlog_recover+0x1bc/0x2d0
 xfs_log_mount+0x17b/0x2c0
 xfs_mountfs+0x70a/0xe70
 xfs_fs_fill_super+0xaca/0xf60
 get_tree_bdev+0x14/0x20
 xfs_fs_get_tree+0x19/0x20
 vfs_get_tree+0x54/0x170
 path_mount+0x4ad/0x13a0
 __x64_sys_mount+0x1dd/0x210
 do_syscall_64+0x10b/0x5f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

With the fix the same image is rejected without any out-of-bounds
access, and a pristine dirty log still recovers fine:

XFS (loop2): log mount/recovery failed: error -117

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
---
 fs/xfs/xfs_dquot_item_recover.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index b8854316ac756..3172efb94c277 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -47,7 +47,9 @@ xlog_recover_dquot_ra_pass2(
 
 	dq_f = item->ri_buf[0].iov_base;
 	ASSERT(dq_f);
-	ASSERT(dq_f->qlf_len == 1);
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_dq_logformat) ||
+	    dq_f->qlf_len != 1)
+		return;
 
 	xlog_buf_readahead(log, dq_f->qlf_blkno,
 			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
@@ -84,7 +86,7 @@ xlog_recover_dquot_commit_pass2(
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EFSCORRUPTED;
 	}
-	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot)) {
+	if (item->ri_buf[1].iov_len != sizeof(struct xfs_disk_dquot)) {
 		xfs_alert(log->l_mp, "dquot too small (%zd) in %s.",
 			item->ri_buf[1].iov_len, __func__);
 		return -EFSCORRUPTED;
@@ -110,13 +112,22 @@ xlog_recover_dquot_commit_pass2(
 	 */
 	dq_f = item->ri_buf[0].iov_base;
 	ASSERT(dq_f);
+
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_dq_logformat))
+		return -EFSCORRUPTED;
+
 	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
 		return -EFSCORRUPTED;
 	}
-	ASSERT(dq_f->qlf_len == 1);
+	if (dq_f->qlf_len != 1)
+		return -EFSCORRUPTED;
+
+	if (dq_f->qlf_boffset > BBTOB(XFS_FSB_TO_BB(mp, dq_f->qlf_len)) -
+				  sizeof(struct xfs_dqblk))
+		return -EFSCORRUPTED;
 
 	/*
 	 * At this point we are assuming that the dquots have been allocated
-- 
2.43.0

