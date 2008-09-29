Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 00:23:02 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T7MxGO016616
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 00:22:59 -0700
Message-ID: <48E084D5.30205@sgi.com>
Date: Mon, 29 Sep 2008 17:33:41 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: compiler warning after applying btree patches
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph,

After applying the first round of btree patches we've now got this warning
when building a non-debug xfs module.

  CC      fs/xfs/xfs_btree.o
fs/xfs/xfs_btree.c:191: warning: ‘xfs_btree_check_ptr’ defined but not used

I took a quick look through your next round of btree patches but couldn't
see a fix for it.  Did I miss something in the original patch set?  Is it
fixed in a later patch?  If not here's a fix:

--- a/fs/xfs/xfs_btree.c	2008-09-29 17:19:24.000000000 +1000
+++ b/fs/xfs/xfs_btree.c	2008-09-29 17:22:33.000000000 +1000
@@ -160,6 +160,7 @@ xfs_btree_check_lptr(
 	return 0;
 }
 
+#ifdef DEBUG
 /*
  * Check that (short) pointer is ok.
  */
@@ -197,6 +198,7 @@ xfs_btree_check_ptr(
 				be32_to_cpu((&ptr->s)[index]), level);
 	}
 }
+#endif
 
 /*
  * Delete the btree cursor.
