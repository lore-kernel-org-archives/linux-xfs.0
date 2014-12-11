Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC47429DF7
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 08:50:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA4548F8033
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 06:50:12 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id o7VaFspfOGMS8YyB
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Dec 2014 06:50:11 -0800 (PST)
From: "Meij, Henk" <hmeij@wesleyan.edu>
Subject: RE: xfs_quota off/remove
Date: Thu, 11 Dec 2014 14:50:06 +0000
Message-ID: <8688BD11DAC0574AA90295127E9E9F4AC04DDFEE@exchangewes8.wesad.wesleyan.edu>
References: <8688BD11DAC0574AA90295127E9E9F4AC04DD4FF@exchangewes8.wesad.wesleyan.edu>
	<5488ADDD.404@gmail.com>
	<20141210204707.GC24183@dastard>,<5488B704.2040602@gmail.com>
In-Reply-To: <5488B704.2040602@gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Michael L. Semon" <mlsemon35@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

ah, thank you all, this is one of those light bulb moments, the sequence below

-c "off" -c "remove" is followed by migration of said share to new partition
then the remount happens (with quotas on for other shares)

and now the metadata for migrated share does not show up. 

-Henk

________________________________________
From: Michael L. Semon [mlsemon35@gmail.com]
Sent: Wednesday, December 10, 2014 4:11 PM
To: Dave Chinner
Cc: Meij, Henk; xfs@oss.sgi.com
Subject: Re: xfs_quota off/remove

On 12/10/14 15:47, Dave Chinner wrote:
> On Wed, Dec 10, 2014 at 03:32:29PM -0500, Michael L. Semon wrote:
>> On one hand, the man page for xfs_quota states for "off":  "Permanently
>> switches quota off for the filesystem identified by the current path.
>> Quota can only be switched back on subsequently by unmounting and then
>> mounting again."
>
> The *only* method for turning on quotas on XFS on is to mount the filesystem
> with the appropriate mount options. You can turn them off in an on-line
> fashion by running the "off" command, but you also need to remove
> the mount options from the next mount, otherwise that turns them
> back on.
>
> If the word "permanently" is the problem, send a patch for th eman
> page that explains it properly.
>
> Cheers,
>
> Dave.

Thanks, Dave.  You, Mark, Eric, and Brian are superior to me at wording.
But here's my shot at it...

Thanks!

Michael

>From 51a3d00b134b72c095c1d4ec42ec619ddf4388bc Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Wed, 10 Dec 2014 15:58:10 -0500
Subject: [PATCH] xfsprogs: clarify wording for xfs_quota off command

The xfs_quota "off" command claims to permanently shut off quotas, but
then reminds the user that they can be turned on again by unmounting
and mounting the filesystem again.  It's the kind of permanent that
is not permanent.  Fix it.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 man/man8/xfs_quota.8 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 8cc8ab7..c79627c 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -479,8 +479,8 @@ Disables quota enforcement, while leaving quota accounting active. The
 option (verbose) displays the state after the operation has completed.
 .TP
 .BR off " [ " \-gpu " ] [ " \-v " ]"
-Permanently switches quota off for the filesystem identified by the
-current path.
+Stops quota enforcement and accounting for the filesystem identified by the
+current path until the filesystem has been unmounted.
 Quota can only be switched back on subsequently by unmounting and
 then mounting again.
 .TP
--
1.8.5.4
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
