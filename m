Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Nov 2006 07:45:46 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA3FjaaG001958
	for <xfs@oss.sgi.com>; Fri, 3 Nov 2006 07:45:40 -0800
Received: from rrzmta2.rz.uni-regensburg.de (rrzmta2.rz.uni-regensburg.de [132.199.1.17])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 835F34ED2C1
	for <xfs@oss.sgi.com>; Fri,  3 Nov 2006 07:44:50 -0800 (PST)
Date: Fri, 3 Nov 2006 16:44:48 +0100
From: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Subject: Re: mount failed after xfs_growfs beyond 16 TB
Message-ID: <20061103154448.GA26647@pc51072.physik.uni-regensburg.de>
Reply-To: christian.guggenberger@physik.uni-regensburg.de
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <454A3B28.7010405@sandeen.net> <20061103093203.GA18010@pc51072.physik.uni-regensburg.de> <20061103123418.GP8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061103123418.GP8394166@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> 
> xfs_db mojo.... ;)
> 
> Note - no guarantee this will work - practise on an expendable
> sparse loopback filessytem image by making a filesystem of slightly less
> than 16TB then growing it to corrupt it the same way and then fixing it up
> successfully.
> 
> Once it's corrupted, unmount and run xfs_db in expert mode.
> The superblock:
> 
> blocksize = 4096
> dblocks = 18446744070056148512
> ...
> agblocks = 84976608
> agcount = 570
> 
> An AG is ~43.5GB, so 570 AGs is 24.8TB. It's to big, and
> we will only shrink by whole AGs. Hence we have to correct
> agcount and dblocks.

isn't the AG size 'agblocks * blocksize' == ~324 GB here ?

got further input on a secondray superblock form the colleague:
looks more reasonable, I'd say. Is there a way to manually recover sb0
from sb1 ?

(btw, I still hope they get access to an 64bit system with recent
xfsprogs and kernel, soon)

xfs_db: read failed: Invalid argument
xfs_db: data size check failed
xfs_db> sb 1
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 4294966000
rblocks = 0
rextents = 0
uuid = 27d35a50-724e-440b-ae1a-79f934f7915a
logstart = 2147483652
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 84976608
agcount = 51
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
ifree = 376828
fdblocks = 1601952378
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

cheers.
 - Christian
 
