Return-Path: <SRS0=cq6/=WO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFD6C3A589
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 17:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A33AF2146E
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 17:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfHRReb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 13:34:31 -0400
Received: from verein.lst.de ([213.95.11.211]:41351 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfHRReb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 18 Aug 2019 13:34:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C4EFB227A81; Sun, 18 Aug 2019 19:34:26 +0200 (CEST)
Date:   Sun, 18 Aug 2019 19:34:26 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190818173426.GA32311@lst.de>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com> <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818074140.GA18648@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 18, 2019 at 09:41:40AM +0200, hch@lst.de wrote:
> On Sun, Aug 18, 2019 at 09:11:28AM +0200, hch@lst.de wrote:
> > > The kernel log shows the following when the mount fails:
> > 
> > Is it always that same message?  I'll see if I can reproduce it,
> > but I won't have that much memory to spare to create fake pmem,
> > hope this also works with a single device and/or less memory..
> 
> I've reproduced a similar ASSERT with a small pmem device, so I hope
> I can debug the issue locally now.

So I can also reproduce the same issue with the ramdisk driver, but not
with any other 4k sector size device (nvmet, scsi target, scsi_debug,
loop).  Which made me wonder if there is some issue about the memory
passed in, and indeed just switching to plain vmalloc vs the XFS
kmem_alloc_large wrapper that either uses kmalloc or vmalloc fixes
the issue for me.  I don't really understand why yet, maybe I need to
dig out alignment testing patches.

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13d1d3e95b88..918ad3b884a7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -125,7 +125,7 @@ xlog_alloc_buffer(
 	if (nbblks > 1 && log->l_sectBBsize > 1)
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
+	return vmalloc(BBTOB(nbblks));
 }
 
 /*
@@ -416,7 +416,7 @@ xlog_find_verify_cycle(
 	*new_blk = -1;
 
 out:
-	kmem_free(buffer);
+	vfree(buffer);
 	return error;
 }
 
@@ -527,7 +527,7 @@ xlog_find_verify_log_record(
 		*last_blk = i;
 
 out:
-	kmem_free(buffer);
+	vfree(buffer);
 	return error;
 }
 
@@ -781,7 +781,7 @@ xlog_find_head(
 			goto out_free_buffer;
 	}
 
-	kmem_free(buffer);
+	vfree(buffer);
 	if (head_blk == log_bbnum)
 		*return_head_blk = 0;
 	else
@@ -795,7 +795,7 @@ xlog_find_head(
 	return 0;
 
 out_free_buffer:
-	kmem_free(buffer);
+	vfree(buffer);
 	if (error)
 		xfs_warn(log->l_mp, "failed to find log head");
 	return error;
@@ -1049,7 +1049,7 @@ xlog_verify_tail(
 		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
 			 orig_tail, *tail_blk);
 out:
-	kmem_free(buffer);
+	vfree(buffer);
 	return error;
 }
 
@@ -1096,7 +1096,7 @@ xlog_verify_head(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
 				      XLOG_MAX_ICLOGS, tmp_buffer,
 				      &tmp_rhead_blk, &tmp_rhead, &tmp_wrapped);
-	kmem_free(tmp_buffer);
+	vfree(tmp_buffer);
 	if (error < 0)
 		return error;
 
@@ -1429,7 +1429,7 @@ xlog_find_tail(
 		error = xlog_clear_stale_blocks(log, tail_lsn);
 
 done:
-	kmem_free(buffer);
+	vfree(buffer);
 
 	if (error)
 		xfs_warn(log->l_mp, "failed to locate log tail");
@@ -1477,7 +1477,7 @@ xlog_find_zeroed(
 	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
-		kmem_free(buffer);
+		vfree(buffer);
 		return 1;
 	}
 
@@ -1488,7 +1488,7 @@ xlog_find_zeroed(
 
 	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
-		kmem_free(buffer);
+		vfree(buffer);
 		return 0;
 	}
 
@@ -1535,7 +1535,7 @@ xlog_find_zeroed(
 
 	*blk_no = last_blk;
 out_free_buffer:
-	kmem_free(buffer);
+	vfree(buffer);
 	if (error)
 		return error;
 	return 1;
@@ -1647,7 +1647,7 @@ xlog_write_log_records(
 	}
 
 out_free_buffer:
-	kmem_free(buffer);
+	vfree(buffer);
 	return error;
 }
 
@@ -5291,7 +5291,7 @@ xlog_do_recovery_pass(
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
 			if (h_size % XLOG_HEADER_CYCLE_SIZE)
 				hblks++;
-			kmem_free(hbp);
+			vfree(hbp);
 			hbp = xlog_alloc_buffer(log, hblks);
 		} else {
 			hblks = 1;
@@ -5307,7 +5307,7 @@ xlog_do_recovery_pass(
 		return -ENOMEM;
 	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
 	if (!dbp) {
-		kmem_free(hbp);
+		vfree(hbp);
 		return -ENOMEM;
 	}
 
@@ -5468,9 +5468,9 @@ xlog_do_recovery_pass(
 	}
 
  bread_err2:
-	kmem_free(dbp);
+	vfree(dbp);
  bread_err1:
-	kmem_free(hbp);
+	vfree(hbp);
 
 	/*
 	 * Submit buffers that have been added from the last record processed,
