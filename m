Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65530 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753112AbdLEX5H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 18:57:07 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [xfsprogs PATCH v2 1/3] xfs_io: fix compiler warnings in getfsmap code
Date: Tue,  5 Dec 2017 16:56:49 -0700
Message-Id: <20171205235651.17102-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

I recently upgraded my compiler from
	gcc (GCC) 6.4.1 20170727 (Red Hat 6.4.1-1)
to
	gcc (GCC) 7.2.1 20170915 (Red Hat 7.2.1-2)
and started getting a bunch of compiler warnings in io/fsmap.c:

  fsmap.c: In function ‘fsmap_f’:
  fsmap.c:228:40: warning: ‘%lld’ directive output may be truncated writing
  between 1 and 17 bytes into a region of size between 12 and 28
  [-Wformat-truncation=]
     snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
  ^~~~
  fsmap.c:228:32: note: directive argument in the range [0, 36028797018963967]
     snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
  ^~~~~~~~~~~~~~~
  fsmap.c:228:3: note: ‘snprintf’ output between 8 and 40 bytes into a
  destination of size 32
     snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (long long)BTOBBT(p->fmr_physical),
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (long long)BTOBBT(p->fmr_physical + p->fmr_length - 1));
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The issue is that 'bbuf' is only defined to be 32 characters wide, but each
signed long long can potentially print as many as 19 characters
(9223372036854775807 is the max value).  The format we're using for bbuf is
"[%lld..%lld]:" which has 2 signed long longs plus 6 other characters
"[..]:\0", which means it's possible we'll print up to 44 characters,
overflowing our 32 char buffer.

Fix this by bumping all the buffer sizes in dump_map_verbose() to 64
characters.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Fixes: 3fcab549a234 ("xfs_io: support the new getfsmap ioctl")
---
 io/fsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 448fb535..3d8a6700 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -184,8 +184,8 @@ dump_map_verbose(
 	off64_t			agoff, bperag;
 	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
 	int			nr_w, dev_w;
-	char			rbuf[32], bbuf[32], abuf[32], obuf[32];
-	char			nbuf[32], dbuf[32], gbuf[32];
+	char			rbuf[64], bbuf[64], abuf[64], obuf[64];
+	char			nbuf[64], dbuf[64], gbuf[64];
 	char			owner[OWNER_BUF_SZ];
 	int			sunit, swidth;
 	int			flg = 0;
-- 
2.14.3

