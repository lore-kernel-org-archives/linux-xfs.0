Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C32627F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 20:20:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ABD468F804B
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 18:20:26 -0800 (PST)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id aBr5Rxf7LQykAbRG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 18:20:24 -0800 (PST)
Message-ID: <52AE6364.7010106@tlinx.org>
Date: Sun, 15 Dec 2013 18:20:20 -0800
From: LA Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: usefulness of 'security attr' being non-copiable on discretionary
	access linux.
References: <52A96211.3050602@tlinx.org> <20131212181315.GB20500@samba2>
	<52AAC7CC.8000802@tlinx.org> <20131213105314.GA2117@infradead.org>
	<52AB7CDC.5040801@tlinx.org> <52ADBB00.8050707@tlinx.org>
	<20131215235443.GT31386@dastard>
In-Reply-To: <20131215235443.GT31386@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 12/15/2013 3:54 PM, Dave Chinner wrote:
>  default on copies or inter-partition moves.
>
> So you want users with no privileges to be able to create and
> modify security context imformation, such as selinux labels,
> integrity hashes, etc? Really?
----
    If they are running under a non-SElinux system where only 
*discretionary* access
is used, why not?  It's not like it would do any good.
>
>> Shouldn't it follow along and be copied much as are the root namespace
>> entries?
>
> There is no "root" attribute namespace that users can manipulate -
> there is a "trusted" namespace for root users, but that's not what
> you are talking about.  The VFS defined name spaces are:
----
    Sorry, I was going by this manpage, shipped by (it looks like) Gnu 
with their
xattr program:

XFS uses  2  disjoint  attribute  name  spaces  associated  with  every
filesystem  object.   They  are  the root and user address spaces.  The
root address space is accessible only to the superuser, and  then  only
by  specifying  a flag argument to the function call.  Other users will
not see or be able to modify attributes in the root address space.  The
user  address  space is protected by the normal file permissions mecha-
nism, so the owner of the file can decide who is  able  to  see  and/or
modify the value of attributes on any particular file.


>
> 	- user
> 	- security
> 	- trusted (requires CAP_SYS_ADMIN)
> 	- system
----
    Doesn't security also require CAP_SYS_ADMIN?


>
> All of the other xattrs fall into these groups. e.g. posix acls:
>
> 	- system.posix_acl_access
> 	- system.posix_acl_default
>
> What you are doing is conflating how XFS stores xattrs on disk with
> user visible xattr namespaces. The two are not the same thing.
----
    That's fine -- the virtual model != the physical model -- just like 
in almost every
other area.  ;-)

>  The
> VFS enforces access to the "trusted" namespace and posix ACLs,
> security modules enforce access to their own attributes and
> potentially restrict access to the entire security namespace.
> Whatever remains is left up to the filesystem to decide access
> rules.
>
>
> Hence, cp as a user cannot copy trusted xattrs and certain security
> attributes as a matter of principle, and some security modules only
> allow security xattr write permission to CAP_SYS_ADMIN (e.g.
> selinux), and hence cp as a user cannot read and/or write these
> xattrs to put them on the newly copied file.
-----
    I'm running with the "default" security (Discretionary -
mode bits + access lists + cap bits slowly supplanting need for root.



>
> IOWs, how XFS stores them on disk is irrelevant to access
> permissions that are enforced by layers above it...
>
>> It gets really confusing if a "proxy service" (ex. file server)
>> for the user, stores attributes in that namespace thinking they will
>> somehow be useful when the user accesses the file w/o the proxy service --
>> i.e. as a normal file.
>
> That's never worked. xattrs are only meaningful to the application
> that created them. 
----
NT attrs that are stored on a file server, _natively_ are the same
as local attrs.  Samba has traditionally tried to map as much of the
NT acl -> the native acl.  In this particular instance, an
unprivileged user (me) saved a file to their home directory.  Then as
an unprivileged user, I couldn't move the file without saving the NT
ACL -- which would still be desired (or needed) on any other exported
NT partition. 

I feel it is a a problem if a normal user can both create the ACL's
when accessing the share over samba but cannot directly move or create
such ACL's.  It it is like Windows, I could probably mount it via a 
loopback, and using the file system presented by samba and mounted
with CIFS (untested), but a user on a client (remote or local) should
have consistent access to the ACL that is stored on the file so they
can move, copy it or back it up.


> Trying to manipulate those xattrs as a user
> outside the context of the application is almost always going to
> fail when special permissions are required by the application to
> manipulate those xattrs.
-----
    They don't on NT-servers.  The native OS ACLS are pretty
much the same.  If I have an ACL on the file and move it, it
goes with the file.  Of course if the file is using a directory
default ACL, it gets whatever it gets in the new dir.

    File sensitivity flags are stored on NT to flag possibly unsafe
material (downloaded material from general internet, for example).

    The user can't set those labels directly, but they do get moved
by the system if the user moves or copies the file.


> Access to the security xattr namespace is entirely controlled by the
> kernel security modules. If you want to use that namespace, you have
> to follow whatever rules your currently loaded security module
> enforces. That, in general, means that the only thing you can
> guarantee is that the security xattr namespace requires
> CAP_SYS_ADMIN for write access.
It also appears the system namespace isn't visible unless you have that 
CAP set.  I.e. the manpage is correct in this regard.

====
As I tried to make clear -- this is a new behavior I'm seeing.  I've never
had attrs on my files that I, as the file 'owner' couldn't move around
to permitted locations.  As it is an ACL, my feeling is it should be
stored in the same way the posix acls are -- which are copyable.






_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
