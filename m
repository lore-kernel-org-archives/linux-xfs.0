Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35752 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750806AbdJBXOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Oct 2017 19:14:23 -0400
Date: Tue, 3 Oct 2017 10:14:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
Message-ID: <20171002231420.GI3666@dastard>
References: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "R. Jason Adams" <rjasonadams@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 02, 2017 at 09:14:07AM -0400, R. Jason Adams wrote:
> Hello,
> 
> I have a use case where I'm writing ~500Kb (avg size) files to a
> 10TB XFS file systems. Each of system has 36 of these 10TB drives.
> 
> The application opens the file, writes the data (single call), and
> closes the file. In addition there are a few lines added to the
> extended attributes. The filesystem ends up with 18 to 20 million
> files when the drive is full. The files are currently spread over
> 128x128 directories using a hash of the filename.

Eric already mentioned it, but hashing directories in userspace is
only necessary to generate sufficient parallelism for the
application's file create/unlink needs.

You're using 10TB drives, so they'll have 10AGs, so each filesystem
can be running 10 concurrent file create/unlinks. Hence having
128x128 = 16384 directories and so ~1000 files per directory is
splitting things way to fine.

Read the "Directory block size" section here:

https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc

Summary:

.Recommended maximum number of directory entries for directory block
sizes
[header]
|=====
| Directory block size  | Max. entries (read-heavy)     | Max.  entries (write-heavy)
| 4 KB                  | 100000-200000                 | 1000000-2000000
| 16 KB                 | 100000-1000000                | 1000000-10000000
| 64 KB                 | >1000000                      | >10000000
|=====

With 4k directory block size and your write heavy workload, you
could get away with just 10 directories. However, it'd probably be
better to use a single level 100-directory wide hash to bring to
down to less than 200k files per directory....

> The format command I'm using:
> 
> mkfs.xfs -f -i size=1024 ${DRIVE}

Small files should be a single extent, so there's heaps of room for
a 200 byte xattr in the inode. using 512 byte inodes will half
memory demand for caching inode buffers....

> Mount options:
> 
> rw,noatime,attr2,inode64,allocsize=2048k,logbufs=8,logbsize=256k,noquota

You probably don't need the allocsize mount option. It turns off the
delalloc autosizing code and prevents tight packing of small
write-once files.

In general, use the defaults and don't add anything extra unless you
know it solves a specific problem you've witnessed in testing...

> As the drive is filling, the first few % of the drive seems fine.
> Using iostat the avgrq-sz is close to the average file size. What
> I'm noticing is as the drive starts to fill (say around 5-10%) the
> reads start increasing (r/s in iostat). In addition, the avgrq-sz
> starts to decrease. Pretty soon the r/s can be 1/3 to 1/2 as many
> as our w/s.

Most likely going to be metadata writeback of inode buffers
requiring RMW based on experience with gluster and ceph having
exactly the same problems.  Use blktrace to identify what the reads
are, and see if those same blocks are written later on. An io marked
a "M" is a metadata IO. Post the blktrace output of the bits you
find relevant.

FWIW, how much RAM do you have in the system, and what does 'echo
200 > /proc/sys/fs/xfs/xfssyncd_centisecs' do to the behaviour?

> At first we thought this was related to using extended
> attributes, but disabling that didn’t make a difference at
> all.
> 
> Considering I know the app isn’t making any read request,
> I’m guessing this is related to updating metadata etc.

Not necessarily. The page cache could be doing RMW cycles if the
write sizes are not page aligned...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
