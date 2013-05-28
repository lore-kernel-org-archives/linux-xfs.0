Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B3D237CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 06:51:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44A1AAC006
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 04:51:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GjLW9dozqnbdYer2 for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 04:51:54 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UhIRS-0002y7-On
	for xfs@oss.sgi.com; Tue, 28 May 2013 21:51:50 +1000
Date: Tue, 28 May 2013 21:51:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: inode unlinked list needs to recalculate the
	inode CRC
Message-ID: <20130528115150.GW29466@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369636707-15150-10-git-send-email-david@fromorbit.com>
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

On Mon, May 27, 2013 at 04:38:27PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode unlinked list manipulations operate directly on the inode
> buffer, and so bypass the inode CRC calculation mechanisms. Hence an
> inode on the unlinked list has an invalid CRC. Fix this by
> recalculating the CRC whenever we modify an unlinked list pointer in
> an inode. This is trivial to do, and the new CRC gets logged with
> the inode core so on replay of the unlinked list operations this
> will be updated as expected and remain consistent.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I need to rework this fix.

The fact that it actually requires log recovery to follow it's
documented recovery ordering constraints has exposed a bug in those
the log recovery transaction item re-ordering code. The bug has
been there since inode chunk deletion was introduced in 2003.

It has also shown up that there is no guarantee that the on-disk
inode in the buffer is actually uptodate, so recording the CRC in
the transaction for recovery is the wrong thing to do because it may
be different to what recovery ends up with after reordering all the
modifications. So the correct thing to do is to have recovery
recalculate the on-disk inode CRC are modifying the unlinked list...

So, there's 2-3 patches that need to replace this one....

Thank xfs/121 and the icreate patch set for finding this mess.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
