Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 13:58:30 -0700 (PDT)
Received: from mail.linbit.com (nudl.linbit.com [212.69.162.21])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34KwPfB008103
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 13:58:27 -0700
Date: Wed, 4 Apr 2007 22:36:01 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: xfs_repair leaves empty but undeletable dirs in lost+found
Message-ID: <20070404203601.GA11771@barkeeper1.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

this is a plain debian sarge system,
i386 (actually k7 athlon), nothing fancy.

kernel is a self-build kernel.org 2.6.16 kernel,
repackaged for sarge, so it is no longer obvious which exact
sublevel.  I can dig that up however, if it seems relevant.

this is a backup volume with typically many (40 to 70, maybe?) hardlinks.

 Filesystem               Inodes  IUsed  IFree  IUse%  Mounted on
 /dev/mapper/vg00-backup  1.2G    19M    1.2G   2%     /mnt/backup
 Filesystem               Size    Used   Avail  Use%   Mounted on
 /dev/mapper/vg00-backup  1.2T    809G   365G   69%    /mnt/backup

somehow file system corruption crept in.
may be related to some power loss, may be related to some strange
  3w-xxxx: scsi0: AEN: WARNING: ATA UDMA upgrade: Port #3
messages (also for port 5), which are actually DOWNgrades...
(unfortunately 2.6.16 has that double definition bug still in some
header file, I'll submit the oneline patch to Adrian together
whith some other stuff I have pending).

maybe cosmic rays.
memtest86+ is fine, btw.

anyhow.  after several runs of 
xfs_repair version 2.6.20
(and then cleaning up lost+found, where possible),

