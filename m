Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F29437CA4
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 13:13:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C45C98F8052
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 11:13:22 -0700 (PDT)
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com
	[15.241.48.73]) by cuda.sgi.com with ESMTP id RZzunPrPUdV1sb64
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 11:13:19 -0700 (PDT)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH-tip 0/6] locking/rwsem: Enable reader optimistic spinning
Date: Tue, 14 Jun 2016 14:12:33 -0400
Message-Id: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
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
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

This patchset adds an option to enable more aggressive optimistic
spinning on both readers and writers waiting on a writer or reader
owned lock. Spinning on writer is done by looking at the on_cpu
flag of the lock owner. Spinning on readers, on the other hand, is
count-based as there is no easy way to figure out if all the readers
are running. The spinner will stop spinning once the count goes to
0. Because of that, spinning on readers may hurt performance in some
cases. So this feature is optional and has to explicitly enabled for
those rwsems where the readers are unlikely to go to sleep.

Patch 1 reduces the length of the blocking window after a read locking
attempt where writer lock stealing is disabled because of the active
read lock. It can improve rwsem performance for contended lock. It is
independent of the rest of the patchset.

Patches 2-5 lays the groundwork for enabling reader optimistic spinning.

Patch 6 enables reader optimistic spinning in XFS for inodes that
comes from a DAX-enabled mount point on top of persistent memory as
the CPUs can do I/O directly without waiting or sleeping.

Waiman Long (6):
  locking/rwsem: Stop active read lock ASAP
  locking/rwsem: Enable optional count-based spinning on reader
  locking/rwsem: move down rwsem_down_read_failed function
  locking/rwsem: Change RWSEM_WAITING_BIAS for better disambiguation
  locking/rwsem: Enable spinning readers
  xfs: Enable reader optimistic spinning for DAX inodes

 arch/alpha/include/asm/rwsem.h |    7 +-
 arch/ia64/include/asm/rwsem.h  |    6 +-
 arch/s390/include/asm/rwsem.h  |    6 +-
 arch/x86/include/asm/rwsem.h   |   13 ++-
 fs/xfs/xfs_icache.c            |    9 ++
 include/asm-generic/rwsem.h    |    9 +-
 include/linux/rwsem.h          |   21 ++++-
 kernel/locking/rwsem-xadd.c    |  212 ++++++++++++++++++++++++++--------------
 8 files changed, 192 insertions(+), 91 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
