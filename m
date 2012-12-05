Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB5GhQCK030137 for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 10:43:27 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l0GK92ml7kZxL7WT for
	<xfs@oss.sgi.com>; Wed, 05 Dec 2012 08:45:50 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qB5GjlBq012181
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:48 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id qB5Gjlce007034
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] speculative preallocation quota throttling
Date: Wed,  5 Dec 2012 11:47:54 -0500
Message-Id: <1354726078-31793-1-git-send-email-bfoster@redhat.com>
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

Hi All,

This set is intended to enable throttling of speculative preallocation as we
approach EDQUOT. Currently, speculative preallocation is throttled only as we
approach global ENOSPC. The addition of quota prealloc. throttling helps prevent
performance issues (e.g., via reduction of prealloc, ENOSPC, inode flush
sequences) and premature errors in this scenario.

Functional Description
XFS speculative preallocation quota throttling is controlled via the hard and
soft quota limits. Preallocation is throttled against the hard limit with a
default prealloc. maximum of 5% free space in the quota. Preallocation is
disabled if the hard limit is surpassed (i.e., noenforce).

If a soft quota limit is set, it is used as a watermark to enable throttling.
The difference between the soft and hard limits also scales the throttling
percentage heuristic (i.e., a 10% difference between the hard and soft limit
adjusts the prealloc throttling heuristic to 10%).

Testing
I've tested this functionality by running 32 concurrent writers (18G each, to
trigger max prealloc requests when files are >8GB) into a project quota of
576GB [1]. Without quota throttling, I'm able to write ~528GB before errors
propagate to the test program and writing stops. With quota throttling enabled
(using the default 5% limit), the test writes ~576GB. With a 10% throttle, the
test stops at ~564GB.

I'm pretty sure I've run this through xfstests in the past, but I don't have a
record of results so I'll be running this through some tests soon.

Brian

P.S., I was originally planning to include eofblocks based handling of EDQUOT
errors in this set but I have more studying up and hacking to do there. It's
easier for me to carry that as an independent set.

[1] - Using the following iozone command:
	iozone -w -c -e -i 0 -+n -r 4k -s 18g -t 32 -F /mnt/file{0..31}

Brian Foster (4):
  xfs: reorganize xfs_iomap_prealloc_size to remove indentation
  xfs: push rounddown_pow_of_two() to after prealloc throttle
  xfs: add quota-driven speculative preallocation throttling
  xfs: preallocation throttling tracepoints

 fs/xfs/xfs_iomap.c |  173 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_iomap.h |    2 +
 fs/xfs/xfs_trace.h |   62 +++++++++++++++++++
 3 files changed, 209 insertions(+), 28 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
