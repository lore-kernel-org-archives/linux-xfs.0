Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9743F7F37
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 23:26:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BF62304084
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:26:34 -0800 (PST)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id j5Xa7tM54VwGlqlM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:26:33 -0800 (PST)
Received: by mail-pa0-f46.google.com with SMTP id rd3so477161pab.5
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:26:32 -0800 (PST)
Date: Tue, 25 Feb 2014 21:25:40 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v5 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
In-Reply-To: <20140226015747.GN13647@dastard>
Message-ID: <alpine.LSU.2.11.1402252049250.1586@eggly.anvils>
References: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
	<20140222140625.GD26637@thunk.org> <20140223213606.GE4317@dastard>
	<alpine.LSU.2.11.1402251525370.2380@eggly.anvils>
	<20140226015747.GN13647@dastard>
MIME-Version: 1.0
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
Cc: Namjae Jeon <linkinjeon@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <namjae.jeon@samsung.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, Ashish Sangwan <a.sangwan@samsung.com>, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Wed, 26 Feb 2014, Dave Chinner wrote:
> On Tue, Feb 25, 2014 at 03:41:20PM -0800, Hugh Dickins wrote:
> > On Mon, 24 Feb 2014, Dave Chinner wrote:
> > > On Sat, Feb 22, 2014 at 09:06:25AM -0500, Theodore Ts'o wrote:
> > > > On Wed, Feb 19, 2014 at 01:37:43AM +0900, Namjae Jeon wrote:
> > > > > +	/*
> > > > > +	 * There is no need to overlap collapse range with EOF, in which case
> > > > > +	 * it is effectively a truncate operation
> > > > > +	 */
> > > > > +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> > > > > +	    (offset + len >= i_size_read(inode)))
> > > > > +		return -EINVAL;
> > > > > +
> > > > 
> > > > I wonder if we should just translate a collapse range that is
> > > > equivalent to a truncate operation to, in fact, be a truncate
> > > > operation?
> > > 
> > > Trying to collapse a range that extends beyond EOF, IMO, is likely
> > > to only happen if the DVR/NLE application is buggy. Hence I think
> > > that telling the application it is doing something that is likely to
> > > be wrong is better than silently truncating the file....
> > 
> > I do agree with Ted on this point.  This is not an xfs ioctl added
> > for one DVR/NLE application, it's a mode of a Linux system call.
> > 
> > We do not usually reject with an error when one system call happens
> > to ask for something which can already be accomplished another way;
> > nor nanny our callers.
> > 
> > It seems natural to me that COLLAPSE_RANGE should support beyond EOF;
> > unless that adds significantly to implementation difficulties?
> 
> Yes, it does add to the implementation complexity significantly - it
> adds data security issues that don't exist with the current API.
> 
> That is, Filesystems can have uninitialised blocks beyond EOF so
> if we allow COLLAPSE_RANGE to shift them down within EOF, we now
> have to ensure they are properly zeroed or marked as unwritten.
> 
> It also makes implementations more difficult. For example, XFS can
> also have in-memory delayed allocation extents beyond EOF, and they
> can't be brought into the range < EOF without either:
> 
> 	a) inserting zeroed pages with appropriately set up
> 	and mapped bufferheads into the page cache for the range
> 	that sits within EOF; or
> 	b) truncating the delalloc extents beyond EOF before the
> 	move
> 
> So, really, the moment you go beyond EOF filesystems have to do
> quite a bit more validation and IO in the context of the system
> call. It no longer becomes a pure extent manipulation offload - it
> becomes a data security problem.

Those sound like problems you would already have solved for a
simple extending truncate.

But I wasn't really thinking of the offset > i_size case, just the
offset + len >= i_size case: which would end with i_size at offset,
and the areas you're worried about still beyond EOF - or am I confused?

> 
> And, indeed, the specification that we are working to is that the
> applications that want to collapse the range of a file are using
> this function instead of read/memcpy/write/truncate, which by
> definition means they cannot shift ranges of the file beyond EOF
> into the new file.
> 
> So IMO the API defines the functionality as required by the
> applications that require it and *no more*. If you need some
> different behaviour - we can add it via additional flags in future
> when you have an application that requires it. 

You still seem to be thinking in terms of xfs ioctl hacks,
rather than fully scoped Linux system calls.

But it probably doesn't matter too much, if we start with an error,
and later correct that to a full implementation - an xfstest or LTP
test which expected failure will fail once it sees success, but no
users harmed in the making of this change.

> 
> > Actually, is it even correct to fail at EOF?  What if fallocation
> > with FALLOC_FL_KEEP_SIZE was used earlier, to allocate beyond EOF:
> > shouldn't it be possible to shift that allocation down, along with
> > the EOF, rather than leave it behind as a stranded island?
> 
> It does get shifted down - it just remains beyond EOF, just like it
> was before the operation. And that is part of the specification of
> COLLAPSE_RANGE - it was done so that preallocation (physical or
> speculative delayed allocation) beyond EOF to avoid fragmentation as
> the DVR continues to write is not screwed up by chopping out earlier
> parts of the file.

Yes, I was confused when I pictured a stranded island there.

Hugh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
