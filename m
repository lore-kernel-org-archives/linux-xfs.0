Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAKGaA0O174467 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 10:36:10 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BAD7A02FE
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 08:36:31 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Y372l6NAqLINYCEg for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2009 08:36:31 -0800 (PST)
Message-ID: <4B06C58F.5070203@sandeen.net>
Date: Fri, 20 Nov 2009 10:36:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: BUG() in end_page_writeback(), stack overflows and system speed
	decrease with XFS over USB
References: <200911190957.45957.JuergenUrban@gmx.de>	<4B0587B0.3020702@sandeen.net>
	<200911201723.48033.JuergenUrban@gmx.de>
In-Reply-To: <200911201723.48033.JuergenUrban@gmx.de>
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
To: Juergen Urban <JuergenUrban@gmx.de>
Cc: xfs@oss.sgi.com

Juergen Urban wrote:
> On Thursday 19 November 2009 19:00:16 Eric Sandeen wrote:
>> Juergen Urban wrote:
>>> Hello,
>>>
>>> my machine is running very unstable since I use XFS on an external USB
>>> harddisc (855 GByte XFS partition on 1TByte). One problem was the stack
>>> overflows caused by the large stack use of XFS, USB, SCSI and VFS in
>>> Linux 2.6.23.13. NFS on XFS caused much more stack overflows. I think I
>>> got around the stack overflows by disabling preemption, SMP and NFS in
>>> Linux, but I am not sure about it. I think that I didn't got a message
>>> from the stack overflow detection after this.
>> Are you on 4k stacks?  To be honest I'd still expect things to be mostly
>> ok stack-wise even if so.
> 
> No, I am using 8k stacks.

Hmm.

...

> Now I tried linux-2.6.31.6. My system hangs in the start scripts. Maybe this 
> is caused by network scripts. I got the message that ehci_hcd need to be 
> loaded before uhci_hcd and ohci_hcd. I skipped uhci_hcd and ohci_hcd in 
> /etc/discover.conf. Now I have a higher performance with linux-2.6.23.13 and I 
> can record 3 normal streams in parallel on the with USB and XFS. But it is 
> still unstable. The last error what I got was in block_prepare_write 
> (fs/buffer.c). This caused follow up errors in do_invalidate_page() called by 
> xfs_get_blocks().
> Sometimes there are file system deadlocks. I can do everything, but not access 
> the file system. Every try to access the file system leads to a deadlock of the 
> program. This normally happens after a kernel exception.

I guess including the kernel messages you see would help us know what
might be going on.

...

>>> Is there an easy way to backup the data or replace the file system
>>> without kernel crash in between?
>> You should certainly be able to copy data off xfs via usb; if it's
>> failing, I guess we'll need more info to find out why, but I'd suggest
>> at least booting a newer livecd to do that copy and see if things fare
>> better.
> 
> My idea was to shrink it and create a new partition where I can copy the data. 
> As far as I understand I need to mount it for the shrink process, so I may 
> have the problem of kernel exceptions while shrinking.

You can't shrink xfs, if that's what you mean.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
