Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4DC487F3F
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 19:56:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C695304051
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 17:56:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zWfNclGhdX3zAnJl for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 17:56:44 -0700 (PDT)
Date: Sat, 15 Jun 2013 10:56:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130615005639.GZ29338@dastard>
References: <1371003548-4026-2-git-send-email-david@fromorbit.com>
	<20130613010441.GX20932@sgi.com> <20130613020827.GG29338@dastard>
	<20130613220903.GA20932@sgi.com> <20130614001306.GM29338@dastard>
	<20130614160940.GA32736@sgi.com> <51BB41AD.4050303@sandeen.net>
	<20130614190850.GB20932@sgi.com> <51BB6C7C.6050300@sandeen.net>
	<20130614194453.GC20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130614194453.GC20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Jun 14, 2013 at 02:44:53PM -0500, Ben Myers wrote:
> Unfortunately log replay is broken.  The verifier has detected this and stopped
> replay.  Ideally the solution would be to fix log replay, but that is going to
> take some time.  So, in the near term we're just going to disable the verifier
> to allow replay to complete.
> 
> I'm suggesting that this disabling be done conditionally on CONFIG_XFS_DEBUG so
> that developers still have a chance at hitting the log replay problem, and a
> comment should be added explaining that we've disabled the verifier due to a
> specific bug as a temporary workaround and we'll re-enable the verifier once
> it's fixed.  I'll update the patch and repost.
> 
> Are you guys arguing that the log replay bug should not be fixed?

I'm not arguing that it should not be fixed, I'm *stating* that it
*can't be fixed* for non-CRC filesystems. That is, the best we can
do is work around this deficiency in log recovery with some kind of
self-defusing warning....

To fix it properly, you need to know the age of the object being
overwritten relative to the age of overwrite data. For non-CRC
filesystems we don't have that information in the metadata object
being overwritten. We can't even correctly identify the object being
overwritten.

So, it's simply not fixable in log recovery for non-CRC filesystems,
and the LSN stamped in every piece of metadata at writeback time for
CRC enabled filesystems is designed precisely to avoid this problem.

Indeed, the LSN stamp is a far more effective method than what used
to be in the inode core to try to avoid the problem for unlogged
inode size updates to try to prevent log recovery from replaying
inode core updates over more recently written inodes - the
di_flushiter field.  Note the comment in xfs_flush_int():

        /*
         * bump the flush iteration count, used to detect flushes which
         * postdate a log record during recovery. This is redundant as we now
         * log every change and hence this can't happen. Still, it doesn't hurt.
         */
        ip->i_d.di_flushiter++;

And this in xlog_recover_inode_pass2():

        /* Skip replay when the on disk inode is newer than the log one */
        if (dicp->di_flushiter < be16_to_cpu(dip->di_flushiter)) {

This recovery problem has been around forever, and it we cannot fix
log recovery with age information in the metadata on disk that
recovery is going overwrite. CRC enabled filesystems have that
information on disk, existing filesystems don't. Therefore, we can
only solve the recovery problem for CRC enabled filesystems...

We could probably also avoid the problem by modifying the way we do
writeback from the AIL to limit it only to objects at the tail LSN,
but that has a horrific performance penalty associated with it for
many common workloads because of the way relogging works. And for a
problem that I've suspected has occurred maybe 5 times in 10 years,
modifying metadata writeback to avoid this problem is a bad tradeoff
to make for just about everyone...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
