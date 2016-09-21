Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbcIUGqk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Sep 2016 02:46:40 -0400
Date: Wed, 21 Sep 2016 14:46:38 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: xfs/032 find xfs corruption
Message-ID: <20160921064638.GT12847@dhcp12-143.nay.redhat.com>
References: <20160921042318.GR12847@dhcp12-143.nay.redhat.com>
 <20160921050804.GM340@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160921050804.GM340@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2016 at 03:08:05PM +1000, Dave Chinner wrote:
> On Wed, Sep 21, 2016 at 12:23:18PM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > xfs/032 trigger xfs(v4/v5) corruption after run it several times:
> > [root@dhcp-13-149 xfstests-dev]# xfs_repair -n ~/xfs-032.img 
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> > sb_icount 64, counted 256
> > sb_ifree 61, counted 242
> > sb_fdblocks 1038280, counted 1035431
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - process newly discovered inodes...
> > Phase 4 - check for duplicate blocks...
> >         - setting up duplicate extent list...
> >         - check for inodes claiming duplicate blocks...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> > entry "d8" in shortform directory 1572896 references free inode 38
> > would have junked entry "d8" in directory inode 1572896
> > No modify flag set, skipping phase 5
> > Phase 6 - check inode connectivity...
> >         - traversing filesystem ...
> > entry "d8" in shortform directory inode 1572896 points to free inode 38
> > would junk entry
> >         - traversal finished ...
> >         - moving disconnected inodes to lost+found ...
> > disconnected dir inode 524320, would move to lost+found
> > Phase 7 - verify link counts...
> > would have reset inode 1069090 nlinks from 2 to 1
> > would have reset inode 1572896 nlinks from 4 to 3
> > No modify flag set, skipping filesystem flush and exiting.
> 
> So, is the log dirty? if so, does mount/unmounting the filesystem
> get rid of all the problems? When the image file check fails, does
> an xfs_repair on the scratch device also fail, or is xfs_copy
> failing to copy the filesystem cleanly for some reason?

Hi Dave,

Looks like mount/umount can help to resolve this problem:
[root@dhcp-13-149 xfstests-dev]# mount -o loop ~/xfs-032.img /mnt/tmp/
[root@dhcp-13-149 xfstests-dev]# xfs_info /mnt/tmp
meta-data=/dev/loop0             isize=512    agcount=4, agsize=262144 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
data     =                       bsize=1024   blocks=1048576, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=1024   blocks=10240, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@dhcp-13-149 xfstests-dev]# umount /mnt/tmp
[root@dhcp-13-149 xfstests-dev]# xfs_repair -n ~/xfs-032.img
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_icount 64, counted 256
sb_ifree 61, counted 242
sb_fdblocks 1038280, counted 1035431
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
entry "d8" in shortform directory 1572896 references free inode 38
would have junked entry "d8" in directory inode 1572896
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "d8" in shortform directory inode 1572896 points to free inode 38
would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 524320, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 1069090 nlinks from 2 to 1
would have reset inode 1572896 nlinks from 4 to 3
No modify flag set, skipping filesystem flush and exiting.

Sorry I didn't describe it clearly, the scratch device is ok, only the
image file copied from the scratch device is corrupted.

I just uploaded the metadump file to my dropbox, maybe you can download
it by click below link (I haven't tried that before:):
https://dl-web.dropbox.com/get/xfs-032.metadump.bz2?_subject_uid=593207464&w=AABxHzGf84uI5q8a4frh_WjK5bH7waQ49rESCBb4AX1gJw&dl=1&_download_id=705892621369384127364746769078756077441885137578537980037504362&_notify_domain=www.dropbox.com

Thanks,
Zorro

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
