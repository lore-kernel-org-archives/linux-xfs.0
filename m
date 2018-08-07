Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37951 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387617AbeHGQ2k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Aug 2018 12:28:40 -0400
From: Colin Ian King <colin.king@canonical.com>
Subject: re: xfs: cancel dfops on xfs_defer_finish() error
Message-ID: <18f3296d-e5d4-4d76-51f8-a40d0ceaa20e@canonical.com>
Date: Tue, 7 Aug 2018 15:14:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

Recent commit 82ff27bc52a88cb5cc400bfa64e210d3ec8dfebd ("xfs: automatic
dfops buffer relogging") removed the assignment of variable error:

-       error = xfs_defer_bjoin(tp->t_dfops, bp);
        if (error) {
                xfs_trans_bhold_release(tp, bp);
                xfs_trans_brelse(tp, bp);


.. the removal of the assignment leads to dead code on the following if
statement as error is always zero at this point.  Not sure if that was
intended, but it tripped a static analysis warning from CoverityScan.


364        xfs_trans_bhold(tp, bp);

   const: At condition error, the value of error must be equal to 0.
   dead_error_condition: The condition error cannot be true.

365        if (error) {
   CID 1472288 (#1 of 1): Logically dead code (DEADCODE)
   dead_error_begin: Execution cannot reach this statement:
xfs_trans_bhold_release(tp,....


366                xfs_trans_bhold_release(tp, bp);
367                xfs_trans_brelse(tp, bp);
368                goto error1;
369        }

Colin
