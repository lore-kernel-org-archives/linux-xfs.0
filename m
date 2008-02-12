Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 03:37:26 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1CBbHCf008033
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 03:37:18 -0800
Received: from hu-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FC095C72F7
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 03:37:38 -0800 (PST)
Received: from hu-out-0506.google.com (hu-out-0506.google.com [72.14.214.236]) by cuda.sgi.com with ESMTP id BC8bPF7vOc3B41Ld for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 03:37:38 -0800 (PST)
Received: by hu-out-0506.google.com with SMTP id 16so7418337hue.17
        for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 03:37:37 -0800 (PST)
Message-ID: <1a4a774c0802120337x55fa2eb6qb7d52511fba3d11c@mail.gmail.com>
Date: Tue, 12 Feb 2008 12:37:36 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: inode size benchmarking
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I'm trying to figure out how different inode sizes on my system
affect the time it takes to:

  1) Create <n1> directories each with <n2> files (using different file sizes)

  2) Read all the files from dir1,
          all the files from dir2,
          ...

  3) Read file1 from dir1,
          file1 from dir2,
          ...
          file2 from dir1,
          file2 from dir2,
          ...

The file sizes in this test range from 1MB to 50MB.
In the test case enclosed I've used inode size 256 and 2048.
(The script I've used is also attached at the end of this email)

The test server used:

 * Debian 4 (Etch)
 * Kernel: Debian 2.6.18-6-amd64 #1 SMP Wed Jan 23 06:27:23 UTC 2008
x86_64 GNU/Linux
 * CPU: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
 * MEM: 4GB RAM
 * DISK: DELL MD1000 7 disks (1TB SATA) in RAID5. PERC6/E controller
 * The test partition is 6TB.
 * I'm using xfsprogs 2.9.4

The timing results indicate that using an inode size = 2048 bytes,
the tests on my system complete quicker than the default inode size = 256 bytes.
I'm curious what might cause this, and if it can be explained by
merely looking at the inode data ? And if yes, what should I be looking for ?

Looking at the extent mapping for each inode from test 1) above,
I find that the each file only contain 1 extent (well in some
cases a few files turn up with 2 extents - see full log below for details),
and thus it should fit inside the inode regardless of the inode size
(256 vs 2048).
So could there be other factors weighing in ?

Thanks

Christian

# ---------------------- Results - short version ----------------------


# grep -A 2 'CREATE_TIME' run5.log

CREATE_TIME:isize=256:fname=file1mb

real    0m10.781s
--
CREATE_TIME:isize=2048:fname=file1mb

real    0m5.601s
--
CREATE_TIME:isize=256:fname=file5mb

real    1m9.771s
--
CREATE_TIME:isize=2048:fname=file5mb

real    0m46.441s
--
CREATE_TIME:isize=256:fname=file10mb

real    2m12.143s
--
CREATE_TIME:isize=2048:fname=file10mb

real    1m20.204s
--
CREATE_TIME:isize=256:fname=file20mb

real    3m59.955s
--
CREATE_TIME:isize=2048:fname=file20mb

real    2m18.546s
--
CREATE_TIME:isize=256:fname=file30mb

real    5m40.613s
--
CREATE_TIME:isize=2048:fname=file30mb

real    3m8.358s
--
CREATE_TIME:isize=256:fname=file40mb

real    7m16.146s
--
CREATE_TIME:isize=2048:fname=file40mb

real    4m7.343s
--
CREATE_TIME:isize=256:fname=file50mb

real    9m3.861s
--
CREATE_TIME:isize=2048:fname=file50mb

real    4m59.963s



# grep -A 2 'READ1_TIME' run5.log

READ1_TIME:isize=256:fname=file1mb

real    1m4.766s
--
READ1_TIME:isize=2048:fname=file1mb

real    0m23.320s
--
READ1_TIME:isize=256:fname=file5mb

real    1m23.792s
--
READ1_TIME:isize=2048:fname=file5mb

real    0m57.450s
--
READ1_TIME:isize=256:fname=file10mb

