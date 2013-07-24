Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D2877F53
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 23:05:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AD0A8F8040
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 21:05:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OayW6RgPY3DycHgm for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 21:05:28 -0700 (PDT)
Date: Wed, 24 Jul 2013 14:05:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: ACL's are a security attribute. They belong in the Security
	attrib space, not the Root-attrib space.
Message-ID: <20130724040525.GQ19986@dastard>
References: <51EEF5C6.3050904@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EEF5C6.3050904@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 23, 2013 at 02:29:42PM -0700, Linda Walsh wrote:
> 
> Currently there are 3 disjoint attribute spaces on files -- user, root and security.
> 
> (there is a misprint in the manual that says there is 2, but later, it gives
> talks about using no switch giving the User attrib space, -R for Root attrib
> space, and -S for the Security attrib space).

You're confusing on-disk formats used to store attributes with
namepaces used to report and access them.  Linux has security,
system, trusted and user namespaces, while on disk XFS has "root",
"secure",  and "user" spaces.

i.e.

Linux attr	XFS on disk
system		root
security	secure
trusted		root
user		user

> Of these, the ACL's are being placed in the root, which might describe
> file types, or other OS related info, but not security attributes like ACL's.
> They should be in the Security attrib space (otherwise what is the point of a
> Security attribute space).

Posix ACLS are defined by the *kernel* to be in the "system"
namespace:

#define POSIX_ACL_XATTR_ACCESS  "system.posix_acl_access"
#define POSIX_ACL_XATTR_DEFAULT "system.posix_acl_default"

IOWs, the Linux *kernel* doesn't consider ACLs to be part of the
security namespace, and so neither does XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
