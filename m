Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62DKXTA223946 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 08:20:33 -0500
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id Fl2vquLOejAq2gx6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 06:20:32 -0700 (PDT)
Received: by werl57 with SMTP id l57so2168937wer.26
	for <xfs@oss.sgi.com>; Mon, 02 Jul 2012 06:20:31 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 0/3] block: improvements for discard alignment
Date: Mon,  2 Jul 2012 15:20:22 +0200
Message-Id: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
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
Cc: axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de

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

For ease of debugging, patch 1 adds a sysfs entry for discard_alignment.
Patch 2 adjusts the computation of the granularity-adjusted
max_discard_sectors so that it prepares for the new code in patch 3,
which 3 actually adjusts the split.

v1->v2: added patch 1, fixed line length

Paolo Bonzini (3):
  block: add sysfs entry for discard_alignment
  block: reorganize rounding of max_discard_sectors
  block: split discard into aligned requests

 block/blk-lib.c   |   41 ++++++++++++++++++++++++++++-------------
 block/blk-sysfs.c |   11 +++++++++++
 2 files changed, 39 insertions(+), 13 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
