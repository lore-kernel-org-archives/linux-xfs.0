Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9BDC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED9AA6103C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhG1VP4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhG1VPz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:15:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C35336101C;
        Wed, 28 Jul 2021 21:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506953;
        bh=gt4C+zcYXBeim9hoIKoPOByRwPJDhHdZsDqzN0TaYfk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fw4rgCZn5T+87SeG96ovx4NN4LFAH/+1yEOHN0KMkn447dcn9lVdWg3nXuj2zYTbl
         L9qSgXia7rq4rl2wTzj69+bGnioqNhug/xIpXV7TpEy1Q70vlsc7+2o/c9NAt0KnXg
         yaodKdoF/fu++JpdDT+oYWbVQvoTJU31sW37My5yuLf97DrLBwA2EHpLlAtm/7pEv1
         8+lrY6eFRk9986rO1B4DoerElE6rDGKy55wBEv2d42p26AXYma/5y58ti/MYsqS2s8
         UyxtqL3vTsDkesgYkDhRg1vmVHXayFggAff4E07xfMNC3NWmnzwLjMJhaq6LP0G4bH
         zvbZgkRXVWnXA==
Subject: [PATCH 2/2] mkfs: validate rt extent size hint when rtinherit is set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Date:   Wed, 28 Jul 2021 14:15:53 -0700
Message-ID: <162750695350.44422.13432316148763097589.stgit@magnolia>
In-Reply-To: <162750694254.44422.4804944030019836862.stgit@magnolia>
References: <162750694254.44422.4804944030019836862.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Extent size hints exist to nudge the behavior of the file data block
allocator towards trying to make aligned allocations.  Therefore, it
doesn't make sense to allow a hint that isn't a multiple of the
fundamental allocation unit for a given file.

This means that if the sysadmin is formatting with rtinherit set on the
root dir, validate_extsize_hint needs to check the hint value on a
simulated realtime file to make sure that it's correct.  Unfortunately,
the gate check here was for a nonzero rt extent size, which is wrong
since we never format with rtextsize==0.  This leads to absurd failures
such as:

# mkfs.xfs -f /dev/sdf -r extsize=7b -d rtinherit=0,extszinherit=13
illegal extent size hint 13, must be less than 649088 and a multiple of 7.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 mkfs/xfs_mkfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f84a42f9..9c14c04e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2384,10 +2384,11 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
 	}
 
 	/*
-	 * Now we do it again with a realtime file so that we know the hint and
-	 * flag that get passed on to realtime files will be correct.
+	 * If the value is to be passed on to realtime files, revalidate with
+	 * a realtime file so that we know the hint and flag that get passed on
+	 * to realtime files will be correct.
 	 */
-	if (mp->m_sb.sb_rextsize == 0)
+	if (!(cli->fsx.fsx_xflags & FS_XFLAG_RTINHERIT))
 		return;
 
 	flags = XFS_DIFLAG_REALTIME;

