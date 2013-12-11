Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AEA797FAB
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:15:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49F50AC011
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 16:15:12 -0800 (PST)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id y1M9ZMUqaoKbnehh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 16:15:10 -0800 (PST)
Message-ID: <52A7AE8A.1080408@tlinx.org>
Date: Tue, 10 Dec 2013 16:15:06 -0800
From: LA Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: where/how is 'xattr' type=security enforced? (security attr
	stripped?)
References: <52A65AD5.9070705@tlinx.org> <20131210055213.GD31386@dastard>
In-Reply-To: <20131210055213.GD31386@dastard>
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
To: Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>

On 12/9/2013 9:52 PM, Dave Chinner wrote:
> You need root permissions to set security namespace attributes.
----
I knew that about the root namespace, but the security namespace
isn't as well documented.

I'd *hoped* for something that made 'sense' -- like the owner
being able to set/change, at least some of them, like mode bits.

I know this isn't a problem, actually "in XFS", but more
in how it is used.  Thinking out loud...if you'll bare
w/me:

Since it's an NTACL, on a file created and owned me, in
a directory that I 'own' the ACL for (as I'm the owner
of the file and the dir it is in), it seems Samba is trying
to follow NT rules in placing the ACL w/the file.

But then the linux utils come along and change the rules
and   strip off the NT-ACL,  when the file is copied or
when it is moved to a different partition (also XFS).

What about the posix ACL's?  Aren't they in the security
section as well?  Do they get stripped off whenever
a copy is made or the file is moved to another XFS
file system?

The NTACL was set on the file because it inherited permissions
under 'NT' rules.  Shouldn't I be able to copy or move the
file (presuming I am the owner and directory owner, etc..).
What about posix ACL's?

It seems to me, that the security section of an ACL should be
(assuming you have the normal, discretionary access system
on linux), should be movable and settable by the file owner.

Under a different security setup (say with mandatory access
rules -- like under SMACK or Flask) it would be a different
matter, but it seems a bit odd to be stripping ACL's from
a file just because it is copied/moved...


> [ On a side note, there's some sooper seekrit voodoo ....
yeah, vaguely remember that...

FWIW -- I've never seen a message like I'm getting now...
so don't know if it is a change in Samba/coreutils or the
kernel (all of which have changed recently in installing
a new suse release for most things)...


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
