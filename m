Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFB2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF64B610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhIOXMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232907AbhIOXMo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689C9600D4;
        Wed, 15 Sep 2021 23:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747484;
        bh=A/3prULHMkrFbswNXTMd5rBRSMbe+wrHm/1Q2VsF/vU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Th9QWfIeooJqsNBT4oy5bRZ/CPWaog64LHTZuw4h5CtwQwyNRWvvEv5jHKl5foIkY
         LJSnUQs3MfDyUQkBrg+EMKLuwTREBWuKf4G/gxNWhXRJOXXPOdld/RmbPeWHu3fRKW
         h9hEY4+7SJ8jcrRa8GJIc8GrjvRH98Gvb4IoJkFZ8sa9VKoIkBZRYJIYWmoWYzqY39
         c3CGVZcuAAmR6+dSLn7Le/s5SODx37gEsvaLPER1xB4oDHrIZ+F9Scr7xjU6IPJ31K
         dZWSJChDaf9/hYNBt4HV9vzo26SMk72dBcMndwK+ztkbJyBDxzIH+EPshg6V8mluvP
         9KHVIRkLLW+Nw==
Subject: [PATCH 53/61] xfs: xfs_log_force_lsn isn't passed a LSN
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:24 -0700
Message-ID: <163174748417.350433.11842245044222052429.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 5f9b4b0de8dc2fb8eb655463b438001c111570fe

In doing an investigation into AIL push stalls, I was looking at the
log force code to see if an async CIL push could be done instead.
This lead me to xfs_log_force_lsn() and looking at how it works.

xfs_log_force_lsn() is only called from inode synchronisation
contexts such as fsync(), and it takes the ip->i_itemp->ili_last_lsn
value as the LSN to sync the log to. This gets passed to
xlog_cil_force_lsn() via xfs_log_force_lsn() to flush the CIL to the
journal, and then used by xfs_log_force_lsn() to flush the iclogs to
the journal.

The problem is that ip->i_itemp->ili_last_lsn does not store a
log sequence number. What it stores is passed to it from the
->iop_committing method, which is called by xfs_log_commit_cil().
The value this passes to the iop_committing method is the CIL
context sequence number that the item was committed to.

As it turns out, xlog_cil_force_lsn() converts the sequence to an
actual commit LSN for the related context and returns that to
xfs_log_force_lsn(). xfs_log_force_lsn() overwrites it's "lsn"
variable that contained a sequence with an actual LSN and then uses
that to sync the iclogs.

This caused me some confusion for a while, even though I originally
wrote all this code a decade ago. ->iop_committing is only used by
a couple of log item types, and only inode items use the sequence
number it is passed.

Let's clean up the API, CIL structures and inode log item to call it
a sequence number, and make it clear that the high level code is
using CIL sequence numbers and not on-disk LSNs for integrity
synchronisation purposes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_types.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 064bd6e8..0870ef6f 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -21,6 +21,7 @@ typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
 typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
 
 typedef int64_t		xfs_lsn_t;	/* log sequence number */
+typedef int64_t		xfs_csn_t;	/* CIL sequence number */
 
 typedef uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
 typedef uint32_t	xfs_dahash_t;	/* dir/attr hash value */

