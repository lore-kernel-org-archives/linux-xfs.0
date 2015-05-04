Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D249C7F59
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 20:49:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA968304043
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 18:49:32 -0700 (PDT)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56]) by
	cuda.sgi.com with ESMTP id T1O2vptnG6vnILGc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 May 2015 18:49:29 -0700 (PDT)
From: "=?ISO-8859-1?B?V2FuZyBTaGVuZy1IdWk=?=" <shhuiw@foxmail.com>
Subject: xfstests: what's the difference between generic/043 and generic/044
Mime-Version: 1.0
Date: Mon, 4 May 2015 09:49:20 +0800
Message-ID: <tencent_5AC82BAD44B2E3AE054828D2@qq.com>
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
To: =?ISO-8859-1?B?eGZz?= <xfs@oss.sgi.com>

Hi,

I'm reading the source code of generic/044 in xfstests, and I cannot figure out the
difference compared with 043 testcase:
-------------------------------------------------------------------------------
$ diff -Nu 043 044
--- 043 2015-03-09 10:03:48.013887582 +0800
+++ 044 2015-03-09 10:03:48.013887582 +0800
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FSQA Test No. 043
+# FSQA Test No. 044
 #
 # Test for NULL files problem
 #
@@ -56,6 +56,12 @@
                echo error creating/writing file $file
                exit
        fi
+       xfs_io -c "truncate 64k" $file &gt; /dev/null
+       if [ $? -ne 0 ]
+       then
+               echo error truncating file $file
+               exit
+       fi
        let i=$i+1
 done


But before the 'truncate 64K', only 64K sized files are created:
                 xfs_io -f -c "pwrite -b 64k -S 0xff 0 64k" $file &gt; /dev/null
So I think it's useless here, or some typo e.g smaller truncate needed?


Regards,
Wang Sheng-Hui
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
