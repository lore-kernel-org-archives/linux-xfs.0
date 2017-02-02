Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdBBSkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 13:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 50/51] xfs: clear _XBF_PAGES from buffers when readahead page
Date: Thu,  2 Feb 2017 19:38:09 +0100
Message-Id: <20170202183347.783000235@linuxfoundation.org>
In-Reply-To: <20170202183345.067336143@linuxfoundation.org>
References: <20170202183345.067336143@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 2aa6ba7b5ad3189cc27f14540aa2f57f0ed8df4b upstream.

If we try to allocate memory pages to back an xfs_buf that we're trying
to read, it's possible that we'll be so short on memory that the page
allocation fails.  For a blocking read we'll just wait, but for
readahead we simply dump all the pages we've collected so far.

Unfortunately, after dumping the pages we neglect to clear the
_XBF_PAGES state, which means that the subsequent call to xfs_buf_free
thinks that b_pages still points to pages we own.  It then double-frees
the b_pages pages.

This results in screaming about negative page refcounts from the memory
manager, which xfs oughtn't be triggering.  To reproduce this case,
mount a filesystem where the size of the inodes far outweighs the
availalble memory (a ~500M inode filesystem on a VM with 300MB memory
did the trick here) and run bulkstat in parallel with other memory
eating processes to put a huge load on the system.  The "check summary"
phase of xfs_scrub also works for this purpose.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -423,6 +423,7 @@ retry:
 out_free_pages:
 	for (i = 0; i < bp->b_page_count; i++)
 		__free_page(bp->b_pages[i]);
+	bp->b_flags &= ~_XBF_PAGES;
 	return error;
 }
 


