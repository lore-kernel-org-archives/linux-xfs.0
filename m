Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 339557F56
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:58:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C09A2AC002
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:58:39 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id kYuVT8uhHkwHPDt4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:58:38 -0800 (PST)
Date: Fri, 22 Jan 2016 16:58:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: abort dedupe loop if fatal signals are pending
Message-ID: <20160123005828.GB5496@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ebiggers3@gmail.com, xfs@oss.sgi.com

If the program running dedupe receives a fatal signal during the
dedupe loop, we should bail out to avoid tying up the system.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index aaaad52..aab334e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1617,6 +1617,9 @@ next_file:
 		mnt_drop_write_file(dst_file);
 next_loop:
 		fdput(dst_fd);
+
+		if (fatal_signal_pending(current))
+			goto out;
 	}
 
 out:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
