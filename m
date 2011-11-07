Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7KIK0x074880 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:18:20 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C69BB2267A3
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 12:18:18 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QKCcB86YrBsmW1TW for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 12:18:18 -0800 (PST)
Date: Tue, 8 Nov 2011 07:18:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Crash with XFS
Message-ID: <20111107201816.GF5534@dastard>
References: <1320676611.3192.36.camel@AlfLaptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320676611.3192.36.camel@AlfLaptop>
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
To: Alexander Naumann <alexandernaumann@gmx.de>
Cc: xfs@oss.sgi.com

On Mon, Nov 07, 2011 at 03:36:51PM +0100, Alexander Naumann wrote:
> Hi!
> 
> I would be glad if anybody can give me any hint on the following
> subject.
> I have a linux server running formatted with XFS. Afer a couple of days
> (about 6 or 7) I get the following crash:
> 
> 
> Nov  6 15:44:03 archive kernel: BUG: unable to handle kernel NULL
> pointer dereference at 0000000000000044
> Nov  6 15:44:03 archive kernel: IP: [<ffffffff811d3248>]
> xfs_inode_ag_iterator+0x4a/0xce

.....

> The system is a Dell R910 (Intek Xeon CPU E7530, 24 cores (with
> hyperthreading).  32GB Ram, Raid Controller is Perc H700, SAS
> discs, Raid 5 with 1.7TB, formatted with XFS.  Kernel version
> 2.6.34.7 is running (64bit kernel on a 32bit system, Debian
  ^^^^^^^^

Upgrade. There were problems in .34 to do with inode reclaim that
were fixed in .35 and .36....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
