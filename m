Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEE5C7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:33:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFB9F8F8039
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:33:24 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sZmxuMXSsny78Qvy for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 10:33:21 -0800 (PST)
Subject: Re: XFS fiemap issue with Linux 3.10.0-327.el7.x86_64 (CentOS 7)
References: <CAJkH1p6LU=d5oLh3A+j_GQ70uoCYMjR=a5yS1w8p5d5ZXz6fwg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C219F0.3050002@sandeen.net>
Date: Mon, 15 Feb 2016 12:33:20 -0600
MIME-Version: 1.0
In-Reply-To: <CAJkH1p6LU=d5oLh3A+j_GQ70uoCYMjR=a5yS1w8p5d5ZXz6fwg@mail.gmail.com>
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
To: xfs@oss.sgi.com, Jim Wilcoxson <prirun@gmail.com>

On 2/15/16 11:26 AM, Jim Wilcoxson wrote:
> I'm developing a backup program, HashBackup, and recently added sparse
> "hole skipping" using fiemap.  

That is probably not safe.  Mapping can change immediately after fiemap
returns, and you could miss data.  cp went down that path a few years ago,
and it caused pain.

SEEK_HOLE/SEEK_DATA would be a better choice.

> Today I ran into a weird issue with xfs
> on Linux 3.10.
> 
> A test program creates a sparse file with 10000*(4K data, 4M hole).
> HB calls fiemap with start=0, length=0xFFFF...FFFF, mapped_extents=0
> to get the number of extents.    Fiemap is coming back with
> mapped_extents=1364 instead of 10000.

Take a look at xfs_bmap -v output to get a clear picture of what
is actually on disk.  It's possible that some combination of
speculative preallocation or other things has merged extents.

In general, the kernel has plenty of leeway in terms of how it
chooses to lay out a file.  "seek/write" doesn't necessarily
guarantee a hole.

> The fiemap.txt file says:
> 
> "If fm_extent_count is zero, then the fm_extents[] array is ignored
> (no extents will be returned), and the fm_mapped_extents count will
> hold the number of extents needed in fm_extents[] to hold the file's
> current mapping."
> 
> It doesn't say the filesystem can choose to return fewer extents if it
> wants, but maybe xfs interprets it this way and fiemap has to be
> called in a loop until the extent_last flag is set.  If that's the
> case, fiemap.txt should be updated.

It's not clear that it is returning fewer extents.  See what xfs_bmap
says, and compare.

But also, don't use fiemap results for anything that requires
data integrity...

-Eric

> Thanks,
> Jim
> (not on the xfs mailing list)
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
