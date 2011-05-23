Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4NDZt1m002940 for <xfs@oss.sgi.com>; Mon, 23 May 2011 08:35:56 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3CC31EB2C6F
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 06:35:52 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id HaEixlpWyW0TTNYW for
	<xfs@oss.sgi.com>; Mon, 23 May 2011 06:35:52 -0700 (PDT)
Date: Mon, 23 May 2011 15:35:48 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110523133547.GA25777@schmorp.de>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
	<20110521041652.GA18375@schmorp.de>
	<20110522020024.GZ32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110522020024.GZ32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, May 22, 2011 at 12:00:24PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > The problem is that this is not anything like the normal case.
> 
> For you, maybe.

For the majority of boxes that use xfs - most desktop boxes are not heavy
NFS servers.

> > It's easy to get some gains in special situations at the expense of normal
> > ones - keep in mind that this optimisation makes little sense for non-NFS
> > cases, which is the majority of use cases.
> 
> XFS is used extensively in NAS products, from small $100 ARM/MIPS
> embedded NAS systems all the way up to high end commercial NAS
> products. It is one of the main use cases we optimise XFS for.

Thats really sad - maybe people like me who use XFS on their servers
should rethink that decision that, if XFS mainly optimises for commercial
nas boxes only.

You aren't serious, are you?

> Sure, that would be my preferred approach. However, if you followed
> the discussion when this first came up, you'd realise that we've
> been trying to get NFS server changes to fix this operation for the
> past 5 years, and I've just about  given up trying.  Hell, the NFS
> OFC (open file cache) proposal that would have mostly solved this
> (and other problems like readahead state thrashing) from 2-3 years
> ago went nowhere...

In other words, if you can't do it right, you make ugly broken hacks, and
then tell people that it's exepcted behaviour, because xfs is optimised
for commercial NFS server boxes.

> > The preallocation makes sense in relation to the working set, which can be
> > characterised by the open files, or recently opened files.
> > Tieing it to the (in-memory) inode lifetime is an abysmal approximation to
> > this.
> 
> So you keep saying, but you keep ignoring the fact that the inode
> cache represents the _entire_ working set of inodes. It's not an
> approximation - it is the _exact_ current working set of files we
> currently have.

I am sory, but that is wrong and shows a serious lack of
understanding. The cached inode set is just that, a cache. It is
definitely not corresponding to any working set, simply because it is a
*cache*.

ls -l in a directory will cache all inodes, but that doesn't mean that
those files are the working set 8 hours later.

Open files are in the working set, because applications open files to use
them.

The inode cache probably contains stuff that was in the working set
before, but is no longer.

> Hence falling back to "preallocation lasts for as long as the inode
> is part of the working set" is an extremely good heuristic to use -

It's of course extremely broken, because all it does is improve the
(fragmentation) performance for broken clients - for normal clients it
will reduce performance of course.

> we move from preallocation for only the L1 cache lifecycle (open
> fd's) to using the L2 cache lifecycle (recently opened inodes)
> instead.

That comparison is seriously flawed, as a cache is transparent, but the
xfs behaviour is not.

> > If I unpack a large tar file, this means that I get a lot of (internal)
> > fragmentation because all files are spread over a large area than
> > necesssary, and diskspace is used for a potentially indefinite time.
> 
> So you can reproduce this using an tar? Any details on size, # of
> files, the untar command, etc?

I can reproduce it simply by running make in the uclibc source tree.

Since gas has the same access behaviour as tar, why would it be different?
What kind of broken heuristic is it that XFS now uses that these two use
cases would make a difference?

> How do you know you get internal fragmentation and tha tit is affecting
> fragmentation?

If what you say is true, thats a logical conclusion, it doesn'T need
evidence, it follows from your claims.

XFS can't preallocate for basically all files that are beign written and
at the same time avoid fragmentation.

> Please provide concrete examples (e.g. copy+paste the command lines and
> any relevant output) that so I might be able to reproduce your problem
> myself?

"make" - I already told you in my first e-mail.

> we should fix it. What I really want is your test cases that
> reproduce the problem so I can analyse it for myself. Once I
> understand what is going on, then we can talk about what the real
> problem is and how to fix it.

Being a good citizen wanting to improve XFS I of course dleivered that in
my first e-mail. Again, I used allocsize=64m and then made a buildroot
build, which stopped after a few minutes because 180GB of disk space were
gone.

The disk space was all used up by the buildroot, which is normally a few
gigabytes (after a successful build).

I found that the uclibc object directory uses 50GB of space, about 8 hours
after the compile - the object files were typically a few kb in size, but
du showed 64mb of usage, even though nobody was using that file more than
once, or ever after the make stopped.

I am sorry, I think you are more interested in forcing your personal
toy heuristic through reality - thats how you come across, because you
selectively ignore the bits that you don't like. It's also pretty telling
that XFS mainly optimises for commercial NAS boxes now, and no longer for
good performance on local boxes.

:(

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
