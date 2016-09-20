Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbcITMro (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Sep 2016 08:47:44 -0400
Date: Tue, 20 Sep 2016 20:47:41 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: xfs_copy V5 XFS to multi-targets cause targets corruption
Message-ID: <20160920124741.GO12847@dhcp12-143.nay.redhat.com>
References: <20160920113916.GN12847@dhcp12-143.nay.redhat.com>
 <272a1d0a-8328-e0fd-447a-5c63f5dec12a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <272a1d0a-8328-e0fd-447a-5c63f5dec12a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 20, 2016 at 07:19:18AM -0500, Eric Sandeen wrote:
> On 9/20/16 6:39 AM, Zorro Lang wrote:
> ...
> 
> > Then I got problem when I ran xfs/073 with MKFS_OPTIONS="-m crc=1":
> > [root@dhcp-13-149 xfstests-dev]# diff -Nurp tests/xfs/073.out results/xfs/073.out.bad 
> > --- tests/xfs/073.out   2016-04-13 11:44:17.809000000 +0800
> > +++ results/xfs/073.out.bad     2016-09-20 19:12:40.194000000 +0800
> > @@ -59,8 +59,5 @@ comparing new image directories to old
> >  comparing new image geometry to old
> >  unmounting and removing new image
> >  checking new image
> > -mounting new image on loopback
> > -comparing new image files to old
> > -comparing new image directories to old
> > -comparing new image geometry to old
> > -unmounting and removing new image
> > +_check_xfs_filesystem: filesystem on /mnt/test/9672.image2 is inconsistent (c) (see /root/git/xfstests-dev/results//xfs/073.full)
> > +_check_xfs_filesystem: filesystem on /mnt/test/9672.image2 is inconsistent (r) (see /root/git/xfstests-dev/results//xfs/073.full)
> > 
> > 
> > The last test stes of xfs/073 failed:
> > echo === copying scratch device to multiple targets
> > $XFS_COPY_PROG -d -L$imgs.log -b $SCRATCH_DEV $imgs.image1 $imgs.image2 \
> >         | _filter_copy '#' $imgs.image1 '#' $imgs.image2
> > _verify_copy $imgs.image1 $SCRATCH_DEV $SCRATCH_MNT
> > _verify_copy $imgs.image2 $SCRATCH_DEV $SCRATCH_MNT
> > 
> > 
> > The full output is too long, so I paste it to below link (this link will
> > keep alive in one month):
> > http://paste.fedoraproject.org/431361/74370897/
> > 
> > I can't find this problem on V4 XFS(crc=0). I tested this bug with upstream
> > linux v4.8-rc7(d2ffb01 Merge branch 'akpm' (patches from Andrew)) and xfsprogs
> > v4.8-rc1(130093a xfsprogs: Release 4.8.0-rc1).
> > 
> > This problem can be simply reproduced by below steps:
> > 1. mkfs.xfs -d name=fsfile,size=512m,file=1 -m crc=1
> > 2. xfs_copy fsfile target1 target2
> > 3. xfs_repair -n target2
> > 4. xfs_repair -n target1
> > 
> > But these steps can't make target1 corrupted(in my test).
> 
> Thanks for finding this Zorro - looks like it is confusing which
> uuid it should be using across the multiple copies.
> 
> $ xfs_db -c "sb 0" -c "p uuid" -c "p meta_uuid" fsfile
> uuid = a439b9f6-a660-46ab-ad10-841485de27a4
> meta_uuid = 00000000-0000-0000-0000-000000000000
> 
> 
> $ xfs_db -c "sb 0" -c "p uuid" -c "p meta_uuid" copy1
> uuid = e0d30f68-533c-48c2-bb96-d719526c5d64
> meta_uuid = a439b9f6-a660-46ab-ad10-841485de27a4
> 
> (ok, meta_uuid matches original)
> 
> $ xfs_db -c "sb 0" -c "p uuid" -c "p meta_uuid" copy2
> Metadata corruption detected at xfs_agf block 0x1/0x200
> xfs_db: cannot init perag data (-117). Continuing anyway.
> uuid = 50bead00-e076-476e-9b7f-db3349253bbf
> meta_uuid = e0d30f68-533c-48c2-bb96-d719526c5d64
> 
> (not OK, meta_uuid matches superblock UUID of first copy,
> not original)
> 
> I'll get it fixed up today.
> 
> -Eric

Wow, so fast!

Did you check the full output?
http://paste.fedoraproject.org/431361/74370897/

It shows more corruption on the 1st target:
*** xfs_check output ***
Metadata corruption detected at xfs_agf block 0x1/0x200
xfs_check: cannot init perag data (117). Continuing anyway.
Metadata corruption detected at xfs_agi block 0x2/0x200
Metadata corruption detected at xfs_agfl block 0x3/0x200
Metadata corruption detected at xfs_allocbt block 0x8/0x1000
Metadata corruption detected at xfs_allocbt block 0x10/0x1000
Metadata corruption detected at xfs_inobt block 0x18/0x1000
Metadata corruption detected at xfs_dir3_block block 0x50/0x1000
Metadata corruption detected at xfs_dir3_block block 0x2028/0x1000
Metadata corruption detected at xfs_dir3_block block 0x2020/0x1000
Metadata corruption detected at xfs_inobt block 0x20/0x1000
Metadata corruption detected at xfs_agf block 0xa401/0x200
Metadata corruption detected at xfs_agi block 0xa402/0x200
Metadata corruption detected at xfs_agfl block 0xa403/0x200
Metadata corruption detected at xfs_allocbt block 0xa408/0x1000
Metadata corruption detected at xfs_allocbt block 0xa410/0x1000
Metadata corruption detected at xfs_inobt block 0xa418/0x1000
Metadata corruption detected at xfs_dir3_block block 0xbf40/0x1000
Metadata corruption detected at xfs_inobt block 0xa420/0x1000
*** end xfs_check output

It doesn't looks like UUID problem, maybe there's another problem?

Thanks,
Zorro

> 
> > Thanks,
> > Zorro
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
