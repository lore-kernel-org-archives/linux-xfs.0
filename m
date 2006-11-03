Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Nov 2006 01:33:03 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA39WraG017853
	for <xfs@oss.sgi.com>; Fri, 3 Nov 2006 01:32:59 -0800
Received: from rrzmta2.rz.uni-regensburg.de (rrzmta2.rz.uni-regensburg.de [132.199.1.17])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15071D1B8CD7
	for <xfs@oss.sgi.com>; Fri,  3 Nov 2006 01:32:06 -0800 (PST)
Date: Fri, 3 Nov 2006 10:32:03 +0100
From: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Subject: Re: mount failed after xfs_growfs beyond 16 TB
Message-ID: <20061103093203.GA18010@pc51072.physik.uni-regensburg.de>
Reply-To: christian.guggenberger@physik.uni-regensburg.de
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <454A3B28.7010405@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <454A3B28.7010405@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, dgc@sgi.com
Cc: christian.guggenberger@physik.uni-regensburg.de, xfs@oss.sgi.com

Eric, Dave,

> 
> xfs_db> sb 0
> xfs_db> p
> 
> let's see what you've got.
> 

xfs_db: read failed: Invalid argument
xfs_db: data size check failed
xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 18446744070056148512
rblocks = 0
rextents = 0
uuid = 27d35a50-724e-440b-ae1a-79f934f7915a
logstart = 2147483652
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 84976608
agcount = 570
rbmblocks = 0
logblocks = 32768
versionnum = 0x30c4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 27
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 1298880
ifree = 376826
fdblocks = 18446744067363131928
frextents = 0
uquotino = 131
gquotino = null
qflags = 0x7
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0
xfs_db> 

> Also how big does /proc/partitions think your new device is?
> 
it thinks it's 26983133184 blocks, which seems to be correct:

  --- Logical volume ---
    LV Name                /dev/data/project
    VG Name                data
    LV UUID                4RIXaW-QxWj-KOr5-CysS-TmLF-Jebu-lPyPOU
    LV Write Access        read/write
    LV Status              available
    # open                 1
    LV Size                25.13 TB
    Current LE             6587679
    Segments               4
    Allocation             inherit
    Read ahead sectors     0
    Block device           254:1

note, the fs was first grown with (originally mounted on /data/projects)

xfs_growfs -D 4294966000 /data/projects
which succeeded.

a further

xfs_growfs -D 4300000000 /data/projects

shut the fs down.

> > found candidate secondary superblock...
> > superblock read failed, offset 10093861404672, size 2048, ag 0, rval 29
> 
> hmm that offset is about 9.4 terabytes.
> 
> any kernel messages when this happens?
> 
> rval 29 is ESPIPE / illegal seek.

not that I know of, unfortunately.

As Dave already stated that > 16TB is not supported on 32bits - is there
any way to step back ? 

cheers.
 - Christian
 
