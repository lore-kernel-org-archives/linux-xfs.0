Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F09977F4E
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 10:44:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D160B8F804C
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 08:44:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id vLwoxlQRPPDtzPf3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 08:44:15 -0700 (PDT)
Date: Thu, 24 Oct 2013 08:44:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: xfstest 318
Message-ID: <20131024154414.GB19055@infradead.org>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

This test has always been failing for me on my Debian stable system
with the output below, any idea why this could be?

--- tests/generic/318.out	2013-09-09 14:41:08.000000000 +0000
+++ /root/xfstests/results//generic/318.out.bad	2013-10-24 15:44:01.000000000 +0000
@@ -17,7 +17,7 @@
 # group: 65534
 user::rw-
 user:0:r-x	#effective:r--
-user:1:rw-	#effective:r--
+user:3:rw-	#effective:r--
 group::r--
 group:0:--x	#effective:---
 mask::r--
@@ -43,7 +43,7 @@
 # group: 65534
 user::rw-
 user:0:r-x	#effective:r--
-user:1:rw-	#effective:r--
+user:3:rw-	#effective:r--
 group::r--
 group:0:--x	#effective:---
 mask::r--

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
