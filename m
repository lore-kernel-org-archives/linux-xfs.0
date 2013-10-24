Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2493C7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 11:13:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5BEBAC005
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 09:12:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id yxdAOXOPd1cSN5l3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 09:12:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VZNWs-0003mB-9H
	for xfs@oss.sgi.com; Thu, 24 Oct 2013 16:12:58 +0000
Date: Thu, 24 Oct 2013 09:12:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [hch@infradead.org: xfstests 317]
Message-ID: <20131024161258.GB29381@infradead.org>
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
To: xfs@oss.sgi.com

Should include the list as well..

----- Forwarded message from Christoph Hellwig <hch@infradead.org> -----

Date: Thu, 24 Oct 2013 09:12:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: xfstests 317
To: Dwight Engen <dwight.engen@oracle.com>

This one also seems to be guranteed to fail for me with the following
output:


--- tests/generic/317.out	2013-09-09 14:41:08.000000000 +0000
+++ /root/xfstests/results//generic/317.out.bad	2013-10-24 16:12:00.000000000 +0000
@@ -4,9 +4,7 @@
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (qa_user)  Gid: (qa_user)
 From user_ns
-  File: "$SCRATCH_MNT/file1"
-  Size: 0            Filetype: Regular File
-  Mode: (0644/-rw-r--r--)         Uid: (0)  Gid: (0)
+execvp: Permission denied
 
 *** Remounting ***
 
@@ -15,6 +13,4 @@
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (qa_user)  Gid: (qa_user)
 From user_ns
-  File: "$SCRATCH_MNT/file1"
-  Size: 0            Filetype: Regular File
-  Mode: (0644/-rw-r--r--)         Uid: (0)  Gid: (0)
+execvp: Permission denied

----- End forwarded message -----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
