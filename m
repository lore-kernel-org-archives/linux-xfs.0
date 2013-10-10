Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E41207F5D
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 01:56:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC0BC304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 23:56:42 -0700 (PDT)
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id nraptwEFnyIZybK7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 23:56:41 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id up15so2099218pbc.12
	for <xfs@oss.sgi.com>; Wed, 09 Oct 2013 23:56:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131009224658.GO4446@dastard>
References: <1381090366-2727-1-git-send-email-linkinjeon@gmail.com>
	<20131009224658.GO4446@dastard>
Date: Thu, 10 Oct 2013 15:56:40 +0900
Message-ID: <CAKYAXd-8pgJomfEjxpj8VK9WfMqYyWa6LvefvnnZC-Zye_xGBA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/7] fs: add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

Hi Dave.

> >
> > +     /*
> > +      * Collapse range works only on fs block size aligned offsets.
> > +      * Check if collapse range is contained within (aligned)i_size.
> > +      * Collapse range can only be used exclusively.
> > +      */
> > +     if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> > +         (offset & blksize_mask || len & blksize_mask ||
> > +          mode & ~FALLOC_FL_COLLAPSE_RANGE ||
> > +          (offset + len >
> > +           round_up(i_size_read(inode), (blksize_mask + 1)))))
> > +             return -EINVAL;
>
> There's lots of individual checks here. Let's separate them out
> logically. Firstly, "Collapse range can only be used exclusively" is
> a mode parameter check, and so should be done directly after
> validating the mode only contains known commands. i.e. in the first
> hunk above.
>
> Secondly, "Collapse range works only on fs block size aligned
> offsets" is an implementation constraint, not an API constraint.
> i.e. There is no reason why a filesystem can't implement byte range
> granularity for this operation, it just may not be efficient for all
> fielsystems and so they don't choose to implement byte range
> granularity. Further, filesystems might have different allocation
> constraints than the filesystem block size (think bigalloc on ext4,
> per-file extent size hints for XFS), and these generally aren't
> reflected in inode->i_blkbits. In these cases, the granularity of
> the collapse operation can only be determined by the filesystem
> itself, not this high level code.
>
> Hence I think the granularity check should be put into a helper
> function that the filesystem's ->fallocate() method calls if it can
> only support fs block aligned operations. That allows each
> filesystem to determine it's own constraints on a per-operation
> basis.
>
> All that remains here is the "within file size"
> check, and that doesn't need to be rounded up to block size to check
> if it is valid. If the range given overlaps the end of file in any
> way, then it is a truncate operation....

Okay, I will update your points on next version patch.
>
>
> > diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> > index 990c4cc..9614b72 100644
> > --- a/include/uapi/linux/falloc.h
> > +++ b/include/uapi/linux/falloc.h
> > @@ -4,6 +4,23 @@
> >  #define FALLOC_FL_KEEP_SIZE  0x01 /* default is extend size */
> >  #define FALLOC_FL_PUNCH_HOLE 0x02 /* de-allocates range */
> >  #define FALLOC_FL_NO_HIDE_STALE      0x04 /* reserved codepoint */
> > +/*
> > + * FALLOC_FL_COLLAPSE_RANGE:
> > + * This flag works in 2 steps.
> > + * Firstly, it deallocates any data blocks present between [offset,
> > offset+len)
> > + * This step is same as punch hole and leaves a hole in the place from
> > where
> > + * the blocks are removed.
> > + * Next, it eliminates the hole created by moving data blocks into it.
> > + * For extent based file systems, we achieve this functionality simply
> > by
> > + * updating the starting logical offset of each extent which appears
> > beyond
> > + * the hole. As this flag works on blocks of filesystem, the offset and
> > len
> > + * provided to fallocate should be aligned with block size of
> > filesystem.
>
> Hmmm - you're describing an implementation, not the API. i.e. what
> you need to describe is the functionality users are provided with by
> the flag and it's usage constraints, not how filesystems need to
> implement it. Something like:
Okay, I will reference your shared description.

>
> "FALLOC_FL_COLLAPSE_RANGE is used to remove a range of a file
> without leaving a hole in the file. The contents of the file beyond
> the range being removed is appended to the start offset of the range
> being removed (i.e. the hole that was punched is "collapsed"),
> resulting in a file layout that looks like the range that was
> removed never existed. As suchm collapsing a range of a file changes
> the size of the file, reducing it by the same length of the range
> that has been removed by the operation.
>
> Different filesystems may implement different limitations on the
> granularity of the operation. Most will limit operations to
> filesystem block size boundaries, but this boundary may be larger or
> smaller depending on the filesystem and/or the configuration of the
> filesystem or file.
>
> Attempting to collapse a range that crosses the end of the file is
> considered an illegal operation - just use ftruncate(2) if you need
> to collapse a range that crosses EOF."
>
> > +#define FALLOC_FL_COLLAPSE_RANGE     0x08 /* it does not leave a hole
> > */
>
> With the large descriptive comment, there is no need for the
> appended "/* it does not leave a hole */" comment.
Okay. will remove.

Thanks for review.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
