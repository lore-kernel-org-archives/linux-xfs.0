Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3440B7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 14:47:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 20C09304062
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 12:47:11 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	21mc2ZW3nxrV7QHz for <xfs@oss.sgi.com>;
	Wed, 10 Dec 2014 12:47:09 -0800 (PST)
Date: Thu, 11 Dec 2014 07:47:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_quota off/remove
Message-ID: <20141210204707.GC24183@dastard>
References: <8688BD11DAC0574AA90295127E9E9F4AC04DD4FF@exchangewes8.wesad.wesleyan.edu>
	<5488ADDD.404@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5488ADDD.404@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "Meij, Henk" <hmeij@wesleyan.edu>

On Wed, Dec 10, 2014 at 03:32:29PM -0500, Michael L. Semon wrote:
> On one hand, the man page for xfs_quota states for "off":  "Permanently
> switches quota off for the filesystem identified by the current path.
> Quota can only be switched back on subsequently by unmounting and then
> mounting again."

The *only* method for turning on quotas on XFS on is to mount the filesystem
with the appropriate mount options. You can turn them off in an on-line
fashion by running the "off" command, but you also need to remove
the mount options from the next mount, otherwise that turns them
back on.

If the word "permanently" is the problem, send a patch for th eman
page that explains it properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
