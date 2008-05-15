Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 22:38:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4F5ccth015373
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 22:38:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0D4C16FA0D
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 22:39:25 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id cZCUk75Z8I0gT4kI for <xfs@oss.sgi.com>; Wed, 14 May 2008 22:39:25 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4F5dIF3016691
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 07:39:18 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4F5dIKc016689
	for xfs@oss.sgi.com; Thu, 15 May 2008 07:39:18 +0200
Date: Thu, 15 May 2008 07:39:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't run test 167 if killall is not installed
Message-ID: <20080515053918.GA16530@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Test 167 will leave runaway fsstress processes around in case killall is
not installed and thus make all following tests fail.  This patch checks
for killall beeing installed and error out otherwise.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/167
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/167,v
retrieving revision 1.3
diff -u -p -r1.3 167
--- xfstests/167	2 Aug 2007 16:19:56 -0000	1.3
+++ xfstests/167	15 May 2008 05:34:20 -0000
@@ -13,6 +13,7 @@ owner=dgc@sgi.com
 seq=`basename $0`
 echo "QA output created by $seq"
 
+killall="/usr/bin/killall"
 here=`pwd`
 tmp=/tmp/$$
 rm -f $seq.full
@@ -43,6 +44,8 @@ workout()
 _supported_fs xfs
 _supported_os Linux
 
+[ -x $killall ] || _notrun "$killall executable not found"
+
 _setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
