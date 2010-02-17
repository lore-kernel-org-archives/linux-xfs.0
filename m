Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HHBepB247691 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:11:40 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D73011DBA338
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 09:12:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bCWq0HPsCdCB0hsp for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 09:12:58 -0800 (PST)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1HHCvDH009553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 12:12:57 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1HHCta0025604
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 12:12:56 -0500
Message-ID: <4B7C2397.90406@redhat.com>
Date: Wed, 17 Feb 2010 11:12:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: 077 should require fsgqa user
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

Running on a newly-provisioned box:

077	 - output mismatch (see 077.out.bad)
--- 077.out	2010-02-17 11:22:35.275052872 -0500
+++ 077.out.bad	2010-02-17 11:59:48.979053106 -0500
@@ -1,6 +1,7 @@
 QA output created by 077
 *** create filesystem
 *** set default ACL
+setfacl: Option -m: Invalid argument near character 3
 *** populate filesystem, pass #1
 *** populate filesystem, pass #2
 *** all done

because we didn't have the fsgqa user, and tried:

# setfacl -R -dm u:fsgqa:rwx,g::rwx,o::r-x,m::rwx ...

instead should have had:

077	 [not run] fsgqa user not defined.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/077 b/077
index ea81c07..72f1b2a 100755
--- a/077
+++ b/077
@@ -54,6 +54,7 @@ _supported_os Linux
 
 _require_scratch
 _require_acls
+_require_user
 
 echo "*** create filesystem"
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
