Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2067629E08
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 13:24:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A42A4AC002
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:24:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XeqmUC1mDSOQS1Sf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 11:24:04 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sADJO3JH024169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 14:24:03 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sADJO3ut002302
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 14:24:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/2] xfs: split up xfslogd global workqueue
Date: Thu, 13 Nov 2014 14:23:59 -0500
Message-Id: <1415906641-43587-1-git-send-email-bfoster@redhat.com>
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

I've broken this up into two patches because the bugfix is easy (patch
1) and I don't want to rework it for the purpose of refactoring usage of
the queue. Patch 1 is a straightforward, tested and backportable fix for
a specific problem and it's no more difficult to refactor queue usage
from a per-mount queue than from a single global queue.

The metadata/log buffer I/O separation is not as straightforward as
defining separate queues. We need to also define a mechanism to split
the completions across multiple queues within the buffer code. The ioend
code does this for the data/unwritten queues via the io type. There are
a few different ways we can go from here with regard to buffers. For
example:

- Define per-buftarg workqueues and configure them appropriately for
  data and log devices.
- Split buf completion processing based on a buffer flag (or some other
  identification).
- Continue using a single queue (per-mount) for metadata/log
  completions.

The first approach introduces variance in that the separation only
occurs with separate data and log devices. This is not ideal and doesn't
seem worthwhile to me. It doesn't change anything in the common case and
introduces a new regression vector for the uncommon case.

The second approach is implemented by the 2/2 RFC of this series using
the XBF_SYNCIO flag simply because it only appears to be used by log
buffers at the moment. If we take this approach, should we define
something like an XBF_LOGIO or XBF_HIGHPRI flag?

The third approach simply involves dropping patch 2/2 and using the
per-mount queue as we use the global queue today.

Brian

v3:
- Split bug fix and buf/log I/O split into separate patches.
- Rename xfslogd workqueue to xfs-buf.
v2: http://oss.sgi.com/archives/xfs/2014-11/msg00164.html
- Rename xfslogd workqueue to xfs-iodone.
v1: http://oss.sgi.com/archives/xfs/2014-10/msg00539.html

Brian Foster (2):
  xfs: replace global xfslogd wq with per-mount wq
  xfs: split metadata and log buffer completion to separate workqueues

 fs/xfs/xfs_buf.c   | 19 ++++++++-----------
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 12 ++++++++++--
 3 files changed, 19 insertions(+), 13 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
