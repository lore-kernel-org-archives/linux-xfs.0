Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B93E29E17
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 05:56:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B1798F8066
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 03:56:50 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id xWosus3PJq5CB2kz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 03:56:49 -0800 (PST)
Date: Wed, 6 Nov 2013 03:56:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: nfs vs xfstests 193
Message-ID: <20131106115648.GA24804@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-nfs@vger.kernel.org
Cc: xfs@oss.sgi.com


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've noticed that xfstests 193 fails when run over NFS talking to an
XFS-based Linux server.  The test checks that we behave correctly
vs Posix 1003.1 for the various operations that end up in ->setattr.

Without the no_root_squash export flag we're not even able to run
something resembling the test as we get permission problems all through
it, see the first attachment for details.

With the root_squash export op we fail to clear the setuid/setgid
bits in various truncate and chown subtests, see the second attachment
for details.

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="193.no_root_squash"

--- tests/generic/193.out	2013-10-24 15:41:33.000000000 +0000
+++ /root/xfstests/results//generic/193.out.bad	2013-11-06 11:55:39.000000000 +0000
@@ -35,26 +35,26 @@
 after:  -rw-r-Sr--
 with user exec perm
 before: -rwsr-Sr--
-after:  -rwxr-Sr--
+after:  -rwsr-Sr--
 with group exec perm
 before: -rwSr-sr--
-after:  -rw-r-xr--
+after:  -rwSr-sr--
 with user+group exec perm
 before: -rwsr-sr--
-after:  -rwxr-xr--
+after:  -rwsr-sr--
 check that suid/sgid bits are cleared after successful truncate...
 with no exec perm
 before: -rwSr-Sr--
-after:  -rw-r-Sr--
+after:  -rwSr-Sr--
 with user exec perm
 before: -rwsr-Sr--
-after:  -rwxr-Sr--
+after:  -rwsr-Sr--
 with group exec perm
 before: -rwSr-sr--
-after:  -rw-r-xr--
+after:  -rwSr-sr--
 with user+group exec perm
 before: -rwsr-sr--
-after:  -rwxr-xr--
+after:  -rwsr-sr--
 
 testing ATTR_*TIMES_SET
 

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="193.root_squash"

--- tests/generic/193.out	2013-10-24 15:41:33.000000000 +0000
+++ /root/xfstests/results//generic/193.out.bad	2013-11-06 11:52:05.000000000 +0000
@@ -2,63 +2,118 @@
 
 testing ATTR_UID
 
+touch: cannot touch '/mnt/nfs1/193.3516.root': Permission denied
+touch: cannot touch '/mnt/nfs1/193.3516.user': Permission denied
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 user: chown root owned file to qa_user (should fail)
-chown: changing ownership of 'test.root': Operation not permitted
+chown: cannot access 'test.root': No such file or directory
 user: chown root owned file to root (should fail)
-chown: changing ownership of 'test.root': Operation not permitted
+chown: cannot access 'test.root': No such file or directory
 user: chown qa_user owned file to qa_user (should succeed)
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 user: chown qa_user owned file to root (should fail)
-chown: changing ownership of 'test.user': Operation not permitted
+chown: cannot access 'test.user': No such file or directory
 
 testing ATTR_GID
 
+touch: cannot touch '/mnt/nfs1/193.3516.root': Permission denied
+touch: cannot touch '/mnt/nfs1/193.3516.user': Permission denied
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 user: chgrp root owned file to root (should fail)
-chgrp: changing group of 'test.root': Operation not permitted
+chgrp: cannot access 'test.root': No such file or directory
 user: chgrp qa_user owned file to root (should fail)
-chgrp: changing group of 'test.user': Operation not permitted
+chgrp: cannot access 'test.user': No such file or directory
 user: chgrp root owned file to qa_user (should fail)
-chgrp: changing group of 'test.root': Operation not permitted
+chgrp: cannot access 'test.root': No such file or directory
 user: chgrp qa_user owned file to qa_user (should succeed)
+chgrp: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 
 testing ATTR_MODE
 
+touch: cannot touch '/mnt/nfs1/193.3516.root': Permission denied
+touch: cannot touch '/mnt/nfs1/193.3516.user': Permission denied
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 user: chmod a+r on qa_user owned file (should succeed)
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 user: chmod a+r on root owned file (should fail)
-chmod: changing permissions of 'test.root': Operation not permitted
+chmod: cannot access 'test.root': No such file or directory
 check that the sgid bit is cleared
--rw-rw-rw-
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 check that suid bit is not cleared
--rwSrw-rw-
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+touch: cannot touch '/mnt/nfs1/193.3516.root': Permission denied
+touch: cannot touch '/mnt/nfs1/193.3516.user': Permission denied
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 check that suid/sgid bits are cleared after successful chown...
 with no exec perm
-before: -rwSr-Sr--
-after:  -rw-r-Sr--
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 with user exec perm
-before: -rwsr-Sr--
-after:  -rwxr-Sr--
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 with group exec perm
-before: -rwSr-sr--
-after:  -rw-r-xr--
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 with user+group exec perm
-before: -rwsr-sr--
-after:  -rwxr-xr--
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+touch: cannot touch '/mnt/nfs1/193.3516.root': Permission denied
+touch: cannot touch '/mnt/nfs1/193.3516.user': Permission denied
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 check that suid/sgid bits are cleared after successful truncate...
 with no exec perm
-before: -rwSr-Sr--
-after:  -rw-r-Sr--
+./tests/generic/193: line 242: /mnt/nfs1/193.3516.user: Permission denied
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+bash: /mnt/nfs1/193.3516.user: Permission denied
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 with user exec perm
-before: -rwsr-Sr--
-after:  -rwxr-Sr--
+./tests/generic/193: line 249: /mnt/nfs1/193.3516.user: Permission denied
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+bash: /mnt/nfs1/193.3516.user: Permission denied
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 with group exec perm
-before: -rwSr-sr--
-after:  -rw-r-xr--
+./tests/generic/193: line 257: /mnt/nfs1/193.3516.user: Permission denied
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+bash: /mnt/nfs1/193.3516.user: Permission denied
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 with user+group exec perm
-before: -rwsr-sr--
-after:  -rwxr-xr--
+./tests/generic/193: line 266: /mnt/nfs1/193.3516.user: Permission denied
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+chmod: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
+before: stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
+bash: /mnt/nfs1/193.3516.user: Permission denied
+after:  stat: cannot stat '/mnt/nfs1/193.3516.user': No such file or directory
 
 testing ATTR_*TIMES_SET
 
+touch: cannot touch '/mnt/nfs1/193.3516.root': Permission denied
+touch: cannot touch '/mnt/nfs1/193.3516.user': Permission denied
+chown: cannot access '/mnt/nfs1/193.3516.user': No such file or directory
 user: touch qa_user file (should succeed)
+touch: cannot touch '/mnt/nfs1/193.3516.user': Permission denied
 user: touch root file (should fail)
 touch: cannot touch 'test.root': Permission denied
 *** done

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Dxnq1zWXvFF0Q93v--
