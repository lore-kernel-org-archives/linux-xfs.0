Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9BMY56G022284 for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 17:34:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCC49DC09A
	for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 15:35:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	DqBEJBujFeTgnqnh for <xfs@oss.sgi.com>;
	Mon, 11 Oct 2010 15:35:11 -0700 (PDT)
Date: Tue, 12 Oct 2010 09:35:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENOSPC at 90% with plenty of inodes
Message-ID: <20101011223507.GB32255@dastard>
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
	<20101008225146.GJ4681@dastard>
	<AANLkTikLyEuSoFRVwirKLws97Vemz4ScNHOqu2Jc5sWR@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikLyEuSoFRVwirKLws97Vemz4ScNHOqu2Jc5sWR@mail.gmail.com>
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
To: James Braid <jamesb@loreland.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 11, 2010 at 03:03:28PM +0100, James Braid wrote:
> On Fri, Oct 8, 2010 at 23:51, Dave Chinner <david@fromorbit.com> wrote:
> > Sounds like fragmented free space. What is the output of:
> >
> > # xfs_db -r -c "freesp -s" <device>
> 
> # xfs_db -r -c "freesp -s" /dev/sdb
>    from      to extents  blocks    pct
>       1       1 2298052 2298052  40.52
>       2       3 1568338 3337017  58.84
>       4       7    8432   35716   0.63
>       8      15      50     423   0.01
> total free extents 3874872
> total free blocks 5671208
> average free extent size 1.46359
> 
> Which seems to say there are a few tiny pieces of free space
> available? The files that were failing to be written were a few
> hundred bytes in size.

The error has nothing to do with the size of the files, but
everything to do with being able to allocate more inodes. Inode
allocation requires 4 contiguous blocks (for 256 byte inodes, more
for larger inodes) with alignment constraints. That means when you
run out of 8 block or larger free extents, inode allocation will
start failing and you'll get ENOSPC being reported.

> We haven't seen any errors so far today, but xfs_fsr ran over the
> weekend, so perhaps I guess it's reorganized the filesystem.

Only a little. xfs_fsr will not improve fragmented free space
conditions (indeed, it normally fragments free space more). The only
way to reduce the fragmentation of free space is to remove a
significant amount of data and inodes from the filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
