Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150245.3wvc6q5xsbchhizz@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34750 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbdBZMdo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2017 07:33:44 -0500
Received: by mail-oi0-f66.google.com with SMTP id m124so460253oig.1
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2017 04:32:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170224180601.GA14631@birch.djwong.org>
References: <CADcJnz_TWkhhPVr7fmVHoZtjOkGDJxTqtcuz_Ef15rguUW3bdA@mail.gmail.com>
 <20170224123017.GA59560@bfoster.bfoster> <20170224143037.GD59560@bfoster.bfoster>
 <20170224175616.GL5846@birch.djwong.org> <CADcJnz8SdVTEHcsbhmYoXThP1Uy2T1rs9p7qQo9mc_aa8R9rQw@mail.gmail.com>
 <20170224180601.GA14631@birch.djwong.org>
From: Mathias Troiden <mathias.troiden@gmail.com>
Date: Sun, 26 Feb 2017 15:32:32 +0300
Message-ID: <CADcJnz-Sq8OJL_XLRX=n8jpgXhBpDDBdFKGUNeO2xkkuuWryNQ@mail.gmail.com>
Subject: Re: xfs_repair fails to recognize corruption reported by kernel -
 possible bug?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

The patch worked for me, thank you very much. Here's the output of
'xfs-repair -d' : http://pastebin.com/tcTtzqk8

For some reason there's double space before 'Immedieate reboot encouraged.' :-)


Mathias

