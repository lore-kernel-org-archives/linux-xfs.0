Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CEFA29DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 03:41:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7747AC001
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:41:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iq9CnrqvIP1OTlrS for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 01:41:08 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vr2lR-00015p-7d
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vr2lR-0005t6-6X
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: dquot modification scalability
Date: Thu, 12 Dec 2013 20:40:55 +1100
Message-Id: <1386841258-22183-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

I recently made the mistake of enabling quotas on one of my regular
scalability tests - concurrent file creates - and discovered that
the quota modification serialised the entire workload. Not good.

Only two of these patches are really scalability patches - the first
patch in the series is a cleanup that gets rid of dquot hints.

The first scalability change is to not require the dquot lock when
taking references to the dquot. This is done simply by converting
the reference count to an atomic and replacing all all operations
with equivalent atomic variable operations. This means that we can
remove the dquot lock from xfs_qm_dqhold(). Further optimisations
can be done on the release of references, but that is not done in
this patch or in this patch set.

Getting rid of the dquot lock from the hold code moves the
contention point to the transaction subsystem - xfs_trans_dqresv and
the transaction commit code. The second scalability change it to
make xfs_trans_dqresv() lockless by using cmpxchg rather than the
dquot lock for updating the reservations. We don't really need to
hold the dquot lock to check the quota limits as the limits almost
never change - it's really only the reservation that we care about
here, and if that changes between the check and the cmpxchg, then
we'll go around the loop and check the limits again with the newly
sampled reservation...

Overall, these patches improve workload performance from around
16,500 creates/s to about 24,000 creates/s. While 25% improvement is
nothing to complain about, performance without quotas is about
250,000 creates/s. So there's still a lot of ground to make up here.

The patchset moves the contention almost entirely to the transaction
commit code, along with the xfs_qm_dqrele calls in xfs_create (about
15% of the overall locks contention). Fixing the transaction commit
code is a major piece of work and where the order of magnitude
improvement will come from, but I haven't quite figured it all
out yet. The dqrele code is simpler, so I'll probably have a patch
soon for that - it'll give another 10% improvement on what we have
now...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