real    1m42.586s
--
READ1_TIME:isize=2048:fname=file10mb

real    1m14.005s
--
READ1_TIME:isize=256:fname=file20mb

real    2m13.475s
--
READ1_TIME:isize=2048:fname=file20mb

real    1m53.727s
--
READ1_TIME:isize=256:fname=file30mb

real    2m53.505s
--
READ1_TIME:isize=2048:fname=file30mb

real    2m26.111s
--
READ1_TIME:isize=256:fname=file40mb

real    3m27.172s
--
READ1_TIME:isize=2048:fname=file40mb

real    3m2.579s
--
READ1_TIME:isize=256:fname=file50mb

real    4m2.087s
--
READ1_TIME:isize=2048:fname=file50mb

real    3m35.429s





# grep -A 2 'READ2_TIME' run5.log

READ2_TIME:isize=256:fname=file1mb

real    0m31.013s
--
READ2_TIME:isize=2048:fname=file1mb

real    0m7.328s
--
READ2_TIME:isize=256:fname=file5mb

real    0m59.086s
--
READ2_TIME:isize=2048:fname=file5mb

real    0m21.544s
--
READ2_TIME:isize=256:fname=file10mb

real    1m18.158s
--
READ2_TIME:isize=2048:fname=file10mb

real    0m39.243s
--
READ2_TIME:isize=256:fname=file20mb

real    1m51.332s
--
READ2_TIME:isize=2048:fname=file20mb

real    1m14.573s
--
READ2_TIME:isize=256:fname=file30mb

real    2m25.312s
--
READ2_TIME:isize=2048:fname=file30mb

real    1m50.197s
--
READ2_TIME:isize=256:fname=file40mb

real    3m0.558s
--
READ2_TIME:isize=2048:fname=file40mb

real    2m24.960s
--
READ2_TIME:isize=256:fname=file50mb

real    3m36.145s
--
READ2_TIME:isize=2048:fname=file50mb

real    3m1.140s


# ---------------------- Test script ----------------------


#!/bin/sh

PARTITION=/content/backup01
DEV=/dev/sdb1
SRCDIR=/root/test
TEST01=$SRCDIR/test01.sh
TEST02=$SRCDIR/test02.sh
FHEAD=file
FTAIL=mb
MPARAM="nobarrier,noatime,logbufs=8,logbsize=256k"
MOUNT="mount -t xfs -o $MPARAM $DEV $PARTITION"
UMOUNT="umount $PARTITION"
DIRCNT=10
FILECNT=100
FILESIZES_MB="1 5 10 20 30 40 50"
INODESIZES="256 2048"

if [ ! -d "$SRCDIR" ] ; then
 echo "ERR: SRCDIR $SRCDIR does not exist"
 exit 1
fi

#create srcfiles used during cp
for MBSIZE in $FILESIZES_MB ;
do
 fname=$FHEAD$MBSIZE$FTAIL
 dd if=/dev/zero of=$SRCDIR/$fname bs=1024k count=$MBSIZE >/dev/null 2>&1
done
sync

