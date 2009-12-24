Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBOAUUc4064413 for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 04:30:31 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 451DC1259B3
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 02:31:13 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	6ps188INg7SQjPdI for <xfs@oss.sgi.com>;
	Thu, 24 Dec 2009 02:31:13 -0800 (PST)
Date: Thu, 24 Dec 2009 02:31:10 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: benchmark results
Message-ID: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
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
To: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org

I've had the chance to use a testsystem here and couldn't resist running a 
few benchmark programs on them: bonnie++, tiobench, dbench and a few 
generic ones (cp/rm/tar/etc...) on ext{234}, btrfs, jfs, ufs, xfs, zfs.

All with standard mkfs/mount options and +noatime for all of them.

Here are the results, no graphs - sorry:
   http://nerdbynature.de/benchmarks/v40z/2009-12-22/

Reiserfs is locking up during dbench, so I removed it from the 
config, here are some earlier results:

   http://nerdbynature.de/benchmarks/v40z/2009-12-21/bonnie.html

Bonnie++ couldn't complete on nilfs2, only the generic tests 
and tiobench were run. As nilfs2, ufs, zfs aren't supporting xattr, dbench 
could not be run on these filesystems.
   
Short summary, AFAICT:
    - btrfs, ext4 are the overall winners
    - xfs to, but creating/deleting many files was *very* slow
    - if you need only fast but no cool features or journaling, ext2
      is still a good choice :)

Thanks,
Christian.
-- 
BOFH excuse #84:

Someone is standing on the ethernet cable, causing a kink in the cable

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
