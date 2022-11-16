Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31612C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 14:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKPOm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 09:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbiKPOmn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 09:42:43 -0500
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com [85.158.142.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EA84045C
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 06:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1668609760; i=@fujitsu.com;
        bh=+EAM7YZJ3m+72yWc668bBSRR2hesnpaSx/8Kkw3ezxY=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=dMOfwlorRoXgOpf/FSvUj9UaE1Qk6uq3InfQJWzexuw3Wa6ySigKEMXXZNg1o43XY
         x+2yzd3fzy6OtgtsPgiQH1JVCSXLgVzAr/OEoQq+Iv7bySqw6739NV+5mSJQst3ZUz
         Olx7CG6mZsrdni6/OeNYkCegwoG9jRo4CvK8TnIn/Nf2YPd2S5FQICaGQl7WikJZge
         l3zY6E04ooxU91K+9cE1NdhGR2EdBUmHVTKEXl4ZekA7UQ2v0NQSJuBp+T+UbfismB
         GOhqiNqbwzE5Cq8geAnw7ZG8qxKRxZHZb0Rd4tjd1UKdKejblFbs2a6krzkT4N+5f6
         ZcMMJKu18xO5A==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRWlGSWpSXmKPExsViZ8ORqHv/W0m
  ywcfDVhaXn/BZ7Pqzg93i6ssD7A7MHhOb37F7bFrVyebxeZNcAHMUa2ZeUn5FAmvGw95tzAXr
  OCsWdO9gb2CcxtHFyMUhJLCFUeLI70NsEM5yJonGD/NZIZz9jBL/Ox8zdzFycrAJqEnsnP6SB
  cQWEVCVmPJ/NlicWSBWYs/fHkYQW1jATqL1zkY2EJsFqOZm2xZWEJtXwFHi8sPTYL0SAgoSUx
  6+Z4aIC0qcnPmEBWKOhMTBFy+YIWoUJdqW/GOHsCskZs1qY4Kw1SSuntvEPIGRfxaS9llI2hc
  wMq1iNC9OLSpLLdI1NNRLKspMzyjJTczM0Uus0k3USy3VzcsvKsnQNdRLLC/WSy0u1iuuzE3O
  SdHLSy3ZxAgM2pTiVPMdjN+X/dE7xCjJwaQkyru7oSRZiC8pP6UyI7E4I76oNCe1+BCjDAeHk
  gTvjK9AOcGi1PTUirTMHGAEwaQlOHiURHj1nwKleYsLEnOLM9MhUqcYXTm2fd63l5ljbcMBID
  l19r/9zBzLweTMr20HmIVY8vLzUqXEeWNeAzULgDRnlObBjYZF/yVGWSlhXkYGBgYhnoLUotz
  MElT5V4ziHIxKwrxHvgBN4cnMK4G74BXQcUxAxx3wKwI5riQRISXVwJS2XFP8zPJG9+pk6ztb
  50UoqKoqLmC+dMbM0ePfnPfC729wT7xw/bN15v2dAdJfTu57tNtk8qdL1b86Hxdu6iw72D5vj
  7K51OOoM7HlFy/FzbtTd0xj6uGz9z/0Trut9uWBpeiX/rlLWu+sfblYtYX35Ms3UYy6nJFhZ/
  QSI+N8P6efms18kN/hK0/RFfNXz4y88423ytrxHdnx0PCd0wGhT4E3ax9nB+/ouZ7bufGj72a
  dFD0X0XO8AXY5K/1cld3Vbm22YTjN63KEe4HUnv9Xbc47Mt090JCVmxtg+yLpugWjfHxWjnLG
  SbOVd1fdW8YoJNK8c+t6C4n9C+ueRHBVLt9uNm/xLvFFmce22MgpsRRnJBpqMRcVJwIALGzv+
  XkDAAA=
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-17.tower-728.messagelabs.com!1668609759!335793!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.100.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 11381 invoked from network); 16 Nov 2022 14:42:39 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-17.tower-728.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 16 Nov 2022 14:42:39 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 6BA4F100188;
        Wed, 16 Nov 2022 14:42:39 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 5F75B100043;
        Wed, 16 Nov 2022 14:42:39 +0000 (GMT)
Received: from 0a0f9a8cc57f.localdomain (10.167.215.54) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Wed, 16 Nov 2022 14:42:37 +0000
From:   Xiao Yang <yangx.jy@fujitsu.com>
To:     <shr@fb.com>, <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <ruansy.fnst@fujitsu.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
Subject: [PATCH] xfs: Call kiocb_modified() for buffered write
Date:   Wed, 16 Nov 2022 14:42:21 +0000
Message-ID: <1668609741-14-1-git-send-email-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

kiocb_modified() should be used for sync/async buffered write
because it will return -EAGAIN when IOCB_NOWAIT is set. Unfortunately,
kiocb_modified() is used by the common xfs_file_write_checks()
which is called by all types of write(i.e. buffered/direct/dax write).
This issue makes generic/471 with xfs always get the following error:
--------------------------------------------------------
QA output created by 471
pwrite: Resource temporarily unavailable
wrote 8388608/8388608 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
pwrite: Resource temporarily unavailable
...
--------------------------------------------------------

Fixes: 1aa91d9c9933 ("xfs: Add async buffered write support")
Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 fs/xfs/xfs_file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e462d39c840e..561fab3a49c7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -417,6 +417,9 @@ xfs_file_write_checks(
 		spin_unlock(&ip->i_flags_lock);
 
 out:
+	if (IS_DAX(inode) || (iocb->ki_flags & IOCB_DIRECT))
+		return file_modified(file);
+
 	return kiocb_modified(iocb);
 }
 
-- 
2.21.0

