Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0508E7CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 21:38:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B921830405F
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:38:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	z7w9AlFxODgostIv for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 19:38:03 -0700 (PDT)
Date: Fri, 14 Jun 2013 12:37:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: replace umode_t with xfs_mode_t
Message-ID: <20130614023758.GT29338@dastard>
References: <51BA219B.4070503@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51BA219B.4070503@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 13, 2013 at 03:46:35PM -0400, Michael L. Semon wrote:
> This patch was made after applying the most recent 3.11-related 
> patchset for xfsprogs.  It was applied against the crc-dev branch, 
> in order to get CRC-enabled xfsprogs to build without complaining 
> about a lack of "umode_t".  The systems used were both 32-bit 
> slackware-current systems, against public kernel headers of kernel 
> 3.8.x and 3.9.x vintage.
> 
> This is an "idea" patch, a way of getting CRC-enabled xfsprogs to 
> build on kernels later than 3.2 while staying within the conventions 
> of my test systems.  The idea may be bad, and the XFS crew might be 
> solving it in a different way while moving header files and functions.
> 
> Anyway, I don't know how the Debian and Red Hat crews solve header-
> related issues like these, so comments and flames are welcome.  In 
> particular, I'm open to a better name than "xfs_mode_t" that does 
> not match the grep term "umode_t".

The usual way to do this is with autoconf magic.

The thing is, we want to keep the user and kernel code as close as
possible, so if the kernel code uses umode_t, then we need to use
that internally in the userspace code as well.

So what we need is an autoconf rule that detects is umode_t is
defined by the distro, and if it isn't define it ourselves.

See, for example, m4/package_types.m4 for how to detect if a
variable is already defined. Add a new rule to detect umode_t,
and use it to set a variable called have_umode_t. i.e.

.....
	], [
		umode_t umode;
	], have_umode_t=no
		AC_MSG_RESULT(yes),
		AC_MSG_RESULT(no))
	AC_SUBST(have_umode_t)
	])

then add a line like:

HAVE_UMODE_T = @have_umode_t@

to include/builddefs.in, as well as add this to the platform compile
flags like so:

ifeq ($(HAVE_UMODE_T),yes)
PCFLAGS += -DHAVE_UMODE_T
endif

then in include/platform_defs.h.in add something like:

#ifndef HAVE_UMODE_T
typedef unsigned short umode_t;
#endif

And then you shouldn't have to modify any of the actual libxfs code
at all...

If you need help, just ping me ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
