Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MGcVW4224719 for <xfs@oss.sgi.com>; Tue, 22 May 2012 11:38:31 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IZszNG4VAbdbW4tF for
	<xfs@oss.sgi.com>; Tue, 22 May 2012 09:38:29 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4MGcTh4022369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 22 May 2012 12:38:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH v3 0/2] xfs: fix xfsaild races and re-enable idle mode
Date: Tue, 22 May 2012 12:38:32 -0400
Message-Id: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
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
Cc: Brian Foster <bfoster@redhat.com>

Hi all,

We reproduced and debugged several hangs in a rhel6.3 kernel that
happened to still support xfsaild idle mode. Our short term fix was
to disable idle mode as in upstream, but I'd like to fire out a
couple potential fixes that allow us to re-enable idle mode, assuming
there aren't any other problems I'm not aware of. The details of the
bug are at:

https://bugzilla.redhat.com/show_bug.cgi?id=813137

... but I'll try to provide all relevant data in this post. The
reproducer is xfstests 273 running in a 100-iteration loop. I have
reproduced this hang on upstream kernels quite reliably with commit
670ce93f reverted. The performance enhancement in that commit makes
this much harder to reproduce.

With the proposed modifications, I've probably run 5+ 100-loop
iterations of test 273 without reproducing a hang. Previously, I
was able to reproduce the first hang with 100% reliability and the
second hang reproduced 10 minutes or so after starting a second
100-loop test (with the first fix applied).

I still have to run a full xfstests but the changes are small enough
that I wanted to send them out before I got too far. Thanks.

Changes since v2:
- Rebased against git://oss.sgi.com/xfs/xfs.
- Combined patches 1 and 2.
Changes since v1:
- Rebased against a pristine tree.

Brian Foster (2):
  xfs: re-enable xfsaild idle mode when the ail is empty
  xfs: fix xfsaild hang due to lost wake ups

 fs/xfs/xfs_trans_ail.c  |    9 ++++++---
 fs/xfs/xfs_trans_priv.h |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
