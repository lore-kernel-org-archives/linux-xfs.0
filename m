Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 01:25:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L8PqHs028350
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:25:52 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55F8C1311678
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:27:36 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id 1ECFHOZJbhB9Kxqh for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:27:36 -0700 (PDT)
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id DE06D4643C
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 10:33:41 +0200 (CEST)
Date: Tue, 21 Oct 2008 10:27:35 +0200
From: Nick Piggin <npiggin@suse.de>
Subject: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20081021082735.GB6974@wotan.suse.de>
References: <20081021082542.GA6974@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021082542.GA6974@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Implement XFS's large buffer support with the new vmap APIs. See the vmap
rewrite (db64fe02) for some numbers. The biggest improvement that comes from
using the new APIs is avoiding the global KVA allocation lock on every call.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -264,7 +264,7 @@ xfs_buf_free(
 		uint		i;
 
 		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
-			vunmap(bp->b_addr - bp->b_offset);
+			vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
 
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
@@ -386,8 +386,8 @@ _xfs_buf_map_pages(
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
 	} else if (flags & XBF_MAPPED) {
-		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
-					VM_MAP, PAGE_KERNEL);
+		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
+					-1, PAGE_KERNEL);
 		if (unlikely(bp->b_addr == NULL))
 			return -ENOMEM;
 		bp->b_addr += bp->b_offset;
