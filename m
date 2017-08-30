Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbdH3ESy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 00:18:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EA9F356EA
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2017 04:18:54 +0000 (UTC)
Received: from ddouwsma.mel.csb (unknown [10.64.146.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24A5E5C7C4
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2017 04:18:53 +0000 (UTC)
From: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] mkfs.xfs: Don't stagger AG for a single disk
Date: Wed, 30 Aug 2017 12:18:32 +0800
Message-Id: <1504066712-26973-1-git-send-email-ddouwsma@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When sunit and swidth are used mkfs.xfs tries to avoid all allocation
groups aligning on the same stripe and will attempt to stagger them
across the stripes that make up swidth.  If there is only one stripe
then there is no benefit in this optimisation.

$ truncate -s10G xfs_10G_su256k_sw1.image
$ mkfs.xfs -d su=256k,sw=1 xfs_10G_su256k_sw1.image
meta-data=xfs_10G_su256k_sw1.image isize=512    agcount=16, agsize=163776 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2620416, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

A side effect of the optimisation is that the size adjustment used to stager
the allocation groups causes the last sunit of storage to be unused.

$ echo $((2620416*4096))
10733223936
$ ls -l xfs_10G_su256k_sw1.image
-rw-rw-r--. 1 test test 10737418240 Aug 30 10:54 xfs_10G_su256k_sw1.image

Skip this optimisation when sunit == swidth.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 mkfs/xfs_mkfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b5c3a57..35dae48 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2534,7 +2534,9 @@ reported by the device (%u).\n"),
 				}
 			}
 		}
-		if (dswidth && ((agsize % dswidth) == 0) && (agcount > 1)) {
+		if (dswidth && ((agsize % dswidth) == 0)
+			    && (dswidth != dsunit)
+			    && (agcount > 1)) {
 			/* This is a non-optimal configuration because all AGs
 			 * start on the same disk in the stripe.  Changing
 			 * the AG size by one sunit will guarantee that this
-- 
1.8.3.1

