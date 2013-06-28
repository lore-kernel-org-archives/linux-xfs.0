Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 33A067F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 20:47:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0DD5AC007
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 18:47:06 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LU7MsKaWNCxGwKqa for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 18:47:04 -0700 (PDT)
Date: Fri, 28 Jun 2013 11:46:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130628014658.GF32195@dastard>
References: <20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130626173017.5100327a@oracle.com>
	<20130626224410.GB28426@dastard> <20130627205758.GQ20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130627205758.GQ20932@sgi.com>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Thu, Jun 27, 2013 at 03:57:58PM -0500, Ben Myers wrote:
> Hey,
> 
> On Thu, Jun 27, 2013 at 08:44:10AM +1000, Dave Chinner wrote:
> > On Wed, Jun 26, 2013 at 05:30:17PM -0400, Dwight Engen wrote:
> > > On Wed, 26 Jun 2013 12:09:24 +1000
> > > Dave Chinner <david@fromorbit.com> wrote:
> > > > On Mon, Jun 24, 2013 at 09:10:35AM -0400, Dwight Engen wrote:
> > > > > Should we just require that callers of bulkstat
> > > > > be in init_user_ns? Thoughts?
> > > > 
> > > > This is one of the reasons why I want Eric to give us some idea of
> > > > how this is supposed to work - exactly how is backup and restore
> > > > supposed to be managed on a shared filesystem that is segmented up
> > > > into multiple namespace containers? We can talk about the
> > > > implementation all we like, but none of us have a clue to the policy
> > > > decisions that users will make that we need to support. Until we
> > > > have a clear idea on what policies we are supposed to be supporting,
> > > > the implementation will be ambiguous and compromised.
> > > > 
> > > > e.g. If users are responsible for it, then bulkstat needs to filter
> > > > based on the current namespace. If management is responsible (i.e.
> > > > init_user_ns does backup/restore of ns-specific subtrees), then
> > > > bulkstat cannot filter and needs to reject calls from outside the
> > > > init_user_ns().
> > > 
> > > Maybe we can have bulkstat always filter based on if the caller
> > > kuid_has_mapping(current_user_ns(), inode->i_uid)? That way a caller
> > > from init_user_ns can see them all, but callers from inside a userns
> > > will get a subset of inodes returned?
> > 
> > We could do that, though it means bulkstat is going to be a *lot
> > slower* when called from within a user namespace environment. A
> > namespace might only have a few thousand files for backup, yet the
> > underlying filesystem might have tens of millions of inodes in it.
> > The bulkstat call now has to walk all of the inodes just to find the
> > few thousand that match the filter. And multiply that by the number
> > of namespaces all doing backups at 3am in the morning and you start
> > to get an idea of the scope of the problem....
> 
> Ugh.  That really doesn't map well onto bulkstat.  If we wanted bulkstat to
> work well with namespaces, we might have to teach the filesystem a bit more
> about them in order to create the required indices per namespace.  While a
> filter might get the job done in a pinch, wouldn't you really rather have an
> inobt?  ;)

Absolutely not. :/

Filesystems can be bind mounted into multiple namespaces, you can
hard link across namespace boundaries, you can do all sorts of
things that result in inodes being shared between namespaces. You
can't have a per-namespace inobt when you can do this sort of thing
that the underlying filesystem many not even be aware of. Hell, you
can have the init namespace manipulate files for the user namespace,
and those manipulations aren't even aware they are happening inside
a namespace.

That doesn't even begin to touch on the major problems it introduces
into the on-disk format. e.g. how do you find, manage and validate
abitrarily rooted allocated inode btrees. What AG do you put them
in? What happens when you have inodes in multiple AGs in a single
namespace? One tree per AG per namespace? What happens when you have
10000 namespaces and 1000 AGs?  How do we find the right inobt(s)
when we do an allocation - they aren't in the AGI anymore? How do we
walk then on mount after an unclean shutdown? How do we allocate and
remove trees? What the hell is repair supposed to do with
corrupt/lost inode btrees?

It's a rats nest, and it doesn't solve the basic problem of how
utilities that use bulkstat are supposed to behave.

> To build that inobt you'd have to know whether a given directory was the root
> of a new namespace.  Maybe implementable as some kind of flag, 'everything
> below this dir is part of its own namespace, put it in this inobt'.  And then
> you'd have to have a way for bulkstat to know to look there, e.g. if the caller
> is not in init_user_ns and if the initial inode had the flag, use the inobt on
> that initial inode for bulkstat instead of the regular inobts.  Crazy.  Could
> be done.

And I could fly to the moon, too. But like per-namespace inode
btrees, I don't see ever happening either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
