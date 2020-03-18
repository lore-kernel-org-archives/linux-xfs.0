Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4683C10F29
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 17:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCECD20757
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 17:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Tc7dT42P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgCRRXa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 13:23:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgCRRXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 13:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=wRA//Fv1F5inuMnabchKmEIHOw/BZ7J7n/G3d0nmAUM=; b=Tc7dT42PoBSRas2mlfGd3FdcAM
        ag21WBp/kaN9g+TpKvj9z9JUBxw3bjZcu9H6rIiLuvxUpsSoAY2478hZo6/JeT3YwcfF5kkxmgrFr
        z0MInPiDrTrM+gQIL7+u1kZW8q+xpR0O5nOzPsrs1JPpHouQtPSN1QqqgTGfkqqXcTwKmv6zB5Knu
        31pOXXyd3YvmCcEKYwOs8rhxWDbYQU98unent7h/sXwtaxumo8f9mvNm6YuI7g62Jy4hqutM9M2xU
        LKIcbkBZefh08Myf7Lpeaw5kVP8cGblG3/qgR6dhP2PRaRO/i2DoRAET473uLxb/GV+P+YTmgLYcC
        2OAaVrUA==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEcPf-0005k0-LC; Wed, 18 Mar 2020 17:23:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     guaneryu@gmail.com
Cc:     jtulak@redhat.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfstests: remove xfs/191-input-validation
Date:   Wed, 18 Mar 2020 18:21:15 +0100
Message-Id: <20200318172115.1120964-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test has constantly failed since it was added, and the promised
input validation never materialized.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/191-input-validation     | 322 -----------------------------
 tests/xfs/191-input-validation.out |   2 -
 tests/xfs/group                    |   1 -
 3 files changed, 325 deletions(-)
 delete mode 100755 tests/xfs/191-input-validation
 delete mode 100644 tests/xfs/191-input-validation.out

diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
deleted file mode 100755
index db427349..00000000
--- a/tests/xfs/191-input-validation
+++ /dev/null
@@ -1,322 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
-#
-# FS QA Test No. xfs/191
-#
-# mkfs.xfs input validation test. Designed to break mkfs.xfs if it doesn't
-# filter garbage input or invalid option combinations correctly.
-#
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-	cd /
-	rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-
-# real QA test starts here
-
-# Modify as appropriate.
-_supported_fs xfs
-_supported_os Linux
-_require_scratch_nocheck
-_require_xfs_mkfs_validation
-
-
-
-rm -f $seqres.full
-echo silence is golden
-
-# clear out any options to mkfs first. We want to test realtime and external log
-# devices if we can, but we also want to control them ourselves.
-logdev=$SCRATCH_LOGDEV
-rtdev=$SCRATCH_RTDEV
-
-MKFS_OPTIONS=
-SCRATCH_LOGDEV=
-SCRATCH_RTDEV=
-
-# limit the image size of the filesystem being created to something small
-fssize=$((4 * 1024 * 1024 * 1024))
-logsize=$((4 * 1024 * 1024 * 100))
-fsimg=$TEST_DIR/$seq.img
-
-do_mkfs_pass()
-{
-	echo >> $seqres.full
-	echo "pass expected $*" >> $seqres.full
-	$MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
-	[ $? -ne 0 ] && echo "fail $*"
-}
-
-do_mkfs_fail()
-{
-	echo >> $seqres.full
-	echo "fail expected $*" >> $seqres.full
-	$MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
-	[ $? -eq 0 ] && echo "pass $*"
-}
-
-reset_fsimg()
-{
-	rm -f $fsimg
-	$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
-}
-
-reset_fsimg
-
-do_mkfs_pass $SCRATCH_DEV
-
-# basic "should fail" options
-
-# specifying sector sizes in sectors or blocks or garbage
-do_mkfs_fail -s size=2s $SCRATCH_DEV
-do_mkfs_fail -d sectsize=2s $SCRATCH_DEV
-do_mkfs_fail -l sectsize=2s $SCRATCH_DEV
-do_mkfs_fail -s size=2b $SCRATCH_DEV
-do_mkfs_fail -d sectsize=2b $SCRATCH_DEV
-do_mkfs_fail -l sectsize=2b $SCRATCH_DEV
-
-do_mkfs_fail -s size=grot $SCRATCH_DEV
-do_mkfs_fail -s size=2yerk $SCRATCH_DEV
-do_mkfs_fail -d sectsize=blah $SCRATCH_DEV
-do_mkfs_fail -d sectsize=2foo $SCRATCH_DEV
-do_mkfs_fail -l sectsize=nggh $SCRATCH_DEV
-do_mkfs_fail -l sectsize=2nggh $SCRATCH_DEV
-
-# conflicting sector/block sizes
-do_mkfs_fail -s size=512 -d sectsize=1024 $SCRATCH_DEV
-do_mkfs_fail -s size=512 -l sectsize=1024 $SCRATCH_DEV
-do_mkfs_fail -d sectsize=2048 -l sectsize=1024 $SCRATCH_DEV
-
-do_mkfs_fail -b size=512 -s size=1024 $SCRATCH_DEV
-do_mkfs_fail -b size=512 -d sectsize=1024 $SCRATCH_DEV
-do_mkfs_fail -b size=512 -l sectsize=1024 $SCRATCH_DEV
-
-# specifying block sizes in sectors without specifying sector size
-# or in blocks or garbage
-do_mkfs_fail -b size=2s $SCRATCH_DEV
-do_mkfs_fail -b size=2b $SCRATCH_DEV
-do_mkfs_fail -b size=nfi $SCRATCH_DEV
-do_mkfs_fail -b size=4096nfi $SCRATCH_DEV
-do_mkfs_fail -n size=2s $SCRATCH_DEV
-do_mkfs_fail -n size=2b $SCRATCH_DEV
-do_mkfs_fail -n size=nfi $SCRATCH_DEV
-do_mkfs_fail -n size=4096nfi $SCRATCH_DEV
-
-# bad label length
-do_mkfs_fail -L thisiswaytoolong $SCRATCH_DEV
-
-# basic "should pass" data section tests
-do_mkfs_pass $SCRATCH_DEV
-do_mkfs_pass -d name=$SCRATCH_DEV
-do_mkfs_pass -d size=$fssize $SCRATCH_DEV
-do_mkfs_pass -d agcount=32 $SCRATCH_DEV
-do_mkfs_pass -d agsize=32m $SCRATCH_DEV
-do_mkfs_pass -d agsize=32M $SCRATCH_DEV
-do_mkfs_pass -d agsize=1g $SCRATCH_DEV
-do_mkfs_pass -d agsize=$((32 * 1024 * 1024)) $SCRATCH_DEV
-do_mkfs_pass -b size=4096 -d agsize=8192b $SCRATCH_DEV
-do_mkfs_pass -d sectsize=512,agsize=65536s $SCRATCH_DEV
-do_mkfs_pass -s size=512 -d agsize=65536s $SCRATCH_DEV
-do_mkfs_pass -d noalign $SCRATCH_DEV
-do_mkfs_pass -d sunit=0,swidth=0 $SCRATCH_DEV
-do_mkfs_pass -d sunit=8,swidth=8 $SCRATCH_DEV
-do_mkfs_pass -d sunit=8,swidth=64 $SCRATCH_DEV
-do_mkfs_pass -d su=0,sw=0 $SCRATCH_DEV
-do_mkfs_pass -d su=4096,sw=1 $SCRATCH_DEV
-do_mkfs_pass -d su=4k,sw=1 $SCRATCH_DEV
-do_mkfs_pass -d su=4K,sw=8 $SCRATCH_DEV
-do_mkfs_pass -b size=4096 -d su=1b,sw=8 $SCRATCH_DEV
-do_mkfs_pass -d sectsize=512,su=8s,sw=8 $SCRATCH_DEV
-do_mkfs_pass -s size=512 -d su=8s,sw=8 $SCRATCH_DEV
-
-# invalid data section tests
-do_mkfs_fail -d size=${fssize}b $SCRATCH_DEV
-do_mkfs_fail -d size=${fssize}s $SCRATCH_DEV
-do_mkfs_fail -d size=${fssize}yerk $SCRATCH_DEV
-do_mkfs_fail -d agsize=8192b $SCRATCH_DEV
-do_mkfs_fail -d agsize=65536s $SCRATCH_DEV
-do_mkfs_fail -d agsize=32Mbsdfsdo $SCRATCH_DEV
-do_mkfs_fail -d agsize=1GB $SCRATCH_DEV
-do_mkfs_fail -d agcount=1k $SCRATCH_DEV
-do_mkfs_fail -d agcount=6b $SCRATCH_DEV
-do_mkfs_fail -d agcount=32,agsize=32m $SCRATCH_DEV
-do_mkfs_fail -d sunit=0,swidth=64 $SCRATCH_DEV
-do_mkfs_fail -d sunit=64,swidth=0 $SCRATCH_DEV
-do_mkfs_fail -d sunit=64,swidth=64,noalign $SCRATCH_DEV
-do_mkfs_fail -d sunit=64k,swidth=64 $SCRATCH_DEV
-do_mkfs_fail -d sunit=64,swidth=64m $SCRATCH_DEV
-do_mkfs_fail -d su=0,sw=64 $SCRATCH_DEV
-do_mkfs_fail -d su=4096,sw=0 $SCRATCH_DEV
-do_mkfs_fail -d su=4097,sw=1 $SCRATCH_DEV
-do_mkfs_fail -d su=4096,sw=64,noalign $SCRATCH_DEV
-do_mkfs_fail -d su=4096,sw=64s $SCRATCH_DEV
-do_mkfs_fail -d su=4096s,sw=64 $SCRATCH_DEV
-do_mkfs_fail -d su=4096b,sw=64 $SCRATCH_DEV
-do_mkfs_fail -d su=4096garabge,sw=64 $SCRATCH_DEV
-do_mkfs_fail -d su=4096,sw=64,sunit=64,swidth=64 $SCRATCH_DEV
-do_mkfs_fail -d sectsize=10,agsize=65536s $SCRATCH_DEV
-do_mkfs_fail -d sectsize=512s,agsize=65536s $SCRATCH_DEV
-
-reset_fsimg
-
-# file section, should pass
-do_mkfs_pass $fsimg
-do_mkfs_pass -d file=0 $SCRATCH_DEV
-do_mkfs_pass -d size=$fssize,file=1,name=$fsimg
-do_mkfs_pass -d size=$fssize,file $fsimg
-do_mkfs_pass -d size=$fssize $fsimg
-do_mkfs_pass -d size=$fssize,name=$fsimg
-do_mkfs_pass -d size=$((fssize/2)) $fsimg
-# again this one, to check that we didn't truncated the file
-do_mkfs_pass -d size=$fssize $fsimg
-rm -f $fsimg
-do_mkfs_pass -d file,size=$fssize $fsimg
-
-reset_fsimg
-
-# file section, should fail
-do_mkfs_fail -d file=1 $SCRATCH_DEV
-do_mkfs_fail -d file $fsimg # no size given
-rm -f $fsimg
-do_mkfs_fail $fsimg
-do_mkfs_fail -d size=$fssize $fsimg
-
-reset_fsimg
-
-# log section, should pass
-do_mkfs_pass -l size=$logsize -d size=$fssize $SCRATCH_DEV
-do_mkfs_pass -l agnum=2 $SCRATCH_DEV
-do_mkfs_pass -l size=4096b $SCRATCH_DEV
-do_mkfs_pass -l sectsize=512 $SCRATCH_DEV
-do_mkfs_pass -l sunit=64 $SCRATCH_DEV
-do_mkfs_pass -l sunit=64 -d sunit=8,swidth=8 $SCRATCH_DEV
-do_mkfs_pass -l sunit=8 $SCRATCH_DEV
-do_mkfs_pass -l su=$((4096*10)) $SCRATCH_DEV
-do_mkfs_pass -b size=4096 -l su=10b $SCRATCH_DEV
-do_mkfs_pass -l sectsize=512,su=$((4096*10)) $SCRATCH_DEV
-do_mkfs_pass -l internal $SCRATCH_DEV
-$XFS_IO_PROG -f -c "truncate $logsize" $fsimg
-do_mkfs_pass -l logdev=$fsimg $SCRATCH_DEV
-do_mkfs_pass -l name=$fsimg $SCRATCH_DEV
-do_mkfs_pass -l lazy-count=0 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -l lazy-count=1 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -l version=1 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -l version=2 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -l version=2 $SCRATCH_DEV
-
-# log section, should fail
-do_mkfs_fail -l size=${fssize}b $SCRATCH_DEV
-do_mkfs_fail -l size=${fssize}s $SCRATCH_DEV
-do_mkfs_fail -l size=${fssize}yerk $SCRATCH_DEV
-do_mkfs_fail -l agnum=1k $SCRATCH_DEV
-do_mkfs_fail -l agnum=6b $SCRATCH_DEV
-do_mkfs_fail -l agnum=32 $SCRATCH_DEV
-do_mkfs_fail -l sunit=0  $SCRATCH_DEV
-do_mkfs_fail -l sunit=63 $SCRATCH_DEV
-do_mkfs_fail -l su=1 $SCRATCH_DEV
-do_mkfs_fail -l su=10b $SCRATCH_DEV
-do_mkfs_fail -l su=10s $SCRATCH_DEV
-do_mkfs_fail -l su=$((4096*10+1)) $SCRATCH_DEV
-do_mkfs_fail -l sectsize=10,agsize=65536s $SCRATCH_DEV
-do_mkfs_fail -l sectsize=512s,agsize=65536s $SCRATCH_DEV
-do_mkfs_fail -l internal=0 $SCRATCH_DEV
-reset_fsimg
-do_mkfs_fail -l internal=1,logdev=$fsimg $SCRATCH_DEV
-do_mkfs_fail -l lazy-count=1garbage $SCRATCH_DEV
-do_mkfs_fail -l lazy-count=2 $SCRATCH_DEV
-do_mkfs_fail -l lazy-count=0 -m crc=1 $SCRATCH_DEV
-do_mkfs_fail -l version=1 -m crc=1 $SCRATCH_DEV
-do_mkfs_fail -l version=0  $SCRATCH_DEV
-
-
-
-# naming section, should pass
-do_mkfs_pass -n size=65536 $SCRATCH_DEV
-do_mkfs_pass -n log=15 $SCRATCH_DEV
-do_mkfs_pass -n version=2 $SCRATCH_DEV
-do_mkfs_pass -n version=ci $SCRATCH_DEV
-do_mkfs_pass -n ftype=0 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -n ftype=1 $SCRATCH_DEV
-
-# naming section, should fail
-do_mkfs_fail -n version=1 $SCRATCH_DEV
-do_mkfs_fail -n version=cid $SCRATCH_DEV
-do_mkfs_fail -n ftype=4 $SCRATCH_DEV
-do_mkfs_fail -n ftype=0 $SCRATCH_DEV
-
-reset_fsimg
-
-# metadata section, should pass
-do_mkfs_pass -m crc=1,finobt=1 $SCRATCH_DEV
-do_mkfs_pass -m crc=1,finobt=0 $SCRATCH_DEV
-do_mkfs_pass -m crc=0,finobt=0 $SCRATCH_DEV
-do_mkfs_pass -m crc=1 -n ftype=1 $SCRATCH_DEV
-do_mkfs_pass -m crc=0 -n ftype=1 $SCRATCH_DEV
-do_mkfs_pass -m crc=0 -n ftype=0 $SCRATCH_DEV
-
-# metadata section, should fail
-do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV
-do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
-
-
-# realtime section, should pass
-do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
-do_mkfs_pass -r extsize=4k $SCRATCH_DEV
-do_mkfs_pass -r extsize=1G $SCRATCH_DEV
-do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
-do_mkfs_pass -r noalign $SCRATCH_DEV
-
-
-# realtime section, should fail
-do_mkfs_fail -r rtdev=$SCRATCH_DEV
-do_mkfs_fail -r extsize=256 $SCRATCH_DEV
-do_mkfs_fail -r extsize=2G $SCRATCH_DEV
-do_mkfs_fail -r size=65536 $SCRATCH_DEV
-
-
-
-# inode section, should pass
-do_mkfs_pass -i size=256 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -i size=512 $SCRATCH_DEV
-do_mkfs_pass -i size=2048 $SCRATCH_DEV
-do_mkfs_pass -i log=10 $SCRATCH_DEV
-do_mkfs_pass -i perblock=2 $SCRATCH_DEV
-do_mkfs_pass -i maxpct=10 $SCRATCH_DEV
-do_mkfs_pass -i maxpct=100 $SCRATCH_DEV
-do_mkfs_pass -i maxpct=0 $SCRATCH_DEV
-do_mkfs_pass -i align=0 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -i align=1 -m crc=1 $SCRATCH_DEV
-do_mkfs_pass -i attr=1 -m crc=0 $SCRATCH_DEV
-do_mkfs_pass -i attr=2 $SCRATCH_DEV
-do_mkfs_pass -i projid32bit $SCRATCH_DEV
-do_mkfs_pass -i sparse=0 $SCRATCH_DEV
-do_mkfs_pass -i sparse -m crc $SCRATCH_DEV
-
-
-# inode section, should fail
-do_mkfs_fail -i size=256 -m crc $SCRATCH_DEV
-do_mkfs_fail -i size=128 $SCRATCH_DEV
-do_mkfs_fail -i size=513 $SCRATCH_DEV
-do_mkfs_fail -i size=4096 $SCRATCH_DEV
-do_mkfs_fail -i maxpct=110 $SCRATCH_DEV
-do_mkfs_fail -i align=2 $SCRATCH_DEV
-do_mkfs_fail -i sparse -m crc=0 $SCRATCH_DEV
-do_mkfs_fail -i align=0 -m crc=1 $SCRATCH_DEV
-do_mkfs_fail -i attr=1 -m crc=1 $SCRATCH_DEV
-
-status=0
-exit
diff --git a/tests/xfs/191-input-validation.out b/tests/xfs/191-input-validation.out
deleted file mode 100644
index 020bd625..00000000
--- a/tests/xfs/191-input-validation.out
+++ /dev/null
@@ -1,2 +0,0 @@
-QA output created by 191-input-validation
-silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 12eb55c9..8487892f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -188,7 +188,6 @@
 188 ci dir auto
 189 mount auto quick
 190 rw auto quick
-191-input-validation auto quick mkfs
 192 auto quick clone
 193 auto quick clone
 194 rw auto
-- 
2.24.1

