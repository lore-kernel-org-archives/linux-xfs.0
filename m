Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 14:09:15 -0700 (PDT)
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FL996p027301
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 14:09:10 -0700
Date: Thu, 15 Mar 2007 14:08:48 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: Announce: new-aops-1 for 2.6.21-rc3
Message-ID: <20070315210848.GG21942@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070315161704.GH8321@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315161704.GH8321@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>, reiserfs-list@namesys.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, nfs@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net

On Thu, Mar 15, 2007 at 05:17:04PM +0100, Nick Piggin wrote:
> OK, I've gone through and fixed several bugs until the thing actually
> survives fsx-linux for both ext2 and ext3 ordered and writeback (both
> when using the new aops, and the legacy prepare_write path). Actually
> ext3 sometimes breaks, but it does in unpatched kernels anyway.

Attached is a bugfix for a crash folks who use an initrd will hit early on.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com


From: Mark Fasheh <mark.fasheh@oracle.com>

[PATCH] Populate pagep in simple_write_begin()

This wasn't getting passed back to callers.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

cbf20bf51ddd6434db935ba29f845a85f3b1ec65
diff --git a/fs/libfs.c b/fs/libfs.c
index 51f9748..602496a 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -357,6 +357,8 @@ int simple_write_begin(struct file *file
 	if (!page)
 		return -ENOMEM;
 
+	*pagep = page;
+
 	return simple_prepare_write(file, page, from, from+len);
 }
 
-- 
1.3.3
