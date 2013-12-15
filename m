Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 662DE7F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 17:55:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ECB0CAC002
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 15:55:05 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vOsPb5SlZEEXazsY for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 15:55:03 -0800 (PST)
Date: Mon, 16 Dec 2013 10:54:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BTW - to xfs folk, 'security attr' doesn't seem very useful
	w/current copy policies
Message-ID: <20131215235443.GT31386@dastard>
References: <52A96211.3050602@tlinx.org> <20131212181315.GB20500@samba2>
	<52AAC7CC.8000802@tlinx.org> <20131213105314.GA2117@infradead.org>
	<52AB7CDC.5040801@tlinx.org> <52ADBB00.8050707@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52ADBB00.8050707@tlinx.org>
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
To: "L.A. Walsh" <samba@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Dec 15, 2013 at 06:21:52AM -0800, L.A. Walsh wrote:
> 
> 
> On 12/13/2013 1:32 PM, L.A. Walsh wrote:
> >On 12/13/2013 2:53 AM, Christoph Hellwig wrote:
> >> On Fri, Dec 13, 2013 at 12:39:40AM -0800, L.A. Walsh wrote:
> >>  >>    Does it have to be under a "namespace" that gets
> >*stripped*
> >>> as soon as the file is copied or "mv'd to another
> >>> samba share (i.e. the partition it was moved to is shared with the
> >>> same permissions as the first one.
> >>
> >> Attributes never get "stripped", they simple don't get copied unless
> >> explicit action is taken to do so.  Setting trusted attributes up on a
> >> new file will of course rely privilegues, exactly for the reasons
> >> Jeremy pointed out.
> -----
> For what purpose?  As it stands the security namespace doesn't seem
> very useful -- i.e. the 'root' attrs get copied and/or moved on a file
> copy/rename which carries the access along with the file contents.
> 
> But I fail to see the usefulness in having a security namespace that
> is dropped by default on copies or inter-partition moves.

So you want users with no privileges to be able to create and
modify security context imformation, such as selinux labels,
integrity hashes, etc? Really?

> Shouldn't it follow along and be copied much as are the root namespace
> entries?

There is no "root" attribute namespace that users can manipulate -
there is a "trusted" namespace for root users, but that's not what
you are talking about.  The VFS defined name spaces are:

	- user
	- security
	- trusted (requires CAP_SYS_ADMIN)
	- system

All of the other xattrs fall into these groups. e.g. posix acls:

	- system.posix_acl_access
	- system.posix_acl_default

What you are doing is conflating how XFS stores xattrs on disk with
user visible xattr namespaces. The two are not the same thing. The
VFS enforces access to the "trusted" namespace and posix ACLs,
security modules enforce access to their own attributes and
potentially restrict access to the entire security namespace.
Whatever remains is left up to the filesystem to decide access
rules.


Hence, cp as a user cannot copy trusted xattrs and certain security
attributes as a matter of principle, and some security modules only
allow security xattr write permission to CAP_SYS_ADMIN (e.g.
selinux), and hence cp as a user cannot read and/or write these
xattrs to put them on the newly copied file.

IOWs, how XFS stores them on disk is irrelevant to access
permissions that are enforced by layers above it...

> It gets really confusing if a "proxy service" (ex. file server)
> for the user, stores attributes in that namespace thinking they will
> somehow be useful when the user accesses the file w/o the proxy service --
> i.e. as a normal file.

That's never worked. xattrs are only meaningful to the application
that created them. Trying to manipulate those xattrs as a user
outside the context of the application is almost always going to
fail when special permissions are required by the application to
manipulate those xattrs.

> Was there a specific use-case for being able to tag files with security
> attrs that can't be copied, moved or renamed except by root that wouldn't
> better be served by signed or 'sealed' (encrypted) content?  For most
> cases, it would seem that signing to detect tampering would be enough,
> though I can think of cases where sealing to prevent knowledge of
> who has what access would also be useful.
> 
> Something to think about before others try to use the security field to
> store attrs they want kept with the content and not the inode.

Access to the security xattr namespace is entirely controlled by the
kernel security modules. If you want to use that namespace, you have
to follow whatever rules your currently loaded security module
enforces. That, in general, means that the only thing you can
guarantee is that the security xattr namespace requires
CAP_SYS_ADMIN for write access.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
