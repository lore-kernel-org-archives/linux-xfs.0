Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAUDjwSC112502 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 07:45:58 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8392713FDE4C
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 05:47:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FvjT02YBuGjZq4YV for
	<xfs@oss.sgi.com>; Tue, 30 Nov 2010 05:47:40 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAUDldoe000831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 08:47:40 -0500
Received: from [10.34.26.208] (dhcp-26-208.brq.redhat.com [10.34.26.208])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id oAUDlcw5028550
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 08:47:39 -0500
Subject: xfstests: getfacl -n unsupported in older acl package
From: Boris Ranto <branto@redhat.com>
Date: Tue, 30 Nov 2010 14:47:38 +0100
Message-ID: <1291124858.3340.9.camel@dhcp-31-190.brq.redhat.com>
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

Test cases 051 and 067 use getfacl with option -n. This works well on newer systems but older acl package know only its longer version: --numeric.

I've tested the two tests with long option and they both passed.

Therefore I'd propose this patch to fix this for earlier acl versions:

diff -uprN /var/lib/xfstests-orig/051 /var/lib/xfstests/051
--- /var/lib/xfstests-orig/051	2010-11-30 08:29:36.000000000 -0500
+++ /var/lib/xfstests/051	2010-11-30 08:28:18.000000000 -0500
@@ -343,23 +343,23 @@ acl5=`_create_n_aces 17` # 1 over A.G. l
 
 echo "1 below xfs acl max"
 chacl $acl1 largeaclfile
-getfacl -n largeaclfile | _filter_aces
+getfacl --numeric largeaclfile | _filter_aces
 
 echo "xfs acl max"
 chacl $acl2 largeaclfile
-getfacl -n largeaclfile | _filter_aces
+getfacl --numeric largeaclfile | _filter_aces
 
 echo "1 above xfs acl max"
 chacl $acl3 largeaclfile
-getfacl -n largeaclfile | _filter_aces
+getfacl --numeric largeaclfile | _filter_aces
 
 echo "use 16 aces"
 chacl $acl4 largeaclfile
-getfacl -n largeaclfile | _filter_aces
+getfacl --numeric largeaclfile | _filter_aces
 
 echo "use 17 aces"
 chacl $acl5 largeaclfile
-getfacl -n largeaclfile | _filter_aces
+getfacl --numeric largeaclfile | _filter_aces
 
 #-------------------------------------------------------
 
diff -uprN /var/lib/xfstests-orig/067 /var/lib/xfstests/067
--- /var/lib/xfstests-orig/067	2010-11-30 08:29:10.000000000 -0500
+++ /var/lib/xfstests/067	2010-11-30 08:31:28.000000000 -0500
@@ -73,19 +73,19 @@ acl21=`_create_n_aces 21`
 
 echo "try 20 aces for access acl"
 chacl $acl20 largeacldir
-getfacl -n largeacldir | _filter_aces
+getfacl --numeric largeacldir | _filter_aces
 
 echo "try 20 aces for default acl"
 chacl -d $acl20 largeacldir
-getfacl -n largeacldir | _filter_aces
+getfacl --numeric largeacldir | _filter_aces
 
 echo "try 21 aces for access acl"
 chacl $acl21 largeacldir
-getfacl -n largeacldir | _filter_aces
+getfacl --numeric largeacldir | _filter_aces
 
 echo "try 21 aces for default acl"
 chacl -d $acl21 largeacldir
-getfacl -n largeacldir | _filter_aces
+getfacl --numeric largeacldir | _filter_aces
 
 # success, all done
 status=0

Signed-off-by: Boris Ranto <branto@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
