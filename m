Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o61JrA5g208600 for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 14:53:10 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66B1015B01F8
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 13:00:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LHcROE2UkJblFQ7a for
	<xfs@oss.sgi.com>; Thu, 01 Jul 2010 13:00:59 -0700 (PDT)
Received: from int-mx05.intmail.prod.int.phx2.redhat.com
	(int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o61JtuqY015099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 15:55:57 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o61Jttm6023538
	for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 15:55:56 -0400
Message-ID: <4C2CF2CB.9030706@redhat.com>
Date: Thu, 01 Jul 2010 14:55:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH xfstests] filter 237 setfacl output
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

Older setfacl error output seems to include the full path to
the file; filter it out.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/237 b/237
index bcec3b1..62232c7 100755
--- a/237
+++ b/237
@@ -72,7 +72,8 @@ touch file1
 chown $acl1.$acl1 file1
 
 echo "Expect to FAIL"
-$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1
+$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1 \
+	| sed -e s%$testdir/$seq.dir1/%%
 
 echo "Test over."
 # success, all done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
