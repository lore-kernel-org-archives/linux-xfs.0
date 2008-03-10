Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 02:00:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2A90Olh001293
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 02:00:25 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1FDD67AE6C
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 02:00:54 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.233]) by cuda.sgi.com with ESMTP id yXZfGf4Fs3PgDUWF for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 02:00:54 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id c53so701356wra.20
        for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 02:00:53 -0700 (PDT)
Message-ID: <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
Date: Mon, 10 Mar 2008 09:34:14 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <20080310000809.GU155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
	 <20080213214551.GR155407@sgi.com>
	 <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
	 <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com>
	 <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com>
	 <20080310000809.GU155407@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Thanks for the help, David. Answers below:

On Mon, Mar 10, 2008 at 1:08 AM, David Chinner <dgc@sgi.com> wrote:
> On Fri, Mar 07, 2008 at 12:19:28PM +0100, Christian Røsnes wrote:
>  > >  Actually, a single mkdir command is enough to trigger the filesystem
>  > >  shutdown when its 99% full (according to df -k):
>  > >
>  > >  /data# mkdir test
>  > >  mkdir: cannot create directory `test': No space left on device
>
>  Ok, that's helpful ;)
>
>  So, can you dump the directory inode with xfs_db? i.e.
>
>  # ls -ia /data


# ls -ia /data
      128 .        128 ..        131 content  149256847 rsync


>
>  The directory inode is the inode at ".", and if this is the root of
>  the filesystem it will probably be 128.
>
>  Then run:
>
>  # xfs_db -r -c 'inode 128' -c p /dev/sdb1
>


# xfs_db -r -c 'inode 128' -c p /dev/sdb1
core.magic = 0x494e
core.mode = 040755
core.version = 1
core.format = 1 (local)
core.nlinkv1 = 4
core.uid = 0
core.gid = 0
core.flushiter = 47007
core.atime.sec = Wed Oct 19 12:14:10 2005
core.atime.nsec = 640092000
core.mtime.sec = Fri Dec 15 10:27:21 2006
core.mtime.nsec = 624437500
core.ctime.sec = Fri Dec 15 10:27:21 2006
core.ctime.nsec = 624437500
core.size = 32
core.nblocks = 0
core.extsize = 0
core.nextents = 0
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
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 0
next_unlinked = null
u.sfdir2.hdr.count = 2
u.sfdir2.hdr.i8count = 0
u.sfdir2.hdr.parent.i4 = 128
u.sfdir2.list[0].namelen = 7
u.sfdir2.list[0].offset = 0x30
u.sfdir2.list[0].name = "content"
u.sfdir2.list[0].inumber.i4 = 131
u.sfdir2.list[1].namelen = 5
u.sfdir2.list[1].offset = 0x48
u.sfdir2.list[1].name = "rsync"
u.sfdir2.list[1].inumber.i4 = 149256847


>
>  > >  --------
>  > >  meta-data=/dev/sdb1              isize=512    agcount=16, agsize=4476752 blks
>  > >          =                       sectsz=512   attr=0
>  > >  data     =                       bsize=4096   blocks=71627792, imaxpct=25
>  > >          =                       sunit=16     swidth=32 blks, unwritten=1
>  > >  naming   =version 2              bsize=4096
>  > >  log      =internal               bsize=4096   blocks=32768, version=2
>  > >          =                       sectsz=512   sunit=16 blks, lazy-count=0
>  > >  realtime =none                   extsz=65536  blocks=0, rtextents=0
>  > >
>  > >  xfs_db -r -c 'sb 0' -c p /dev/sdb1
>  > >  ----------------------------------
>  .....
>  > >  fdblocks = 847484
>
>  Apparently there are still lots of free blocks. I wonder if you are out of
>  space in the metadata AGs.
>
>  Can you do this for me:
>
>  -------
>  #!/bin/bash
>
>  for i in `seq 0 1 15`; do
>         echo freespace histogram for AG $i
>         xfs_db -r -c "freesp -bs -a $i" /dev/sdb1
>  done
>  ------
>

# for i in `seq 0 1 15`; do
>        echo freespace histogram for AG $i
>        xfs_db -r -c "freesp -bs -a $i" /dev/sdb1
> done
freespace histogram for AG 0
   from      to extents  blocks    pct
      1       1    2098    2098   3.77
      2       3    8032   16979  30.54
      4       7    6158   33609  60.46
      8      15     363    2904   5.22
total free extents 16651
total free blocks 55590
average free extent size 3.33854
freespace histogram for AG 1
   from      to extents  blocks    pct
      1       1    2343    2343   3.90
      2       3    9868   21070  35.10
      4       7    6000   34535  57.52
      8      15     261    2088   3.48
total free extents 18472
total free blocks 60036
average free extent size 3.25011
freespace histogram for AG 2
   from      to extents  blocks    pct
      1       1    1206    1206  10.55
      2       3    3919    8012  70.10
      4       7     394    2211  19.35
total free extents 5519
total free blocks 11429
average free extent size 2.07085
freespace histogram for AG 3
   from      to extents  blocks    pct
      1       1    3179    3179   8.48
      2       3   14689   29736  79.35
      4       7     820    4560  12.17
total free extents 18688
total free blocks 37475
average free extent size 2.0053
freespace histogram for AG 4
   from      to extents  blocks    pct
      1       1    4113    4113   9.62
      2       3   10685   22421  52.45
      4       7    2951   16212  37.93
total free extents 17749
total free blocks 42746
average free extent size 2.40836
freespace histogram for AG 5
   from      to extents  blocks    pct
      1       1    2909    2909   4.23
      2       3   20370   41842  60.81
      4       7    3973   23861  34.68
      8      15      24     192   0.28
total free extents 27276
total free blocks 68804
average free extent size 2.52251
freespace histogram for AG 6
   from      to extents  blocks    pct
      1       1    3577    3577   4.86
      2       3   18592   38577  52.43
      4       7    4427   25764  35.02
      8      15     707    5656   7.69
total free extents 27303
total free blocks 73574
average free extent size 2.69472
freespace histogram for AG 7
   from      to extents  blocks    pct
      1       1    2634    2634   9.14
      2       3   11928   24349  84.48
      4       7     366    1840   6.38
total free extents 14928
total free blocks 28823
average free extent size 1.9308
freespace histogram for AG 8
   from      to extents  blocks    pct
      1       1    6473    6473   6.39
      2       3   22020   46190  45.61
      4       7    7343   40137  39.64
      8      15    1058    8464   8.36
total free extents 36894
total free blocks 101264
average free extent size 2.74473
freespace histogram for AG 9
   from      to extents  blocks    pct
      1       1    2165    2165   2.22
      2       3   15746   33317  34.20
      4       7    9402   55502  56.97
      8      15     805    6440   6.61
total free extents 28118
total free blocks 97424
average free extent size 3.46483
freespace histogram for AG 10
   from      to extents  blocks    pct
      1       1    5886    5886   9.46
      2       3   13682   29881  48.01
      4       7    4561   23919  38.43
      8      15     319    2552   4.10
total free extents 24448
total free blocks 62238
average free extent size 2.54573
freespace histogram for AG 11
   from      to extents  blocks    pct
      1       1    4197    4197   7.47
      2       3    8421   18061  32.14
      4       7    4336   24145  42.97
      8      15    1224    9792  17.43
total free extents 18178
total free blocks 56195
average free extent size 3.09137
freespace histogram for AG 12
   from      to extents  blocks    pct
      1       1     310     310  90.64
      2       3      16      32   9.36
total free extents 326
total free blocks 342
average free extent size 1.04908
freespace histogram for AG 13
   from      to extents  blocks    pct
      1       1    4845    4845  22.31
      2       3    7533   16873  77.69
total free extents 12378
total free blocks 21718
average free extent size 1.75456
freespace histogram for AG 14
   from      to extents  blocks    pct
      1       1    3572    3572   6.50
      2       3   17437   36656  66.72
      4       7    2702   14711  26.78
total free extents 23711
total free blocks 54939
average free extent size 2.31703
freespace histogram for AG 15
   from      to extents  blocks    pct
      1       1    4568    4568   6.24
      2       3   13400   28983  39.62
      4       7    6992   39606  54.14
total free extents 24960
total free blocks 73157
average free extent size 2.93097


>
>  > Instrumenting the code, I found that this occurs on my system when I
>  > do a 'mkdir /data/test' on the partition in question:
>  >
>  > in xfs_mkdir  (xfs_vnodeops.c):
>  >
>  >   error = xfs_dir_ialloc(&tp, dp, mode, 2,
>  >                         0, credp, prid, resblks > 0,
>  >                 &cdp, NULL);
>  >
>  >         if (error) {
>  >                 if (error == ENOSPC)
>  >                         goto error_return;   <=== this is hit and then
>  > execution jumps to error_return
>  >                 goto abort_return;
>  >         }
>
>  Ah - you can ignore my last email, then. You're already one step ahead
>  of me ;)
>
>  This does not appear to be the case I was expecting, though I can
>  see how we can get an ENOSPC here with plenty of blocks free - none
>  are large enough to allocate an inode chunk. What would be worth
>  knowing is the value of resblks when this error is reported.

Ok. I'll see if I can print it out.

>
>  This tends to imply we are returning an ENOSPC with a dirty
>  transaction. Right now I can't see how that would occur, though
>  the fragmented free space is something I can try to reproduce with.

ok

>
>
>  > Is this the correct behavior for this type of situation: mkdir command
>  > fails due to no available space on filesystem,
>  > and xfs_mkdir goes to label error_return  ? (And after this the
>  > filesystem is shutdown)
>
>  The filesystem should not be shutdown here. We need to trace through
>  further to the source of the error....
>

ok

Btw - to debug this on a test-system, can I do a dd if=/dev/sdb1 or dd
if=/dev/sdb,
and output it to an image which is then loopback mounted on the test-system ?
Ie. is there some sort of  "best practice" on how to copy this
partition to a test-system
for further testing ?

Thanks
Christian
