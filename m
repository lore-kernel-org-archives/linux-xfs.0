Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE44A7CA1
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 19:37:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA3F5304039
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 17:37:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AIpoDDtjJFauWb0Y for <xfs@oss.sgi.com>;
	Thu, 11 Aug 2016 17:37:14 -0700 (PDT)
Date: Fri, 12 Aug 2016 10:37:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-4.7.0 are conflicting with glibc's MS_RDONLY definition
Message-ID: <20160812003711.GY16044@dastard>
References: <2608952f-e6c4-0f20-8f49-818d67896dd3@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2608952f-e6c4-0f20-8f49-818d67896dd3@gentoo.org>
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
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 11, 2016 at 02:42:50PM +0200, Thomas Deutschmann wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> Hi,
> 
> collectd [1] now longer builds against xfsprogs-4.7.0 due to a
> conflict with MS_RDONLY definition in sys/mount.h by glibc vs exposed
> kernels header by xfsprogs due to the include of linux/fs.h.
> 
> Upstream bug: https://github.com/collectd/collectd/issues/1877
> 
> Gentoo-Bug: https://bugs.gentoo.org/590998
> 
> 
> I am bringing this to your attention to ask if you want to do anything
> to fix this in xfsprogs or do you consider that as a bug in collectd.

XFS grabs structure definitions that are exposed by the
kernel from linux/fs.h because they are used in the XFS ioctl
API definitions, as well as other syscalls that aren't supported by
glibc. So we kind of need it to make sure we pick up the system
definition of what is supported and what isn't.

That userspace unconditionally redefines the kernel mount API flags
with the same names and values seems like a bug in whatever provides
those definitions. My current userspace doesn't even have a
sys/mount.h file - I can only find a platform specific header:

/usr/include/x86_64-linux-gnu/sys/mount.h

Which contains a stale, partial copy of /usr/include/linux/fs.h.
That platform header should pull the definitions from linux/fs.h
if it exists, and only if it doesn't should it define it's own.
Esepcially as the only userspace component is 3 function prototypes
at the bottom of the file.

However, I'm probably not the best person to ask how this should all
be structured properly - it seems pretty obvious to me that
libraries should include system definitions of interfaces, and
system libraries should include the kernel definitions of kernel
interfaces.

So for collectd I'm not sure what the solution is right now - this
is only going to get more problematic as we push lots of new kernel
API support into xfsprogs over the next few months that glibc will
not support directly for some time, if ever. People using XFS
interfaces usually want to compile programs that will work on
kernels that support those functions (i.e. they use runtime support
checks, not compile time), so from the xfsprogs perspective we are
kind of stuck between a rock and a hard place here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
