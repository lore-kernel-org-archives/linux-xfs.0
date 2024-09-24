Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404511AC45A;
	Tue, 24 Sep 2024 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203153; cv=none; b=UMGxj7qr6oapzLxP59DGKeCHcqMITuSHoHTkaJxYTQxIo6KKzg4F16X84uKDS1pEULOrI6h4dqp04mDkr4WJEVh/aPLLFTPpb4XXccWUg1RI02jGFHJF4KNCfExM7zqZL/4NA8t5cQ4ztaz7/ifWXQ5j9+w2pjk+uuL7XZGluNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203153; c=relaxed/simple;
	bh=8yYeCIKmKPe5of7iXfagMj/76j9/rMFDJcPT0YINd00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJZilGIQ58EUl3vKhFpSlN/R7KL9L/HoXUQvyVas7+xWOm/RcNa9FePchmig0itcpk0ZJAJXnTPhhMvByKgQmkL7RMqwL94s8/zOo+PXYVbeuwyE9f2FertapduFOjuoQyPIm0D4EFGZ/0KKQmAXIUYLabNlov5ZTfxN+qT7ZUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fg7SHq1f; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fg7SHq1f"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7c6b4222fe3so3769079a12.3;
        Tue, 24 Sep 2024 11:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203151; x=1727807951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYr8XI7x/C+klcH+M93RinC8NekpG56P3408vvG5ctE=;
        b=Fg7SHq1fj9dkUEnsXVjSdeL/71blIjyflMnTbBHEmFfLpewyDySkhXX8xabRfd2AX8
         EBenSkiOUGCfDQmtUsmCpvSbP/7B5SFCrjL/d2N07XZgTO4vbCLTWCvandhbhLOnQq0L
         jXdJHnXrDKb5mU1nJTkc1RD4xggHni4xSMnw0Yf99pAaTyezKtvSAGNy80+sJOwx+x+g
         b5OfeQe7A1kBGuCIMBtLIq2lDpz8OP6ZoLsqiYLYRlTvEhPW2ldEtuyfANTGTivPesMi
         1rryHmd9s/ipZ64VLxjZJHh1AN3j6azUhxXYNOEWNvOiOeEjsbbNSfXcotEOeHDsZLnz
         mbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203151; x=1727807951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYr8XI7x/C+klcH+M93RinC8NekpG56P3408vvG5ctE=;
        b=TvL6PkY6BNeoafuu3gPNNDVDrlAJ1F/M9IJWAFsP4V38Zz0/1enCUXTCF2JIy0H22U
         186lg6zxbsFmcY/5Jqde587gs1/pBOpp55JFwzcmCdRKTtc0pgQjELW1CA8PrMvwgmvw
         gJameQ7lXO02pttePZBSoGLibw/lZCXeV2IxkdwR66I5C8MJv07ZKzviJACjWFcVg5Pb
         +p9kiVwfENhWNKViELQRRiPL1t6ZIJDa+/R3Np+jIhJyK8wc4GDzk6DaW3DbuJ7kwSGK
         02Az93WSBha3Vn6a444lGAOPyWl0Ee/XuJgCRF6JM17ua50ge2G6UNdTdVAGBPi1r9Is
         H9Hw==
X-Gm-Message-State: AOJu0YwaI+EUf/1+xi/p4NrELb/ODW2NxDPnfUVcExta2xLG7AD1vEQ5
	tqy4myrSXD1B99wyzK8nsMKskY56CRk4OO/b9V4Pf2q1M7yXldp/ePYzd6D4
X-Google-Smtp-Source: AGHT+IGgGXLrZZJ+c78/UuCeudvABMzspR5IrYTrJ3b/e5umRTuhMBm1/M4N/VR/u5INid4eq/5PtA==
X-Received: by 2002:a05:6a20:ac43:b0:1d2:ea38:3774 with SMTP id adf61e73a8af0-1d4e0bbe334mr115377637.32.1727203151287;
        Tue, 24 Sep 2024 11:39:11 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:10 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Ye Bin <yebin10@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 10/26] xfs: fix BUG_ON in xfs_getbmap()
