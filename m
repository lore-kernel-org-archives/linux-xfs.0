Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7EFC7CA2
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 20:52:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB7FE304032
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:52:03 -0800 (PST)
Received: from g1t6214.austin.hp.com (g1t6214.austin.hp.com [15.73.96.122]) by
	cuda.sgi.com with ESMTP id HBRFDNj7SyAlGtPY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 18:52:01 -0800 (PST)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH 0/2] percpu_counter: Enable switching to global counter
Date: Fri,  4 Mar 2016 21:51:37 -0500
Message-Id: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
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
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Scott J Norton <scott.norton@hp.com>, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, Douglas Hatch <doug.hatch@hp.com>

This patchset allows the degeneration of per-cpu counters back to
global counters when:

 1) The number of CPUs in the system is large, hence a high cost for
    calling percpu_counter_sum().
 2) The initial count value is small so that it has a high chance of
    excessive percpu_counter_sum() calls.

When the above 2 conditions are true, this patchset allows the user of
per-cpu counters to selectively degenerate them into global counters
with lock. This is done by calling the new percpu_counter_set_limit()
API after percpu_counter_set(). Without this call, there is no change
in the behavior of the per-cpu counters.

Patch 1 implements the new percpu_counter_set_limit() API.

Patch 2 modifies XFS to call the new API for the m_ifree and m_fdblocks
per-cpu counters.

Waiman Long (2):
  percpu_counter: Allow falling back to global counter on large system
  xfs: Allow degeneration of m_fdblocks/m_ifree to global counters

 fs/xfs/xfs_mount.c             |    1 -
 fs/xfs/xfs_mount.h             |    5 +++
 fs/xfs/xfs_super.c             |    6 +++
 include/linux/percpu_counter.h |   10 +++++
 lib/percpu_counter.c           |   72 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 92 insertions(+), 2 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
