Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 12:22:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5EJM1hh005274
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 12:22:01 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AD8E231D27
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 12:22:57 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 5YsUq2Tuwm6pR1lI for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 12:22:57 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5EJMmNW025306
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 21:22:49 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5EJMmrf025304
	for xfs@oss.sgi.com; Sat, 14 Jun 2008 21:22:48 +0200
Date: Sat, 14 Jun 2008 21:22:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix XFSQA 144
Message-ID: <20080614192248.GA24329@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Two really dumb bugs:

 - "foo & 0x3FFFFFFFFFFFF" doesn't cap at 1TB, but rather at more than
   two magnitudes larger than that.  That gets us EFBIG with typical
   32bit XFS setups.
 - the command array can easily overflow and thus let the test fail


Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfstests/dmapi/src/suite2/src/test_fileattr.c
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/dmapi/src/suite2/src/test_fileattr.c,v
retrieving revision 1.12
diff -u -p -r1.12 test_fileattr.c
--- xfstests/dmapi/src/suite2/src/test_fileattr.c	21 Sep 2007 04:15:06 -0000	1.12
+++ xfstests/dmapi/src/suite2/src/test_fileattr.c	14 Jun 2008 19:12:43 -0000
@@ -160,7 +160,7 @@ main(
 	char		*ls_path;
 	char		*pathname;
 	char            test_file[100];
-	char            command[100];
+	char            command[200];
 	int		num_files=50;
 	dm_stat_t	*stat_arr;
 	dm_stat_t	dmstat;
@@ -244,7 +244,7 @@ main(
 	  stat_arr[i].dt_uid=(uid_t)(rand()+rand()*0x10000);
 	  stat_arr[i].dt_gid=(gid_t)(rand()+rand()*0x10000);
 	  stat_arr[i].dt_mode=(mode_t)((rand()%4096)+32768);
-          stat_arr[i].dt_size=((dm_off_t)(rand()+rand()*0x10000)) & 0x3FFFFFFFFFFFF; /* 1 TB max */
+          stat_arr[i].dt_size=((dm_off_t)(rand()+rand()*0x10000)) & 0x1FFFFFFFFFFULL; /* 1 TB max */
 	}	
 
 	/*-----------------------------------------------------*\
