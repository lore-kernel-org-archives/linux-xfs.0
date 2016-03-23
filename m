Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E63EA7CCD
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 17:37:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6BD1EAC001
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 15:37:56 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hWK9G6j2KOvggpz9 for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2016 15:37:49 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1airPP-0007YT-B6
	for xfs@oss.sgi.com; Thu, 24 Mar 2016 09:37:47 +1100
Date: Thu, 24 Mar 2016 09:37:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160323223747.GX30721@dastard>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
	<20160322140345.GA54245@bfoster.bfoster>
	<0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
	<20160323123010.GA43073@bfoster.bfoster>
	<20160323153221.GA19456@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323153221.GA19456@redhat.com>
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
To: xfs@oss.sgi.com

On Wed, Mar 23, 2016 at 04:32:21PM +0100, Carlos Maiolino wrote:
> I'm still trying to get a reliable reproducer, at least exactly with what I have
> seen a few days ago.
> 
> Shyam, could you try to reproduce it with a recent/upstream kernel? That would
> be great to make sure we have been seen the same issue.
> 
> AFAICT, it happens in the following situation:
> 
> 1 - Something is written to the filesystem
> 2 - log checkpoint is done for the previous write
> 3 - Disk failure
> 4 - XFS tries to writeback metadata logged in [2]
> 
> When [4] happens, I can't trigger xfs_log_force messages all the time, most of
> time I just get an infinite loop in these messages:
> 
> [12694.318109] XFS (dm-0): Failing async write on buffer block
> 0xffffffffffffffff. Retrying async write.
>
> Sometimes I can trigger the xfs_log_force() loop.

This all smells like the filesystem is getting IO errors but it not
in a shutdown state. What happens when you run 'xfs_io -x -c
"shutdown" /mnt/pt' on a filesystem in this state? Can you then
unmount it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