Date: Tue, 24 Sep 2024 11:38:35 -0700
Message-ID: <20240924183851.1901667-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 8ee81ed581ff35882b006a5205100db0b57bf070 ]

There's issue as follows:
XFS: Assertion failed: (bmv->bmv_iflags & BMV_IF_DELALLOC) != 0, file: fs/xfs/xfs_bmap_util.c, line: 329
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 14612 Comm: xfs_io Not tainted 6.3.0-rc2-next-20230315-00006-g2729d23ddb3b-dirty #422
RIP: 0010:assfail+0x96/0xa0
RSP: 0018:ffffc9000fa178c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff888179a18000
RDX: 0000000000000000 RSI: ffff888179a18000 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff8321aab6 R09: 0000000000000000
R10: 0000000000000001 R11: ffffed1105f85139 R12: ffffffff8aacc4c0
R13: 0000000000000149 R14: ffff888269f58000 R15: 000000000000000c
FS:  00007f42f27a4740(0000) GS:ffff88882fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000b92388 CR3: 000000024f006000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xfs_getbmap+0x1a5b/0x1e40
 xfs_ioc_getbmap+0x1fd/0x5b0
 xfs_file_ioctl+0x2cb/0x1d50
 __x64_sys_ioctl+0x197/0x210
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Above issue may happen as follows:
         ThreadA                       ThreadB
do_shared_fault
 __do_fault
  xfs_filemap_fault
   __xfs_filemap_fault
    filemap_fault
                             xfs_ioc_getbmap -> Without BMV_IF_DELALLOC flag
			      xfs_getbmap
			       xfs_ilock(ip, XFS_IOLOCK_SHARED);
			       filemap_write_and_wait
 do_page_mkwrite
  xfs_filemap_page_mkwrite
   __xfs_filemap_fault
    xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
    iomap_page_mkwrite
     ...
     xfs_buffered_write_iomap_begin
      xfs_bmapi_reserve_delalloc -> Allocate delay extent
                              xfs_ilock_data_map_shared(ip)
	                      xfs_getbmap_report_one
			       ASSERT((bmv->bmv_iflags & BMV_IF_DELALLOC) != 0)
	                        -> trigger BUG_ON

As xfs_filemap_page_mkwrite() only hold XFS_MMAPLOCK_SHARED lock, there's
small window mkwrite can produce delay extent after file write in xfs_getbmap().
To solve above issue, just skip delalloc extents.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 867645b74d88..351087cde27e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -314,15 +314,13 @@ xfs_getbmap_report_one(
 	if (isnullstartblock(got->br_startblock) ||
 	    got->br_startblock == DELAYSTARTBLOCK) {
 		/*
-		 * Delalloc extents that start beyond EOF can occur due to
-		 * speculative EOF allocation when the delalloc extent is larger
-		 * than the largest freespace extent at conversion time.  These
-		 * extents cannot be converted by data writeback, so can exist
-		 * here even if we are not supposed to be finding delalloc
-		 * extents.
+		 * Take the flush completion as being a point-in-time snapshot
+		 * where there are no delalloc extents, and if any new ones
+		 * have been created racily, just skip them as being 'after'
+		 * the flush and so don't get reported.
 		 */
-		if (got->br_startoff < XFS_B_TO_FSB(ip->i_mount, XFS_ISIZE(ip)))
-			ASSERT((bmv->bmv_iflags & BMV_IF_DELALLOC) != 0);
+		if (!(bmv->bmv_iflags & BMV_IF_DELALLOC))
+			return 0;
 
 		p->bmv_oflags |= BMV_OF_DELALLOC;
 		p->bmv_block = -2;
-- 
2.46.0.792.g87dc391469-goog

