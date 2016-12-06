Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:48853 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbcLFJJ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Dec 2016 04:09:26 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Tue, 06 Dec 2016 10:08:35 +0100
Message-ID: <3543192.v6q4dNmvom@libor-nb>
In-Reply-To: <20161110213057.GH28922@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb> <2152865.L3K5Xz7SXO@libor-nb> <20161110213057.GH28922@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Hello,
did you get anything useful from partial metadata dump?

Meanwhile, we have another VPS/machine acting like that, this one was installed as Debian Jessie, 
so it was always on some version of kernel 3.16 (+xfsprogs 3.2.1)
I wiil upgrade to kernel 4.7.8 and xfsprogs 4.8.0 and run check, repair and metadata dump.
Error has some new lines 

Dec  6 04:00:36 vps3 kernel: [29332726.258682] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs], block 0x4878b30
Dec  6 04:00:36 vps3 kernel: [29332726.259234] XFS (dm-2): Unmount and run xfs_repair
Dec  6 04:00:36 vps3 kernel: [29332726.259598] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Dec  6 04:00:36 vps3 kernel: [29332726.259929] ffff880129d9b000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Dec  6 04:00:36 vps3 kernel: [29332726.260661] ffff880129d9b010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Dec  6 04:00:36 vps3 kernel: [29332726.261552] ffff880129d9b020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Dec  6 04:00:36 vps3 kernel: [29332726.262594] ffff880129d9b030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Dec  6 04:00:36 vps3 kernel: [29332726.263800] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1330 of file /build/linux-HklQoT/linux-3.16.7-ckt20/fs/xfs/xfs_buf.c.  Return address = 0xffffffffa0385820
Dec  6 04:00:36 vps3 kernel: [29332726.277233] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
Dec  6 04:00:36 vps3 kernel: [29332726.277926] XFS (dm-2): Please umount the filesystem and rectify the problem(s)
Dec  6 04:00:36 vps3 kernel: [29332726.285057] Buffer I/O error on device dm-2, logical block 10636433
Dec  6 04:00:36 vps3 kernel: [29332726.285854] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.285860] Buffer I/O error on device dm-2, logical block 10636434
Dec  6 04:00:36 vps3 kernel: [29332726.286580] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.286602] Buffer I/O error on device dm-2, logical block 14169416
Dec  6 04:00:36 vps3 kernel: [29332726.287347] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.287354] Buffer I/O error on device dm-2, logical block 13145613
Dec  6 04:00:36 vps3 kernel: [29332726.288100] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.288105] Buffer I/O error on device dm-2, logical block 13145614
Dec  6 04:00:36 vps3 kernel: [29332726.288851] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.288856] Buffer I/O error on device dm-2, logical block 13145615
Dec  6 04:00:36 vps3 kernel: [29332726.289611] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.289615] Buffer I/O error on device dm-2, logical block 13145616
Dec  6 04:00:36 vps3 kernel: [29332726.290347] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.290352] Buffer I/O error on device dm-2, logical block 13145617
Dec  6 04:00:36 vps3 kernel: [29332726.291072] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.291075] Buffer I/O error on device dm-2, logical block 13145618
Dec  6 04:00:36 vps3 kernel: [29332726.291814] lost page write due to I/O error on dm-2
Dec  6 04:00:36 vps3 kernel: [29332726.291819] Buffer I/O error on device dm-2, logical block 13145619
Dec  6 04:00:36 vps3 kernel: [29332726.292535] lost page write due to I/O error on dm-2
Dec  6 04:00:48 vps3 kernel: [29332737.898720] XFS (dm-2): xfs_log_force: error 5 returned.


dm-2 is logical volume created on single disk without partitions


Could it be HW problem? HW servers do have ECC memory and HW raids

Thanks,
Libor


On pátek 11. listopadu 2016 8:30:57 CET Dave Chinner wrote:
> On Thu, Nov 10, 2016 at 05:04:48PM +0100, Libor Klep�? wrote:
> > On ?tvrtek 10. listopadu 2016 16:29:15 CET Dave Chinner wrote:
> > > Which:
> > > > > Phase 3 - for each AG...
> > > > > 
> > > > >         - scan (but don't clear) agi unlinked lists...
> > > > >         - process known inodes and perform inode discovery...
> > > > >         - agno = 0
> > > > >         - agno = 1
> > > > > 
> > > > > Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
> > > > > Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000
> > > 
> > > These two blocks. It looks like repair didn't clean them up?
> > > 
> > > Hmmmm - looking at the code I'm not sure that repair detects and
> > > removes empty attr leaf blocks, which would explain why the error
> > > showed up again.. Can you provide a metadump of the filesystem so we
> > > can did into the exact neature of the problem you are seeing?
> > 
> > Sure not a problem. How much time will it take giving xfs_repair took approx 40 minutes?
> 
> No longer than that, with agood possibility it will be much faster
> as metadump only needs 1 pass over the metadata, not three...
> 
> Cheers,
> 
> Dave.
> 


