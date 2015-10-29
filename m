Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6CFB7CBF
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 17:26:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 970B730404E
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 15:26:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ulyB6FixkKQZvL7x for <xfs@oss.sgi.com>;
	Thu, 29 Oct 2015 15:26:11 -0700 (PDT)
Date: Fri, 30 Oct 2015 09:26:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] cleanup: get rid of ASSERT
Message-ID: <20151029222609.GC10656@dastard>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
	<1444959901-31319-2-git-send-email-david@fromorbit.com>
	<20151028115121.GA50552@bfoster.bfoster>
	<20151028223234.GQ8773@dastard>
	<20151029121333.GA11663@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151029121333.GA11663@bfoster.bfoster>
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

On Thu, Oct 29, 2015 at 08:13:34AM -0400, Brian Foster wrote:
> On Thu, Oct 29, 2015 at 09:32:34AM +1100, Dave Chinner wrote:
> > On Wed, Oct 28, 2015 at 07:51:22AM -0400, Brian Foster wrote:
> > > On Fri, Oct 16, 2015 at 12:44:54PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > ASSERT comes from the xfs/xfs.h include, and we don't ever define
> > > > DEBUG so we never get asserts built in. We want asserts built in for
> > > > testing, but not for distro packages. The debian package already
> > > > tries to do this by using "export DEBUG=-DNDEBUG" for the build
> > > > context, but seeing as we pull in #define ASSERT(ex) (0) from the
> > > > XFS headers it's a no-op.
> > > > 
> > > > Convert all the ASSERT calls to assert to remove this conflict with
> > > > the xfsprogs headers and so local developer builds are built with
> > > > asserts enabled.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > 
> > > My initial concern when reading this was that asserts were now
> > > unconditionally enabled. According to the man page, assert() is enabled
> > > unless NDEBUG is defined at include time. The debian builder apparently
> > > does this, but is this standard for other such utils?
> > 
> > For other XFS utilities? Yes. For other packages I don't maintain? I
> > don't know, I don't care, and I don't think it's relevant at all.
> > How the distro builds and packages a utility is up to the distro
> > maintainers - if they define -NDEBUG, then there is absolutely no
> > change in behaviour of xfsdump. I think the binary is effectively
> > unchanged as assert() is defined out in that case...
> > 
> 
> I'm talking about common packaging tools (e.g., yum/dnf being the
> obvious next example) and XFS packages, not random other packages. If
> they don't define NDEBUG, then apparently there is a change in behavior.

If they don't define that, then they've been building the packages
incorrectly... ;)

> > > If the
> > > problem is that asserts cannot be enabled, I'm wondering why the
> > > appropriate fix isn't to define DEBUG somewhere for debug-enabled builds
> > > rather than unconditionally convert all of the ASSERT() calls into
> > > actual assert()'s..?
> > 
> > Becuase it has to build with both old and new xfsprogs userspace
> > headers. Hence we cannot use ASSERT reliably in xfsdump at all,
> > because it's owned by the old xfsprogs headers and it's behaviour is
> > determined by whatever that xfsprogs installation defined......
> > 
> 
> Then why not try to undef/redef in xfsdump or just rename the #define
> that's used? I don't care too much either way, I just don't follow why
> there's a need to change behavior at all to fix a naming conflict.
> 
> Are we saying that ASSERT() probably shouldn't exist in userspace (incl.
> xfsprogs) and we should always use the generic assert() mechanism? Or
> are we saying ASSERT() can exist in userspace, but it's purely a libxfs
> thing and should not be exported beyond that (e.g., libxfs can use
> ASSERT(), actual userspace tools like repair, etc. should eventually use
> assert())..?

Precisely this. ASSERT is used in the kernel side libxfs code, and
so only exists in userspace to support the libxfs code in userspace.
We don't want the libxfs code in userspace aborting on corrupt
structures or invalid situations, because we need to
handle/parse/repair such brokenness. IOWS, the ASSERTs in libxfs/ in
userspace need to be turned off for userspace to work correctly.
That's what the DEBUG define in libxfs does.

That leads to the xfsprogs userspace still needing an assert
facility - that comes from using assert() and NDEBUG to turn it off
and on.

Essentially, ASSERT is internal to libxfs and should not be exported
anywhere. assert() should used outside libxfs in xfsprogs and other
XFS code bases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
