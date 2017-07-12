Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756203AbdGLLGx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 07:06:53 -0400
Date: Wed, 12 Jul 2017 07:06:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: non mountable xfs with 2 primary and 2 logical
Message-ID: <20170712110650.GA33764@bfoster.bfoster>
References: <1498686205.13847.1.camel@versatel.nl>
 <f6ba654f-5d85-043d-f632-30d0b88226f7@sandeen.net>
 <1499862173.1356.20.camel@versatel.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499862173.1356.20.camel@versatel.nl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Waterbeek <richardwbb@versatel.nl>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Wed, Jul 12, 2017 at 12:22:53PM +0000, Richard Waterbeek wrote:
> Hello Eric, linux-xfs list,
> 
> I have been thinking about getting myself options first.
> 
> I learned that;
> 
> The [Linux] operating system, doesn't recognize all "sda<number>"
> partition. But I have found a program "CG TestDisk". To avoid discuccins
> about that program, let me post a link to a screenshot, of what I have
> now.
> 
> First things first, the two NTFS partitions have been restored.
> 
> Then, I expect to find a 'sda5', and a 'sda6', [so that is an extended
> partition, containing two XFS partitions [524GB and 363GB]. 
> 
> The first screenshot is this program, again, to avoid discussing about
> that program, [CG TestDisk], my question is related to XFS. Because; I
> can tell, there seems to be a 'drive geometry', readable.
> 
> Here is the link to the screenshot;
> http://www.fotobakje.nl/map/div/linux/testdisk/testdisk-correcte-weergave.png [Notice the two green 'L']. However, it is reported as being 'HPFS/ NTFS'.
> 
> Now I wonder about the geometry, is it possible [and how], to calculate
> where mkfs.xfs, should have been written something [this is based on my
> expectations, I really have no real understanding of the XFS file
> system], so, where mkfs.xfs should have been written a [sda5 "mbr"],
> since I believe the SuperBlock or SuperBlocks are intact. Since you
> might have noticed there are five partitions in total [NTFS/ NTFS/ EXT4/
> XFS/ XFS], I wonder, is there a way, I make a call to the [most]
> knowledgable people here, to have a "xfs-<something", program or another
> way, to learn, -where-, "mkfs.xfs", should "find" [I actually mean where
> Linux expects an 'sda/ xfs block', to -mount- those file systems.
> 

It sounds like you've had a corrupted partition table, partially
restored it and are now trying to figure out where the last couple of
XFS partitions on the drive may reside. Note that partitions are just a
range of blocks to the filesystem. While sda5 might start on block N on
a physical drive, the fs simply sees it as block 0. IOW, the fs does not
know, care or have any information associated with the location of the
underlying disk partition.

Therefore, as Eric noted in the immediately previous reply, the only
recovery approach that I'm aware of is to manually search for XFS
superblocks in the range of sda that is still unaccounted for. You can
use hexdump to try and locate the blocks that start with the 'XFSB'
magic value, _hope_ they point to valid superblocks and try to recreate
your partitions from that information (the superblock should reside in
the first block of the partition). Of course you will want to
'xfs_repair -n' the associated partition to determine how broken the
filesystem is.

Brian

> This I ask [I know it is a bit complicated, trying to learn here],
> because; xfs_repair expects a mounted file system [ro]. And, with
> "guessing", and writing with mkfs.xfs which is easy for me to do, I can
> be almost sure, I will end up with an empty XFS file system. [Yes, the
> damaged drive, is still untouched by me], reading NTFS wasn't a pain.
> 
> I sincerely hope to get some waypointers, that will help me in my -own-
> search. Please do not tell me this isn't XFS related. It is XFS related,
> it might just be my person, willing and trying to be able, to understand
> XFS and where that [I expect 512 bytes sector, not a "mkfs.xfs
> recreation [that will make it bust for for sure], or if I am mistaken,
> please tell me about the options you are thinking of. I of course take
> full responsibillity for the steps I make [e.g. a real write to this
> hard drive], so no one to blame, if it fails somehow.
> 
> Richard.
> 
> 
> 
> 
> Eric Sandeen schreef op wo 28-06-2017 om 16:52 [-0500]:
> > On 6/28/17 4:43 PM, Richard Waterbeek wrote:
> > > Hi linux-xfs mailinglist,
> > > 
> > > I've recently subscribed to this list. I've seen many messages, but have
> > > little understading of the 'XFS' file system. I know about mkfs.xfs.
> > > I've benched my hardware. But, now my harddrive had a collision with the
> > > mbr somehow. [or something]
> > > 
> > > But, now I've 'hexdumped', the first 512 bytes, [because after a
> > > disaterous reboot, cfdisk is now saying; "/dev/sda empty".
> > 
> > If the xfs partition you lost was on extended partition sda5,
> > that's not at the front of the disk.  It sounds like something
> > overwrote your partition table. 
> > 
> > Honestly, recreating a partition table isn't an xfs issue.
> > 
> > > I'm aware of two primary and two logical partitions. I feel that I know
> > > the size of the first and second primary, but the xfs/ sda5 and, xfs
> > > sda6, are no longer appearing. I had to '#' the /etc/fstab, because it
> > > won't boot [long waiting].
> > > 
> > > Now I would like to restore the first 512 bytes which is the MBR.
> > > 
> > > I have absolutely no understanding of -where-, "the SuperBlock" [or how
> > > that should be called], happens to be.
> > 
> > The MBR is not the XFS superblock.  sda5's XFS superblock is somewhere
> > much further into the disk.
> > 
> > I don't think anyone here can tell you how to recreate the partitions,
> > because nobody knows what their exact size was.
> >  
> > The XFS superblock signature is "XFSB" so you could go hexdumping the
> > whole disk, look for eveny-spaced occurences of that pattern, and assume
> > that you've found some superblocks, and work backwards from there.
> > 
> > All this is essentially data recovery, getting well beyond the scope of
> > normal mailing-list help, though.
> > 
> > -Eric
> > 
> > > But, I feel that 512 bytes missing and no reason to believe a whole
> > > Terabyte would be "ones and/ or zero's", now, I wonder, how to restore
> > > this. I have not made backup of this harddrive, just an rsync, which is
> > > a little outdated and a bit incomplete, because difference in size of
> > > both drives.
> > > 
> > > I might be able to create a XFS-something [from /dev/sda, for example],
> > > and write that with dd. 
> > > 
> > > But, before I would 'try this out', I would like to gain some
> > > understanding, of what -should- be on the first 512 bytes of a
> > > harddrive, besides what I have now, cfdisk is saying empty.
> > > 
> > > Hoping to receive a reply, Richard, the Netherlands
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
