Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9450E7F47
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:16:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C46C304039
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 13:16:54 -0700 (PDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
	[209.85.213.170]) by cuda.sgi.com with ESMTP id
	XcohCDrwUBiTvNgJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 13:16:52 -0700 (PDT)
Received: by igblo3 with SMTP id lo3so111677475igb.1
	for <xfs@oss.sgi.com>; Tue, 05 May 2015 13:16:52 -0700 (PDT)
From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH 04/12] xfs:Make the function,xfs_alloc_fix_len static
Date: Tue,  5 May 2015 16:16:31 -0400
Message-Id: <1430856999-31952-4-git-send-email-xerofoify@gmail.com>
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

This properly makes the function,xfs_alloc_fix_len static
due to no callers outside of the file this function is
declared and defined in.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5e575ac..71d20a4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -239,7 +239,7 @@ xfs_alloc_compute_diff(
  * If len is too small it is returned unchanged.
  * If len hits maxlen it is left alone.
  */
-STATIC void
+static void
 xfs_alloc_fix_len(
 	xfs_alloc_arg_t	*args)		/* allocation argument structure */
 {
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
