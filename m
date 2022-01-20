Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097D7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbiATAYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47866 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345270AbiATAYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6282FB81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B88BC004E1;
        Thu, 20 Jan 2022 00:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638253;
        bh=8e2jp2/c9uRFOFBQ7C0CMaAGmv600zruyRYaNi0lDxc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bM+45Q2GGVFWXt4viOTY1T+jQrrDi8BSM06jUOQ2OlxGOScrlUl6bPnO6qcgvX9gE
         hQpCmz2tKb3iTIRFDYc2itbrnh32od3fkOW3CX7B+CeNqWrTptp7aTFyoKG5bqHS32
         bxX3vhtrBK2R7ozsESXqsGfz1EVw+pB9/yEo0mx7ofZI7wGjDHgM5HeF3PMg5Z/ps9
         72muyKzIWK1j5L/ei5m3pJMWW3Zka4juLHjHBjkkZndow1nRW6mOlQlJB7MkdYfbEB
         /DkQt/ixBvKVD86ilDRs92ClZfHSvx/Fb1mG9UxxTs3D7T5coCNX/AWHknb4VEuLek
         9POZWlDALzRDA==
Subject: [PATCH 11/48] xfs: terminate perag iteration reliably on agcount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:12 -0800
Message-ID: <164263825289.865554.13464342972383061245.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

Source kernel commit: 8ed004eb9d07a5d6114db3e97a166707c186262d

The for_each_perag_from() iteration macro relies on sb_agcount to
process every perag currently within EOFS from a given starting
point. It's perfectly valid to have perag structures beyond
sb_agcount, however, such as if a growfs is in progress. If a perag
loop happens to race with growfs in this manner, it will actually
attempt to process the post-EOFS perag where ->pag_agno ==
sb_agcount. This is reproduced by xfs/104 and manifests as the
following assert failure in superblock write verifier context:

XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22

Update the corresponding macro to only process perags that are
within the current sb_agcount.

Fixes: 58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 9cd06694..fae2a38e 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -144,7 +144,7 @@ xfs_perag_next(
 		(pag) = xfs_perag_next((pag), &(agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \

