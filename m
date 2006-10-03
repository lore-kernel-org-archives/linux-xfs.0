Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Oct 2006 15:24:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k93MNoaG014113
	for <xfs@oss.sgi.com>; Tue, 3 Oct 2006 15:23:53 -0700
Date: Wed, 4 Oct 2006 08:22:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/3] Convert XFS inode hashes to radix trees
Message-ID: <20061003222256.GW4695059@melbourne.sgi.com>
References: <20061003060610.GV3024@melbourne.sgi.com> <20061003212335.GA13120@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061003212335.GA13120@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com, dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>

On Tue, Oct 03, 2006 at 02:23:35PM -0700, Chris Wedgwood wrote:
> On Tue, Oct 03, 2006 at 04:06:10PM +1000, David Chinner wrote:
> > Overall, the patchset removes more than 200 lines of code from the
> > xfs inode caching and lookup code and provides more consistent
> > scalability for large numbers of cached inodes. The only down side
> > is that it limits us to 32 bit inode numbers of 32 bit platforms due
> > to the way the radix tree uses unsigned longs for it's indexes
> 
>     commit afefdbb28a0a2af689926c30b94a14aea6036719
>     tree 6ee500575cac928cd90045bcf5b691cf2b8daa09
>     parent 1d32849b14bc8792e6f35ab27dd990d74b16126c
>     author David Howells <dhowells@redhat.com> 1159863226 -0700
>     committer Linus Torvalds <torvalds@g5.osdl.org> 1159887820 -0700
> 
>     [PATCH] VFS: Make filldir_t and struct kstat deal in 64-bit inode numbers
> 
>     These patches make the kernel pass 64-bit inode numbers internally when
>     communicating to userspace, even on a 32-bit system.  They are required
>     because some filesystems have intrinsic 64-bit inode numbers: NFS3+ and XFS
>     for example.  The 64-bit inode numbers are then propagated to userspace
>     automatically where the arch supports it.
>     [...]
> 
> Doing this will mean XFS won't be able to support 32-bit inodes on
> 32-bit platforms the above (merged) patch --- though given that cheap
> 64-bit systems are now abundant does anyone really care?

That's a good question. In a recent thread on linux-fsdevel about
these patches Christoph Hellwig pointed out that 32bit user space is
not ready for 64 bit inodes, so it's probably going to be a while
before the second half of this mod is ready (which exports 64 bit
inodes ito userspace on 32bit platforms).

http://marc.theaimsgroup.com/?l=linux-fsdevel&m=115946211808497&w=2
http://marc.theaimsgroup.com/?l=linux-fsdevel&m=115948836023569&w=2

ISTR someone else also menitoning that 64bit inodes on 32-bit machines
also breaks the dynamic linker, but I can't find a reference to that
atm.

As it stands, there's still a few barriers to getting 64 bit inodes
on 32 bit platforms and I can't see them going away quickly. Right
now I see little reason in moving to 64 bit inodes for 32 bit
platforms for XFS because of the 16TB filesystem size limit (that
only needs 33-36 bit inodes depending on the inode size) and no
32bit platform is currently able to repair a filesystem of that
size.

And yes, 64 bit systems are cheap, cheap, cheap so IMO this
functionality is really irrelevant moving forward. If it had come
along a couple of years ago then it would be different, but I think
mainstream technology is finally catching up with XFS so it's not a
critical issue anymore... ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
