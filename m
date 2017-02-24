Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145912.bxua74xrrzlaowsk@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from userp1040.oracle.com ([156.151.31.81]:21774 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXR4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2017 12:56:24 -0500
Date: Fri, 24 Feb 2017 09:56:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_repair fails to recognize corruption reported by kernel -
 possible bug?
Message-ID: <20170224175616.GL5846@birch.djwong.org>
References: <CADcJnz_TWkhhPVr7fmVHoZtjOkGDJxTqtcuz_Ef15rguUW3bdA@mail.gmail.com>
 <20170224123017.GA59560@bfoster.bfoster>
 <20170224143037.GD59560@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170224143037.GD59560@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mathias Troiden <mathias.troiden@gmail.com>, linux-xfs@vger.kernel.org

On Fri, Feb 24, 2017 at 09:30:37AM -0500, Brian Foster wrote:
> On Fri, Feb 24, 2017 at 07:30:18AM -0500, Brian Foster wrote:
> > On Thu, Feb 23, 2017 at 11:14:47PM +0300, Mathias Troiden wrote:
> > > Original topic: https://bbs.archlinux.org/viewtopic.php?pid=1692896
> > > 
> > > Hi list,
> > > 
> > > My system fails to start login manager with following messages in journal:
> > > 
> > > >kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00 00 00  Xg..*:..........
> > > >kernel: XFS (sda1): Internal error xfs_iread at line 514 of file fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
> > > >kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair
> > > >kernel: XFS (sda1): xfs_iread: validation failed for inode 34110192 failed
> > > >kernel: ffff88040e8bc000: 49 4e a1 ff 03 01 00 00 00 00 00 00 00 00 00 00  IN..............
> > > >kernel: ffff88040e8bc010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >kernel: ffff88040e8bc020: 58 aa 04 b8 2e e3 65 3a 57 41 fe 12 00 00 00 00  X.....e:WA......
> > > >kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00 00 00  Xg..*:..........
> > > >kernel: XFS (sda1): Internal error xfs_iread at line 514 of file fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
> > > >kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair
> > > 
> > > 
> > > and subsequent core dump of the login manager.
> > > 
> > 
> > What kernel and xfsprogs versions? Also, please provide 'xfs_info <mnt>'
> > output for the fs.
> > 
> > From the output above, it looks like you could have a zero-sized
> > symlink, which triggers xfs_dinode_verify() failure. It's quite possible
> > I'm misreading the raw inode buffer output above too, however.. Did you
> > have any interesting "events" before this problem started to occur? For
> > example, a crash or hard reset, etc.?
> > 
> > Could you run 'find <mnt> -inum 34110192 -print' on the fs and report
> > the associated filename? You could try 'stat <file>' as well but I'm
> > guessing that's just going to report an error.
> > 
> > Note that another way to get us details of the fs is to send an
> > xfs_metadump image. An md image skips all file data in the fs and
> > obfuscates metadata (such as filenames) such that no sensitive
> > information is shared. It simply provides a skeleton metadata image for
> > us to debug. To create an obfuscated metadump, run 'xfs_metadump -g
> > <dev> <outputimg>,' compress the resulting image file and send it along
> > (feel free to send directly) or upload it somewhere.
> > 
> 
> After looking at a metadump, this is indeed a zero-sized symlink. The
> immediate fix here is probably to allow xfs_repair to detect this
> situation and recover, which most likely means clearing out the inode.
> 
> Unfortunately, it's not clear how we got into this situation in the
> first place. I'm still curious if you've had any crash or reset events
> that might have required log recovery recently..?
> 
> Regardless, you'll probably have to try something like the appended
> xfsprogs patch, which clears out the offending inode and means you'll
> have to recreate it manually to recover system functionality (Mathias
> has pointed out offline that the offending link is a standard
> /usr/lib/lib*.so symlink with a known target, so fortunately recovery
> should be simple).
> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8d01409..d664f87 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1385,6 +1385,11 @@ process_symlink(
>  		return(1);
>  	}
>  
> +	if (be64_to_cpu(dino->di_size) == 0) {
> +		do_warn(_("zero size symlink in inode %" PRIu64 "\n"), lino);
> +		return 1;
> +	}
> +

Just for fun I gave this a try with on a filesystem where I'd
deliberately set a symlink's core.size to zero:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
zero size symlink in inode 4483
problem with symbolic link in inode 4483
cleared inode 4483
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
entry "S_IFLNK.FMT_LOCAL" at block 0 offset 1856 in directory inode 128
references free inode 4483
        clearing inode number in entry at offset 1856...
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 128 (no data entry): rebuilding
rebuilding directory inode 128
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
Metadata corruption detected at xfs_dir3_block block 0xc0/0x1000
libxfs_writebufr: write verifer failed on xfs_dir3_block bno 0xc0/0x1000
releasing dirty buffer (bulk) to free list!done

So inode 128 is a block-format directory that gets rebuilt during phase
6.  The old dblock[0] for the directory is the same one that's hitting
the write verifier (daddr 0xc0) which is stale because the directory has
been rebuilt with a different block.

IOWs Brian's patch is fine, but (at least for me) it also hits this
write-after-free thing.  AFAICT it's benign since block 0xc0 is free
space, but it's silly to write to free blocks and mildly alarming that
doing so spits out a message. :)

<shrug> Basically I think longform_dir2_rebuild needs to go find any
xfs_bufs for the directory and clear the dirty flag before calling
libxfs_bunmapi.  Or maybe as part of it.

--D

>  	/*
>  	 * have to check symlink component by component.
>  	 * get symlink contents into data area
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
