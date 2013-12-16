Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E48B17F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 21:02:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0794304059
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 19:02:24 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7Z6vpFOr08NBoFgY for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 19:02:19 -0800 (PST)
Date: Mon, 16 Dec 2013 14:02:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: usefulness of  'security attr' being non-copiable on
	discretionary access linux.
Message-ID: <20131216030215.GW31386@dastard>
References: <52A96211.3050602@tlinx.org> <20131212181315.GB20500@samba2>
	<52AAC7CC.8000802@tlinx.org> <20131213105314.GA2117@infradead.org>
	<52AB7CDC.5040801@tlinx.org> <52ADBB00.8050707@tlinx.org>
	<20131215235443.GT31386@dastard> <52AE6364.7010106@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52AE6364.7010106@tlinx.org>
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
To: LA Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Dec 15, 2013 at 06:20:20PM -0800, LA Walsh wrote:
> On 12/15/2013 3:54 PM, Dave Chinner wrote:
> > default on copies or inter-partition moves.
> >
> >So you want users with no privileges to be able to create and
> >modify security context imformation, such as selinux labels,
> >integrity hashes, etc? Really?
> ----
>    If they are running under a non-SElinux system where only
> *discretionary* access
> is used, why not?  It's not like it would do any good.
> >
> >>Shouldn't it follow along and be copied much as are the root namespace
> >>entries?
> >
> >There is no "root" attribute namespace that users can manipulate -
> >there is a "trusted" namespace for root users, but that's not what
> >you are talking about.  The VFS defined name spaces are:
> ----
>    Sorry, I was going by this manpage, shipped by (it looks like)
> Gnu with their
> xattr program:
> 
> XFS uses  2  disjoint  attribute  name  spaces  associated  with  every
> filesystem  object.   They  are  the root and user address spaces.  The
> root address space is accessible only to the superuser, and  then  only
> by  specifying  a flag argument to the function call.  Other users will
> not see or be able to modify attributes in the root address space.  The
> user  address  space is protected by the normal file permissions mecha-
> nism, so the owner of the file can decide who is  able  to  see  and/or
> modify the value of attributes on any particular file.

Note the name of the man page:

ATTR(1) XFS Compatibility API

The fact there is a utility that lets you access the XFS on-disk
xattr space does not mean other tools actually access those
namespaces directly.

Indeed, have you looked at what attr does when it writes an
attribute into the "root" namespace in XFS?

$ sudo strace attr -R -s blah -V grotfuddink foo
....
lsetxattr("foo", "trusted.blah", "grotfuddink", 11, 0) = 0
....

It writes it into the "trusted" VFS xattr namespace which means it
knows *nothing* about how XFS stores it's xattrs on disk.

> >	- user
> >	- security
> >	- trusted (requires CAP_SYS_ADMIN)
> >	- system
> ----
>    Doesn't security also require CAP_SYS_ADMIN?

I've already answered that question:

> >Hence, cp as a user cannot copy trusted xattrs and certain security
> >attributes as a matter of principle, and some security modules only
> >allow security xattr write permission to CAP_SYS_ADMIN (e.g.
> >selinux), and hence cp as a user cannot read and/or write these
> >xattrs to put them on the newly copied file.
> -----
>    I'm running with the "default" security (Discretionary -
> mode bits + access lists + cap bits slowly supplanting need for root.

So, did you turn the distro default selinux config off?

> >permissions that are enforced by layers above it...
> >
> >>It gets really confusing if a "proxy service" (ex. file server)
> >>for the user, stores attributes in that namespace thinking they will
> >>somehow be useful when the user accesses the file w/o the proxy service --
> >>i.e. as a normal file.
> >
> >That's never worked. xattrs are only meaningful to the application
> >that created them.
> ----
> NT attrs that are stored on a file server, _natively_ are the same
> as local attrs.  Samba has traditionally tried to map as much of the
> NT acl -> the native acl.  In this particular instance, an
> unprivileged user (me) saved a file to their home directory.  Then as
> an unprivileged user, I couldn't move the file without saving the NT
> ACL -- which would still be desired (or needed) on any other exported
> NT partition.

You missed what I said completely. You didn't create the NT attr,
Samba did it on your behalf. Samba - the aplication that owns the
xattr - has higher privileges than you do, and so it can do things
you can't. Like manage attributes in the security namespace.

> I feel it is a a problem if a normal user can both create the ACL's
> when accessing the share over samba but cannot directly move or create
> such ACL's. 

Just because you own the file, it doesn't mean you own or can access
all the xattrs on it the file.

> >Access to the security xattr namespace is entirely controlled by the
> >kernel security modules. If you want to use that namespace, you have
> >to follow whatever rules your currently loaded security module
> >enforces. That, in general, means that the only thing you can
> >guarantee is that the security xattr namespace requires
> >CAP_SYS_ADMIN for write access.
> It also appears the system namespace isn't visible unless you have
> that CAP set.  I.e. the manpage is correct in this regard.
> 
> ====
> As I tried to make clear -- this is a new behavior I'm seeing.  I've never
> had attrs on my files that I, as the file 'owner' couldn't move around
> to permitted locations.  As it is an ACL, my feeling is it should be
> stored in the same way the posix acls are -- which are copyable.

Then something above the filesystem has changed. We haven't changed
anything to do with who or how xattrs are stored or used in XFS for
a long time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
