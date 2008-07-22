Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 01:49:10 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M8n72M014956
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 01:49:08 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D8441918579
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 01:50:16 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 0oa2rAfYfLk67e9U for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 01:50:16 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6M8o7Ng000705
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 10:50:07 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6M8o7i1000703
	for xfs@oss.sgi.com; Tue, 22 Jul 2008 10:50:07 +0200
Date: Tue, 22 Jul 2008 10:50:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix XFSQA 096 for recent xfsprogs
Message-ID: <20080722085007.GA32499@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

With recent xfsprogs xfs_info is aware of the case insensitive support
and displays ascii-ci=[01] in the naming section.  Update testcase 096
to strip away this information in the big sed expression.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/096
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/096,v
retrieving revision 1.13
diff -u -p -r1.13 096
--- xfstests/096	30 Nov 2007 03:07:14 -0000	1.13
+++ xfstests/096	22 Jul 2008 08:34:53 -0000
@@ -64,6 +64,7 @@ _mkfs_filter()
 	-e '/ *= *sectsz=[0-9][0-9]* *attr=[0-9][0-9]*$/d' \
 	-e '/ *= *mmr=[0-9][0-9]* *$/d' \
 	-e 's/ *mixed-case=[YN]//' \
+	-e 's/ *ascii-ci=[01]//' \
 	-e 's/sectsz=[0-9][0-9]* *//' \
 	-e 's/, lazy-count.*//' \
 	-e '/inode-paths/d' \
