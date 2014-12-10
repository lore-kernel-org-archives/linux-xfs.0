Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D7347F3F
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 14:41:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6A3F68F8035
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 12:41:35 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DSSOUTtVPQDt28i8 for <xfs@oss.sgi.com>;
	Wed, 10 Dec 2014 12:41:33 -0800 (PST)
Date: Thu, 11 Dec 2014 07:41:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_quota off/remove
Message-ID: <20141210204131.GB24183@dastard>
References: <8688BD11DAC0574AA90295127E9E9F4AC04DD4FF@exchangewes8.wesad.wesleyan.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8688BD11DAC0574AA90295127E9E9F4AC04DD4FF@exchangewes8.wesad.wesleyan.edu>
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
To: "Meij, Henk" <hmeij@wesleyan.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Dec 10, 2014 at 06:37:41PM +0000, Meij, Henk wrote:
> Is off/remove working for xfs_quota? I seem to not be able to zero
> out the project quota metadata and move the project to another
> partition. I did not remove the entries in the /etc/proj* files.
.....
> 
>  1318  xfs_quota -x -c 'off' -c 'remove' /data/1
> 
>  1331  umount /data/1; mount /data1

And the output of /proc/self/mounts after this?

>From the xfs_quota man page:

       off [ -gpu ] [ -v ]
	     Permanently switches quota off for the filesystem
	     identified by the current path.  Quota can only be
	     switched back on subsequently by unmounting and then
	     mounting again.

So it's likely that mounting is still picking up the quota mount
options from /etc/fstab and turning quotas back on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
