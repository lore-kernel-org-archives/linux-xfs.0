Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9148ntW014690 for <xfs@oss.sgi.com>; Thu, 30 Sep 2010 23:08:49 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8799EA1AB3
	for <xfs@oss.sgi.com>; Thu, 30 Sep 2010 21:23:02 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id LrE2V0dxlzWzV3cp for
	<xfs@oss.sgi.com>; Thu, 30 Sep 2010 21:23:02 -0700 (PDT)
Message-ID: <4CA55F09.2010609@sauce.co.nz>
Date: Fri, 01 Oct 2010 17:09:45 +1300
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Quota confusion
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I am setting up project quota at 95% of  the storage capacity. df shows:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/dm-0            13672271872 11816602148 1855669724  87% /mnt/storage1

so I set it:

limit -p bhard=12988658278k 1

but when I do an xfs_quota "quota -p 1":

Disk quotas for Project shares (1)
Filesystem              Blocks      Quota      Limit  Warn/Time 
Mounted on
/dev/dm-0           11816148292          0 12988658280   00 [--------] 
/mnt/storage1

the number of blocks is less than the limit.

Also, an xfs_quota df:

Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/dm-0           13672271872 11816602148 1855669724   87% /mnt/storage1
/dev/dm-0           13672271872 23632296584 1855669724  173% 
/mnt/storage1/share

I do not understand the lower "Used" figure.

Any help appreciated.

Regards,

Richard


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
