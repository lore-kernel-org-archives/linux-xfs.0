Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 735837F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 21:09:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BBA830404E
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 19:09:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	d2BTZkXhLy5hCLwv for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 19:09:21 -0700 (PDT)
Date: Fri, 28 Jun 2013 12:09:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/15] xfs: update mount options documentation
Message-ID: <20130628020912.GI32195@dastard>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-2-git-send-email-david@fromorbit.com>
	<20130627144814.GM20932@sgi.com> <20130627190831.GN20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130627190831.GN20932@sgi.com>
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

On Thu, Jun 27, 2013 at 02:08:31PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Thu, Jun 27, 2013 at 09:48:14AM -0500, Ben Myers wrote:
> > On Thu, Jun 27, 2013 at 04:04:45PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Because it's horribly out of date.
> > > 
> > > And mark various deprecated options as deprecated and give them a
> > > removal date.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> > 
> > Regarding removal of these mount options and sysctls:  initially these all look
> > pretty reasonable but we need to be very careful here.  I've read some
> > discussions on lkml that seem to suggest that such interfaces which have been
> > exported to userspace shouldn't be removed at all.  Not that I want to keep
> > around a bunch of worn out interfaces...
> > 
> > Applied.
> 
> On second thought... Not pushed.
> 
> I'm going to hold off on pushing this one to oss for now because I'm just not
> comfortable with it yet.  I can pull this in sans the removal notices if you
> want.  Lets discuss whether the removal of deprecated mount options and sysctls
> is acceptable before announcing an intention to remove them.  I'm trending no,
> but I can be flexible if this really is ok.

Mount options are perfectly fine to be removed - they've been given
deprecated warnings for quite some time now (the most recent is the
delaylog which has been doing that since 3.1 IIRC). So they are all
fine to actually remove - 12 months warning is usually considered
sufficient.

As to the sysctls - they haven't had any effect since 3.5 when the
xfsbufd was removed, so it's time to mark them deprecated so we can
remove them in a year's time. That gives anyone using them
(including distros) plenty of time to fix whatever is using them
before they get removed.

> I'm thinking of the 3.3 glusterfs and 3.8 pulseaudio reakeage.  And I would
> really like to have a nice holiday weekend. ;)

I think you're being overly paranoid here - I'm simply following the
normal deprecation protocol here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
