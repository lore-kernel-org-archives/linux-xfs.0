Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbfAUNB0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jan 2019 08:01:26 -0500
Date: Mon, 21 Jan 2019 08:01:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190121130121.GA4537@bfoster>
References: <1543238989.2507.33.camel@pengutronix.de>
 <20181126153249.GC14585@bfoster>
 <1548067317.2465.7.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548067317.2465.7.camel@pengutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <l.stach@pengutronix.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 21, 2019 at 11:41:57AM +0100, Lucas Stach wrote:
> Hi Brian,
> 
> sorry for taking so long to respond. It's hard to gather some good
> debug data here.
> 
> Am Montag, den 26.11.2018, 10:32 -0500 schrieb Brian Foster:
> > On Mon, Nov 26, 2018 at 02:29:49PM +0100, Lucas Stach wrote:
...
> > 
> > Can you provide xfs_info for the fs and details of your storage, CPU and
> > RAM configuration?
> 
> root@XXX:~# xfs_info /srv/
> meta-data=/dev/mapper/XXX-backup isize=512    agcount=33, agsize=183123968 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=5860389888, imaxpct=15
>          =                       sunit=16     swidth=48 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The storage is LVM on top of md raid10 across 8 disks.
> 
> System is a Intel Xeon CPU E5-2630 with 64GB ECC RAM. The system
> reports no errors about RAM.
> 

Thanks, looks fairly standard to me.

> >  Also, what typically happens after this crash? Can
> > the filesystem mount again or does log recovery fail and require a
> > repair? If the filesystem mounts, have you tried running a
> > non-destructive 'xfs_repair -n <dev>' after log recovery to check for
> > any latent problems?
> 
> We are able to umount and mount the filesystem again. I don't there was
> a non-destructive run of xfs_repair yet, but just a regular one. Would
> a non-destructive one make more sense?
> 

Not really, I just suggest that in general because 1. xfs_repair mutates
the fs even when no corruption is found and 2. we don't always know how
xfs_repair is going to react to a corrupted fs. I generally prefer to
run 'xfs_repair -n' to find out what the repair will expect to do when
run without -n, how long it might take, etc.

> root@XXX:/mnt/metadump# xfs_repair  /dev/XXX
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> bad magic # 0x49414233 in inobt block 5/7831662

Hmm, so this looks like a very isolated corruption. It's complaining
about a magic number (internal filesystem value stamped to metadata
blocks for verification/sanity purposes) being wrong on a finobt block
and nothing else seems to be wrong in the fs. (I guess repair should
probably print out 'finobt' here instead of 'inobt,' but that's a
separate issue..).

The finobt uses a magic value of XFS_FIBT_CRC_MAGIC (0x46494233, 'FIB3')
whereas this block has a magic value of 0x49414233. The latter is
'IAB3' (XFS_IBT_CRC_MAGIC), which is the magic value for regular inode
btree blocks.

>         - 23:06:50: scanning filesystem freespace - 33 of 33 allocation groups done
>         - found root inode chunk
> Phase 3 - for each AG...
...
> Phase 7 - verify and correct link counts...
>         - 22:29:19: verify and correct link counts - 33 of 33 allocation groups done
> done
> 
> >  Would you be able to provide an xfs_metadump image
> > of this filesystem for closer inspection?
> 
> This filesystem is really metadata heavy, so an xfs_metadump ended up
> being around 400GB of data. Not sure if this is something you would be
> willing to look into?
> 

Ok, it might be difficult to get ahold of that. Does the image happen to
compress well?

In the meantime, given that the corruption appears to be so isolated you
might be able to provide enough information from the metadump without
having to transfer it. The first thing is probably to take a look at the
block in question..

First, restore the metadump somewhere:

xfs_mdrestore -g ./md.img <destination>

You'll need somewhere with enough space for that 400G or so. Note that
you can restore to a file and mount/inspect that file as if it were the
original fs. I'd also mount/unmount the restored metadump and run an
'xfs_repair -n' on it just to double check that the corruption was
captured properly and there are no other issues with the metadump. -n is
important here as otherwise repair will fix the metadump and remove the
corruption.

Next, use xfs_db to dump the contents of the suspect block. Run 'xfs_db
<metadump image>' to open the fs and try the following sequence of
commands.

- Convert to a global fsb: 'convert agno 5 agbno 7831662 fsb'
- Jump to the fsb: 'fsb <output of prev cmd>'
- Set the block type: 'type finobt'
- Print the block: 'print'

... and copy/paste the output.

> > Can you characterize the rsync workload in any more detail? For example,
> > are files added/removed across runs (perhaps whatever rsync flags are
> > used would help)? Are files of consistent or varying size/content? Are
> > many rsync processes running in parallel? Generally, anything you can
> > describe that might help recreate this problem with a simulated workload
> > is potentially useful.
> 
> There are typically about 2 or 3 rsync processes running in parallel.
> The workload syncs a lot of small files and uses hardlinks to avoid
> storing files that didn't change.
> 
> All the corruption issues we've seen so far have the same call trace
> starting with a do_mkdirat syscall. We've never seen it happen in other
> calls.
> 
> As a wild shot in aiding some debugging we've added the following patch
> on top of 4.19.16:
> 
...
> 
> With that applied we were able to collect the following dump:
> 
> [215922.475666] 00000000d471c70c: 49 41 42 33 00 01 01 0c 00 07 58 ab ff ff ff ff  IAB3......X.....
> [215922.475954] 000000001be9cc59: 00 00 00 01 b5 db 40 b8 00 00 00 00 00 00 00 00  ......@.........
> [215922.476241] 000000005b12f32e: 02 67 11 cc 25 c7 44 b9 89 aa 0a ac 49 6e df ec  .g..%.D.....In..
> [215922.476556] 00000000e6e67a65: 00 00 00 05 2a bb 5c 47 36 85 a2 40 36 8e f9 00  ....*.\G6..@6...
> [215922.476840] 00000000e4807aa6: 36 96 3e 80 36 a4 61 80                          6.>.6.a.
> [215922.477172] XFS (dm-3): Internal error xfs_btree_check_sblock at line 180 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_lastrec+0x41/0x90 [xfs]
...
> 
> Does this make any sense to you? Aside from the xfs_metadump, is there
> any other debug info we could provide to help you figure this out?
> 

This pretty much replicates what repair told us. Perhaps there are more
debug checks we could add to help narrow down the cause of this problem,
but I'd start with getting a look at the block as described above.

Brian

> Regards,
> Lucas
> 
