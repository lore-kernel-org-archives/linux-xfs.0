Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08Luf3N009210 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 15:56:42 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB05817C0A8A
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 13:56:40 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id C8FJZpmjDWfAkT4t for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 13:56:40 -0800 (PST)
Date: Thu, 8 Jan 2009 22:56:02 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090108215602.GA24479@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107185628.GA19255@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


I needed the parallel port driver so i compiled 2.6.28-git3 with debug info.
It barfed: http://www.dth.net/kernel/c3/netconsole_2.6.28-git3-d.txt

I re-compiled git2 (with debug support) and <knock wood> so far it is stable:

# procinfo
Memory:        Total        Used        Free     Buffers                       
RAM:          507116      258048      249068         428                       
Swap:         497972           0      497972                                   

Bootup: Thu Jan  8 12:00:04 2009   Load average: 0.10 0.37 0.19 2/104 2767     

user  :   00:02:55.96   2.6%  page in :           183385                       
nice  :   00:00:00.00   0.0%  page out:           497130                       
system:   00:00:47.36   0.7%  page act:            23771                       
IOwait:   00:00:28.21   0.4%  page dea:                0                       
hw irq:   00:00:02.10   0.0%  page flt:           698907                       
sw irq:   00:00:03.37   0.0%  swap in :                0                       
idle  :   01:48:06.90  96.2%  swap out:                0                       
uptime:   01:52:23.93         context :           323529                       

irq   0:     293258  timer               irq  10:     112849  eth0             
irq   1:          8  i8042               irq  11:      42028  sata_promise     
irq   2:          0  cascade             irq  12:          0  uhci_hcd:usb1, uh
irq   5:          0  acpi                irq  14:       7629  pata_via         
irq   7:          1  parport0            irq  15:          0  pata_via         

sda             2740r            3576w   sdb             1037r             325w
sda1              70r               2w   sdb1            1024r             325w
sda2               2r               0w   sdc             2615r           14257w
sda5              25r               0w   sdc1            2602r           14257w
sda6            2636r            3574w                                         

lo          TX 5.68MiB       RX 5.68MiB       eth0        TX 86.38MiB      RX 10.32MiB     
-------------------
So (in my case) something while going from git2 -> git3 didn't go positive.
If i could get some explanation howto gdb the vmlinux image to determine in what
function the git3 barfed, i would be able to give more info/feedback.
I looked in the Documents folder in the kernel source, i looked at the examples
given there but i really dont understand how/what.


Danny
-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
