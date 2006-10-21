Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 21 Oct 2006 14:16:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9LLGUaG026920
	for <xfs@oss.sgi.com>; Sat, 21 Oct 2006 14:16:32 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46CE1D19F57B
	for <xfs@oss.sgi.com>; Sat, 21 Oct 2006 14:15:46 -0700 (PDT)
Message-ID: <453A8DFF.20707@sandeen.net>
Date: Sat, 21 Oct 2006 16:15:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS_WANT_CORRUPTED_GOTO at line 4528 of file fs/xfs/xfs_bmap.c
References: <45397929.8050704@kjellander.com> <F6C06450CC3FDD46A8E3A711BEF172BE347D0D@mx1.ddns.agami.com>
In-Reply-To: <F6C06450CC3FDD46A8E3A711BEF172BE347D0D@mx1.ddns.agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: Carl-Johan Kjellander <carljohan@kjellander.com>, xfs@oss.sgi.com

Shailendra Tripathi wrote:
> Hi Carl,
>            The best way to see what is going on is to see what log thinks it has. You must have got a message indicating the inode number and other details of the extent as indicated by the source.
>  
>          if(!rt && !gotp->br_startblock && (*lastxp != NULLEXTNUM <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=NULLEXTNUM> )) {
>                cmn_err <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=cmn_err> (CE_PANIC <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=CE_PANIC> ,"Access to block zero: fs: <%s> inode: %lld "
>                         "start_block : %llx start_off : %llx blkcnt : %llx "
>                        "extent-state : %x \n",
>                         (ip <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=ip> ->i_mount)->m_fsname,(long long)ip <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=ip> ->i_ino,
>                          gotp->br_startblock, gotp->br_startoff,
>                          gotp->br_blockcount,gotp->br_state);
>         }
> 
>  
>  
> Can you attach the hex dump of complete log with inode and extent information ? I want to see what has gone into the log for the operations on this inode. It could be that the extent map was corrupted just before shutdown or something in recovery screwed up. 
> -shailendra

(russell, looks like your take-message-rewriter is going a bit nuts up there? or 
something)

Anyway, the code in question that tripped here is:

                 XFS_WANT_CORRUPTED_GOTO(
                         XFS_BMAP_SANITY_CHECK(mp, block, level),
                         error0);

which is checking magic & other things.

The filesystem is corrupted; I'd guess this may be from 4kstacks + xfs + lvm + raid.

the image he provided has a clean log...
XFS mounting filesystem loop0
Ending clean XFS mount for filesystem: loop0

this file is one of the ones in bad shape as he mentioned:

[root@link-07 tmp]# ls -i mnt/lib/rpm/Packages
1048708 mnt/lib/rpm/Packages

in my case if I try to read it I get:

attempt to access beyond end of device
loop0: rw=0, want=1546188226568, limit=4194304
I/O error in filesystem ("loop0") meta-data dev loop0 block 0x16800000000 
("xfs_trans_read_buf") error 5 buf count 4096
attempt to access beyond end of device

the inode looks like :

xfs_db> p
core.magic = 0x494e
core.mode = 0100644
core.version = 1
core.format = 3 (btree)
core.nlinkv1 = 1
core.uid = 37
core.gid = 37
core.flushiter = 121
core.atime.sec = Sun Oct 15 17:17:38 2006
core.atime.nsec = 403299952
core.mtime.sec = Sun Oct 15 17:17:38 2006
core.mtime.nsec = 403299952
core.ctime.sec = Sun Oct 15 17:17:45 2006
core.ctime.nsec = 983773702
core.size = 21340160
core.nblocks = 5212
core.extsize = 0
core.nextents = 154
core.naextents = 1
core.forkoff = 15
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
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.gen = 0
next_unlinked = null
u.bmbt.level = 1
u.bmbt.numrecs = 1
u.bmbt.keys[1] = [startoff] 1:[0]
u.bmbt.ptrs[1] = 1:1233986491173044224
a.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,72071,1,0]

repair output:

repair output follows.

