Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7BExHHZ242777 for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 09:59:17 -0500
Received: from mx4.geneon.de (76.reverse.geneon.de [89.244.16.76]) by
	cuda.sgi.com with ESMTP id 6DMM7kDEA2qlb0ct for
	<xfs@oss.sgi.com>; Sat, 11 Aug 2012 07:59:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mx4.geneon.de (Postfix) with ESMTP id 876DD18F9BC
	for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 16:53:23 +0200 (CEST)
Received: from mx4.geneon.de ([127.0.0.1])
	by localhost (mx4 [127.0.0.1]) (amavisd-new, port 10024) with LMTP
	id 10109-01-8 for <xfs@oss.sgi.com>;
	Sat, 11 Aug 2012 16:53:23 +0200 (CEST)
Received: from galaxy.nbg.geneon.de (backupnas [89.244.16.77])
	by mx4.geneon.de (Postfix) with ESMTP id 6C6BD96281
	for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 16:53:23 +0200 (CEST)
From: Andreas Vogler <andreas.vogler@geneon.de>
Date: Sat, 11 Aug 2012 16:59:11 +0200
Subject: bad version from xfs_repair after raid crash
Message-ID: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E94@COSMOS.nbg.geneon.de>
Content-Language: de-DE
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi all,

we had a crash of a raid 5 system. After rebuilding we could access one of  two partitions. Upon mounting the second parttion we got an error "mount: Structure needs cleaning". So we tried using xfs_repair.

Xfs_repair returns: "bad primary superblock - bad version number !!!"

and tries to find a secondary superblock but gives up after scanning the volume.

Looking at the superblock with xfs_db looks good as far as I can tell. Can anybody give me a hint what "bad version number" means?

Thank you very much in advance.

  Andreas Vogler

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
