Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAKGNha4173293 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 10:23:43 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id BC20018B7F1E
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 08:24:05 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id Gq2IP9xAAyivCFQ3 for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2009 08:24:05 -0800 (PST)
From: Juergen Urban <JuergenUrban@gmx.de>
Subject: Re: BUG() in end_page_writeback(),
	=?iso-8859-1?q?=09stack_overflows_and_system_speed_decrease_with_XFS_over?=
	=?iso-8859-1?q?_USB?=
Date: Fri, 20 Nov 2009 17:23:47 +0100
References: <200911190957.45957.JuergenUrban@gmx.de>
	<4B0587B0.3020702@sandeen.net>
In-Reply-To: <4B0587B0.3020702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911201723.48033.JuergenUrban@gmx.de>
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

On Thursday 19 November 2009 19:00:16 Eric Sandeen wrote:
> Juergen Urban wrote:
> > Hello,
> >
> > my machine is running very unstable since I use XFS on an external USB
> > harddisc (855 GByte XFS partition on 1TByte). One problem was the stack
> > overflows caused by the large stack use of XFS, USB, SCSI and VFS in
> > Linux 2.6.23.13. NFS on XFS caused much more stack overflows. I think I
> > got around the stack overflows by disabling preemption, SMP and NFS in
> > Linux, but I am not sure about it. I think that I didn't got a message
> > from the stack overflow detection after this.
>
> Are you on 4k stacks?  To be honest I'd still expect things to be mostly
> ok stack-wise even if so.

No, I am using 8k stacks.

>
> > I also tried a Live-CD (KNOPPIX), but there are the same
> > problems. I exchanged some of the hardware. XFS is decreasing system
> > performance.  I use the Linux VDR with DVB-S which seems to increase the
> > problems. I was able to record 3 high bandwidth streams in parallel
> > before using XFS.
>
> Really, you could record 3 parallel high-def TV streams to ext3 via USB?
> I guess I'm a little surprised...
>

No, I meant that I was able to record 3 high bandwidth SDTV streams on the 
internal hard disc with ext3. Then I've got an external USB drive and 
formatted it with XFS, because someone told me that XFS is running stable with 
VDR on an internal hard disc.

> > Now it has problems to record one high bandwidth stream.  The
> > system got a little bit usable after I changed the IO scheduler to
> > deadline. It is difficult to get a good backtrace of the kernel crash,
> > because the backlog is not saved on the internal harddisc (reiserfs and
> > ext3). I was able to find out that XFS triggers a BUG() in
> > end_page_writeback() at mm/filemap.c:552:
> >
> > void end_page_writeback(struct page *page)
> > {
> >         if (!TestClearPageReclaim(page) || rotate_reclaimable_page(page))
> > { if (!test_clear_page_writeback(page))
> >                         BUG();
> >         }
> >         smp_mb__after_clear_bit();
> >         wake_up_page(page, PG_writeback);
> > }
>
> Regarding the bug, if there is any way to test a kernel newer than .23,
> I'd start there; I don't know offhand of a bug that was fixed here, but
> .23 was a long time ago...

Now I tried linux-2.6.31.6. My system hangs in the start scripts. Maybe this 
is caused by network scripts. I got the message that ehci_hcd need to be 
loaded before uhci_hcd and ohci_hcd. I skipped uhci_hcd and ohci_hcd in 
/etc/discover.conf. Now I have a higher performance with linux-2.6.23.13 and I 
can record 3 normal streams in parallel on the with USB and XFS. But it is 
still unstable. The last error what I got was in block_prepare_write 
(fs/buffer.c). This caused follow up errors in do_invalidate_page() called by 
xfs_get_blocks().
Sometimes there are file system deadlocks. I can do everything, but not access 
the file system. Every try to access the file system leads to a deadlock of the 
program. This normally happens after a kernel exception.

>
> > The backtrace looks like this (Sorry, I needed to write it down from
> > screen and I don't have everything):
> >
> > end_page_writeback()
> > end_buffer_async_write()
> > update_stats_wait_end()
> > xfs_setfilesize()
> > xfs_???_dealloc()
> > xfs_destroy_ioend()
> > run_workqueue()
> >
> > After searching in the code I found:
> > /* TODO: cleanup count and page_dirty */
> >
> > It seems that page_dirty may be handled wrong and could cause the
> > problem, but I don't know the purpose of this stuff. The same comment is
> > in the latest source code from GIT.
> > After running the system for while, I was able to trigger the kernel
> > crash by starting "sync" in the command line.
> > My stack traces includes often dvb_dmx_swfilter_packets(),
> > do_IRQ()/tasklets and sys_write()/vfs_write(). I can't scroll up in most
> > situations. Can anyone help me?
> > Is there an easy way to backup the data or replace the file system
> > without kernel crash in between?
>
> You should certainly be able to copy data off xfs via usb; if it's
> failing, I guess we'll need more info to find out why, but I'd suggest
> at least booting a newer livecd to do that copy and see if things fare
> better.

My idea was to shrink it and create a new partition where I can copy the data. 
As far as I understand I need to mount it for the shrink process, so I may 
have the problem of kernel exceptions while shrinking.

>
> -Eric
>
> > Best regards
> > Juergen Urban
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
