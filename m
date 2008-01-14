Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 09:37:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0EHbRUq021176
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 09:37:31 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 692A351918F
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 09:37:43 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2WpWnjSg9CbfbWQU for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 09:37:43 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m0EHbbF3014300
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 18:37:37 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m0EHbaBg014298
	for xfs@oss.sgi.com; Mon, 14 Jan 2008 18:37:36 +0100
Date: Mon, 14 Jan 2008 18:37:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix XFSQA #184 for multiple invocations
Message-ID: <20080114173736.GA14234@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Make sure the device node is removed before creating it to allow running
the testcase multiple times without recreating the filesystem.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/184
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/184,v
retrieving revision 1.1
diff -u -p -r1.1 184
--- xfstests/184	19 Dec 2007 05:14:33 -0000	1.1
+++ xfstests/184	12 Jan 2008 13:57:26 -0000
@@ -35,6 +35,7 @@ _supported_os IRIX Linux
 
 _setup_testdir
 
+rm -f $testdir/null
 mknod $testdir/null c 1 3
 chmod 666 $testdir/null
 echo fred > $testdir/null