# start test
for MBSIZE in $FILESIZES_MB ;
do
 for isize in $INODESIZES ;
 do
  fname=$FHEAD$MBSIZE$FTAIL
  echo "Run: isize=$isize, fname=$fname      (`date`)"
  # RAID5 - 7 disks (6 data + 1 parity) sw=6
  mkfs.xfs -f -i size=$isize,attr=2 -l \
           version=2,su=64k,size=128m -d su=64k,sw=6 $DEV || exit 1

  $MOUNT || exit 1
  echo "Mount options used:"
  mount | grep $DEV
  # cache srcfile used during cp
  cp $SRCDIR/$fname /dev/null
  echo "Creating $DIRCNT directories and cp $FILECNT $fname files into each"
  echo "CREATE_TIME:isize=$isize:fname=$fname"
  time {
    for d in `seq -w 1 $DIRCNT`
    do
      D="$PARTITION/test/$d"
      mkdir -p "$D" || exit 1
      for f in `seq -w 1 $FILECNT`
        do cp "$SRCDIR/$fname" "$D/file.$f" ; done
    done
    sync
    }

  echo
  echo "Disk usage:"
  df -k | grep "$DEV"

  echo
  echo "Extents:"

  for ino in `find $PARTITION/test -type f -printf "%i "` ;
  do
    xfs_db -r -c "inode $ino " -c "print core.nextents" $DEV
  done  | sort | uniq -c
  $UMOUNT || exit 1

  $MOUNT || exit 1
  echo
  echo "READ1 (cp) each of the $FILECNT $fname files"
  echo "      in each of the $DIRCNT directories"
  echo "NOTE: we read (cp) the first file from each directory, "
  echo "      then the second file from each directory, and so on"
  echo "READ1_TIME:isize=$isize:fname=$fname"
  time  {
    for f in `seq -w 1 $FILECNT`
    do
      for d in `seq -w 1 $DIRCNT`
      do D="$PARTITION/test/$d"; cp "$D/file.$f" /dev/null ; done
    done
    sync
    }
  $UMOUNT || exit 1

  $MOUNT || exit 1
  echo
  echo "READ2 (cp) each of the $FILECNT $fname files"
  echo "      in each of the $DIRCNT directories"
  echo "NOTE: we read all files in the first directory,"
  echo "      then the all the files in the second, and so on"
  echo "READ2_TIME:isize=$isize:fname=$fname"
  time  {
    for d in `seq -w 1 $DIRCNT`
    do
      for f in `seq -w 1 $FILECNT`
      do D="$PARTITION/test/$d"; cp "$D/file.$f" /dev/null ; done
    done
    sync
    }
  $UMOUNT || exit 1
  echo "-------------------------------------------------------------"
 done
done

echo "Done `date`"






# ---------------------- Results - full version ----------------------


./benchmark_fs.sh > run5.log 2>&1


# cat run5.log

Run: isize=256, fname=file1mb      (Tue Feb 12 10:31:54 CET 2008)
meta-data=/dev/sdb1              isize=256    agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file1mb files into each
CREATE_TIME:isize=256:fname=file1mb

real    0m10.781s
user    0m0.388s
sys     0m2.496s

Disk usage:
/dev/sdb1            5857212416   1025368 5856187048   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file1mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=256:fname=file1mb

real    1m4.766s
user    0m0.372s
sys     0m1.468s

READ2 (cp) each of the 100 file1mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=256:fname=file1mb

real    0m31.013s
user    0m0.376s
sys     0m1.520s
-------------------------------------------------------------
Run: isize=2048, fname=file1mb      (Tue Feb 12 10:33:43 CET 2008)
meta-data=/dev/sdb1              isize=2048   agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file1mb files into each
CREATE_TIME:isize=2048:fname=file1mb

real    0m5.601s
user    0m0.348s
sys     0m2.456s

Disk usage:
/dev/sdb1            5857212416   1027728 5856184688   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file1mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=2048:fname=file1mb

real    0m23.320s
user    0m0.344s
sys     0m1.564s

READ2 (cp) each of the 100 file1mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=2048:fname=file1mb

real    0m7.328s
user    0m0.296s
sys     0m1.448s
-------------------------------------------------------------
Run: isize=256, fname=file5mb      (Tue Feb 12 10:34:22 CET 2008)
meta-data=/dev/sdb1              isize=256    agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file5mb files into each
CREATE_TIME:isize=256:fname=file5mb

real    1m9.771s
user    0m0.672s
sys     0m10.789s

Disk usage:
/dev/sdb1            5857212416   5121368 5852091048   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file5mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=256:fname=file5mb

real    1m23.792s
user    0m0.552s
sys     0m4.140s

READ2 (cp) each of the 100 file5mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=256:fname=file5mb

real    0m59.086s
user    0m0.468s
sys     0m3.936s
-------------------------------------------------------------
Run: isize=2048, fname=file5mb      (Tue Feb 12 10:37:59 CET 2008)
meta-data=/dev/sdb1              isize=2048   agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file5mb files into each
CREATE_TIME:isize=2048:fname=file5mb

