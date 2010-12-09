Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9D3wWj258219 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 07:03:58 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 204901CA9E4E
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 05:05:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8fNaJe8Tg6CrEuKD for
	<xfs@oss.sgi.com>; Thu, 09 Dec 2010 05:05:47 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oB9D5kHF021986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 08:05:46 -0500
Received: from [10.34.26.208] (dhcp-26-208.brq.redhat.com [10.34.26.208])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id oB9D5iQn006710
	for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 08:05:45 -0500
Subject: xfstests: ignore absolute address in filename in test case 237
From: Boris Ranto <branto@redhat.com>
Date: Thu, 09 Dec 2010 14:05:44 +0100
Message-ID: <1291899944.3196.11.camel@dhcp-31-190.brq.redhat.com>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

Test case 237 checks for setfacl output. The setfacl can use both
relative address or absolute address for filename.

Following patch ignores the unnecessary part of absolute address and
therefore the test case can pass on systems that output absolute
address:

diff -urpN a/xfstests/237 b/xfstests/237
--- a/xfstests/237      2010-12-09 11:24:48.587432718 +0100
+++ b/xfstests/237      2010-12-09 13:46:29.008245581 +0100
@@ -72,7 +72,7 @@ touch file1
 chown $acl1.$acl1 file1

 echo "Expect to FAIL"
-$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1
+$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1 | sed 's/^setfacl: \/.*file1: Operation not permitted$/setfacl: file1: Operation not permitted/'

 echo "Test over."
 # success, all done

Signed-off-by: Boris Ranto <branto@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
