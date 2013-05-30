Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E14497F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 00:21:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BFFEAC003
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 22:21:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4euvA6Y2ES8g2LVd for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 22:21:28 -0700 (PDT)
Date: Thu, 30 May 2013 15:20:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.3: Oops running xfstests
Message-ID: <20130530052049.GK29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
	<1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: CAI Qian <caiqian@redhat.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 29, 2013 at 11:45:28PM -0400, CAI Qian wrote:
> Also reproduced this on 3.9.4 on several different machines.

How? what workload are you running that causes it to occur?

<snip stack trace showing page overrun in
xfs_attr_leaf_compact/xfs_attr_leaf_moveents> 

> System information is below:
> 
> + cat /proc/mounts
....
> /dev/mapper/rhel_hp--xw9400--02-root / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> /dev/mapper/rhel_hp--xw9400--02-home /home xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> /dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0

Which of these filesystems did it happen on? Or some other
filesystem not mounted when you took this snapshot?

And can you post the xfs_info output of the filesystems under test,
too?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
