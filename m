Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793673518;
	b=F+745PJzIt9wHr0pV0fNr9o96E/Wqr54MZCJHt9LmhMLAA7+HwVY2ikf1A4QE12y/mJR
	 UicH2UQbYR45WDCXwisMpOYUN2fCKMMtvYmkdioro6XAq0Og9oIRHxrrLcmYSepT6VyI+
	 x7fdajn6gubFEqEwy7CTLTkSU7qGYeH4ePIbbL0QnMyr2uU0KNYUACzj6dW9GlUgUabuE
	 iS5UsKKhIIZCNyvCneNiwZLCrX9f/DGGFCjlr92jT1Mb4un2xvSelEhqH6QVFbMXd4vSl
	 Q6mhRfKU5+XjxgMp2pnCBz8Md392yJwjmbYGNgU7+Qik6TJ1cRxkQ9Ty66cKlZgDzDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793673518;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4cj5TJ+D6fIKqhd2S1uwmsKq+7z6cyNmSTBoePAtnuY=;
	b=wjD1FgzsLBQ5nZJSfuIlIcTkWK+KRFR+8avrDez5QWsR6CiZw7PLUglC98heRLtrVl18
	 hxZKo49v8ejN2Da1Mwa6Z1WWeC+okvUeTEpSgEc1U0cU93Z0wkmsjE8zFN8ghl9nZzhzH
	 x0Sl++BspSE5m9LYxLgo2W9LU/RrB372zAnGZLvf1t/YAbGH/U0DC0Kn8ZcteTvC55Sjh
	 LO7ktzkF+eQ8YtFGWSx0+4MdM1nG+wkAXLrON9tfIG3Ebr3CSjtRzufd1lYHS4v6doPYK
	 zpi7R7kZLqozcZaacTp+VQAKGOtzuvDhmlnXOiZGDlPzc9I/zdm82XSSjIKEcRk1lBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ZiHiDcwk;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA51606A326;
	Tue,  3 Nov 2026 02:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDA51606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ZiHiDcwk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ZiHiDcwkcvtbtSQ7p/F1cOZvdWASfC75uFFdQACvua5v/xVGNeM2bICN2WRB7QGXwSJiFd7BxFJMI
	 NjKbnC68tX/jrSWyopASiKyBflBT8CYFKTNr+fETeiI+8ayXIQ0z6HY50WKoeKXfiHqLfr0eMP5s1Z
	 wim7Xl/X8L//OQWs=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56ae94924d64-8bf1f;
	Tue, 03 Nov 2026 10:38:28 +0800 (CST)
X-RM-TRANSID:2ee56ae94924d64-8bf1f
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from fedora (unknown[223.108.79.101])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36ae94913a16-e3604;
	Tue, 03 Nov 2026 10:38:28 +0800 (CST)
X-RM-TRANSID:2ee36ae94913a16-e3604
From: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
To: Christian Brauner <brauner@kernel.org>
Cc: gfs2@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+5e659793378ad9e06387@syzkaller.appspotmail.com
Subject: [PATCH] iomap: allow writeback from kswapd again
Date: Tue,  3 Nov 2026 10:38:04 +0800
Message-ID: <20261103023804.8074-1-wuyiqing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit ff59f71f1c95 ("iomap: simplify writepages reclaim guard") removed
the PF_KSWAPD exemption from the iomap_writepages() guard on the
assumption that kswapd can no longer reach filesystem writeback now
that pageout() returns PAGE_ACTIVATE for non-shmem, non-anon folios.
That assumption only covers the folio reclaim path.  kswapd can still
reach filesystem writeback through the inode shrinkers, and syzbot
reports exactly that on GFS2:

  WARNING: (current->flags & PF_MEMALLOC) in iomap_writepages
  kswapd -> balance_pgdat -> shrink_node -> shrink_slab
  -> super_cache_scan -> prune_icache_sb -> evict
  -> gfs2_evict_inode -> evict_linked_inode -> gfs2_log_flush
  -> gfs2_ordered_write -> filemap_fdatawrite -> do_writepages
  -> gfs2_writepages -> iomap_writepages

Under memory pressure kswapd evicts GFS2 inodes whose glock is still
dirty, and gfs2_evict_inode() -> gfs2_log_flush() ->
gfs2_ordered_write() then writes back the ordered data of every inode
on sd_log_ordered.  This is long-standing, intentional behaviour: in
the default data=ordered mode GFS2 must flush dirty data before the
log commit that writes the metadata.  Writeback from kswapd has been
explicitly allowed since 2010, when the guard was still in XFS:
commit d4f7a5cbd544 ("xfs: allow writeback from kswapd"), because
the kswapd stack usage is low and it cannot deadlock on the
filesystem.

Beyond the noisy warning the new guard is actively harmful: it returns
-EIO on every hit (WARN_ON_ONCE only limits the report), while
gfs2_ordered_write() ignores the filemap_fdatawrite() return value, so
the log commit proceeds with metadata even though the ordered data was
never written, breaking the data-before-metadata ordering guarantee of
data=ordered mode.

Restore the historical semantics of the guard using the
current_is_kswapd() helper that replaced the PF_KSWAPD flag: warn about
and refuse writeback from direct or memcg reclaim, but allow it from
kswapd, as was the case from 2010 until ff59f71f1c95.

Fixes: ff59f71f1c95 ("iomap: simplify writepages reclaim guard")
Reported-by: syzbot+5e659793378ad9e06387@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=5e659793378ad9e06387
Cc: Christian Brauner <brauner@kernel.org>
Cc: gfs2@lists.linux.dev
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d6e2f1ded5ca..324da0f5cb29 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -2082,7 +2082,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
 	 * Writeback from reclaim context should never happen except in the case
 	 * of a VM regression so warn about it and refuse to write the data.
 	 */
-	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
+	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC) && !current_is_kswapd()))
 		return -EIO;
 
 	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
-- 
2.56.0