some "empty" but not so empty directories stay behind.

  [root:/mnt/backup/lost+found]# rmdir 4059295137
  rmdir: `4059295137': Directory not empty
  [root:/mnt/backup/lost+found]# find 4059295137 -ls
  4059295137    8 drwxrwxr-x   2 1049     1049         4096 Apr  3 12:39 4059295137

  that is it!

[right now I have still 118 of these]

additional runs of xfs_repair don't change the situation.
on run takes about 8+ hours, though.

NOTE that I used the default sarge xfsprogs version 2.6.20, not
     the upstream 2.8.20. yet. I'll start an xfs_repair run with
     2.8.20 right after this post, though...

from a post on xfs mailing list
 Message-Id: <200608150145.LAA07105@larry.melbourne.sgi.com>
 From: Barry Naujok <bnaujok@melbourne.sgi.com>
 To: 'Paul Slootman' <paul@wurtel.net>, xfs@oss.sgi.com
 Subject: RE: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
 Date: Tue, 15 Aug 2006 11:49:13 +1000

I found a suggestion to investigate like this:
xfs_db version 2.6.20

xfs_db /dev/vg00/backup

[sorry, I skipped the blockget -n and therefor the ncheck,
 if absolutely necessary, I can do that still, but I suspect it
 will take hours, too?  I tried it, but after a few minutes with
 95% CPU and about 2GB RAM used, I killed it...]

xfs_db> inode 4059295137
xfs_db> p
core.magic = 0x494e
core.mode = 040775
core.version = 1
core.format = 2 (extents)
core.nlinkv1 = 2
core.uid = 1049
core.gid = 1049
core.flushiter = 24
core.atime.sec = Thu Feb  1 20:30:54 2007
core.atime.nsec = 533550800
core.mtime.sec = Tue Apr  3 12:39:00 2007
core.mtime.nsec = 472123752
core.ctime.sec = Tue Apr  3 12:39:00 2007
core.ctime.nsec = 472123752
core.size = 4096
core.nblocks = 2
core.extsize = 0
core.nextents = 2
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.gen = 11
next_unlinked = null
u.bmx[0-1] = [startoff,startblock,blockcount,extentflag] 0:[0,253808988,1,0] 1:[8388608,253808989,1,0]
xfs_db> ncheck lost+found
must run blockget -n first
xfs_db> dblock 0
xfs_db> p
dhdr.magic = 0x58443244
dhdr.bestfree[0].offset = 0x20
dhdr.bestfree[0].length = 0xfd0
dhdr.bestfree[1].offset = 0
dhdr.bestfree[1].length = 0
dhdr.bestfree[2].offset = 0
dhdr.bestfree[2].length = 0
du[0].inumber = 4059295137
du[0].namelen = 1
du[0].name = "."
du[0].tag = 0x10
du[1].freetag = 0xffff
du[1].length = 0xfd0
du[1].tag = 0x20
du[2].inumber = 656
du[2].namelen = 2
du[2].name = ".."
du[2].tag = 0xff0
xfs_db> dblock 8388608
xfs_db> p
lhdr.info.forw = 0
lhdr.info.back = 0
lhdr.info.magic = 0xd2f1
lhdr.count = 99
lhdr.stale = 97
lbests[0] = 0:0xfd0
lents[0].hashval = 0x2e
lents[0].address = 0x2
lents[1].hashval = 0x172e
lents[1].address = 0x1fe
lents[2].hashval = 0x859d16c
lents[2].address = 0
lents[3].hashval = 0xdc6133e
lents[3].address = 0
lents[4].hashval = 0xeffc248
lents[4].address = 0
lents[5].hashval = 0xfed728e
lents[5].address = 0
lents[6].hashval = 0x124f4f36
lents[6].address = 0
lents[7].hashval = 0x13625491
lents[7].address = 0
lents[8].hashval = 0x1372549d
lents[8].address = 0
lents[9].hashval = 0x19ef9ac0
lents[9].address = 0
lents[10].hashval = 0x1b1d6dce
lents[10].address = 0
lents[11].hashval = 0x1db2dd93
lents[11].address = 0
lents[12].hashval = 0x262a70f3
lents[12].address = 0
lents[13].hashval = 0x29460811
lents[13].address = 0
lents[14].hashval = 0x2956081d
lents[14].address = 0
lents[15].hashval = 0x2d8b48ab
lents[15].address = 0
lents[16].hashval = 0x31e3c314
lents[16].address = 0
lents[17].hashval = 0x3669d1ab
lents[17].address = 0
lents[18].hashval = 0x3679d1a7
lents[18].address = 0
lents[19].hashval = 0x36b8264b
lents[19].address = 0
lents[20].hashval = 0x3996aced
lents[20].address = 0
lents[21].hashval = 0x3a35ab00
lents[21].address = 0
lents[22].hashval = 0x3c670bbd
lents[22].address = 0
lents[23].hashval = 0x3f150fd1
lents[23].address = 0
lents[24].hashval = 0x4308c7cd
lents[24].address = 0
lents[25].hashval = 0x463489b9
lents[25].address = 0
lents[26].hashval = 0x475261d5
lents[26].address = 0
lents[27].hashval = 0x53469be7
lents[27].address = 0
lents[28].hashval = 0x53569beb
lents[28].address = 0
lents[29].hashval = 0x589604ba
lents[29].address = 0
lents[30].hashval = 0x594bf53d
lents[30].address = 0
lents[31].hashval = 0x5981bb01
lents[31].address = 0
lents[32].hashval = 0x5a46bb9c
lents[32].address = 0
lents[33].hashval = 0x5c0b668e
lents[33].address = 0
lents[34].hashval = 0x5deca0a1
lents[34].address = 0
lents[35].hashval = 0x5f872eba
lents[35].address = 0
lents[36].hashval = 0x5f8a3faa
lents[36].address = 0
lents[37].hashval = 0x5f9a3fa6
lents[37].address = 0
lents[38].hashval = 0x691b5828
lents[38].address = 0
lents[39].hashval = 0x69d27a70
lents[39].address = 0
lents[40].hashval = 0x73c859c2
lents[40].address = 0
lents[41].hashval = 0x73d859ce
lents[41].address = 0
lents[42].hashval = 0x75eb5177
lents[42].address = 0
lents[43].hashval = 0x75fb517b
lents[43].address = 0
lents[44].hashval = 0x891e2e5b
lents[44].address = 0
lents[45].hashval = 0x8965893f
lents[45].address = 0
lents[46].hashval = 0x8cb8b142
lents[46].address = 0
lents[47].hashval = 0x8cce44a0
lents[47].address = 0
lents[48].hashval = 0x8de83f12
lents[48].address = 0
lents[49].hashval = 0x8f22b70e
lents[49].address = 0
lents[50].hashval = 0x8f4ab64c
lents[50].address = 0
lents[51].hashval = 0x90acb7a0
lents[51].address = 0
lents[52].hashval = 0x9302cac0
lents[52].address = 0
lents[53].hashval = 0x9312cacc
lents[53].address = 0
lents[54].hashval = 0x950c4daa
lents[54].address = 0
lents[55].hashval = 0x960164df
lents[55].address = 0
lents[56].hashval = 0x97df8a76
lents[56].address = 0
lents[57].hashval = 0x9b1ca984
lents[57].address = 0
lents[58].hashval = 0x9be7549e
lents[58].address = 0
lents[59].hashval = 0x9bf75492
lents[59].address = 0
lents[60].hashval = 0x9db319d9
lents[60].address = 0
lents[61].hashval = 0xa4926d71
lents[61].address = 0
lents[62].hashval = 0xa5677d7e
lents[62].address = 0
lents[63].hashval = 0xa5777d72
lents[63].address = 0
lents[64].hashval = 0xaa01d033
lents[64].address = 0
lents[65].hashval = 0xaa11d03f
lents[65].address = 0
lents[66].hashval = 0xaa8a84f0
lents[66].address = 0
lents[67].hashval = 0xaa9a84fc
lents[67].address = 0
lents[68].hashval = 0xae810ff0
lents[68].address = 0
lents[69].hashval = 0xaedc9085
lents[69].address = 0
lents[70].hashval = 0xb55cb496
lents[70].address = 0
lents[71].hashval = 0xb8866b93
lents[71].address = 0
lents[72].hashval = 0xb98b5af9
lents[72].address = 0
lents[73].hashval = 0xb9d6e5c3
lents[73].address = 0
lents[74].hashval = 0xbb1c6ddf
lents[74].address = 0
lents[75].hashval = 0xbc34bda9
lents[75].address = 0
lents[76].hashval = 0xbd20f48a
lents[76].address = 0
lents[77].hashval = 0xbe8bae2a
lents[77].address = 0
lents[78].hashval = 0xc86644bc
lents[78].address = 0
lents[79].hashval = 0xcdb62e47
lents[79].address = 0
lents[80].hashval = 0xcdcd8923
lents[80].address = 0
lents[81].hashval = 0xd43269bc
lents[81].address = 0
lents[82].hashval = 0xde074636
lents[82].address = 0
lents[83].hashval = 0xde17463a
lents[83].address = 0
lents[84].hashval = 0xe1321219
lents[84].address = 0
lents[85].hashval = 0xe1465aa0
lents[85].address = 0
lents[86].hashval = 0xe65770a0
lents[86].address = 0
lents[87].hashval = 0xe7e6d19e
lents[87].address = 0
lents[88].hashval = 0xeb8d1d7a
lents[88].address = 0
lents[89].hashval = 0xf02bb092
lents[89].address = 0
lents[90].hashval = 0xf03bb09e
lents[90].address = 0
lents[91].hashval = 0xf494b02c
lents[91].address = 0
lents[92].hashval = 0xf58811b2
lents[92].address = 0
lents[93].hashval = 0xf59811be
lents[93].address = 0
lents[94].hashval = 0xf988f496
lents[94].address = 0
lents[95].hashval = 0xfb4d59cd
lents[95].address = 0
lents[96].hashval = 0xfb5d59c1
lents[96].address = 0
lents[97].hashval = 0xfca78996
lents[97].address = 0
lents[98].hashval = 0xfe80e968
lents[98].address = 0
ltail.bestcount = 1
xfs_db> 

hope that helps someone figure out what is wrong.
if I can provide further info, anything, just tell me.

cheers,

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
__
please use the "List-Reply" function of your email client.
