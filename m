Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KLXPVX249419 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 16:33:26 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17796EE8CA9
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 14:33:24 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 0UOAbodmnqj4eWZ2 for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2011 14:33:24 -0700 (PDT)
Date: Wed, 20 Jul 2011 17:33:20 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Message-ID: <20110720213320.GA3304@thunk.org>
References: <20110720175918.GB17971@thunk.org>
 <4E271F30.6070102@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E271F30.6070102@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 20, 2011 at 01:32:16PM -0500, Eric Sandeen wrote:
> 
> How does it fail?  Works here(tm):

It doesn't find the autoconfig macros defined in the m4 directory:

<tytso@tytso-glaptop> {/kbuild/xfstests/xfsprogs-dev}  [master]
512% autoconf
autoconf: Undefined macros:
configure.in:100:AC_PACKAGE_NEED_PTHREADMUTEXINIT
configure.in:102:AC_HAVE_FADVISE
configure.in:103:AC_HAVE_MADVISE
configure.in:104:AC_HAVE_MINCORE
configure.in:105:AC_HAVE_SENDFILE
configure.in:106:AC_HAVE_GETMNTENT
configure.in:107:AC_HAVE_GETMNTINFO
configure.in:108:AC_HAVE_FALLOCATE
configure.in:109:AC_HAVE_FIEMAP
configure.in:110:AC_HAVE_BLKID_TOPO($enable_blkid)
configure.in:112:AC_TYPE_PSINT
configure.in:113:AC_TYPE_PSUNSIGNED
configure.in:114:AC_TYPE_U32
configure.in:115:AC_SIZEOF_POINTERS_AND_LONG
configure.in:116:AC_MANUAL_FORMAT
configure.in:3:AC_CONFIG_MACRO_DIR([m4])
configure.in:7:AC_PROG_LIBTOOL
configure.in:89:AC_PACKAGE_GLOBALS(xfsprogs)
configure.in:90:AC_PACKAGE_UTILITIES(xfsprogs)
configure.in:91:AC_MULTILIB($enable_lib64)
configure.in:93:AC_PACKAGE_NEED_AIO_H
configure.in:94:AC_PACKAGE_NEED_LIO_LISTIO
configure.in:96:AC_PACKAGE_NEED_UUID_H
configure.in:97:AC_PACKAGE_NEED_UUIDCOMPARE
configure.in:99:AC_PACKAGE_NEED_PTHREAD_H

Maybe you have all of these autoconf macros stuffed in some
distro-supplied global m4 directory?

> > b) By default xfsprogs builds with DEBUG, and this causes building
> > libxfs/xfs_ialloc.c to blow up since there a reference of
> > xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
> > fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
> > two figure this out....
> 
> Odd, libxfs/Makefile has:
> 
> DEBUG = -DNDEBUG

Yeah, but include/builddefs{.in}, DEBUG is defined to @debug_build@,
which is -DDEBUG, and then GCFLAGS is set to $(OPTIMIZER) $(DEBUG) ...,

and the override in libxfs/Makefile doesn't change the value of
GCFLAGS, at least not for gmake 3.81.

> But to be honest, the DEBUG stuff has been a thorn in my side for Fedora
> too, with the extra CFLAGS it sets, something gets goobered up by
> default, and I build with -DNDEBUG for those packages too.
> 
> I just haven't sorted it out yet ....
> 
> So things to look into, but can you also describe how building xfstests
> fails for you when you have all the ubuntu xfsprogs-related packages
> installed?

Yeah, working on it.  I'm starting from scratch so I can have a shell
script that can build all of this by hand, instead of manually fixing
these things one at a time as I've done in the past...

      	     	      	      	   	   - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
