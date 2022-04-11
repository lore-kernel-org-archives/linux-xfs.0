Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C79C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244863AbiDKW4r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344838AbiDKW4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:56:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DA07656;
        Mon, 11 Apr 2022 15:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27C52B81996;
        Mon, 11 Apr 2022 22:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D984FC385A5;
        Mon, 11 Apr 2022 22:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717662;
        bh=hrgCphgBIJbdExB7fwLsooVx23IiXP1/Sq2+Mu1APAQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PvIkidOj6GewYYIjKBa/w35YHI0CCzjuHBh6wgMpVK0j3H+4LlpoN7r/Hp0/boj9p
         zRoJ+dStrcWiJl3OAd511tYVnNyjLtXe43bxCF7q1a8XyXf3iJccS3zqUKWbkK5b/t
         YjKss7hVo/CQ6YN3stpkhak/B37QbxkzRWHd4vpM9/YO3YMBArm/rA5vPOZWGsDpQO
         Wq6WfNMTlB0JC9wbsifKp82E+F7fHKj/+s405qcfn1wRd0/RH0WXLiExTOsqyHMEbw
         A+pVpXgfr/xMKNHL90KXEUkahj0V8CDd8YbnVs/Ls28srAL64JO8PDavGoM7us7pw7
         nv16Z757CDHTQ==
Subject: [PATCH 1/2] xfs/187: don't rely on FSCOUNTS for free space data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:54:22 -0700
Message-ID: <164971766238.169895.2389864738831855587.stgit@magnolia>
In-Reply-To: <164971765670.169895.10730350919455923432.stgit@magnolia>
References: <164971765670.169895.10730350919455923432.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, this test relies on the XFS_IOC_FSCOUNTS ioctl to return
accurate free space information.  It doesn't.  Convert it to use statfs,
which uses the accurate versions of the percpu counters.  Obviously,
this only becomes a problem when we convert the free rtx count to use
(sloppier) percpu counters instead of the (more precise and previously
buggy) ondisk superblock counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/187 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/187 b/tests/xfs/187
index 1929e566..a9dfb30a 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -135,7 +135,7 @@ punch_off=$((bigfile_sz - frag_sz))
 $here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
 
 # Make sure we have some free rtextents.
-free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep counts.freertx | awk '{print $3}')
+free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep statfs.f_bavail | awk '{print $3}')
 if [ $free_rtx -eq 0 ]; then
 	echo "Expected fragmented free rt space, found none."
 fi

