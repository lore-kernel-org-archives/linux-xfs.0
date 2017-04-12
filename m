Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753262AbdDLLGp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 07:06:45 -0400
Date: Wed, 12 Apr 2017 07:06:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Message-ID: <20170412110633.GC6834@bfoster.bfoster>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
 <20170411223405.GC12369@dastard>
 <20170411234326.GA5109@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411234326.GA5109@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Apr 11, 2017 at 04:43:26PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 12, 2017 at 08:34:05AM +1000, Dave Chinner wrote:
> > On Tue, Apr 11, 2017 at 04:12:37PM +0200, Jan Tulak wrote:
> > > A dirty log in an obfuscated dump means that a corruption can happen
> > > when replaying the log (which contains unobfuscated data). Warn the user
> > > about this possibility.
> >
> > > The xlog workaround is copy&paste solution from repair/phase2.c and
> > > other tools, because the function is not implemented in libxlog.
> > > 
> > > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > 
> > I think this is overkill. mdrestore is not the place
> > to be interpreting the state of the dumped image - it is a basic
> > "restore the image" program, not a "check the validity of the image"
> > program.
> >
> > Secondly, if people are having problems with running log recovery on
> > a restored obfuscated image and getting corruption and not knowing
> > why or what to do, then that is a /documentation and training/
> > problem, not a code problem.
> >
> > i.e. the problem is that people who aren't developers are trying to
> > use tools that were written for developers to do forensic analysis
> > of failures. Don't dumb down the tool for clueless users - point the
> > users at the documentation that the tool requires to use correctly...
> 
> Looking at the patch, that's a lot of code to add to mdrestore that has
> nothing to do with metadump restoration.  For that matter, who's to say
> that the metadump'd image is even an XFS filesystem, and not just some
> garbage with the just the right superblock values to pass the
> perform_restore() checks?  (Ok, ok, that was a little over the top.)
> 

Agreed wrt to the mdrestore bits...

> The key change we're trying to make is to prevent people incorrectly
> replaying an XFS with a dirty log when the fs image has been restored
> from an obfuscated metadump.
> 
> So in my mind this brings up two questions:  First, how do we prevent
> log replay in such situations?  Second, how do we teach people not to
> attempt log replay?  As you point out, it's better that we educate
> people as what problems each tool tries to solve and where the sharp
> edges might be on the debugging tools, but the answer to the first
> question ensures that us fallible developers can't do something stupid
> even though we theoretically know better.
> 
> Frankly, if the goal is to nudge n00b members of support teams away from
> a behavior that won't help them towards starting their failure analysis,
> then then I think we ought to patch the log recovery code to detect an
> obfuscated fs image, complain to dmesg about someone making an illogical
> move, and then refuse to mount the log.
> 

I don't think this is really appropriate. Some users may very well have
no other option but to create a dirty log + obfuscated metadump for
whatever security/privacy reasons they have. The purpose of warning in
that case is to notify the user to either verify the resulting image
shows whatever problems are exhibited by the original fs and no others,
or to notify the developer that other corruption might exist and to
ignore it as a side effect of the metadump process itself (provided it
doesn't interfere with rca of the original problem). Refusing to run log
recovery in such cases just gets in the way.

I'm not tied to having an mdrestore warning at all, but I'd much prefer
to see it there rather than include obfuscation logic in the kernel just
to facilitate a userspace tool to continue on silently corrupting
filesystem images.

Brian

> I'd rather push back on the incorrect behavior at the time it is done,
> instead of training people to ignore a priori warning messages.
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
