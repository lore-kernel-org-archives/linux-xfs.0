Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8AN7Ukh170643 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 18:07:31 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 286CB648DE
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 16:08:13 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id jTSfDaxUKBPbV7Io for
	<xfs@oss.sgi.com>; Fri, 10 Sep 2010 16:08:13 -0700 (PDT)
Message-ID: <4C8ABA5B.7080604@sauce.co.nz>
Date: Sat, 11 Sep 2010 11:08:11 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: XFS over LVM over md RAID
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

  Stan Hoeppner wrote:

 > What is the reasoning behind adding so many terabytes under a single 
filesystem?

Heavily scripted project environments, where initial storage estimates 
are exceeded and more needs to be added without the complications of 
managing seperate filesystems part way through.

It is unlikely that more than 2 arrays would be involved and I used the 
example to try and understand how XFS adapts to changing topologies.

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
