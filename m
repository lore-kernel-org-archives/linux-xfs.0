Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7B3E7F6A
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:13:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D84AAC004
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 05:13:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kQjKd7EnnhgUt0Ui (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 05:13:36 -0700 (PDT)
Date: Thu, 29 Oct 2015 08:13:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/8] cleanup: get rid of ASSERT
Message-ID: <20151029121333.GA11663@bfoster.bfoster>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
	<1444959901-31319-2-git-send-email-david@fromorbit.com>
	<20151028115121.GA50552@bfoster.bfoster>
	<20151028223234.GQ8773@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151028223234.GQ8773@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 29, 2015 at 09:32:34AM +1100, Dave Chinner wrote:
> On Wed, Oct 28, 2015 at 07:51:22AM -0400, Brian Foster wrote:
> > On Fri, Oct 16, 2015 at 12:44:54PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > ASSERT comes from the xfs/xfs.h include, and we don't ever define
> > > DEBUG so we never get asserts built in. We want asserts built in for
> > > testing, but not for distro packages. The debian package already
> > > tries to do this by using "export DEBUG=-DNDEBUG" for the build
> > > context, but seeing as we pull in #define ASSERT(ex) (0) from the
> > > XFS headers it's a no-op.
> > > 
> > > Convert all the ASSERT calls to assert to remove this conflict with
> > > the xfsprogs headers and so local developer builds are built with
> > > asserts enabled.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > My initial concern when reading this was that asserts were now
> > unconditionally enabled. According to the man page, assert() is enabled
> > unless NDEBUG is defined at include time. The debian builder apparently
> > does this, but is this standard for other such utils?
> 
> For other XFS utilities? Yes. For other packages I don't maintain? I
> don't know, I don't care, and I don't think it's relevant at all.
> How the distro builds and packages a utility is up to the distro
> maintainers - if they define -NDEBUG, then there is absolutely no
> change in behaviour of xfsdump. I think the binary is effectively
> unchanged as assert() is defined out in that case...
> 

I'm talking about common packaging tools (e.g., yum/dnf being the
obvious next example) and XFS packages, not random other packages. If
they don't define NDEBUG, then apparently there is a change in behavior.

> > That aside, this seems like an inconsistent approach from our other
> > tools. For example, the debian/rules from xfsprogs does the same thing,
> > yet DEBUG must be defined to enable asserts in the first place.
> 
> That's a issue with the way xfsprogs uses asserts - ASSERT should
> never have been exported in the first, nor should the xfsdump buildi
> rely on it, but here we are....
> 

Sure...

> > If the
> > problem is that asserts cannot be enabled, I'm wondering why the
> > appropriate fix isn't to define DEBUG somewhere for debug-enabled builds
> > rather than unconditionally convert all of the ASSERT() calls into
> > actual assert()'s..?
> 
> Becuase it has to build with both old and new xfsprogs userspace
> headers. Hence we cannot use ASSERT reliably in xfsdump at all,
> because it's owned by the old xfsprogs headers and it's behaviour is
> determined by whatever that xfsprogs installation defined......
> 

Then why not try to undef/redef in xfsdump or just rename the #define
that's used? I don't care too much either way, I just don't follow why
there's a need to change behavior at all to fix a naming conflict.

Are we saying that ASSERT() probably shouldn't exist in userspace (incl.
xfsprogs) and we should always use the generic assert() mechanism? Or
are we saying ASSERT() can exist in userspace, but it's purely a libxfs
thing and should not be exported beyond that (e.g., libxfs can use
ASSERT(), actual userspace tools like repair, etc. should eventually use
assert())..? Or perhaps we want to enable assert functionality, but
DEBUG is broken (?) and we don't want to deal with that just to fix
asserts and the build? Any of those seem reasonable to me.

> > We do actually have a bunch of '#ifdef DEBUG' code
> > throughout xfsdump (and DEBUG appears in 'configure' as well, though I
> > have no idea if that actually does anything)...
> 
> I'm not going to pull that string and have this turn into a massive
> "we have to change everything" exercise. I've built the code with
> and without NDEBUG enabled, and had no problems with the assert code
> either way.
> 

I'm not sure what that has to do with fixing ASSERT(). If DEBUG is in
fact broken on xfsdump today, then it could technically be fixed
separately whenever somebody has the time and motivation to do so.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
