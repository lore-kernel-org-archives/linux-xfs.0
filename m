Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE12E7F96
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 21:58:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D3F3304048
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 19:58:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wfoiClJ6GxG9ErUZ for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 19:58:24 -0700 (PDT)
Date: Wed, 16 Jul 2014 12:58:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: copy, don't clear, stripe geometry in backup
	SB
Message-ID: <20140716025810.GA20518@dastard>
References: <53C06CE9.9000209@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53C06CE9.9000209@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 11, 2014 at 06:02:01PM -0500, Eric Sandeen wrote:
> Today, if we have a filesystem with stripe geometry and
> a damaged primary superblock, we will zero out stripe geometry
> if we have copied the backup.
> 
> I'm guessing this might be because changing geometry with mount
> options only updates the primary, so backups aren't guaranteed
> to be current or correct.
> 
> Unfortunately, that leaves us with sb 0 w/ no geom, and backups
> *with* geom, so the next repair finds the mismatch, and complains.
> (In other words, the 2nd repair does not come up clean.)_
> And ... the second repair copies the backup stripe geometry back
> into the primary!
> 
> Rather than clearing stripe geometry in this case, just leave it
> at what was found in the backup super, and inform the user that this
> was done.  This leaves a consistent filesystem, and gives the user
> a heads-up to double-check the result.
> 
> This can all be demonstrated and tested by running xfs/030 with
> geometry set in MKFS_OPTIONS.  (To really make the test pass, 
> we need to filter the warning out of repair output.)

There are a few other tests that also fail due to this. Can you
please send an updated filter patch to fstests@vger.kernel.org?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
