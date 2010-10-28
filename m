Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9SNVolh068285 for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 18:31:51 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D72F3136E8F4
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 16:48:55 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id B2r5BRFpTbUAJhE8
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 16:48:55 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id ED3496C11D
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 18:33:08 -0500 (CDT)
Message-ID: <4CCA0834.8040703@hardwarefreak.com>
Date: Thu, 28 Oct 2010 18:33:08 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS journaling position
References: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>	<alpine.DEB.1.10.1010271011510.27409@castor.opentrend.net>	<alpine.DEB.1.10.1010271027511.27409@castor.opentrend.net>
	<201010281144.39307@zmi.at>
In-Reply-To: <201010281144.39307@zmi.at>
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

Michael Monnerie put forth on 10/28/2010 4:44 AM:
> On Mittwoch, 27. Oktober 2010 Robert Brockway wrote:
>> Similarly virtual hosts have little chance of trying to establish
>> the  physical nature of the device holding their filesystems.
> 
> Yes, performance optimizations will be fun in the near future. VMs, thin 
> provisioning, NetApps WAFL, LVM, funny disk layouts, all can do things 
> completely different than our "old school" thinking. I wonder when 
> there's gonna be an I/O scheduler that just elevates the I/O from a VM 
> to the real host, so that the host itself can optimize and align. After 
> all, a VM has no idea of the storage. That's why already now you can 
> choose "noop" as the scheduler in a VM. I guess there will be a 
> "virtualized" scheduler once, but we will see.

I don't see how any of this is really that different from where we
already are with advanced storage systems and bare metal host OSes.
We're already virtualized WRT basic SAN arrays and maybe even some PCIe
RAID cards if they allow carving a RAID set into LUNs.

Take for example a small FC/iSCSI SAN array controller box with 16 x 1TB
SATA drives.  We initialize it using the serial console, web gui, or
other management tool into a single RAID 6 array with 14TB of raw space
using a 256KB stripe size.  We then carve this 14TB into 10 LUNs, 1.4TB
each, and unmask each LUN to the FC WWN of a bare metal host running
Linux.  Lets assume the array controller starts at the outside edge of
each disk and works its way to the inner cylinder when creating each
LUN, which seems like a logical way for a vendor to implement this.  We
now have 10 LUNs each with progressively less performance than the one
preceding it due to its location on the platters.

Now, on each host we format the 1.4TB LUN with XFS.  In this
configuration, given that the LUNs are spread all across the platters,
from outside to inside cylinder, is it really going to matter where each
AG or the log is located, from a performance standpoint?

The only parameters we actually know for sure here are the stripe width
(14) and the stripe size (256KB).  We have no knowledge of the real
layout of the cylinders when we run mkfs.xfs.

So as we move to a totally virtualized guest OS, we then lose the stripe
width and stripe size information.  How much performance does this
really cost us WRT XFS filesystem layout?  And considering these are VM
guests, which are by design meant for consolidation, not necessarily
performance, are we really losing anything at all, when looking at the
big picture?  How many folks are running their critical core business
databases in virtual machine guests?  How about core email systems?
Other performance/business critical applications?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
