Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC33C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 21:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D95611AB
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 21:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhESVD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 17:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhESVD0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 17:03:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 304106100C;
        Wed, 19 May 2021 21:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621458126;
        bh=UPnlVMmF6GD5WYLq8Ll3rVWyXY3snGfmsjLWwtLkqVE=;
        h=Date:From:To:Cc:Subject:From;
        b=YTvrZAAKv9f059p1vG/HMTdxo7YAytEjZX3Bri5X8hufXkr2W2nzI5RGjaVEcw0D6
         aJSn8to4MRsILrmWDWPrUOpzY7kEcr6M6bFDdaYg140rhERitq/3vqozcY6nZaKqAp
         tUo5pdnCa7cl17QeDbASgmrvwZkzYpK/pFAjnmM9RWCJK3hfNDaoNSEZ6OgqseGQFc
         DrDE3gFmMRZjT0o420M5MDK5foAwozWenhzszrQ6UeXhkV+NcZ7e4t2ncXuTxotPIV
         kgf1i2bcrkTwpiqP83+lncnwvTidoOwdkQK3eVN2zOuwWKiTddNOML46DYHbU0dH72
         9KWU4Nd2AwFIQ==
Date:   Wed, 19 May 2021 14:02:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, hsiangkao@aol.com
Subject: regressions in xfs/168?
Message-ID: <20210519210205.GT9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hm.  Does anyone /else/ see failures with the new test xfs/168 (the fs
shrink tests) on a 1k blocksize?  It looks as though we shrink the AG so
small that we trip the assert at the end of xfs_ag_resv_init that checks
that the reservations for an AG don't exceed the free space in that AG,
but tripping that doesn't return any error code, so xfs_ag_shrink_space
commits the new fs size and presses on with even more shrinking until
we've depleted AG 1 so thoroughly that the fs won't mount anymore.

At a bare minimum we probably need to check the same thing the assert
does and bail out of the shrink; or maybe we just need to create a
function to adjust an AG's reservation to make that function less
complicated.

--D

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 flax-mtr00 5.13.0-rc2-xfsx #rc2 SMP PREEMPT Mon May 17 15:26:13 PDT 2021
MKFS_OPTIONS  -- -f -b size=1024, /dev/sdf
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt

xfs/168
Message from syslogd@flax-mtr00 at May 19 13:50:05 ...
 kernel:[ 9688.703923] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 332

Message from syslogd@flax-mtr00 at May 19 13:50:06 ...
 kernel:[ 9689.186021] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 332

Message from syslogd@flax-mtr00 at May 19 13:50:07 ...
 kernel:[ 9690.313532] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 332

Message from syslogd@flax-mtr00 at May 19 13:50:07 ...
 kernel:[ 9690.359752] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 332

Message from syslogd@flax-mtr00 at May 19 13:50:07 ...
 kernel:[ 9690.406718] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 332

Message from syslogd@flax-mtr00 at May 19 13:50:07 ...
 kernel:[ 9690.977567] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 332
[failed, exit status 1]- output mismatch (see /var/tmp/fstests/xfs/168.out.bad)
    --- tests/xfs/168.out       2021-05-16 18:48:31.290361859 -0700
    +++ /var/tmp/fstests/xfs/168.out.bad        2021-05-19 13:50:09.520067445 -0700
    @@ -1,2 +1,3 @@
     QA output created by 168
    -Silence is golden
    +xfs_repair failed with shrinking 748457
    +(see /var/tmp/fstests/xfs/168.full for details)
    ...
    (Run 'diff -u /tmp/fstests/tests/xfs/168.out /var/tmp/fstests/xfs/168.out.bad'  to see the entire diff)
Ran: xfs/168
Failures: xfs/168
Failed 1 of 1 tests

Test xfs/168 FAILED with code 1 and bad golden output:
--- /tmp/fstests/tests/xfs/168.out      2021-05-16 18:48:31.290361859 -0700
+++ /var/tmp/fstests/xfs/168.out.bad    2021-05-19 13:50:09.520067445 -0700
@@ -1,2 +1,3 @@
 QA output created by 168
-Silence is golden
+xfs_repair failed with shrinking 748457
+(see /var/tmp/fstests/xfs/168.full for details)

--D
