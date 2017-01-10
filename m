Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10338 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754400AbdAJVwl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 16:52:41 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 3/7] dax: update MAINTAINERS entries for FS DAX
Date: Tue, 10 Jan 2017 14:52:18 -0700
Message-Id: <1484085142-2297-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1484085142-2297-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1484085142-2297-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Add the new include/trace/events/fs_dax.h tracepoint header, the existing
include/linux/dax.h header, update Matthew's email address and add myself
as a maintainer for filesystem DAX.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c13a4f6..9fb35d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3909,10 +3909,13 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-diolan-u2c.c
 
 DIRECT ACCESS (DAX)
-M:	Matthew Wilcox <willy@linux.intel.com>
+M:	Matthew Wilcox <mawilcox@microsoft.com>
+M:	Ross Zwisler <ross.zwisler@linux.intel.com>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 F:	fs/dax.c
+F:	include/linux/dax.h
+F:	include/trace/events/fs_dax.h
 
 DIRECTORY NOTIFICATION (DNOTIFY)
 M:	Eric Paris <eparis@parisplace.org>
-- 
2.7.4

