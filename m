Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6NNvCLt087532 for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 18:57:12 -0500
Received: from mta11.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEA493815AD
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 16:57:55 -0700 (PDT)
Received: from mta11.charter.net (mta11.charter.net [216.33.127.80]) by
	cuda.sgi.com with ESMTP id G6ZV7Ota1CCmvVfm for
	<xfs@oss.sgi.com>; Thu, 23 Jul 2009 16:57:55 -0700 (PDT)
Received: from imp10 ([10.20.200.10]) by mta11.charter.net
	(InterMail vM.7.09.01.00 201-2219-108-20080618) with ESMTP
	id <20090723235754.JUPY22327.mta11.charter.net@imp10>
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 19:57:54 -0400
Received: from c400 (dhcp-yelw-03-11.internal.sessys.com [192.168.3.11])
	(authenticated bits=0) (authenticated user=elbles)
	by mail.sessys.com (8.13.7/8.13.7-SES__MASTER) with ESMTP id
	n6NNvq14012260
	(version=TLSv1/SSLv3 cipher=DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 19:57:53 -0400
From: "Sean Elble" <elbles@sessys.com>
Subject: Using xfsdump On Linux With IRIX Version 1 FS?
Date: Thu, 23 Jul 2009 19:57:52 -0400
Message-ID: <008401ca0bf1$64c2eac0$2e48c040$@com>
MIME-Version: 1.0
Content-Language: en-us
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

Hi all,

While I am aware that the current kernel implementation of XFS doesn't
support mounting an IRIX filesystem with version 1 directories, I'm not so
sure whether xfsdump/xfsrestore will support the dumping of an IRIX
filesystem with version 1 directories.  To be more specific, I am dealing
with an old disk from an Indigo2, running IRIX 6.5.6m with version 1
(0x1094) directories.  I was hoping it had version 2 directories, but after
finding an old SCSI card I could put in a Linux box with XFS support, I
found just the opposite, obviously.  I had the old SCSI card back in its
donor system (which was up-and-running) when it occurred to me that
xfsdump/xfsrestore *might* be a possibility, and I can't take it (the donor
system) down again unless I know I can make this work.

If anyone can give me an answer to this question, I would certainly
appreciate it.  I didn't see anything in the man pages, and my Google
searches have proven fruitless thus far, but I've been known to be blind on
occasion.  :-)  Thanks, in advance.

-- 
+-------------------------------------------------
|  Sean Elble      
|  Virginia Tech, Class of 2009
|  E-Mail:   elbles@sessys.com
|  Web:      http://www.sessys.com/~elbles/
|  Cell:     860.946.9477
+-------------------------------------------------



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
