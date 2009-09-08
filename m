Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n88DpYnW072664 for <xfs@oss.sgi.com>; Tue, 8 Sep 2009 08:51:45 -0500
Received: from ICIQEXC02.ICIQ.ES (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE3521604A5F
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2009 06:52:01 -0700 (PDT)
Received: from ICIQEXC02.ICIQ.ES (ns2.iciq.es [193.146.115.194]) by
	cuda.sgi.com with ESMTP id cSciAloRM6LWGWki for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2009 06:52:01 -0700 (PDT)
Subject: warn users soft quota exceeded
From: Martin Gumbau <mgumbau@ICIQ.ES>
Date: Tue, 8 Sep 2009 15:51:38 +0200
Message-ID: <1252417898.2452.64.camel@p005>
MIME-Version: 1.0
Reply-To: mgumbau@ICIQ.ES
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

Hi,
I try o manage soft xfs_quota warning messages with:

	xfs_quota -x -c 'warn 2 userA' /QUOTEDPARTITION

and any warn message is sent to userA when user exceeded soft quota.
How can I warn user when the user-disk-limit is coming?


------------------------------------------------------------------------------
$ xfs_info /QUOTEDPARTITION

meta-data=/dev/sdb1              isize=256    agcount=16, agsize=7631000
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=122096000,
imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

------------------------------------------------------------------------------
$ xfs_quota -x -c 'state'

User quota state on /QUOTEDPARTITION (/dev/sdb1)
  Accounting: ON
  Enforcement: ON
  Inode: #40089640 (9 blocks, 7 extents)
Group quota state on  /QUOTEDPARTITION(/dev/sdb1)
  Accounting: OFF
  Enforcement: OFF
  Inode: #18446744073709551615 (0 blocks, 0 extents)
Project quota state on /QUOTEDPARTITION (/dev/sdb1)
  Accounting: OFF
  Enforcement: OFF
  Inode: #18446744073709551615 (0 blocks, 0 extents)
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [7 days 00:00:30]
Realtime Blocks grace time: [--------]


------------------------------------------------------------------------------
$ xfs_quota -x -c report /QUOTEDPARTITION

User quota on /QUOTEDPARTITION (/dev/sdb1)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
...
userA       2566056    2566056    2600100     02  [6 days]
...







-- 
Martin Gumbau Gonzalez
System Manager
ICIQ - Theoretical chemistry computing groups
mgumbau@iciq.es - http://www.iciq.es
Tel. 977 920 200 - ext 308



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
