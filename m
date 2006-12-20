Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 00:22:53 -0800 (PST)
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBK8Mmqw007660
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 00:22:49 -0800
Message-ID: <4588F2A2.4000609@sgi.com>
Date: Wed, 20 Dec 2006 08:21:54 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Clear unwritten flag on during partial page truncation
References: <20061220062813.GU44411608@melbourne.sgi.com>
In-Reply-To: <20061220062813.GU44411608@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

@@ -41,6 +41,8 @@
  #include <linux/pagevec.h>
  #include <linux/writeback.h>

+STATIC void xfs_vm_invalidatepage(struct page *, unsigned long);
+
  STATIC void
  xfs_count_page_state(
  	struct page		*page,
@@ -1061,7 +1063,7 @@ error:
  	 */
  	if (err != -EAGAIN) {
  		if (!unmapped)
-			block_invalidatepage(page, 0);
+			xfs_vm_invalidatepage(page, 0);

We pass in an offset of zero here...


@@ -1458,6 +1468,32 @@ xfs_vm_invalidatepage(
  {
  	xfs_page_trace(XFS_INVALIDPAGE_ENTER,
  			page->mapping->host, page, offset);
+
+	/*
+	 * Need to clear private flags from buffers on partial
+	 * page truncations ourselves. Same inner loop as
+	 * block_invalidatepage() is used.
+	 */
+	if (offset && page_has_buffers(page)) {

And only do this code for non-zero offsets.  Are you sure this is correct?
