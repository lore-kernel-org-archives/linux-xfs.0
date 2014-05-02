Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 179857F69
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08CFC304066
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:05:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id s5bmZ7ORQv6v2gcf for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 10:05:50 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s42H5nbB008477
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:50 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s42H5nQS029205
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/5] xfstests: filter agno/ino repair output for finobt
Date: Fri,  2 May 2014 13:14:00 -0400
Message-Id: <1399050842-19633-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

finobt enabled filesystems can generate new repair output. Update
_filter_repair() to ensure specific AG and inode numbers are filtered
from test output.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common/repair | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/repair b/common/repair
index 3e73c1d..46ca9e0 100644
--- a/common/repair
+++ b/common/repair
@@ -83,6 +83,8 @@ s/\s+- \d+:\d\d:\d\d:.*\n//g;
 /^Metadata corruption detected/ && next;
 /^Metadata CRC error detected/ && next;
 /^agfl has bad CRC/ && next;
+# finobt enabled filesystem output
+s/(inode chunk) (\d+)\/(\d+)/AGNO\/INO/;
 	print;'
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
