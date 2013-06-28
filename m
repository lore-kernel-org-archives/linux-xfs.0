Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F031D7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:15:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5CA18F804B
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:15:32 -0700 (PDT)
Date: Fri, 28 Jun 2013 10:15:19 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130628151519.GA26841@sergelap>
References: <20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130626173017.5100327a@oracle.com>
	<20130626224410.GB28426@dastard> <20130627205758.GQ20932@sgi.com>
	<20130628014658.GF32195@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130628014658.GF32195@dastard>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Ben Myers <bpm@sgi.com>, Dwight Engen <dwight.engen@oracle.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Quoting Dave Chinner (david@fromorbit.com):
> On Thu, Jun 27, 2013 at 03:57:58PM -0500, Ben Myers wrote:
> > Hey,
> > 
> > On Thu, Jun 27, 2013 at 08:44:10AM +1000, Dave Chinner wrote:
> > > On Wed, Jun 26, 2013 at 05:30:17PM -0400, Dwight Engen wrote:
> > > > On Wed, 26 Jun 2013 12:09:24 +1000
> > > > Dave Chinner <david@fromorbit.com> wrote:
> > > > > On Mon, Jun 24, 2013 at 09:10:35AM -0400, Dwight Engen wrote:
> > > > > > Should we just require that callers of bulkstat
> > > > > > be in init_user_ns? Thoughts?
> > > > > 
> > > > > This is one of the reasons why I want Eric to give us some idea of
> > > > > how this is supposed to work - exactly how is backup and restore
> > > > > supposed to be managed on a shared filesystem that is segmented up
> > > > > into multiple namespace containers? We can talk about the
> > > > > implementation all we like, but none of us have a clue to the policy
> > > > > decisions that users will make that we need to support. Until we
> > > > > have a clear idea on what policies we are supposed to be supporting,
> > > > > the implementation will be ambiguous and compromised.
> > > > > 
> > > > > e.g. If users are responsible for it, then bulkstat needs to filter
> > > > > based on the current namespace. If management is responsible (i.e.
> > > > > init_user_ns does backup/restore of ns-specific subtrees), then
> > > > > bulkstat cannot filter and needs to reject calls from outside the
> > > > > init_user_ns().
> > > > 
> > > > Maybe we can have bulkstat always filter based on if the caller
> > > > kuid_has_mapping(current_user_ns(), inode->i_uid)? That way a caller
> > > > from init_user_ns can see them all, but callers from inside a userns
> > > > will get a subset of inodes returned?
> > > 
> > > We could do that, though it means bulkstat is going to be a *lot
> > > slower* when called from within a user namespace environment. A
> > > namespace might only have a few thousand files for backup, yet the
> > > underlying filesystem might have tens of millions of inodes in it.
> > > The bulkstat call now has to walk all of the inodes just to find the
> > > few thousand that match the filter. And multiply that by the number
> > > of namespaces all doing backups at 3am in the morning and you start
> > > to get an idea of the scope of the problem....
> > 
> > Ugh.  That really doesn't map well onto bulkstat.  If we wanted bulkstat to
> > work well with namespaces, we might have to teach the filesystem a bit more
> > about them in order to create the required indices per namespace.  While a
> > filter might get the job done in a pinch, wouldn't you really rather have an
> > inobt?  ;)

Eric's intent was to map uids at the kernel-user boundary.  At the
syscall.  Just as if you send credentials over a unix socket which
crosses pid and user ns, the ucred.pid, ucred.uid and ucred.gid get
converted to valid values for the recipient.

The filesystem is kernel code.  It should only ever deal with the
kuids.  If a process stat()s a file, it should see uids mapped into
its own userns, or overflowuid if not mapped.

I'm not saying I know what to do with bulkstat, but I'm pretty sure
that teaching the filesystem about namespaces would be wrong.

It sounds to me like only allowing bulkstat from the init_user_ns
makes the most sense.  Short term, and quite likely long term.

> Absolutely not. :/
> 
> Filesystems can be bind mounted into multiple namespaces, you can
> hard link across namespace boundaries, you can do all sorts of
> things that result in inodes being shared between namespaces. You
> can't have a per-namespace inobt when you can do this sort of thing
> that the underlying filesystem many not even be aware of. Hell, you
> can have the init namespace manipulate files for the user namespace,
> and those manipulations aren't even aware they are happening inside
> a namespace.

They're not happening in a namespace.  All the uids in the namespace
are mapped to uids in the init ns.  So if you're doing something in
the init_user_ns, whatever changes you make should simply be properly
reflected in the container.  If you end up chowning a file which
was previously owned by a userid mapped into the container, to a uid
which is not mapped into the container, then inside the container you'll
see the overflowuid after the chown.  Just as you would if you looked
at a host-owned file to begin with.

-serge

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
