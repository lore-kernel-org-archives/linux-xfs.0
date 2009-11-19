Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJ8vjFa251757 for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 02:57:46 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 13F949A36A
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 00:58:07 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id guz9JPRATONaYHZw for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2009 00:58:07 -0800 (PST)
From: Juergen Urban <JuergenUrban@gmx.de>
Subject: BUG() in end_page_writeback(),
	stack overflows and system speed decrease with XFS over USB
Date: Thu, 19 Nov 2009 09:57:45 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911190957.45957.JuergenUrban@gmx.de>
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

Hello,

my machine is running very unstable since I use XFS on an external USB 
harddisc (855 GByte XFS partition on 1TByte). One problem was the stack 
overflows caused by the large stack use of XFS, USB, SCSI and VFS in Linux 
2.6.23.13. NFS on XFS caused much more stack overflows. I think I got around 
the stack overflows by disabling preemption, SMP and NFS in Linux, but I am not 
sure about it. I think that I didn't got a message from the stack overflow 
detection after this. I also tried a Live-CD (KNOPPIX), but there are the same 
problems. I exchanged some of the hardware. XFS is decreasing system 
performance.  I use the Linux VDR with DVB-S which seems to increase the 
problems. I was able to record 3 high bandwidth streams in parallel before 
using XFS. Now it has problems to record one high bandwidth stream.  The 
system got a little bit usable after I changed the IO scheduler to deadline.
It is difficult to get a good backtrace of the kernel crash, because the backlog 
is not saved on the internal harddisc (reiserfs and ext3). I was able to find 
out that XFS triggers a BUG() in end_page_writeback() at mm/filemap.c:552:

void end_page_writeback(struct page *page)
{
        if (!TestClearPageReclaim(page) || rotate_reclaimable_page(page)) {
                if (!test_clear_page_writeback(page))
                        BUG();
        }
        smp_mb__after_clear_bit();
        wake_up_page(page, PG_writeback);
}

The backtrace looks like this (Sorry, I needed to write it down from screen 
and I don't have everything):

end_page_writeback()
end_buffer_async_write()
update_stats_wait_end()
xfs_setfilesize()
xfs_???_dealloc()
xfs_destroy_ioend()
run_workqueue()

After searching in the code I found:
/* TODO: cleanup count and page_dirty */

It seems that page_dirty may be handled wrong and could cause the problem, but 
I don't know the purpose of this stuff. The same comment is in the latest 
source code from GIT.
After running the system for while, I was able to trigger the kernel crash by 
starting "sync" in the command line.
My stack traces includes often dvb_dmx_swfilter_packets(), do_IRQ()/tasklets 
and sys_write()/vfs_write(). I can't scroll up in most situations.
Can anyone help me?
Is there an easy way to backup the data or replace the file system without 
kernel crash in between?

Best regards
Juergen Urban

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
