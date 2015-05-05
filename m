Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2BB129E1A
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:17:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B00B304032
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 13:17:03 -0700 (PDT)
Received: from mail-ie0-f174.google.com (mail-ie0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	VdX7x8bOjWiSYVCb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 13:17:02 -0700 (PDT)
Received: by iecnq11 with SMTP id nq11so1095455iec.3
	for <xfs@oss.sgi.com>; Tue, 05 May 2015 13:17:01 -0700 (PDT)
From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH 09/12] xfs:Make the function,xfs_alloc_ag_vextent static
Date: Tue,  5 May 2015 16:16:36 -0400
Message-Id: <1430856999-31952-9-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
References: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: jack@suse.cz, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de

This makes the function,xfs_alloc_ag_vextent static
now due to its only callers being in the same file
as this function's declaration and definition.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2f94b53..3c9a58f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -581,7 +581,7 @@ xfs_alloc_update_counters(
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
  */
-STATIC int			/* error */
+static int			/* error */
 xfs_alloc_ag_vextent(
 	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
 {
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
