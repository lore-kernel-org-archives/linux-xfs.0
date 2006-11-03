Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Nov 2006 04:35:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA3CZJaG012067
	for <xfs@oss.sgi.com>; Fri, 3 Nov 2006 04:35:24 -0800
Date: Fri, 3 Nov 2006 23:34:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mount failed after xfs_growfs beyond 16 TB
Message-ID: <20061103123418.GP8394166@melbourne.sgi.com>
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <454A3B28.7010405@sandeen.net> <20061103093203.GA18010@pc51072.physik.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061103093203.GA18010@pc51072.physik.uni-regensburg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, dgc@sgi.com, xfs@oss.sgi.com

On Fri, Nov 03, 2006 at 10:32:03AM +0100, Christian Guggenberger wrote:
> Eric, Dave,
> 
> > 
> > xfs_db> sb 0
> > xfs_db> p
> > 
> > let's see what you've got.
> > 
> 
> xfs_db: read failed: Invalid argument
> xfs_db: data size check failed
> xfs_db> sb 0
> xfs_db> p
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 18446744070056148512

That looks like an overflow to me ;)

> fdblocks = 18446744067363131928

Free space gone kaboom too...

> frextents = 0
> uquotino = 131
> gquotino = null
> qflags = 0x7
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 0
> features2 = 0
> xfs_db> 
> 
> > Also how big does /proc/partitions think your new device is?
> > 
> it thinks it's 26983133184 blocks, which seems to be correct:
> 
>   --- Logical volume ---
>     LV Name                /dev/data/project
>     VG Name                data
>     LV UUID                4RIXaW-QxWj-KOr5-CysS-TmLF-Jebu-lPyPOU
>     LV Write Access        read/write
>     LV Status              available
>     # open                 1
>     LV Size                25.13 TB
>     Current LE             6587679
>     Segments               4
>     Allocation             inherit
>     Read ahead sectors     0
>     Block device           254:1
> 
> note, the fs was first grown with (originally mounted on /data/projects)
> 
> xfs_growfs -D 4294966000 /data/projects
> which succeeded.

Which is just less than 16TB: 0x1ffeffaf0000

> a further
> 
> xfs_growfs -D 4300000000 /data/projects

Which is just more than 16TB: 0x2008ccb00000

> shut the fs down.

Probably corrupted metadata in the first couple of AGs...

> > > found candidate secondary superblock...
> > > superblock read failed, offset 10093861404672, size 2048, ag 0, rval 29
> > 
> > hmm that offset is about 9.4 terabytes.

With a size of 25.13TiB in the LVM, 9.4TB is ~(25.13 - 16)TiB

That's a 32 bit overflow as well...

> As Dave already stated that > 16TB is not supported on 32bits - is there
> any way to step back ? 

xfs_db mojo.... ;)

Note - no guarantee this will work - practise on an expendable
sparse loopback filessytem image by making a filesystem of slightly less
than 16TB then growing it to corrupt it the same way and then fixing it up
successfully.

Once it's corrupted, unmount and run xfs_db in expert mode.
The superblock:

blocksize = 4096
dblocks = 18446744070056148512
...
agblocks = 84976608
agcount = 570

An AG is ~43.5GB, so 570 AGs is 24.8TB. It's to big, and
we will only shrink by whole AGs. Hence we have to correct
agcount and dblocks.

So, 404 AGs gives:

dblocks = agblocks * agcount
	= 84976608 * 404 * 512 bytes
	= 0xFFC853B0000 bytes, which is under 16TiB
	= 4291318704 blocks

Now you need to zero fdblocks, and now you should be able to run
xfs_repair to fix it up. Don't be surprised if repair runs out of
memory - you'll have to hope Barry gets finished with the memory
reduction work he's doing soon or get a 64 bit machine to fix that
problem. A 64bit machine wouldn't have the 16TB limit, either ;)

Good luck....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
