Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 18:43:59 -0700 (PDT)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l481hrfB032410
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 18:43:54 -0700
Date: Mon, 7 May 2007 21:43:37 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070508014337.GA14072@thunk.org>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070507171541.5370a36a.akpm@linux-foundation.org> <1178584899.3933.73.camel@dyn9047017103.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178584899.3933.73.camel@dyn9047017103.beaverton.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mingming Cao <cmm@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andreas Dilger <adilger@clusterfs.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Mon, May 07, 2007 at 05:41:39PM -0700, Mingming Cao wrote:
> We could check the total number of fs free blocks account before
> preallocation happens, if there isn't enough space left, there is no
> need to bother preallocating.

Checking against the fs free blocks is a good idea, since it will
prevent the obvious error case where someone tries to preallocate 10GB
when there is only 2GB left.  But it won't help if there are multiple
processes trying to allocate blocks the same time.  On the other hand,
that case is probably relatively rare, and in that case, the
filesystem was probably going to be left completely full in any case.

On Mon, May 07, 2007 at 05:15:41PM -0700, Andrew Morton wrote:
> Userspace could presumably repair the mess in most situations by truncating
> the file back again.  The kernel cannot do that because there might be live
> data in amongst there.

Actually, the kernel could do it, in that could simply release all
unitialized extents back to the system.  The problem is distinguishing
between the unitialized extents that had just been newly added, versus
the ones that had there from before.  (On the other hand, if the
filesystem was completely full, releasing unitialized blocks wouldn't
be the worse thing in the world to do, although releasing previously
fallocated blocks probably does violate the princple of least
surprise, even if it's what the user would have wanted.)

On Mon, May 07, 2007 at 05:41:39PM -0700, Mingming Cao wrote:
> If there is enough free space, we could make a reservation window that
> have at least N free blocks and mark it not stealable by other files. So
> later we will not run into the ENOSPC error.

Could you really use a single reservation window?  When the filesystem
is almost full, the free extents are likely going to be scattered all
over the disk.  The general principle of grabbing all of the extents
and keeping them in an in-memory data structure, and only adding them
to the extent tree would work, though; I'm just not sure we could do
it using the existing reservation window code, since it only supports
a single reservation window per file, yes?

						- Ted
