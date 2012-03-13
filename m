Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2D4MMZj189098 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 23:22:23 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BmTbZAbwV3nKY0VF for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 21:22:20 -0700 (PDT)
Date: Tue, 13 Mar 2012 15:22:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: repeatable attribute corruption
Message-ID: <20120313042216.GD5091@dastard>
References: <1331589615.25204.35.camel@montana.filmlight.ltd.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331589615.25204.35.camel@montana.filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On Mon, Mar 12, 2012 at 10:00:15PM +0000, Roger Willcocks wrote:
> Hi folks,
> 
> On stock CentOS kernels from 5.5 (earliest I tried) through to the
> latest 6.2 kernel (as of five days ago) 2.6.32-220.7.1.el6.x86_64 I can
> repeatedly create a silent on-disk corruption. This typically shows up
> later as:
> 
> XFS internal error xfs_da_do_buf(1) at line 2020 of
> file /usr/src/redhat/BUILD/kernel-2.6.18/linux-2.6.18.x86_64/fs/xfs/xfs_da_btree.c
> 
> (or line 2112 of the same file).
> 
> The 'before' metadump is a bit big to attach to an email (~600k) so
> here's a download link valid for 30 days -
> 
> http://private.filmlight.ltd.uk/c4c864ecca4ac13b/xfs_attrib_crash.taz
> 
> - this is a gzip-compressed tar file containing 
> 
> -rw-r--r--.  1 root root   10885632 Mar 12 18:02 xfs_metadump_hda6
> -rw-r--r--.  1 root root       3558 Mar 12 18:15 zap.txt
> 
> The metadump expands to about 5GB. xfs_repair believes it to be clean.
> I've not obfuscated the dump; it was originally a copy of the linux
> header directory from the 5.5 kernel.
> 
> 'zap.txt' simply overwrites a single existing extended (directory)
> attribute with a slightly longer value. So, steps to repeat:
> 
> # xfs_mdrestore xfs_metadump_hda6 xfs.img 
> # mkdir /mnt/disk1
> # mount -o loop xfs.img /mnt/disk1
> # setfattr --restore=zap.txt
> # umount /mnt/disk1
> # xfs_repair -n xfs.img
> ...
> bad sibling back pointer for block 4 in attribute fork for inode 131
> problem with attribute contents in inode 131
> would clear attr fork
> bad nblocks 8 for inode 131, would reset to 3
> bad anextents 4 for inode 131, would reset to 0
> ...

OK, I've reproduced it. There's some kind of problem in the atomic
attribute rename code when the new attribute gets has to be moved
into a new block.

Basically we've got this structure to begin with:

btree format
Level 1:
	key/ptrs: 1:31
Level 0:
	key/ptrs: 0:13, 1:25, 2:30

leaf: 0:13 - contains hash index
	   - forward/back pointers empty
      1:25 - full, contains the large attribute being replaced.
           - back ptr empty, forward ptr = index 2
      2:30 - mostly empty, has enough free space for the attribute
             being replaced.
	   - back ptr = index 1, forw ptr empty.

What we end up with is:

btree format
Level 1:
	key/ptrs: 1:31
Level 0:
	key/ptrs: 0:13, 1:25, 2:30, 3:622

leaf: 0:13 - contains hash index
	   - forward/back pointers empty
	   - btree[0-2] = [hashval,before] 0:[0xb6003373,1] 1:[0xb611400d,4] 2:[0xfd936a3c,2]
	   - expects only 3 blocks, index 1, 4 and 2 in that order
	   - *** index 4 does not exist ***

      1:25 - 1/3rd full, large attribute gone, no free space (correct!)
           - back ptr empty, forward ptr = index 4
	   - *** expects index 4 to exist ***

      2:30 - contains new attribute, hash 0xb611400d.
			*** implies hash index is incorrect ***
	   - back ptr = index 1, forw ptr empty.
	   - forward ptr empty,
	   - back ptr => 4
			*** expects index 4 to exist ***

      3:622 - contains large attribute
	   - block should not exist!
	   - attribute has hash 0xb611400d
			*** implies this should be index 4 ***

           - back ptr empty,
			*** should be index 1 ***
	   - forward ptr => 2

So something really strange has happened here. The original block at
index 2 (2:30) has enough space for the new attribute to be inserted
for the atomic rename, but for some reason a new leaf block was
added to hold it. An event trace (sadly deficient or attribute
events) indicates that:

[...] xfs_bmap_pre_update: dev 7:0 ino 0x83 state LC|ATTR idx 3 offset 3 block 622 count 1 flag 0 caller xfs_bmap_add_extent_hole_real
[...] xfs_bmap_post_update: dev 7:0 ino 0x83 state LC|ATTR idx 3 offset 3 block 622 count 2 flag 0 caller xfs_bmap_add_extent_hole_real

that somewhere along the line there was a fifth block added....

[...] xfs_bmap_pre_update:  dev 7:0 ino 0x83 state ATTR idx 3 offset 3 block 622 count 2 flag 0 caller xfs_bmap_del_extent
[...] xfs_bmap_post_update: dev 7:0 ino 0x83 state ATTR idx 3 offset 4 block 623 count 1 flag 0 caller xfs_bmap_del_extent

... and later removed.

So there's been multiple blocks added, but not enough removed, and
somewhere along the line the ordering of them has been screwed up.
Both copies of the attribute that remain are marked complete, so
something is definitely screwed up here.

First thing I need to do is add tracing to the attribute
modification code to find out what is going on here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
