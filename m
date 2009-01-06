Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n061AMER031429 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 19:10:22 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19C8215B7E6B
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 17:10:19 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	JMUGWvLglcnV6gz8 for <xfs@oss.sgi.com>;
	Mon, 05 Jan 2009 17:10:19 -0800 (PST)
Date: Tue, 6 Jan 2009 12:10:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: retrocompatibility XFS 2.10.1 with 2.8.1 ?
Message-ID: <20090106011014.GA9448@disturbed>
References: <BAY123-W145701C4842C1B063295BDEAE10@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAY123-W145701C4842C1B063295BDEAE10@phx.gbl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Tritium Tritium <tritium_helium@hotmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 05, 2009 at 07:04:30PM +0000, Tritium Tritium wrote:
> 
> HI !
> 
> In first, I 'm a french user and sorry for my very bad english ...
> For an Adsl Box, I want to partitionning and format my external hard disk drive under XFS .What a good idea , isn't it ? ;o)
> I get my Mandriva One (I know it isn't a "professionnal" distribution but you know the French search the simple thing !) and use fdisk -l , gparted and mkfs.xfs /dev/xxx .
> With this, the adsl box reboot ! And of course it doesn't recognize the partition.
> I tried with a Debian Etch XFS ... and this is a SUCCESS !
> When I compare XFS versions I find a 2.10.1 for Mandriva and 2.8.1 for Debian.

The defaults mkfs.xfs uses in 2.10.1 are different to 2.8.1. The
newer version enables features that are only availble in more recent
kernels (since about 2.6.19, IIRC), so it would seem that your ADSL
box has an old kernel on it that does not support the newer, faster,
shinier features XFS has....

The kernel version of your ADSL box, as well as the mkfs.xfs output
from both distro's would help confirm this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
