Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q65G29xq077991 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 11:02:09 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 1TXpajfkfkvduwvn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Jul 2012 09:02:08 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so16092919pbb.26
	for <xfs@oss.sgi.com>; Thu, 05 Jul 2012 09:02:07 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 0/2] block: improvements for discard alignment
Date: Thu,  5 Jul 2012 18:01:42 +0200
Message-Id: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
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
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de, vgoyal@redhat.com

When a disk has a large discard_granularity, discards are not split with
optimal alignment; the pessimization gets bigger as discard_granularity
and max_discard_sectors become closer.

Take the limit case of discard_granularity == max_discard_sectors == 64.
Then, if a request is submitted for 256 sectors 2..257 it will be split
like this: 2..65, 66..129, 130..193, 194..257.  None of these requests
is aligned, so in fact you might end up with no discarded logical blocks
at all.  With this patch, the split will be 2..63, 64..127, 128..191,
192..255, 256..257.  The patches also take the discard_alignment into
consideration.

Patch 1 adjusts the computation of the granularity-adjusted
max_discard_sectors so that it prepares for the new code in patch 2,
which actually adjusts the split.

v2->v3: drop addition of queue/discard_alignment to sysfs, use
  correct alignment for partitions

Paolo Bonzini (2):
  block: reorganize rounding of max_discard_sectors
  block: split discard into aligned requests

 block/blk-lib.c        |   41 ++++++++++++++++++++++++++++-------------
 include/linux/blkdev.h |   10 ++++++++++
 2 files changed, 38 insertions(+), 13 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
