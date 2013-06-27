Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2E137F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:58:01 -0500 (CDT)
Date: Thu, 27 Jun 2013 15:57:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130627205758.GQ20932@sgi.com>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130626173017.5100327a@oracle.com>
	<20130626224410.GB28426@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130626224410.GB28426@dastard>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

Hey,

On Thu, Jun 27, 2013 at 08:44:10AM +1000, Dave Chinner wrote:
> On Wed, Jun 26, 2013 at 05:30:17PM -0400, Dwight Engen wrote:
> > On Wed, 26 Jun 2013 12:09:24 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > > On Mon, Jun 24, 2013 at 09:10:35AM -0400, Dwight Engen wrote:
> > > > Should we just require that callers of bulkstat
> > > > be in init_user_ns? Thoughts?
> > > 
> > > This is one of the reasons why I want Eric to give us some idea of
> > > how this is supposed to work - exactly how is backup and restore
> > > supposed to be managed on a shared filesystem that is segmented up
> > > into multiple namespace containers? We can talk about the
> > > implementation all we like, but none of us have a clue to the policy
> > > decisions that users will make that we need to support. Until we
> > > have a clear idea on what policies we are supposed to be supporting,
> > > the implementation will be ambiguous and compromised.
> > > 
> > > e.g. If users are responsible for it, then bulkstat needs to filter
> > > based on the current namespace. If management is responsible (i.e.
> > > init_user_ns does backup/restore of ns-specific subtrees), then
> > > bulkstat cannot filter and needs to reject calls from outside the
> > > init_user_ns().
> > 
> > Maybe we can have bulkstat always filter based on if the caller
> > kuid_has_mapping(current_user_ns(), inode->i_uid)? That way a caller
> > from init_user_ns can see them all, but callers from inside a userns
> > will get a subset of inodes returned?
> 
> We could do that, though it means bulkstat is going to be a *lot
> slower* when called from within a user namespace environment. A
> namespace might only have a few thousand files for backup, yet the
> underlying filesystem might have tens of millions of inodes in it.
> The bulkstat call now has to walk all of the inodes just to find the
> few thousand that match the filter. And multiply that by the number
> of namespaces all doing backups at 3am in the morning and you start
> to get an idea of the scope of the problem....

Ugh.  That really doesn't map well onto bulkstat.  If we wanted bulkstat to
work well with namespaces, we might have to teach the filesystem a bit more
about them in order to create the required indices per namespace.  While a
filter might get the job done in a pinch, wouldn't you really rather have an
inobt?  ;)

To build that inobt you'd have to know whether a given directory was the root
of a new namespace.  Maybe implementable as some kind of flag, 'everything
below this dir is part of its own namespace, put it in this inobt'.  And then
you'd have to have a way for bulkstat to know to look there, e.g. if the caller
is not in init_user_ns and if the initial inode had the flag, use the inobt on
that initial inode for bulkstat instead of the regular inobts.  Crazy.  Could
be done.

Initially, requiring bulkstat callers to be in init_user_ns is ok.  It just
doesn't suit everyone's needs..

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