real    0m46.441s
user    0m0.688s
sys     0m9.833s

Disk usage:
/dev/sdb1            5857212416   5123728 5852088688   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file5mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=2048:fname=file5mb

real    0m57.450s
user    0m0.552s
sys     0m3.996s

READ2 (cp) each of the 100 file5mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=2048:fname=file5mb

real    0m21.544s
user    0m0.552s
sys     0m3.784s
-------------------------------------------------------------
Run: isize=256, fname=file10mb      (Tue Feb 12 10:40:12 CET 2008)
meta-data=/dev/sdb1              isize=256    agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file10mb files into each
CREATE_TIME:isize=256:fname=file10mb

real    2m12.143s
user    0m0.872s
sys     0m20.629s

Disk usage:
/dev/sdb1            5857212416  10241368 5846971048   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file10mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=256:fname=file10mb

real    1m42.586s
user    0m0.764s
sys     0m7.272s

READ2 (cp) each of the 100 file10mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=256:fname=file10mb

real    1m18.158s
user    0m0.752s
sys     0m7.036s
-------------------------------------------------------------
Run: isize=2048, fname=file10mb      (Tue Feb 12 10:45:29 CET 2008)
meta-data=/dev/sdb1              isize=2048   agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file10mb files into each
CREATE_TIME:isize=2048:fname=file10mb

real    1m20.204s
user    0m0.960s
sys     0m19.189s

Disk usage:
/dev/sdb1            5857212416  10243728 5846968688   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file10mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=2048:fname=file10mb

real    1m14.005s
user    0m0.768s
sys     0m7.148s

READ2 (cp) each of the 100 file10mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=2048:fname=file10mb

real    0m39.243s
user    0m0.724s
sys     0m7.136s
-------------------------------------------------------------
Run: isize=256, fname=file20mb      (Tue Feb 12 10:48:47 CET 2008)
meta-data=/dev/sdb1              isize=256    agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file20mb files into each
CREATE_TIME:isize=256:fname=file20mb

real    3m59.955s
user    0m1.376s
sys     0m39.874s

Disk usage:
/dev/sdb1            5857212416  20481368 5836731048   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file20mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=256:fname=file20mb

real    2m13.475s
user    0m1.036s
sys     0m13.849s

READ2 (cp) each of the 100 file20mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=256:fname=file20mb

real    1m51.332s
user    0m0.972s
sys     0m13.313s
-------------------------------------------------------------
Run: isize=2048, fname=file20mb      (Tue Feb 12 10:56:56 CET 2008)
meta-data=/dev/sdb1              isize=2048   agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file20mb files into each
CREATE_TIME:isize=2048:fname=file20mb

real    2m18.546s
user    0m1.256s
sys     0m39.622s

Disk usage:
/dev/sdb1            5857212416  20483728 5836728688   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file20mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=2048:fname=file20mb

real    1m53.727s
user    0m1.156s
sys     0m13.789s

READ2 (cp) each of the 100 file20mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=2048:fname=file20mb

real    1m14.573s
user    0m1.016s
sys     0m13.229s
-------------------------------------------------------------
Run: isize=256, fname=file30mb      (Tue Feb 12 11:02:28 CET 2008)
meta-data=/dev/sdb1              isize=256    agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file30mb files into each
CREATE_TIME:isize=256:fname=file30mb

real    5m40.613s
user    0m1.840s
sys     0m58.684s

Disk usage:
/dev/sdb1            5857212416  30721368 5826491048   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file30mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=256:fname=file30mb

real    2m53.505s
user    0m1.340s
sys     0m20.013s

READ2 (cp) each of the 100 file30mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=256:fname=file30mb

real    2m25.312s
user    0m1.408s
sys     0m20.073s
-------------------------------------------------------------
Run: isize=2048, fname=file30mb      (Tue Feb 12 11:13:36 CET 2008)
meta-data=/dev/sdb1              isize=2048   agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file30mb files into each
CREATE_TIME:isize=2048:fname=file30mb

