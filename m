Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C21527F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 17:12:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94F6F304051
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 15:12:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	05pQ3wUs5UJBuP7n for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 15:12:13 -0700 (PDT)
Date: Fri, 21 Jun 2013 08:12:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130620221203.GU29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com> <51C31F48.9070503@redhat.com>
	<20130620133903.5193d3ee@oracle.com> <51C35410.2040109@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C35410.2040109@redhat.com>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Thu, Jun 20, 2013 at 03:12:16PM -0400, Brian Foster wrote:
> On 06/20/2013 01:39 PM, Dwight Engen wrote:
> > On Thu, 20 Jun 2013 11:27:04 -0400
> > Brian Foster <bfoster@redhat.com> wrote:
> > 
> >> On 06/20/2013 09:54 AM, Dwight Engen wrote:
> >>> On Thu, 20 Jun 2013 10:13:41 +1000
> >>> Dave Chinner <david@fromorbit.com> wrote:
> >>>
> >>>> On Wed, Jun 19, 2013 at 11:09:48AM -0400, Dwight Engen wrote:
> ...
> >>
> >> Hi Dwight,
> >>
> >> If I understand correctly, the proposition is to turn
> >> XFS_EOF_FREE_EOFBLOCKS into administrator only functionality and run
> >> ns conversions on the inode uid/gid and associated eofb values for
> >> the ID filtering functionality.
> > 
> > Hi Brian, yeah that was the proposal :) I think there are really two
> > issues here. One is that the uid_t/gid_t may come from a userns so we
> > should be aware of that. Currently the ids passed in are used for
> > *filtering* so a malicious user can't do anything more than they
> > already can by not passing ids at all, but we should fix this so only
> > the intended files are affected. Second is that currently the ioctl
> > allows an unprivileged user to affect another user (as Eric pointed
> > out):
> > 
> >> I am little dubious about XFS_IOC_FREE_EOFBLOCKS allowing any
> >> user to affect any other user.  Your changes just seem to make
> >> it guaranteed that when called from a user namespace the wrong
> >> user will be affected.
> > 
> > I don't think the nsown_capability() I proposed is enough to take care
> > of this. Do you agree that if the caller is going to affect other
> > users, they should be CAP_SYS_ADMIN (or maybe CAP_FOWNER) in
> > init_user_ns?
> > 
> 
> Yeah, that's what I was getting at below by restricting "global" scans
> to admin privilege.

Project quota scans are global scans, so user-based initiation
through ioctls they should always be restricted to CAP_SYS_ADMIN.

> >> The latter sounds reasonable to me, though I'm not so sure about the
> >> CAP_SYS_ADMIN bit. For example, I think we'd expect a regular user to
> >> be able to run an eofblocks scan against files covered under his
> >> quota.
> >>
> >> Perhaps the right thing to do here is to restrict global (and project
> >> quota?) scans to CAP_SYS_ADMIN and uid/gid based scans to processes
> >> with the appropriate permissions (i.e., CAP_SYS_ADMIN, matching
> >> uid/gid or CAP_FOWNER). Thoughts?
> > 
> > That sounds good to me. Maybe for a regular user the appropriate
> > permission check (at the top of xfs_inode_free_eofblocks()) could be
> > something like:
> > 
> 
> I think the various capability/permission checks should be in the ioctl
> code.

Yes, the cap/perm checks should be done before anything else in
the ioctl.

> This would still allow use cases such as the pending code I have that
> invokes an eofblocks scan on write() failure due to EDQUOT/ENOSPC in the
> case of project or user/group quotas.

Right, we have to ensure this can occur without namespace
restriction, because ENOSPC is not something that is bound by user
namespaces.

> I suspect adding the namespace
> conversion stuff wouldn't break the typical user/group quota case, but

For EDQUOT, no, but for a global ENOSPC scan I think it could cause
problems.

> we'd still require the ability to run a project quota scan from a
> particular user context.  I think the combined check you have
> above would break that.

Yup, that still needs to work, as does the background scanner which
should not be subject to any restrictions at all ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
