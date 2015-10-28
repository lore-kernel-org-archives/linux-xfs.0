Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 28EF97CBF
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 17:32:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C97E2AC001
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 15:32:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SL4m1hZ67EoQuXCB for <xfs@oss.sgi.com>;
	Wed, 28 Oct 2015 15:32:41 -0700 (PDT)
Date: Thu, 29 Oct 2015 09:32:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] cleanup: get rid of ASSERT
Message-ID: <20151028223234.GQ8773@dastard>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
	<1444959901-31319-2-git-send-email-david@fromorbit.com>
	<20151028115121.GA50552@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151028115121.GA50552@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 28, 2015 at 07:51:22AM -0400, Brian Foster wrote:
> On Fri, Oct 16, 2015 at 12:44:54PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > ASSERT comes from the xfs/xfs.h include, and we don't ever define
> > DEBUG so we never get asserts built in. We want asserts built in for
> > testing, but not for distro packages. The debian package already
> > tries to do this by using "export DEBUG=-DNDEBUG" for the build
> > context, but seeing as we pull in #define ASSERT(ex) (0) from the
> > XFS headers it's a no-op.
> > 
> > Convert all the ASSERT calls to assert to remove this conflict with
> > the xfsprogs headers and so local developer builds are built with
> > asserts enabled.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> My initial concern when reading this was that asserts were now
> unconditionally enabled. According to the man page, assert() is enabled
> unless NDEBUG is defined at include time. The debian builder apparently
> does this, but is this standard for other such utils?

For other XFS utilities? Yes. For other packages I don't maintain? I
don't know, I don't care, and I don't think it's relevant at all.
How the distro builds and packages a utility is up to the distro
maintainers - if they define -NDEBUG, then there is absolutely no
change in behaviour of xfsdump. I think the binary is effectively
unchanged as assert() is defined out in that case...

> That aside, this seems like an inconsistent approach from our other
> tools. For example, the debian/rules from xfsprogs does the same thing,
> yet DEBUG must be defined to enable asserts in the first place.

That's a issue with the way xfsprogs uses asserts - ASSERT should
never have been exported in the first, nor should the xfsdump buildi
rely on it, but here we are....

> If the
> problem is that asserts cannot be enabled, I'm wondering why the
> appropriate fix isn't to define DEBUG somewhere for debug-enabled builds
> rather than unconditionally convert all of the ASSERT() calls into
> actual assert()'s..?

Becuase it has to build with both old and new xfsprogs userspace
headers. Hence we cannot use ASSERT reliably in xfsdump at all,
because it's owned by the old xfsprogs headers and it's behaviour is
determined by whatever that xfsprogs installation defined......

> We do actually have a bunch of '#ifdef DEBUG' code
> throughout xfsdump (and DEBUG appears in 'configure' as well, though I
> have no idea if that actually does anything)...

I'm not going to pull that string and have this turn into a massive
"we have to change everything" exercise. I've built the code with
and without NDEBUG enabled, and had no problems with the assert code
either way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
