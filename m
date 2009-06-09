Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59HuMSx050903 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 12:56:22 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E950E2E2963
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 10:56:42 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id vzDYkusjPdtDTUXA for <xfs@oss.sgi.com>;
	Tue, 09 Jun 2009 10:56:42 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n59Hufab024190
	for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:56:41 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n59HufJl029673
	for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:56:41 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n59HudAx015164
	for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:56:40 -0400
Message-ID: <4A2EA257.9000702@redhat.com>
Date: Tue, 09 Jun 2009 12:56:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: enable test 080 for LInux
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

Seems to work here...  Anyone know why it's disabled?

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/080 b/080
index e9721ad..1794a4c 100755
--- a/080
+++ b/080
@@ -48,13 +48,13 @@ _supported_fs xfs
 # Apparently should be able to work on IRIX,
 # but not at the moment.
 # It does not work on Linux due to some locking issues...
-_supported_os IRIX
+_supported_os IRIX Linux
 
 [ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"
 
 _setup_testdir
 
-#quiet=-q
+quiet=-q
 clean=-c
 
 export here

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
