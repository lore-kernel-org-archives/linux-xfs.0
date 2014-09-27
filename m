Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4448E7F9A
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 09:39:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 315E9304039
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 07:39:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id drD2J6Aom4VO7tA0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 27 Sep 2014 07:39:02 -0700 (PDT)
Date: Sat, 27 Sep 2014 10:38:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: blktrace and xfs_db block offset mismatch
Message-ID: <20140927143859.GA60739@bfoster.bfoster>
References: <CAOj3taPoXpVktWJxmYKLZrvfe7T1qYArLsoQ39gsMdj_T1hNYg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOj3taPoXpVktWJxmYKLZrvfe7T1qYArLsoQ39gsMdj_T1hNYg@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sushma R <gsushma@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 27, 2014 at 12:32:21AM -0700, Sushma R wrote:
> Hi,
> 
> I ran blktrace while reading a file on XFS partition and here's it's output.
> 
> 8,17   3        1    22.065944956  5489  D   R 20973896 + 8 [cat]
> 
> Using xfs_db, I dumped the inode for the same file and it shows the
> following as its data extents.
> 
> u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,2621481,1,0]
> 
> I understand that blktrace reports in 512-byte sectors while xfs_db in
> filesystem block size (which is the default 4KB on my setup).
> Converting blktrace offset to fs block = 2621737 which is close to the data
> extent startblock (2621481), but still off by 256 fs blocks.
> 
> Could someone please help understand the reason for this mismatch?
> 

I believe you are comparing a raw read of a device to an internal XFS
fsb, the latter of which is encoded to account for the internal
structure of XFS (e.g., allocation groups). You might want to take a
look at xfs_bmap on the file to see the actual disk blocks.

The fsb to daddr conversion depends on the geometry of the fs, but you
can get the various values with xfs_db as well. E.g.:

convert fsb 2621481 agno	# ag number
convert fsb 2621481 agbno	# relative ag block nr
convert fsb 2621481 daddr	# disk address

Also, I'm not familiar enough with blktrace output off the top of my
head so perhaps not an issue, but it's not clear to me whether the
output above could have been converted/adjusted to a raw address based
on a device partition.

You might also want to verify you're looking at the actual file read vs.
a directory/inode lookup or block mapping lookup or something else. I
see you're running cat, a direct I/O read via dd might ensure you aren't
just pulling file data from cache.

Brian

> Thanks,
> Sushma

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
