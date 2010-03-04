Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o241jDLu126512 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 19:45:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AFA913F180B
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 17:46:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	0dIzodWoUzmRLDhp for <xfs@oss.sgi.com>;
	Wed, 03 Mar 2010 17:46:39 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15676392-1927428
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 12:16:37 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nn095-0004aS-Lg
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:35 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nn08x-00022y-Vl
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: delayed allocation @ ENOSPC fixes
Date: Thu,  4 Mar 2010 12:46:22 +1100
Message-Id: <1267667185-7736-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The first patch fixes an extreme slowdown when lots of concurrent threads are
trying to flush inodes - xfssyncd can "miss" work that is queued and so can
result in a flush waiting for 30s for the next timeout. Test 225 can take 15
minutes to run without this fix. Withthe fix it consistently takes about 50s.

The second patch prevents stale delayed allocation mappings from being left on
inodes when we discard a page in writeback due to an IO error or an ENOSPC
condition. The stale mappings can cause a BUG() to be triggered during
subsequent direct IO reads.

The last patch increases the size of the reserve block pool to reduce the
possibility of getting ENOSPC conditions during delayed allocation that
would trigger the page tossing in the first place. This requires some QA
tests to be updated - that will follow in a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
