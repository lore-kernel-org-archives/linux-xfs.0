Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0V1ngVU065146 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 19:49:42 -0600
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Date: Sat, 31 Jan 2009 02:48:41 +0100
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de>
	<20090130171423.f99c88d0.akpm@linux-foundation.org>
In-Reply-To: <20090130171423.f99c88d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901310248.42820.arnd@arndb.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Saturday 31 January 2009, Andrew Morton wrote:
> Is this written in a standard somewhere? =A0Is it guaranteed?

Alignment is defined in the architecture psABI documents. =

Unfortunately, many of them were written before the 'long long'
type became part of the C standard, so it's not strictly guaranteed.
AFAICT, the alignment of __u64 on x86 is the same as the alignment
of 'double' by convention.

However, the problem is well-understood: x86 is the only one
that has a problem in 32/64 bit compat mode. m68k has similar
issues with 16/32 bit integers, but those don't apply here.

> If some (perhaps non-gcc) compiler were to lay this out differently
> (perhaps with suitable command-line options) then that's liveable
> with - as long as the kernel never changes the layout. =A0Of course
> it would be better to avoid this if poss.

If a compiler was using irregular structure alignment, all sorts of
library interfaces would break. The kernel ABI is only a small part
of the problem then.

> The other potential issue with a structure like this is that there's a
> risk that it will lead us to copy four bytes of uninitialised kernel
> memory out to userspace.
> =

> IOW, it seems a generally bad idea to rely upon compiler-added padding
> for this sort of thing.

Agreed in general, but the whole point of this particular patch was to
provide compatibility with an interface that has been part of XFS for
many years.
Linux already has a better interface for new users (sys_fallocate), so
changing the patch would not be helpful and not provide any advantage.

There is also no leak of uninitialized data here, because this structure
is only read, never written.

	Arnd <><

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
