Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtpq6.tb.mail.iss.as9143.net ([212.54.42.169]:58454 "EHLO
        smtpq6.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753382AbdGNRaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2017 13:30:13 -0400
Message-ID: <1500060674.24639.23.camel@versatel.nl>
Subject: Re: non mountable xfs with 2 primary and 2 logical
From: Richard Waterbeek <richardwbb@versatel.nl>
Date: Fri, 14 Jul 2017 19:31:14 +0000
In-Reply-To: <20170712110650.GA33764@bfoster.bfoster>
References: <1498686205.13847.1.camel@versatel.nl>
         <f6ba654f-5d85-043d-f632-30d0b88226f7@sandeen.net>
         <1499862173.1356.20.camel@versatel.nl>
         <20170712110650.GA33764@bfoster.bfoster>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

Hello again, Brian, Eric, A C Cenci and xfs-list,

If you find this a lengthy post, the important part is three paragraphs and the two posted links narrow it down even more and might be sufficient to you.

For starters, A C Cenci, pointed me in to the right direction with an
url that made me notice that CG Testdisk, exists.

Eric gave a good response, stating that it wasn't XFS related. Which I
won't agree to.

And Brian, I've lost you a little [your second paragraph], but your answer to
my e-mail, is something for me to keep. For your first paragraph, I
wasn't able to view at a disk partition that way before. It helped me understanding what I had to do to be succesful.

What I have accomplished [besides hexdump 'hexdump -C /dev/sdb1' [where
sdb1 is a mountable and undamaged XFS], I couldn't really make heads or
tails out of, man pages, Red Hat webpages and cray docs XFS related
pages. But I did see the 'XFSB' string several times appearing from hexdump.

Now, where I find, I feel I got lucky, first, A C Cenci, pointed me
straight to a page with this CG TestDisk, where I -did- post my question
on it's forum, but it had to be moderated and somehow I didn't make it.
But comprehending CG TestDisk is kind of, "the write option means, it
will restore everything, or it will become even more unrepairable", which I can
understand now. Fiddling with CG TestDisk on a usb testing stick with a
similar setup [sda1/NTFS, sda2/NTFS, sda4/ extended and therefore sda5/
XFS and sda6/ XFS], made me comprehend how that program works.

It did recognize the sda5/ XFS and sda6/ XFS [with 'Quick Search'], as HPFS,
which would be type 7. Then I let it run on the whole 1TB to look for
more partitions, and what the manual said appeared to be true; deleted
partitions might also be found and I even saw a FAT12 partition, that
made me wonder, how that was possible. After almost three hours
of searching on the hard drive, it complained about the cylinders and heads, litteraly in the end,
not "being as expected".

But luckily I bought another 1TB SATA-600 2.5" hard drive from another
brand but with great price/ performance/ delivery option. And the drives
in question, stated on the drive label; CHS 16383/16/36. [Where I wonder how is it possible that CG Testdisk noticed invalidities] So my first
step before doing anything a simple dd
if=<source> of=<target> bs=8M, that after almost three hours of copying
with dd, everything was transfered. And on -that- disk, I did a write.
My steps where to leave CG TestDisk with what it found of the two NTFS,
and it did see the extended partition with the sda5 and sda6. Only, it
reported them as file system type 7. Now I have read somewhere, that a
linux file system usually is 83. And by working with mkfs.xfs on this
usb stick for testing purposes [a nullified one], I learned that XFS is
[also] seen/ reported by the linux operating system, as a file system
type 83. So I left two times type 7, and wrote two times type 83. Then,
changed /etc/fstab, the 'rw' part of those two XFS partitions to 'ro' and uncommented those again.
I am still verifying, if and where, data migh be corrupted [however
my sda6 wasn't totally full, which would explain this fuzzy FAT-12 find
I've had.] And, Brian, now I could mount those XFS partitions and
quickly went to my most important documents that appeared readable and without a
mangled beginning or end, which told me that the most easy way for me [I gave up on hexdump]
was to, doing my best to remember how I partitioned [primary or extended
and file system type] All the numbers seemed the same but I had a hard
time comprehending the "hexdump -C to XFSB" [besides the easy part, finding those strings] and [however if I was able to do so, I really would
have done a dry run with rebuilding since that is the only powerful thing against disaster]. 

What I have learned is that my laptop did something weird [lost /dev/sd<number> after a clean reboot]. I seriously rewrote my fstab, to not use UUID and such [a long time ago], but
for the bootable file system / I left it with it's UUID. I find that this can not or shouldn't be a problem, a 90 second waiting time on a linux distro, I find a problem.

As far I can guess, because I have no proof or traces, linux just reported
that /dev/sda5 and /dev/sda6 wheren't there any longer and also didn't
appear as "/dev/sdb5 and/ or /dev/sdb6" [which it also never did].

This is where you could start reading. I have no clue why cfdisk stated that it was
an empty /dev/sda, but I expect that CG TestDisk was able to find the
backup [which I have no knowledge for or understanding of]. So the magic that was done there, was beyond me. And besides
being a grateful person since you all have helped me with this, I
show my respect with a true, but lengthy post. And the big deal I find with XFS, after xfs_repair- n /dev/sd<number>, it said something about "moving to lost+found", so I've
checked those places and those where empty. Large zipped files did
decompress in full and without error. It is good to know [but maybe not
very informational [depending on your knowledge], that a recognized file
system type 7, might be a file system type 83, where what Brian said
about where hard disk volumes start to write, came to my mind. I'm pretty
sure that the way I believe how things work with hard drive file-systems, is not what really has happened. But for backing up my valuable
data [so no torrent movie or non personal media], I am now in the process of
looking at JFS and ZFS. If ZFS is kind of Btrfs, then I really will
have a look at JFS only. XFS performs really well with anything I find
[small files also], hdparm gave me higher results then that the brand of
that hard drive wrote themselves [160MB/s really isn't bad for a 2.5"
7200 rpm drive], and that is for me a real good reason to stick with XFS
[and do something more about backupping -properly-, and this time with a
hard drive that will be disconnected afterwards, and, to not forget, to
write valuable data to another file system, not necessarily the same
file system. And the JFS journal is something I will have a look at. But
I don't expect the high performance I'm having with XFS, so that I will
have to bench somehow.

Brian, Eric and A C Censi, thank you again, you have been most helpful.
I hope my response isn't viewed as spammy. I'm just a person that had a
computer boo boo, and find it logical and equally important, to write a thorough reply [which isn't only read, but also on the internet for other people]. Maybe I
found an easier way than restoring XFSB blocks with hexdump, because the
calculations I've made with it, never seemed right. And CG TestDisk, it
gives the restorable partitions in highlighted green on screen and with
doing a deeper search those two HPFS partitions didnt appear as XFS 6.2
+, but CG TestDisk, -did- print 'XFS 6.2+' on screen from there [if you find that my first link prooves otherwise, that is because that is the already repaired version]. What I make out of all
this, I was lucky to find a drive of another brand with the same
geometry, and somehow, it all turned out to be what Eric wrote, about
restoring the partition table. I only just would like to learn, how to
backup all those important information about the partitioning and where
the superblocks and backups are for example [or this partition table
itself, since that would be a good idea with a 1TB drive that isn't
easily backed up and will give me some down time too]. Now that I have
running my sda5 and sda6 again, I still have the option to redo my
findings on the "original" disk with the "original problem", that would save
me about three hours of dd'ing [and seems wiser then dd'ing things back]. [But somehow I believe those disk
geometry's where exactly the same, however dd also did tell something
here and there at the end of the drive geometry it saw. 

Thank you very much xfs-list, it might be simple what I wrote, but I
just believe it can be important to someone else. And CG TestDisk seems
XFS compatible and the CG TestDisk site wasn't really clear on this.
They didn't accept my post with my question but somehow also didn't gave
a response on the why, [or that my post still was in sent items, it was
like posting via a webpage and never receiving an e-mail with
confirmation], so I am a little xfs-list biased now. but don't expect me
to post a lengthy story again, ones misfortune just can help others. It
all matters on how the heck linux lost it's cookie. In my case might be Lenovo
ThinkPad bios related, and the media wasn't all positive about that [in
relation with linux and recognizing a volume, Windows is just working fine with them. And I forgot one thing which I believe 
is important; XFS seems to want a UPS. My laptop battery is a UPS.
The desktop I have besides it, doesn't have a UPS, I should look at if
there are file systems that make a difference in case of a unexpected 
outage. I just want to have something better then a USB based WD Elements.

To give some proof of my findings;

http://www.fotobakje.nl/map/div/linux/testdisk/testdisk-na-dd-met-type-83.png
Here you can see TestDisk, reading the partition table and telling that a XFS
can be a Linux, or a HPFS [fourth and fifth green line].

http://www.fotobakje.nl/map/div/linux/testdisk/testdisk-na-dd-met-type-83-toshiba.png
Here you can see cfdisk, reading the partition table and telling that a XFS
can be a Linux, type 83. And that was the way it was I believe. Now I
would like to backup those partition settings [and the superblocks if I am
not mistaken]. That would save me a lot of trouble next time and it for
sure will then be easier and less time consuming to get up and running.


Richard Waterbeek, the Netherlands



Brian Foster schreef op wo 12-07-2017 om 07:06 [-0400]:
> On Wed, Jul 12, 2017 at 12:22:53PM +0000, Richard Waterbeek wrote:
> > Hello Eric, linux-xfs list,
> > 
> > I have been thinking about getting myself options first.
> > 
> > I learned that;
> > 
> > The [Linux] operating system, doesn't recognize all "sda<number>"
> > partition. But I have found a program "CG TestDisk". To avoid discuccins
> > about that program, let me post a link to a screenshot, of what I have
> > now.
> > 
> > First things first, the two NTFS partitions have been restored.
> > 
> > Then, I expect to find a 'sda5', and a 'sda6', [so that is an extended
> > partition, containing two XFS partitions [524GB and 363GB]. 
> > 
> > The first screenshot is this program, again, to avoid discussing about
> > that program, [CG TestDisk], my question is related to XFS. Because; I
> > can tell, there seems to be a 'drive geometry', readable.
> > 
> > Here is the link to the screenshot;
> > http://www.fotobakje.nl/map/div/linux/testdisk/testdisk-correcte-weergave.png [Notice the two green 'L']. However, it is reported as being 'HPFS/ NTFS'.
> > 
> > Now I wonder about the geometry, is it possible [and how], to calculate
> > where mkfs.xfs, should have been written something [this is based on my
> > expectations, I really have no real understanding of the XFS file
> > system], so, where mkfs.xfs should have been written a [sda5 "mbr"],
> > since I believe the SuperBlock or SuperBlocks are intact. Since you
> > might have noticed there are five partitions in total [NTFS/ NTFS/ EXT4/
> > XFS/ XFS], I wonder, is there a way, I make a call to the [most]
> > knowledgable people here, to have a "xfs-<something", program or another
> > way, to learn, -where-, "mkfs.xfs", should "find" [I actually mean where
> > Linux expects an 'sda/ xfs block', to -mount- those file systems.
> > 
> 
> It sounds like you've had a corrupted partition table, partially
> restored it and are now trying to figure out where the last couple of
> XFS partitions on the drive may reside. Note that partitions are just a
> range of blocks to the filesystem. While sda5 might start on block N on
> a physical drive, the fs simply sees it as block 0. IOW, the fs does not
> know, care or have any information associated with the location of the
> underlying disk partition.
> 
> Therefore, as Eric noted in the immediately previous reply, the only
> recovery approach that I'm aware of is to manually search for XFS
> superblocks in the range of sda that is still unaccounted for. You can
> use hexdump to try and locate the blocks that start with the 'XFSB'
> magic value, _hope_ they point to valid superblocks and try to recreate
> your partitions from that information (the superblock should reside in
> the first block of the partition). Of course you will want to
> 'xfs_repair -n' the associated partition to determine how broken the
> filesystem is.
> 
> Brian
> 
> > This I ask [I know it is a bit complicated, trying to learn here],
> > because; xfs_repair expects a mounted file system [ro]. And, with
> > "guessing", and writing with mkfs.xfs which is easy for me to do, I can
> > be almost sure, I will end up with an empty XFS file system. [Yes, the
> > damaged drive, is still untouched by me], reading NTFS wasn't a pain.
> > 
> > I sincerely hope to get some waypointers, that will help me in my -own-
> > search. Please do not tell me this isn't XFS related. It is XFS related,
> > it might just be my person, willing and trying to be able, to understand
> > XFS and where that [I expect 512 bytes sector, not a "mkfs.xfs
> > recreation [that will make it bust for for sure], or if I am mistaken,
> > please tell me about the options you are thinking of. I of course take
> > full responsibillity for the steps I make [e.g. a real write to this
> > hard drive], so no one to blame, if it fails somehow.
> > 
> > Richard.
> > 
> > 
> > 
> > 
> > Eric Sandeen schreef op wo 28-06-2017 om 16:52 [-0500]:
> > > On 6/28/17 4:43 PM, Richard Waterbeek wrote:
> > > > Hi linux-xfs mailinglist,
> > > > 
> > > > I've recently subscribed to this list. I've seen many messages, but have
> > > > little understading of the 'XFS' file system. I know about mkfs.xfs.
> > > > I've benched my hardware. But, now my harddrive had a collision with the
> > > > mbr somehow. [or something]
> > > > 
> > > > But, now I've 'hexdumped', the first 512 bytes, [because after a
> > > > disaterous reboot, cfdisk is now saying; "/dev/sda empty".
> > > 
> > > If the xfs partition you lost was on extended partition sda5,
> > > that's not at the front of the disk.  It sounds like something
> > > overwrote your partition table. 
> > > 
> > > Honestly, recreating a partition table isn't an xfs issue.
> > > 
> > > > I'm aware of two primary and two logical partitions. I feel that I know
> > > > the size of the first and second primary, but the xfs/ sda5 and, xfs
> > > > sda6, are no longer appearing. I had to '#' the /etc/fstab, because it
> > > > won't boot [long waiting].
> > > > 
> > > > Now I would like to restore the first 512 bytes which is the MBR.
> > > > 
> > > > I have absolutely no understanding of -where-, "the SuperBlock" [or how
> > > > that should be called], happens to be.
> > > 
> > > The MBR is not the XFS superblock.  sda5's XFS superblock is somewhere
> > > much further into the disk.
> > > 
> > > I don't think anyone here can tell you how to recreate the partitions,
> > > because nobody knows what their exact size was.
> > >  
> > > The XFS superblock signature is "XFSB" so you could go hexdumping the
> > > whole disk, look for eveny-spaced occurences of that pattern, and assume
> > > that you've found some superblocks, and work backwards from there.
> > > 
> > > All this is essentially data recovery, getting well beyond the scope of
> > > normal mailing-list help, though.
> > > 
> > > -Eric
> > > 
> > > > But, I feel that 512 bytes missing and no reason to believe a whole
> > > > Terabyte would be "ones and/ or zero's", now, I wonder, how to restore
> > > > this. I have not made backup of this harddrive, just an rsync, which is
> > > > a little outdated and a bit incomplete, because difference in size of
> > > > both drives.
> > > > 
> > > > I might be able to create a XFS-something [from /dev/sda, for example],
> > > > and write that with dd. 
> > > > 
> > > > But, before I would 'try this out', I would like to gain some
> > > > understanding, of what -should- be on the first 512 bytes of a
> > > > harddrive, besides what I have now, cfdisk is saying empty.
> > > > 
> > > > Hoping to receive a reply, Richard, the Netherlands
> > > > 
> > > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html








