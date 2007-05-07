Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 16:36:41 -0700 (PDT)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47NabfB016849
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 16:36:38 -0700
Date: Mon, 7 May 2007 19:36:22 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070507233622.GB29907@thunk.org>
References: <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org> <20070507222103.GJ8181@schatzie.adilger.int> <463FB008.3080706@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463FB008.3080706@garzik.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, May 07, 2007 at 07:02:32PM -0400, Jeff Garzik wrote:
> Andreas Dilger wrote:
> >On May 07, 2007  13:58 -0700, Andrew Morton wrote:
> >>Final point: it's fairly disappointing that the present implementation is
> >>ext4-only, and extent-only.  I do think we should be aiming at an ext4
> >>bitmap-based implementation and an ext3 implementation.
> >
> >Actually, this is a non-issue.  The reason that it is handled for 
> >extent-only
> >is that this is the only way to allocate space in the filesystem without
> >doing the explicit zeroing.  For other filesystems (including ext3 and
> 
> Precisely /how/ do you avoid the zeroing issue, for extents?
> 
> If I posix_fallocate() 20GB on ext4, it damn well better be zeroed, 
> otherwise the implementation is broken.

There is a bit in the extent structure which indicates that the extent
has not been initialized.  When reading from a block where the extent
is marked as unitialized, ext4 returns zero's, to avoid returning the
uninitalized contents of the disk, which might contain someone else's
love letters, p0rn, or other information which we shouldn't leak out.
When writing to an extent which is uninitalized, we may potentially
have to split the extent into three extents in the worst case.

My understanding is that XFS uses a similar implementation; it's a
pretty obvious and standard way to implement allocated-but-not-initialized
extents.

We thought about supporting persistent preallocation for inodes using
indirect blocks, but it would require stealing a bit from each entry
in the indirect block, reducing the maximum size of the filesystem by
two (i.e., 2**31 blocks).  It was decided it wasn't worth the
complexity, given the tradeoffs.

						- Ted
