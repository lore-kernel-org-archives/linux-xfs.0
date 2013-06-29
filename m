Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13E2C7FA0
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 21:38:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F203D8F8049
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 19:38:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KGPShhzIdtqdjZHE for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 19:38:17 -0700 (PDT)
Date: Sat, 29 Jun 2013 12:38:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/15] xfs: update mount options documentation
Message-ID: <20130629023804.GE9047@dastard>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-2-git-send-email-david@fromorbit.com>
	<20130627144814.GM20932@sgi.com> <20130627190831.GN20932@sgi.com>
	<20130628020912.GI32195@dastard> <20130628023204.GJ32195@dastard>
	<20130628193959.GC20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130628193959.GC20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 28, 2013 at 02:39:59PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Fri, Jun 28, 2013 at 12:32:04PM +1000, Dave Chinner wrote:
> > On Fri, Jun 28, 2013 at 12:09:12PM +1000, Dave Chinner wrote:
> > > On Thu, Jun 27, 2013 at 02:08:31PM -0500, Ben Myers wrote:
> > > > Hey Dave,
> > > > 
> > > > On Thu, Jun 27, 2013 at 09:48:14AM -0500, Ben Myers wrote:
> > > > > On Thu, Jun 27, 2013 at 04:04:45PM +1000, Dave Chinner wrote:
> > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > 
> > > > > > Because it's horribly out of date.
> > > > > > 
> > > > > > And mark various deprecated options as deprecated and give them a
> > > > > > removal date.
> > > > > > 
> > > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> > > > > 
> > > > > Regarding removal of these mount options and sysctls:  initially these all look
> > > > > pretty reasonable but we need to be very careful here.  I've read some
> > > > > discussions on lkml that seem to suggest that such interfaces which have been
> > > > > exported to userspace shouldn't be removed at all.  Not that I want to keep
> > > > > around a bunch of worn out interfaces...
> > > > > 
> > > > > Applied.
> > > > 
> > > > On second thought... Not pushed.
> > > > 
> > > > I'm going to hold off on pushing this one to oss for now because I'm just not
> > > > comfortable with it yet.  I can pull this in sans the removal notices if you
> > > > want.  Lets discuss whether the removal of deprecated mount options and sysctls
> > > > is acceptable before announcing an intention to remove them.  I'm trending no,
> > > > but I can be flexible if this really is ok.
> > > 
> > > Mount options are perfectly fine to be removed - they've been given
> > > deprecated warnings for quite some time now (the most recent is the
> > > delaylog which has been doing that since 3.1 IIRC). So they are all
> > > fine to actually remove - 12 months warning is usually considered
> > > sufficient.
> > > 
> > > As to the sysctls - they haven't had any effect since 3.5 when the
> > > xfsbufd was removed, so it's time to mark them deprecated so we can
> > > remove them in a year's time. That gives anyone using them
> > > (including distros) plenty of time to fix whatever is using them
> > > before they get removed.
> > > 
> > > > I'm thinking of the 3.3 glusterfs and 3.8 pulseaudio reakeage.  And I would
> > > > really like to have a nice holiday weekend. ;)
> > > 
> > > I think you're being overly paranoid here - I'm simply following the
> > > normal deprecation protocol here....
> > 
> > Documenation/ABI/README:
> > 
> > We have four different levels of ABI stability, as shown by the four
> > different subdirectories in this location.  Interfaces may chang levels
> > of stability according to the rules described below.
> > ....
> >  obsolete/
> >          This directory documents interfaces that are still remaining in
> > 	 the kernel, but are marked to be removed at some later point in
> > 	 time.  The description of the interface will document the reason
> > 	 why it is obsolete and when it can be expected to be removed.
> > 
> > I think you'll find that what I done follows this policy.
> 
> Thanks.  That's exactly the sort of doc I am looking for.  I'll check it out.
> I really just want to make sure that we're not going to be breaking userspace
> by removing these...
> 
> > If you really want, I'll move them to Documenation/ABI/obsolete.  And, of
> > course, if removing them proves to be a problem, as Eric said we can always
> > reinstate them or remove the deprecation notices.
> 
> I forgot to mention that noatime seems to be missing now.  Was that intentional?

Yes - it's not an XFS mount option - it's handled by the VFS and
documented as a common mount option for all filesystems just like
nodiratime, relatime, strictatime, sync, dirsync, nosuid, noexec,
etc. IOWs, there's no need to document it as an XFS specific mount
option....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
