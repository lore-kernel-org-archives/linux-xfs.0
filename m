Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 331137CA1
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:18:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D68858F8033
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 08:18:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mmYuhUapb8Rok0Jo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 08:18:30 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B22F364D1D
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 15:18:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-205.bos.redhat.com [10.18.41.205])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u45FITtb007147
	for <xfs@oss.sgi.com>; Thu, 5 May 2016 11:18:29 -0400
Date: Thu, 5 May 2016 11:18:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V3]
Message-ID: <20160505151827.GA1523@bfoster.bfoster>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<20160505141107.GG1231@bfoster.bfoster>
	<20160505143718.GB9359@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160505143718.GB9359@redhat.com>
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

On Thu, May 05, 2016 at 04:37:18PM +0200, Carlos Maiolino wrote:
> On Thu, May 05, 2016 at 10:11:07AM -0400, Brian Foster wrote:
> > On Wed, May 04, 2016 at 05:43:13PM +0200, Carlos Maiolino wrote:
> > > This is the new revision of this patchset, according to last comments.
> > > 
> > > This patchset is aimed to implement a configurable error behavior in XFS, and
> > > most of the design has been done by Dave, so, that's why I kept his signed-off
> > > in the patches.
> > > 
> > > This new revision has the detailed changelog written on each patch, but the
> > > major changes are:
> > > 
> > > 	- Detailed changelog by-patch and description fixed to become
> > > 	  (hopefuly) more clear
> > > 	- kept fail_at_unmount as a sysfs attribute
> > > 
> > > 
> > > Regarding fail_at_unmount, I left it almost exactly as Dave's design, giving his
> > > comments on the last revision, although, I still think there is no need to keep
> > > it as a per-error granularity, so, I was wondering if a single, global option in
> > > /sys/fs/xfs/<dev>/error/fail_at_unmount wouldn't suffice, but, this will require
> > > a new place to store the value inside kernel, instead of keeping it inside
> > > struct xfs_error_cfg, or maybe use the same structure but use it outside of the
> > > m_error_cfg array?
> > > 
> > 
> > I agree with regard to the granularity of fail_at_unmount. This was
> > brought up previously:
> > 
> > http://oss.sgi.com/archives/xfs/2016-02/msg00558.html
> > 
> > ... and I haven't heard a use case for per-error granularity.
> 
> Hi, yes, my comment was based on our previous discussion, my apologies to not
> have made it clear.
> 

Ok..

> > 
> > I suggest just to pull it out of the error classification stuff entirely
> > and place it under xfs_mount. E.g., at the same level as "fail_writes"
> > (but not a DEBUG mode only option).
> > 
> > I'm also wondering whether we need more mechanism for the
> > fail_at_unmount behavior. For example, instead of defining
> > XFS_MOUNT_UNMOUNTING, could we just call a function that resets
> > max_retries (of each class) to 0 in the unmount path? Then maybe call
> > the mount tunable retry_on_unmount or something like that. Thoughts?
> > 
> I don't oppose to that, although, having a flag like XFS_MOUNT_UNMOUNTING, might
> be useful in the future, but still, wouldn't be better this single flag, instead
> of walk through all classes/errors resetting the max_retries? It sounds as
> granular as having fail_at_unmount inside each error, despite the fact it's not
> exposed to user-space, we will need to interact over each max_retries to
> actually shutdown the filesystem during unmount, which, is also error-prone
> IMHO.

I view the granularity problem as a usability problem, not necessarily a
code problem. E.g., why would somebody know or care to configure certain
errors to fail on unmount but not others. If we have a knob, I think the
knob is more clear as a general behavior knob rather than an error
classification knob. Of course, that assumes there isn't some unknown
good reason for per-error behavior (and/or a userspace mgmt tool that
could provide a more usable interface on top of per-error knobs).

> It also depends on how granular we will implement fail_at_unmount. If it's a
> single global option, resetting all max_retries works, otherwise it might not
> work, for example, if we decide to have fail_at_unmount for each class, we might
> need to reset max_retries only in specific errors, which will increase the
> complexity of the code.
> 

I'm assuming a per-mount option is sufficient. :) Otherwise, I'm just
thinking out loud for ways to try and condense and/or reuse the code a
bit here. I don't see a reason to add new mechanisms or config tunables
in cases where we can accomplish the same thing by making existing
knobs/mechanisms sufficiently generic.

Sure, the code might be slightly more complex (or maybe some of the
existing code can be refactored to support a reinit) and it might
introduce the issue of unmount racing against sysfs knob updates. The
tradeoff is that it reuses an existing mechanism, for what that's worth.
Just an idea, though. ;)

Brian

> Well, hope my comments make sense, just giving my $0.02 :)
> 
> cheers
> 
> > Brian
> > 
> > > First 6 patches are ready, the fail_at_unmount one, need to be re-worked if we
> > > want it in a less granular way, but until now I don't think we reached any
> > > decision about how it should be implemented.
> > > 
> > >  fs/xfs/xfs_buf.h      |  22 ++++
> > >  fs/xfs/xfs_buf_item.c | 126 ++++++++++++++--------
> > >  fs/xfs/xfs_mount.c    |  19 +++-
> > >  fs/xfs/xfs_mount.h    |  32 ++++++
> > >  fs/xfs/xfs_sysfs.c    | 283 +++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  fs/xfs/xfs_sysfs.h    |   3 +
> > >  6 files changed, 437 insertions(+), 48 deletions(-)
> > > 
> > > -- 
> > > 2.4.11
> > > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
