Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 13:47:44 -0700 (PDT)
Received: from agminet02.oracle.com (agminet02.oracle.com [141.146.126.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FKlc6p023378
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 13:47:39 -0700
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by agminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l2FJsEmo013249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 14:54:15 -0500
Date: Thu, 15 Mar 2007 12:53:51 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: Announce: new-aops-1 for 2.6.21-rc3
Message-ID: <20070315195351.GE21942@ca-server1.us.oracle.com>
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
> 
> At 15 patches (including the initial buffered write deadlock fixes),
> it is too much to keep posting -- not much has fundamentally changed,
> so I'll just post occasionally if we make big changes. The quilt
> format is probably easier for someone wishing to work on it anyway.

Hmm, we still left out some exports...
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com


From: Mark Fasheh <mark.fasheh@oracle.com>
[PATCH] Export simple_write_begin, simple_write_end

These are used by configfs, which can be built as a module.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

---

 fs/libfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

36f5d6a135c9f3f30fee3d0e4ffa887e1803ac95
diff --git a/fs/libfs.c b/fs/libfs.c
index d687819..51f9748 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -656,6 +656,8 @@ EXPORT_SYMBOL(dcache_dir_open);
 EXPORT_SYMBOL(dcache_readdir);
 EXPORT_SYMBOL(generic_read_dir);
 EXPORT_SYMBOL(get_sb_pseudo);
+EXPORT_SYMBOL(simple_write_begin);
+EXPORT_SYMBOL(simple_write_end);
 EXPORT_SYMBOL(simple_commit_write);
 EXPORT_SYMBOL(simple_dir_inode_operations);
 EXPORT_SYMBOL(simple_dir_operations);
-- 
1.3.3
