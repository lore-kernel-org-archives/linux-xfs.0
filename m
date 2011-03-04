Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p242dF34130256 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 20:39:16 -0600
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1C34311710
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 18:42:06 -0800 (PST)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id I7JzIwnJ7XADSe54
	for <xfs@oss.sgi.com>; Thu, 03 Mar 2011 18:42:06 -0800 (PST)
Received: by vws8 with SMTP id 8so1693244vws.26
	for <xfs@oss.sgi.com>; Thu, 03 Mar 2011 18:42:06 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 4 Mar 2011 11:42:05 +0900
Message-ID: <AANLkTimnivTBGhwpYZPapiPMRa0aCTgfwDUOc3Vo3Fsj@mail.gmail.com>
Subject: When XFS saves secondary Super block
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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

Often when primary super block is corrupted, and xfs_repair is run on
it, it try to find the secondary super block traversing in block units
from XFS_AG_MIN_BYTES to end of partition.
Now the problem is at first place we do not know whether we actually
have secondary super block or not on partition,
because if we know this inadvance then we may not waste time in
scanning a complete disk.
User point of view is that its like xfs_repair hangs (offcourse
developer knows its not, point of view are different)

1. In which case secondary super block is created, is it created
during format itself, if yes then at what location.
2. In our case we always find that when ever primary super block is
corrupted, xfs_repair never find secondary super block also, so we are
doubt ful of its existence. If its not there then we can just exit
xfs_repair instead of waiting for minutes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
