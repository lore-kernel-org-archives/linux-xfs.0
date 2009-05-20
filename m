Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4KAoDiJ100833 for <xfs@oss.sgi.com>; Wed, 20 May 2009 05:50:13 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F4D019EFE86
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 03:50:22 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id VCEjKS8hHQoeLasr for <xfs@oss.sgi.com>;
	Wed, 20 May 2009 03:50:22 -0700 (PDT)
Date: Wed, 20 May 2009 06:50:11 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT vs XFS at 80% filled filesystem
Message-ID: <20090520105011.GD3523@mit.edu>
References: <49F9565E.40804@gslab.com> <20090430183450.GB19276@mit.edu>
	<1242651808.3339.28.camel@alhena> <20090518131755.GJ32019@mit.edu>
	<1242798210.3457.4.camel@alhena>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1242798210.3457.4.camel@alhena>
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
To: Milind <milind@gslab.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 20, 2009 at 11:13:30AM +0530, Milind wrote:
> I am building xfsprogs to add it to my toolchain and want xfsprogs to
> refer to my toolchain's libuuid. So I need libuuid.so in my toolchain.
> But building e2fsprogs from sources doesn't build libuuid as .so (builds
> as .a). Could you please give some pointers on building libuuid as .so?

Add to the configure script --enable-elf-shared (I assume this is on a
Linux system, right?).  There are a number of configure options.  Run
configure --help to see them....

> Do I have to change Makefiles? How do you do it for ubuntu/debian
> packages that you maintain?

The debian packages are built using the standard debian packaging
framework, which means a number of support programs, one of which
eventually runs "make -f debian/rules" with various makefile targets.
Take a look at it, but be warned it's rather complicated.

The debian packages ultimately end up building e2fsprogs three times,
with different sets of configure options.  One is the standard build,
one is for the restricted-size build for boot floppies (which arguably
we don't need any more since we these days CD-ROM's have plenty of
space, and Debian doesn't support boot floppies any more) and one is
for the static build for e2fsck.static (although the utility of that
one is somewhat dubious given that even the shell is with shared
library, so if the filesystem is corrupted enough that shared libaries
don't work, it's rescue CD-ROM time; the main use for e2fsck.static is
for emergency use when someone running an older version of Debian
needs a newer e2fsck to fix a filesystem corruption).

      	      	     	      		 - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
