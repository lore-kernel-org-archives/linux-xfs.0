Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Apr 2008 09:10:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m36G9Ku7007040
	for <xfs@oss.sgi.com>; Sun, 6 Apr 2008 09:09:23 -0700
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Sun, 6 Apr 2008 18:09:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <20080401003518.GK103491721@sgi.com>
Message-Id: <20080406160953.D47CF944596@cuda.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'David Chinner' <dgc@sgi.com>
Cc: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

Hi guys, the earlier problem came out again:

Here are the logs:

[root]~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0               42G   15G   26G  37% /
tmpfs                 7.9G     0  7.9G   0% /lib/init/rw
udev                   10M   76K   10M   1% /dev
tmpfs                 7.9G  2.2M  7.9G   1% /dev/shm
/dev/md1              420G   31G  389G   8% /var/www/users
/dev/mapper/a-a        17T   17T   51G 100% /var/www/users/sms

[root]~# df -ih
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md0                5.3M    152K    5.1M    3% /
tmpfs                   2.0M       5    2.0M    1% /lib/init/rw
udev                    2.0M     487    2.0M    1% /dev
tmpfs                   2.0M      10    2.0M    1% /dev/shm
/dev/md1                420M    398K    419M    1% /var/www/users
/dev/mapper/a-a         203M    850K    202M    1% /var/www/users/sms

[root]~# xfs_info /var/www/users/sms
meta-data=/dev/a/a               isize=256    agcount=32, agsize=137326144
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=4394436608, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

[root]~# xfs_logprint /dev/a/a
xfs_logprint:
xfs_logprint: /dev/a/a contains a mounted and writable filesystem
    data device: 0xfd00
    log device: 0xfd00 daddr: 17577746464 length: 262144

Header 0x1 wanted 0xfeedbabe
**********************************************************************
* ERROR: header cycle=1           block=176303                       *
**********************************************************************
Bad log record header

[root]~# umount /var/www/users/sms

[root]~# xfs_repair /dev/a/a
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - deleting existing "lost+found" entry
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

[root]~# mount /var/www/users/sms

[root]~# touch /var/www/users/sms/1
touch: cannot touch `/var/www/users/sms/1': No space left on device

[root]~# xfs_logprint /dev/a/a
xfs_logprint:
xfs_logprint: /dev/a/a contains a mounted and writable filesystem
    data device: 0xfd00
    log device: 0xfd00 daddr: 17577746464 length: 262144

cycle: 1        version: 1              lsn: 1,0        tail_lsn: 1,0
length of Log Record: 20        prev offset: -1         num ops: 1
uuid: 68b5aa39-c15e-4170-a43f-9278e95911ea   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: b0c0d0d0  len: 8  clientid: LOG  flags: UNMOUNT
Unmount filesystem

============================================================================
xfs_logprint: skipped 512 cleared blocks in range: 2 - 513
xfs_logprint: skipped 261630 zeroed blocks in range: 514 - 262143
xfs_logprint: physical end of log
============================================================================
xfs_logprint: logical end of log
============================================================================

We have another server, which has exactly the same hardware architecture,
exactly the same system, it's the same server we use dns load balancing
between the two, and there we have no problem at all, but see the log:

[root]~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0               42G   12G   30G  28% /
tmpfs                 7.9G     0  7.9G   0% /lib/init/rw
udev                   10M   72K   10M   1% /dev
tmpfs                 7.9G     0  7.9G   0% /dev/shm
/dev/mapper/a-a        17T   17T   28G 100% /var/www/users/sms

[root]~# df -ih
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md0                5.3M    293K    5.0M    6% /
tmpfs                   2.0M       5    2.0M    1% /lib/init/rw
udev                    2.0M     469    2.0M    1% /dev
tmpfs                   2.0M       1    2.0M    1% /dev/shm
/dev/mapper/a-a         309M    857K    309M    1% /var/www/users/sms

[root]~# xfs_info /var/www/users/sms
meta-data=/dev/a/a               isize=256    agcount=32, agsize=137326144
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=4394436608, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

[root]~# xfs_logprint /dev/a/a
xfs_logprint:
xfs_logprint: /dev/a/a contains a mounted and writable filesystem
    data device: 0xfd00
    log device: 0xfd00 daddr: 17577746464 length: 262144

Header 0x3 wanted 0xfeedbabe
**********************************************************************
* ERROR: header cycle=3           block=55900                        *
**********************************************************************
Bad log record header

So you tell me, it appeared again just suddenly.
Thank you,

Viktor

-----Original Message-----
From: David Chinner [mailto:dgc@sgi.com] 
Sent: Tuesday, April 01, 2008 2:35 AM
To: Huszár Viktor Dénes
Cc: 'Emmanuel Florac'; xfs@oss.sgi.com
Subject: Re: free space problem

On Mon, Mar 31, 2008 at 07:36:56PM +0200, Huszár Viktor Dénes wrote:
> -----Original Message-----
> From: Emmanuel Florac [mailto:eflorac@intellique.com] 
> Sent: Monday, March 31, 2008 9:40 AM
> To: Huszár Viktor Dénes; xfs@oss.sgi.com
> Subject: Re: free space problem
> 
> Le Mon, 31 Mar 2008 02:31:16 +0200 vous écriviez:
> 
> >Then maybe you simply ran out of inodes. It's common if you have lots
> >of small files. There is a way to increase the number of inodes but I
> >don't remember it right now.
> --
> No, unfortunately not. There are not many small files and the inode usage
is
> 1%. See.

Yes, but if you have fragemented free space then it is possible that there
are not enough free extents large enough (or aligned correctly) to
allocate more inodes. The number of "free inodes" reported doesn't take
this into account; it only looks at the number of free blocks and converts
that to a theoretical number of inodes that could be allocated in that
space (i.e. it assumes perfect fit and no waste). 

In this "not quite full filesystem" situation, you can write data to the
filesystem, but any attempt to create a new inode (new file, directory,
etc) will fail with ENOSPC. This sounds like the symptoms you are
reporting....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


__________ Information from ESET NOD32 Antivirus, version of virus signature
database 2988 (20080331) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