[root@link-07 tmp]# xfs_repair -n image
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - scan filesystem freespace and inode maps...
would zero unused portion of primary superblock (AG #0)
would zero unused portion of secondary superblock (AG #1)
would zero unused portion of secondary superblock (AG #2)
would zero unused portion of secondary superblock (AG #3)
would zero unused portion of secondary superblock (AG #4)
would zero unused portion of secondary superblock (AG #5)
would zero unused portion of secondary superblock (AG #6)
would zero unused portion of secondary superblock (AG #7)
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
bad bmap btree ptr 0x1120002d00000000 in ino 1048708
bad data fork in inode 1048708
would have cleared inode 1048708
bad bmap btree ptr 0x8000000300000000 in ino 1048709
bad data fork in inode 1048709
would have cleared inode 1048709
bad bmap btree ptr 0x57e0001700000000 in ino 1048711
bad data fork in inode 1048711
would have cleared inode 1048711
bad bmap btree ptr 0x9b00000200000000 in ino 1048716
bad data fork in inode 1048716
would have cleared inode 1048716
bad bmap btree ptr 0x9140000100000000 in ino 1048717
bad data fork in inode 1048717
would have cleared inode 1048717
bad bmap btree ptr 0xbf00000100000000 in ino 1048718
bad data fork in inode 1048718
would have cleared inode 1048718
bad bmap btree ptr 0xa840000100000000 in ino 1048719
bad data fork in inode 1048719
would have cleared inode 1048719
bad bmap btree ptr 0x6b00000100000000 in ino 1048722
bad data fork in inode 1048722
would have cleared inode 1048722
bad bmap btree ptr 0x98c0000100000000 in ino 1048723
bad data fork in inode 1048723
would have cleared inode 1048723
         - agno = 2
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
entry "Packages" at block 0 offset 144 in directory inode 1048704 references 
free inode 1048708
         would clear inode number in entry at offset 144...
entry "Providename" at block 0 offset 200 in directory inode 1048704 references 
free inode 1048709
         would clear inode number in entry at offset 200...
entry "Basenames" at block 0 offset 312 in directory inode 1048704 references 
free inode 1048711
         would clear inode number in entry at offset 312...
entry "Requirename" at block 0 offset 520 in directory inode 1048704 references 
free inode 1048716
         would clear inode number in entry at offset 520...
entry "Dirnames" at block 0 offset 568 in directory inode 1048704 references 
free inode 1048717
         would clear inode number in entry at offset 568...
entry "Requireversion" at block 0 offset 624 in directory inode 1048704 
references free inode 1048718
         would clear inode number in entry at offset 624...
entry "Provideversion" at block 0 offset 688 in directory inode 1048704 
references free inode 1048719
         would clear inode number in entry at offset 688...
entry "Sha1header" at block 0 offset 856 in directory inode 1048704 references 
free inode 1048722
         would clear inode number in entry at offset 856...
entry "Filemd5s" at block 0 offset 904 in directory inode 1048704 references 
free inode 1048723
         would clear inode number in entry at offset 904...
bad bmap btree ptr 0x1120002d00000000 in ino 1048708
bad data fork in inode 1048708
would have cleared inode 1048708
bad bmap btree ptr 0x8000000300000000 in ino 1048709
bad data fork in inode 1048709
would have cleared inode 1048709
bad bmap btree ptr 0x57e0001700000000 in ino 1048711
bad data fork in inode 1048711
would have cleared inode 1048711
bad bmap btree ptr 0x9b00000200000000 in ino 1048716
bad data fork in inode 1048716
would have cleared inode 1048716
bad bmap btree ptr 0x9140000100000000 in ino 1048717
bad data fork in inode 1048717
would have cleared inode 1048717
bad bmap btree ptr 0xbf00000100000000 in ino 1048718
bad data fork in inode 1048718
would have cleared inode 1048718
bad bmap btree ptr 0xa840000100000000 in ino 1048719
bad data fork in inode 1048719
would have cleared inode 1048719
bad bmap btree ptr 0x6b00000100000000 in ino 1048722
bad data fork in inode 1048722
would have cleared inode 1048722
bad bmap btree ptr 0x98c0000100000000 in ino 1048723
bad data fork in inode 1048723
would have cleared inode 1048723
         - agno = 2
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
         - traversing filesystem starting at / ...
entry "Packages" in directory inode 1048704 points to free inode 1048708, would 
junk entry
entry "Providename" in directory inode 1048704 points to free inode 1048709, 
would junk entry
entry "Basenames" in directory inode 1048704 points to free inode 1048711, would 
junk entry
entry "Requirename" in directory inode 1048704 points to free inode 1048716, 
would junk entry
entry "Dirnames" in directory inode 1048704 points to free inode 1048717, would 
junk entry
entry "Requireversion" in directory inode 1048704 points to free inode 1048718, 
would junk entry
entry "Provideversion" in directory inode 1048704 points to free inode 1048719, 
would junk entry
entry "Sha1header" in directory inode 1048704 points to free inode 1048722, 
would junk entry
entry "Filemd5s" in directory inode 1048704 points to free inode 1048723, would 
junk entry
         - traversal finished ...
         - traversing all unattached subtrees ...
         - traversals finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
