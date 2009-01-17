Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HNPNFH017072 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 17:25:24 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 661B599115
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 15:25:16 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id eNpPTIHkA6fvQ4BI for <xfs@oss.sgi.com>;
	Sat, 17 Jan 2009 15:25:16 -0800 (PST)
Date: Sun, 18 Jan 2009 00:25:11 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090117232511.GA8443@dth.net>
References: <20090109020800.GO9448@disturbed> <20090109061043.GA31450@dth.net>
	<20090109194445.GA28759@infradead.org>
	<20090109195144.GA19857@dth.net>
	<20090109195852.GA6362@infradead.org>
	<20090109214206.GA2901@dth.net>
	<20090109220138.GA5282@infradead.org>
	<20090113200414.GA21013@dth.net> <20090116204346.GA5117@dth.net>
	<20090117073824.GK8071@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090117073824.GK8071@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Quoting Dave Chinner (david@fromorbit.com):
> Sorry for not getting back to you sooner.

No problem. I initally posted to LKLM, git redirected by Christoph to this
list. I'm so stupid that i didn't check the other messages from this list.
Sorry.

> I think that Alexander tripped over this same problem during his bisect.
> If you follow the thread from here:
> http://oss.sgi.com/archives/xfs/2009-01/msg00496.html

Yep! [cheer] i'm not alone! :-)
But why only us two ? there must be thousands of users out there using
XFS. Why did it bite us ? large filesystem together with slow hardware ?

> You'll see that Alexander had the same problem and managed
> to continue the bisect once he copied the xfs_btree_trace.h
> header file from top-of-tree back into the broken commits.

Grwat.

> I hope this helps (and I hope that the bisect lands on the
> same commit that it did for Alexander).

Do you want me to still try it ?
I think you allready figured out where the culprit is ?!

I saw changes in the announcement of 2.6.29-rc3 and took the plunge:

# procinfo
Memory:        Total        Used        Free     Buffers                       
RAM:          506940      447868       59072          84                       
Swap:         497972           0      497972                                   

Bootup: Sat Jan 17 10:28:27 2009   Load average: 0.03 0.11 0.09 2/104 5259     

user  :   00:09:30.12   3.2%  page in :           417582                       
nice  :   00:00:00.00   0.0%  page out:          1220260                       
system:   00:02:01.76   0.7%  page act:            41134                       
IOwait:   00:03:34.28   1.2%  page dea:            13444                       
hw irq:   00:00:01.94   0.0%  page flt:          1531395                       
sw irq:   00:00:04.50   0.0%  swap in :                0                       
idle  :   04:39:41.90  94.8%  swap out:                0                       
uptime:   04:54:55.09         context :           892623                       

irq   0:     799012  timer               irq  10:     101465  eth0             
irq   1:          8  i8042               irq  11:      46893  sata_promise     
irq   2:          0  cascade             irq  12:          0  uhci_hcd:usb1, uh
irq   5:          0  acpi                irq  14:      50059  pata_via         
irq   7:          1  parport0            irq  15:          0  pata_via         

sda            15445r           22597w   sdb             2820r           23372w
sda1             555r             284w   sdb1            2750r           23372w
sda2               2r               0w   sdc               63r               3w
sda5             136r               0w   sdc1              50r               3w
sda6           14659r           22313w                                         

lo          TX 59.65KiB      RX 59.65KiB      eth0        TX 13.40MiB      RX 23.78MiB     

over 4 hours of uptime and moderate usage, so i'm not 100% convinced but this one
looks good (so far)

Let me know if i should persue some more.

Thanks for all the help.

Danny
-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
