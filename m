Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858B1187357
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560524; cv=none; b=A8CHk0GAhCQIQJRZ4FEurZSMdapWeB7Q7B/Mn3S+mJL2jVS+Z0eibU0fKiAH88ojEixXaP+pzTtq42VfunCQFegV2l6WMgowl3m8SZc0DVGpRR5h0+n5ixpCgvGfrXnVAcZLonbKthe773Sl98sf57Dl7D51/1K0nAQDFFfR7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560524; c=relaxed/simple;
	bh=fNxF1A85GQ3tX99uYdvNeatQYgz/N0TrtfWfvLV0184=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ux/GeDiLYbotSG15yTGrXTSyVFzVEFxPQHMWHy7PiVX7UguAmqTiYkkt3YQRTMMNZHADId8tYIKEzy6hhUQYHpz00W4GAt51rcz2b/bHOEIEMX9MQpn6DNvXA3ZnUVJrxPIIe7QpHKQerTKeGDIRjzeiZFc7ZaUFxV8uHJghgP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRxHNjKG; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRxHNjKG"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2055136b612so12351855ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560522; x=1726165322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=41dGirSTLjJ1lRlnioWURooeGcIA7fc6MXk3B/N6dEA=;
        b=WRxHNjKGH2w/pEmlhwxpNmLpQpd5ReNDuj6iecXeQdCb1bk3UnksldRJyf/TejJhaA
         KQxh5mljVkt5bAlYFtzsujbzjlKP2Ua1gXvF/dxb7Go9llYWSjz31pbLHUZmNFKRpeAC
         0lgtuShHLPYQRM1lYgTl3ugIlH3NDzzv+Pi+H7u7w03EYM7InRwSVQjtrbpKTSDKXqh2
         G4wMFQAg9Se9nMTJilLfUTPTMz7e4VjSKYbae0TXG76Ke53GAJ7S6kMQ2uRF9EfDeQCu
         l+CSQynec1R8+hPATwOsCVBGtaoBiWvAxTh9GeZBBZQYKkW3zkiJa2bKlm4GbIuH6clI
         wjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560522; x=1726165322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41dGirSTLjJ1lRlnioWURooeGcIA7fc6MXk3B/N6dEA=;
        b=mmsHgViOOZpjRptMaPWINvep+6fRDkWjeV5ZN99DbVA/twIkLewLDIdKYGAkk4L1sM
         ZWbCgUnK+73b1suBkbkL+8/5SREWhB1Kg2Qg+YYjlACm3lX5ZsisHGLa9LCZ5rx0NXgw
         9AIuiUIzShf2jRdBAUdtPYaTRK/bz8ZyqEAMi4br9RCCfjnC+JMyux0ytDzxTSDyoo5T
         bG8cIpFBal9wiGsXdM59aAOM1OIfuVfIn2uRURRa4FMqOFb8F2CEKBaLouLxTzoZ8Fus
         gYmf3+D2+LLXY5TvyxJ2hMfU+FWEDIMCgShZwVyGX8mtuP1vupHpkeXqUWSWcTQ7EOSR
         jIvw==
X-Gm-Message-State: AOJu0YxJPGHhOxHVADmz0TzFBqtYqKzmTnUEn73mFwcYpPe0M7RdCyDK
	bd8ulqUA+KqCtv4JVOLGwj60kkneONTSRemvxz3IwCKiEUmJysjBnsLT81ap
X-Google-Smtp-Source: AGHT+IE+l+2mPRSkVQVc3j74Eny1N8vw5GLGknU28tvyZwWV9Gh6cvdass/Rn5m+Q5PT0nGT8E8S3g==
X-Received: by 2002:a17:902:da82:b0:206:9ab3:2ebc with SMTP id d9443c01a7336-2069ab33684mr131494255ad.47.1725560521704;
        Thu, 05 Sep 2024 11:22:01 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:01 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Ye Bin <yebin10@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 10/26] xfs: fix BUG_ON in xfs_getbmap()
Date: Thu,  5 Sep 2024 11:21:27 -0700
Message-ID: <20240905182144.2691920-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

