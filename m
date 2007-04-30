Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Apr 2007 16:28:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3UNS2fB028014
	for <xfs@oss.sgi.com>; Mon, 30 Apr 2007 16:28:04 -0700
Date: Tue, 1 May 2007 09:27:55 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Slow performance when extracting tarballs
Message-ID: <20070430232755.GT32602149@melbourne.sgi.com>
References: <4635DAA4.4070402@griffith.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4635DAA4.4070402@griffith.edu.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen So <s.so@griffith.edu.au>
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2007 at 10:01:40PM +1000, Stephen So wrote:
> Hi everyone,
> 
> Just a question about XFS when extracting bzipped tarballs containing
> lots of little files (e.g. the linux kernel source).  I've noticed on my
> new laptop (Intel Core 2 Duo @ 2.16 GHz), which has FC6 i386, which has
> XFS partitions that when I extract these types of tarballs, my system
> becomes rather non responsive, my mp3 player starts skipping etc.  After
> looking at top during the extraction process, bzip2 uses about 80-90% of
> CPU initially and extraction seems quite fast but after a few seconds,
> it drops to 30-40%, the system becomes non responsive, and extraction is
> much slower. 

The log probably fills up and then it falls back to the speed that
your disk can write back all the metadata.

> I created a new partition of ext3 and reiserfs, did the same tarball
> extraction, and on both filesystems, bzip2 uses at least 90%, extraction
> is fast the whole way through, and the system is quite responsive.
> 
> I created my XFS partition using the following command (I made a larger
> log file size since I heard that improve delete performance a bit):
> 
> mkfs.xfs  -l size=64m /dev/sda10
> 
> Then to mount this partition, I have these switches in my /etc/fstab file
> 
> noatime, nodiratime, logbufs=8

If you don't care about the filesystem always being able to recover
correctly when power fails (i.e. can lead to filesystem coruption
on power failure) you can also use the "nobarrier" option which
can significant;y speed up metadata perfromance on XFS.

> I'm using kernel 2.6.20 that came from the FC6 updates repositories.  So
> is there something wrong with my XFS setup?  Is my log file too small? 
> Or is this "normal" behaviour of XFS (i.e. that it excels best when
> working with very large files but not lots of little files)?

XFS excels at large files and/or lots and lots of files. On small files it
performs adequately but is not the fastest filesystem around.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
