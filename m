Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 May 2007 09:53:09 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l48Gr2fB021897
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 09:53:04 -0700
Date: Tue, 8 May 2007 09:52:59 -0700
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070508165259.GD6375@schatzie.adilger.int>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070507171541.5370a36a.akpm@linux-foundation.org> <1178584899.3933.73.camel@dyn9047017103.beaverton.ibm.com> <20070508014337.GA14072@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508014337.GA14072@thunk.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On May 07, 2007  21:43 -0400, Theodore Tso wrote:
> On Mon, May 07, 2007 at 05:15:41PM -0700, Andrew Morton wrote:
> > Userspace could presumably repair the mess in most situations by truncating
> > the file back again.  The kernel cannot do that because there might be live
> > data in amongst there.
> 
> Actually, the kernel could do it, in that could simply release all
> unitialized extents back to the system.  The problem is distinguishing
> between the unitialized extents that had just been newly added, versus
> the ones that had there from before.  (On the other hand, if the
> filesystem was completely full, releasing unitialized blocks wouldn't
> be the worse thing in the world to do, although releasing previously
> fallocated blocks probably does violate the princple of least
> surprise, even if it's what the user would have wanted.)

I tend to agree with this.  Having fallocate() fill up the filesystem
is exactly what the caller asked.  Doing a write() hit ENOSPC doesn't
trucate off the whole write either, nor does "dd" delete the whole file
when the filesystem is full.

Even checking the statfs() space before doing the fallocate() may be
counter intuitive, since it will return ENOSPC but the filesystem will
not actually be full.  Some applications (e.g. database) may WANT to
fill the filesystem and then get the actual file size back to avoid
trusting statfs() because of metadata overhead (e.g. indirect blocks).

One of the design goals for sys_fallocate() was to allow FA_DELALLOC
to deallocate unwritten extents in a safe manner.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
