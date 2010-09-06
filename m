Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o86MsZZh205282 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 17:54:36 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 794F11E5EFE4
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 15:55:16 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id hiFRvhmiqH2hGPsU for
	<xfs@oss.sgi.com>; Mon, 06 Sep 2010 15:55:16 -0700 (PDT)
Message-ID: <4C857152.4060904@sauce.co.nz>
Date: Tue, 07 Sep 2010 10:55:14 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
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

Michael Monnerie wrote:

 > When I defined su/sw on mkfs, is it enough, or would I always have to
 > specify sunit/swidth with every mount too?

Yes. sunit/swidth only needs to be added to your fstab if you either got 
the calculation wrong when you initially created the fs and wish to 
correct it, or if you grow the fs later over more drives.

Note that with recent kernels, mkfs.xfs will choose the optimal 
sunit/swidth for you if you are using md RAID or LVM (I believe the 
latter is correct).

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
