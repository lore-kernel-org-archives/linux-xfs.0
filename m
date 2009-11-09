Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA99pHP3179823 for <xfs@oss.sgi.com>; Mon, 9 Nov 2009 03:51:17 -0600
Received: from mail.in-medias-res.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F06CCE6610
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2009 01:51:33 -0800 (PST)
Received: from mail.in-medias-res.com (mail.in-medias-res.com [78.47.10.114])
	by cuda.sgi.com with ESMTP id aJ4n27MDmRDgt6m6 for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2009 01:51:33 -0800 (PST)
Date: Mon, 9 Nov 2009 10:51:26 +0100
From: mill / in-medias-res <mill@in-medias-res.com>
Subject: Re: xfs_repair breaks; xfs_metadump hangs
Message-ID: <20091109095126.GA9727@mytux.intra.in-medias-res.com>
References: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
	<4AF4A66B.8090906@digitalelves.com>
	<20091109091915.GB3601@mytux.intra.in-medias-res.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091109091915.GB3601@mytux.intra.in-medias-res.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

* mill / in-medias-res <mill@in-medias-res.com> [091109 10:28]:
> 
> > Hmm interesting.
> > Can you go into xfs_db and print out the bad inode? send it to us?
> > I'm guessing the extents are corrupted somehow.
> 
> Did you mean "xfs_db -x -c 'blockget inode 3256930831' /dev/sdc2" ?
> xfs_db consumes 99% of CPU and Virt 2510m RES 194m of RAM.
> 
> How long should i wait?
> 
Done now:
xfs_db -x -c 'blockget inode 3256930831' /dev/sdc2 > xfs_db.log            :(
exit code 3
338,12s user 12,32s system 49% cpu 11:48,39 total
The first lines of output:
bad number of extents 1 for inode 3256930831
bad nblocks 1 for inode 3256930831, counted 0
block 9/2317591 type unknown not expected
link count mismatch for inode 1038934 (name ?), nlink 1, counted 2
link count mismatch for inode 128 (name ?), nlink 4672, counted 6
link count mismatch for inode 129 (name ?), nlink 36525, counted 1
link count mismatch for inode 130 (name ?), nlink 0, counted 1
link count mismatch for inode 131 (name ?), nlink 0, counted 1
link count mismatch for inode 132 (name ?), nlink 2, counted 1305238
link count mismatch for inode 133 (name ?), nlink 0, counted 2
link count mismatch for inode 134 (name ?), nlink 7144, counted 1
link count mismatch for inode 135 (name ?), nlink 42666, counted 1
link count mismatch for inode 136 (name ?), nlink 40424, counted 2
link count mismatch for inode 137 (name ?), nlink 37040, counted 2
link count mismatch for inode 138 (name ?), nlink 16, counted 2
link count mismatch for inode 139 (name ?), nlink 0, counted 2
link count mismatch for inode 140 (name ?), nlink 20, counted 2
link count mismatch for inode 141 (name ?), nlink 0, counted 2
link count mismatch for inode 142 (name ?), nlink 12, counted 2
link count mismatch for inode 143 (name ?), nlink 62336, counted 2
link count mismatch for inode 144 (name ?), nlink 3203, counted 2
link count mismatch for inode 146 (name ?), nlink 27224, counted 2
link count mismatch for inode 147 (name ?), nlink 41204, counted 2
link count mismatch for inode 148 (name ?), nlink 21, counted 2
link count mismatch for inode 149 (name ?), nlink 0, counted 2
link count mismatch for inode 150 (name ?), nlink 0, counted 2
link count mismatch for inode 151 (name ?), nlink 0, counted 2
link count mismatch for inode 152 (name ?), nlink 0, counted 2
link count mismatch for inode 153 (name ?), nlink 32768, counted 2
link count mismatch for inode 154 (name ?), nlink 58352, counted 2
link count mismatch for inode 155 (name ?), nlink 40290, counted 2
The output is 53 MB big. Tons of link count mismatch for inode ...


> 
> > One option to then flag the inode as deleted which will cause repair to
> > toss is hopefully clean up the mess.
> >
> > Here is a write up how to do that.
> > http://jijo.free.net.ph/19
> If i can't get that block i will try with deleting it, Thanks!
> 
> Best regards,
> Maximilian Mill
> >> time: 67,27s user 10,09s system 10% cpu 12:05,31 total
> >>
> >> I tried to run xfs_metadump serveral times and it hangs everytime on this position:
> >> xfs_metadump  -g /dev/sdc2 metadump-sdc2-2
> >> Copied 1411840 of 4835520 inodes (0 of 3 AGs)
> >>
> >> It runs till 2 days on the same inode and xfs_db consumes 99% of CPU.
> >> Should i wait here?
> >>
> >> Versions:
> >> dpkg -l |grep xfs
> >> ii  xfsdump   3.0.2~bpo50+1       Administrative utilities for the XFS filesys
> >> ii  xfsprogs  3.0.4~bpo50+1       Utilities for managing the XFS filesystem
> >> Distribution: Debian lenny with xfsprogs, xfsdump backport from unstable.
> >>
> >> The xfs_repair with stock Debian Lenny version also does crash at inode 3256930831.
> >>
> >> Best Regards,
> >> Maximilian Mill
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> >>
> >>   
> >
> >
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
