Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CBF5A7CA0
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 04:53:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5EB80AC002
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 02:53:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HAkSpA45t0NdYSm3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 May 2016 02:53:32 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id DC78D62678
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 09:53:31 +0000 (UTC)
Received: from redhat.com (unused [10.10.50.11] (may be forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u449rSpA005913
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 4 May 2016 05:53:31 -0400
Date: Wed, 4 May 2016 11:53:28 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V2]
Message-ID: <20160504095328.GA2855@redhat.com>
References: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
	<20160503225948.GU26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160503225948.GU26977@dastard>
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
To: xfs@oss.sgi.com

On Wed, May 04, 2016 at 08:59:48AM +1000, Dave Chinner wrote:
> On Tue, May 03, 2016 at 07:55:33PM +0200, Carlos Maiolino wrote:
> > Hi folks,
> > 
> > I spoke with Dave and to offload him a bit, I took over his patchset for enable
> > configurable error handlers.
> > 
> > Since he did most of the design, I kept his signed-off to the patches.
> > 
> > Here are core the changes I did from his last patchset to this one:
> > 
> >  - Removed fail_speed configuration
> > 	According with what has been discussed, there is no real need to have a
> > fail_speed configuration, but instead, use the "max_retries" configuration to
> > get for how long the filesystem should retrying, with the only special case for
> > 	"-1", which will make the filesystem to retry forever.
> > 
> >  - Fail at unmount is no longer a config option
> > 	Having a filesystem stuck forever during unmount due errors is not a
> > 	good thing, so just enforce it if we are trying to unmount a failed
> > 	filesystem.
> 
> I think this is wrong - the option should still remain to let the
> filesystem retry for a long while if desired. We have lazy unmounts
> to deal with this situation (i.e. it won't block an unmount command)
> and there are cases where leaving the unmount retrying in the
> background is useful.
> 
> If you are particularly worried about not being able to shut down a
> filesystem that has been unmounted lazily and hence terminate the
> retry forever loop, then we should be looking at ensuring the fs is
> still visible in /sys/fs/xfs/<dev> when it is in this state and
> providing a new shutdown hook through that interface....
> 

Right, I will keep this option, although, I don't think it's useful to have this
option configurable with a per-error granularity, a single fail_at_unmount might
suffice.

> > I reduced by now, the amount of patches into this patchset, once, our priority
> > here IMHO is to enable the possibility to shutdown the filesystem when we have
> > metadata errors, and I can work on disabling specific error configs and add
> > memory errors later, I hope that with a reduced amount of patches it can be
> > easier for people to review the core of the error handlers configuration and
> > speed up the inclusion of this patchset.
> 
> We'll see - the issue here is that once we settle on a sysfs
> interface, we can't change it easily (it's part of the user facing
> ABI). Hence if we don't consider all the different types of errors
> we want to handle from the start, we may miss something that we
> can't easily fix in future. Hence we at least have to consider the
> different constraints for the different error types now to determine
> if the abstractions and presentation will handle everything we think
> we might need...
> 

Agreed, the interface for now looks good IMO, and adding the possibility to hide
some specific error handlers from userspace can be done later without a real
impact in the ABI, I just believe that implementing the interface for errors
that will be visible is more important for now, specifically for EIO and ENOSPC

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
