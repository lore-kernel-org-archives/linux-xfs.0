Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E12C57F50
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:13:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AC91B304067
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 06:13:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y1hRFqmoIkSWxU4A for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 06:13:36 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s56DDakr005026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:36 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s56DDZQp009711
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6/6] xfs: document log sysfs attributes in testing ABI
Date: Fri,  6 Jun 2014 09:13:34 -0400
Message-Id: <1402060414-22075-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
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

Create a sysfs-fs-xfs ABI documentation file for newly added sysfs
attributes. This is created under the testing section.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 Documentation/ABI/testing/sysfs-fs-xfs | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-xfs

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
new file mode 100644
index 0000000..b81aa08
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -0,0 +1,39 @@
+What:		/sys/fs/xfs/<disk>/log/log_head_lsn
+Date:		June 2014
+KernelVersion:	3.16
+Contact:	xfs@oss.sgi.com
+Description:
+		The log sequence number (LSN) of the current head of the
+		log. The LSN is exported in "cycle:basic block" format.
+Users:		xfstests
+
+What:		/sys/fs/xfs/<disk>/log/log_tail_lsn
+Date:		June 2014
+KernelVersion:	3.16
+Contact:	xfs@oss.sgi.com
+Description:
+		The log sequence number (LSN) of the current tail of the
+		log. The LSN is exported in "cycle:basic block" format.
+
+What:		/sys/fs/xfs/<disk>/log/reserve_grant_head
+Date:		June 2014
+KernelVersion:	3.16
+Contact:	xfs@oss.sgi.com
+Description:
+		The current state of the log reserve grant head. It
+		represents the total log reservation of all currently
+		outstanding transactions. The grant head is exported in
+		"cycle:bytes" format.
+Users:		xfstests
+
+What:		/sys/fs/xfs/<disk>/log/write_grant_head
+Date:		June 2014
+KernelVersion:	3.16
+Contact:	xfs@oss.sgi.com
+Description:
+		The current state of the log write grant head. It
+		represents the total log reservation of all currently
+		oustanding transactions, including regrants due to
+		rolling transactions. The grant head is exported in
+		"cycle:bytes" format.
+Users:		xfstests
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