real    3m8.358s
user    0m1.684s
sys     0m58.192s

Disk usage:
/dev/sdb1            5857212416  30723728 5826488688   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file30mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=2048:fname=file30mb

real    2m26.111s
user    0m1.344s
sys     0m19.993s

READ2 (cp) each of the 100 file30mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=2048:fname=file30mb

real    1m50.197s
user    0m1.340s
sys     0m19.809s
-------------------------------------------------------------
Run: isize=256, fname=file40mb      (Tue Feb 12 11:21:07 CET 2008)
meta-data=/dev/sdb1              isize=256    agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file40mb files into each
CREATE_TIME:isize=256:fname=file40mb

real    7m16.146s
user    0m2.020s
sys     1m18.325s

Disk usage:
/dev/sdb1            5857212416  40961368 5816251048   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file40mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=256:fname=file40mb

real    3m27.172s
user    0m1.744s
sys     0m25.962s

READ2 (cp) each of the 100 file40mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=256:fname=file40mb

real    3m0.558s
user    0m1.452s
sys     0m25.946s
-------------------------------------------------------------
Run: isize=2048, fname=file40mb      (Tue Feb 12 11:35:00 CET 2008)
meta-data=/dev/sdb1              isize=2048   agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file40mb files into each
CREATE_TIME:isize=2048:fname=file40mb

real    4m7.343s
user    0m2.144s
sys     1m17.077s

Disk usage:
/dev/sdb1            5857212416  40963728 5816248688   1% /content/backup01

Extents:
   1000 core.nextents = 1

READ1 (cp) each of the 100 file40mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=2048:fname=file40mb

real    3m2.579s
user    0m1.748s
sys     0m26.298s

READ2 (cp) each of the 100 file40mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=2048:fname=file40mb

real    2m24.960s
user    0m1.444s
sys     0m26.126s
-------------------------------------------------------------
Run: isize=256, fname=file50mb      (Tue Feb 12 11:44:41 CET 2008)
meta-data=/dev/sdb1              isize=256    agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file50mb files into each
CREATE_TIME:isize=256:fname=file50mb

real    9m3.861s
user    0m2.512s
sys     1m36.162s

Disk usage:
/dev/sdb1            5857212416  51201368 5806011048   1% /content/backup01

Extents:
    997 core.nextents = 1
      3 core.nextents = 2

READ1 (cp) each of the 100 file50mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=256:fname=file50mb

real    4m2.087s
user    0m2.036s
sys     0m32.382s

READ2 (cp) each of the 100 file50mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=256:fname=file50mb

real    3m36.145s
user    0m2.044s
sys     0m32.598s
-------------------------------------------------------------
Run: isize=2048, fname=file50mb      (Tue Feb 12 12:01:28 CET 2008)
meta-data=/dev/sdb1              isize=2048   agcount=32, agsize=45760496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1464335872, imaxpct=25
         =                       sunit=16     swidth=96 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
Mount options used:
/dev/sdb1 on /content/backup01 type xfs
(rw,noatime,nobarrier,logbufs=8,logbsize=256k)
Creating 10 directories and cp 100 file50mb files into each
CREATE_TIME:isize=2048:fname=file50mb

real    4m59.963s
user    0m2.676s
sys     1m34.186s

Disk usage:
/dev/sdb1            5857212416  51203728 5806008688   1% /content/backup01

Extents:
    996 core.nextents = 1
      4 core.nextents = 2

READ1 (cp) each of the 100 file50mb files
      in each of the 10 directories
NOTE: we read (cp) the first file from each directory,
      then the second file from each directory, and so on
READ1_TIME:isize=2048:fname=file50mb

real    3m35.429s
user    0m1.776s
sys     0m32.742s

READ2 (cp) each of the 100 file50mb files
      in each of the 10 directories
NOTE: we read all files in the first directory,
      then the all the files in the second, and so on
READ2_TIME:isize=2048:fname=file50mb

real    3m1.140s
user    0m2.116s
sys     0m32.810s
-------------------------------------------------------------
Done Tue Feb 12 12:13:11 CET 2008