On Fri, Feb 24, 2017 at 9:06 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Feb 24, 2017 at 09:00:45PM +0300, Mathias Troiden wrote:
>> I'm currently figuring out how to apply the patch since it's my first time.
>> Will i have to patch the package every time it's upgraded or it's gonna be
>> included in newer versions?
>>
>> Can i copy the patch back to the original thread so people with similar
>> issues can google and apply it?
>
> Eric Sandeen is the xfsprogs maintainer so he has the last word, but in
> general once we verify that the patch fixes your problem (and doesn't
> cause any other problems) then we push it into upstream xfsprogs and
> it'll be in the next release.
>
> --D
>
>>
>> Mathias
>>
>> On 24 Feb 2017 20:56, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
>>
>> > On Fri, Feb 24, 2017 at 09:30:37AM -0500, Brian Foster wrote:
>> > > On Fri, Feb 24, 2017 at 07:30:18AM -0500, Brian Foster wrote:
>> > > > On Thu, Feb 23, 2017 at 11:14:47PM +0300, Mathias Troiden wrote:
>> > > > > Original topic: https://bbs.archlinux.org/viewtopic.php?pid=1692896
>> > > > >
>> > > > > Hi list,
>> > > > >
>> > > > > My system fails to start login manager with following messages in
>> > journal:
>> > > > >
>> > > > > >kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00
>> > 00 00  Xg..*:..........
>> > > > > >kernel: XFS (sda1): Internal error xfs_iread at line 514 of file
>> > fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
>> > > > > >kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair
>> > > > > >kernel: XFS (sda1): xfs_iread: validation failed for inode 34110192
>> > failed
>> > > > > >kernel: ffff88040e8bc000: 49 4e a1 ff 03 01 00 00 00 00 00 00 00 00
>> > 00 00  IN..............
>> > > > > >kernel: ffff88040e8bc010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00
>> > 00 00  ................
>> > > > > >kernel: ffff88040e8bc020: 58 aa 04 b8 2e e3 65 3a 57 41 fe 12 00 00
>> > 00 00  X.....e:WA......
>> > > > > >kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00
>> > 00 00  Xg..*:..........
>> > > > > >kernel: XFS (sda1): Internal error xfs_iread at line 514 of file
>> > fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
>> > > > > >kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair
>> > > > >
>> > > > >
>> > > > > and subsequent core dump of the login manager.
>> > > > >
>> > > >
>> > > > What kernel and xfsprogs versions? Also, please provide 'xfs_info
>> > <mnt>'
>> > > > output for the fs.
>> > > >
>> > > > From the output above, it looks like you could have a zero-sized
>> > > > symlink, which triggers xfs_dinode_verify() failure. It's quite
>> > possible
>> > > > I'm misreading the raw inode buffer output above too, however.. Did you
>> > > > have any interesting "events" before this problem started to occur? For
>> > > > example, a crash or hard reset, etc.?
>> > > >
>> > > > Could you run 'find <mnt> -inum 34110192 -print' on the fs and report
>> > > > the associated filename? You could try 'stat <file>' as well but I'm
>> > > > guessing that's just going to report an error.
>> > > >
>> > > > Note that another way to get us details of the fs is to send an
>> > > > xfs_metadump image. An md image skips all file data in the fs and
>> > > > obfuscates metadata (such as filenames) such that no sensitive
>> > > > information is shared. It simply provides a skeleton metadata image for
>> > > > us to debug. To create an obfuscated metadump, run 'xfs_metadump -g
>> > > > <dev> <outputimg>,' compress the resulting image file and send it along
>> > > > (feel free to send directly) or upload it somewhere.
>> > > >
>> > >
>> > > After looking at a metadump, this is indeed a zero-sized symlink. The
>> > > immediate fix here is probably to allow xfs_repair to detect this
>> > > situation and recover, which most likely means clearing out the inode.
>> > >
>> > > Unfortunately, it's not clear how we got into this situation in the
>> > > first place. I'm still curious if you've had any crash or reset events
>> > > that might have required log recovery recently..?
>> > >
>> > > Regardless, you'll probably have to try something like the appended
>> > > xfsprogs patch, which clears out the offending inode and means you'll
>> > > have to recreate it manually to recover system functionality (Mathias
>> > > has pointed out offline that the offending link is a standard
>> > > /usr/lib/lib*.so symlink with a known target, so fortunately recovery
>> > > should be simple).
>> > >
>> > > Brian
>> > >
>> > > --- 8< ---
>> > >
>> > > diff --git a/repair/dinode.c b/repair/dinode.c
>> > > index 8d01409..d664f87 100644
>> > > --- a/repair/dinode.c
>> > > +++ b/repair/dinode.c
>> > > @@ -1385,6 +1385,11 @@ process_symlink(
>> > >               return(1);
>> > >       }
>> > >
>> > > +     if (be64_to_cpu(dino->di_size) == 0) {
>> > > +             do_warn(_("zero size symlink in inode %" PRIu64 "\n"),
>> > lino);
>> > > +             return 1;
>> > > +     }
>> > > +
>> >
>> > Just for fun I gave this a try with on a filesystem where I'd
>> > deliberately set a symlink's core.size to zero:
>> >
>> > Phase 1 - find and verify superblock...
>> > Phase 2 - using internal log
>> >         - zero log...
>> >         - scan filesystem freespace and inode maps...
>> >         - found root inode chunk
>> > Phase 3 - for each AG...
>> >         - scan and clear agi unlinked lists...
>> >         - process known inodes and perform inode discovery...
>> >         - agno = 0
>> > zero size symlink in inode 4483
>> > problem with symbolic link in inode 4483
>> > cleared inode 4483
>> >         - agno = 1
>> >         - agno = 2
>> >         - agno = 3
>> >         - process newly discovered inodes...
>> > Phase 4 - check for duplicate blocks...
>> >         - setting up duplicate extent list...
>> >         - check for inodes claiming duplicate blocks...
>> >         - agno = 0
>> >         - agno = 1
>> >         - agno = 2
>> >         - agno = 3
>> > entry "S_IFLNK.FMT_LOCAL" at block 0 offset 1856 in directory inode 128
>> > references free inode 4483
>> >         clearing inode number in entry at offset 1856...
>> > Phase 5 - rebuild AG headers and trees...
>> >         - reset superblock...
>> > Phase 6 - check inode connectivity...
>> >         - resetting contents of realtime bitmap and summary inodes
>> >         - traversing filesystem ...
>> > bad hash table for directory inode 128 (no data entry): rebuilding
>> > rebuilding directory inode 128
>> >         - traversal finished ...
>> >         - moving disconnected inodes to lost+found ...
>> > Phase 7 - verify and correct link counts...
>> > Metadata corruption detected at xfs_dir3_block block 0xc0/0x1000
>> > libxfs_writebufr: write verifer failed on xfs_dir3_block bno 0xc0/0x1000
>> > releasing dirty buffer (bulk) to free list!done
>> >
>> > So inode 128 is a block-format directory that gets rebuilt during phase
>> > 6.  The old dblock[0] for the directory is the same one that's hitting
>> > the write verifier (daddr 0xc0) which is stale because the directory has
>> > been rebuilt with a different block.
>> >
>> > IOWs Brian's patch is fine, but (at least for me) it also hits this
>> > write-after-free thing.  AFAICT it's benign since block 0xc0 is free
>> > space, but it's silly to write to free blocks and mildly alarming that
>> > doing so spits out a message. :)
>> >
>> > <shrug> Basically I think longform_dir2_rebuild needs to go find any
>> > xfs_bufs for the directory and clear the dirty flag before calling
>> > libxfs_bunmapi.  Or maybe as part of it.
>> >
>> > --D
>> >
>> > >       /*
>> > >        * have to check symlink component by component.
>> > >        * get symlink contents into data area
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
