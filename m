Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MK987X081699 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 15:09:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E7D31840A04
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:10:02 -0700 (PDT)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id cgnScvyTxywZO9oB for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:10:02 -0700 (PDT)
Message-ID: <4C9A6298.106@sandeen.net>
Date: Wed, 22 Sep 2010 15:10:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Contiguous file sequences
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
In-Reply-To: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
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
To: Daire Byrne <daire.byrne@gmail.com>
Cc: xfs@oss.sgi.com

Daire Byrne wrote:
> Hi,
> 
> I have been trying to figure out how to lay down a file sequence (e.g.
> images) such that they are guaranteed to always be contiguous on disk
> (i.e. no block gaps between them). 

There's no mechanism to guarantee that.

Why is this the goal, what are you trying to achieve?

> Currently if I write a sequence to
> disk things like "filestreams" help keep everything in the same AG and
> the allocation algorithm seems to prefer to try and place files next
> to eachother but without the filesystem knowing the total size of the
> sequence there are always likely to be gaps in the blocks where
> existing data has been written. 

preallocation of each image before writing would help make it more
likely that each image is itself contiguous (but again this is not
-guaranteed-)

> So even if the first file is written
> completely contiguously to disk there is no way to guarantee that
> there is contiguous free space after it to write the rest of the
> images.
> 
> What I really want is to be able to find and reserve enough space for
> the entire sequence and then write the files into that big contiguous
> range. I tried to do this with xfs_io hoping that the allocator would
> just know what I wanted and do the right thing (ever the optimist...).

:)

> So something like this:
> 
>   # find and reserve a big chunk to fit all my files in
>   xfs_io -f -c "resvsp 0 136314880" -c "bmap -v" $DIR/test.0
> 
>   # now shrink it keeping the start block
>   xfs_io -f -c "freesp 13631488 0" -c "bmap -v" $DIR/test.0
> 
>   # now write a bunch of files and hope they continue from test.0 on disk
>   dd if=/dev/zero of=$DIR/test.0 bs=1M count=13 conv=nocreat,notrunc
>   for  x in `seq 1 4`; do
>       dd if=/dev/zero of=$DIR/test.$x bs=1M count=13 conv=notrunc
>   done
> 
> But a new allocation is made for the first new file in the sequence
> elsewhere on disk and I don't know how to get it to use the large
> chunk of free contiguous space after the "test.0" file instead.

You can't specify a starting block for any given file I'm afraid.

> Another option might be to create a single contiguous large file,
> concatenate all the images into it and then split it up on disk using
> offsets but I don't think such a thing is even possible? I always know
> the image sequence size beforehand, all images are exactly the same
> size and I can control/freeze the filesystem access if needed.
> 
> Anybody got any suggestions? It *seems* like something that should be
> possible and would be useful.

This would be pretty low-level control of the allocator by userspace.

I'll just go back and ask what problem you're trying to solve?  There
may be a better (i.e. currently existing) solution.

-Eric

> Daire
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
