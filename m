Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69383C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B89B2071E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=btinternet.com header.i=@btinternet.com header.b="eCECAG+x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgBTPoS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:44:18 -0500
Received: from mailomta27-sa.btinternet.com ([213.120.69.33]:39286 "EHLO
        sa-prd-fep-040.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728305AbgBTPoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:44:18 -0500
Received: from sa-prd-rgout-005.btmx-prd.synchronoss.net ([10.2.38.8])
          by sa-prd-fep-048.btinternet.com with ESMTP
          id <20200220153238.PCVA30845.sa-prd-fep-048.btinternet.com@sa-prd-rgout-005.btmx-prd.synchronoss.net>;
          Thu, 20 Feb 2020 15:32:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1582212758; 
        bh=2aKfWh99zS2Dr4/mFKzGYgDwM9TMA4q53PVsadWqABs=;
        h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version;
        b=eCECAG+xCaP/AGwhtZGywB5yOBDFZAW2TH12dLY8xhi0bUR961le7sc3LF5httCoCZbOltZlkq0Q54WIu+NE+fr5xsQOIqFpO48r78W3BP2fwG11vPL112mYxGSXPmqW6al43GUutccd6HXfgFgRVwQ/F9nLHnqgLnAReNVr253zwyal8HZjsuTLw7dbe8q5AapIdtZM/ZwR6bQnvtswWrahrQuYYsyPU7ARpcxh7/ia5PkrleXRqttu5bvb9UH4U0jxAqABKZB0kyiHcg6OqqWvz9zKg5gasFhUeGKnhsUYjYU+ggMD+ZvY32WFHnrFd5ZZrGrk0J9pIdfsVUo2Zg==
Authentication-Results: btinternet.com;
    auth=pass (PLAIN) smtp.auth=richard_c_haines@btinternet.com
X-Originating-IP: [86.134.4.49]
X-OWM-Source-IP: 86.134.4.49 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedugedrkedvgdejlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceutffkvffkuffjvffgnffgvefqofdpqfgfvfenuceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomheptfhitghhrghrugcujfgrihhnvghsuceorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomheqnecukfhppeekiedrudefgedrgedrgeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeekiedrudefgedrgedrgeelpdhmrghilhhfrhhomhepoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqedprhgtphhtthhopeeouggrrhhrihgtkhdrfihonhhgsehorhgrtghlvgdrtghomheqpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeophgruhhlsehprghulhdqmhhoohhrvgdrtghomheqpdhrtghpthhtohepoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqecuqfftvefrvfeprhhftgekvddvnehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmpdhrtghpthhtohepoehsughssehthigthhhordhnshgrrdhgohhv
        qedprhgtphhtthhopeeoshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrgheq
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from localhost.localdomain (86.134.4.49) by sa-prd-rgout-005.btmx-prd.synchronoss.net (5.8.340) (authenticated as richard_c_haines@btinternet.com)
        id 5E3A290C026B4432; Thu, 20 Feb 2020 15:32:38 +0000
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     darrick.wong@oracle.com, sds@tycho.nsa.gov, paul@paul-moore.com
Cc:     linux-xfs@vger.kernel.org, selinux@vger.kernel.org,
        Richard Haines <richard_c_haines@btinternet.com>
Subject: [PATCH 0/1] selinux: Add xfs quota command types
Date:   Thu, 20 Feb 2020 15:32:33 +0000
Message-Id: <20200220153234.152426-1-richard_c_haines@btinternet.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Added these quota command types for SELinux checks on XFS quotas. I picked
those I thought useful. The selinux-testsuite will have tests for these
permission checks on XFS.

One point to note: XFS does not call dquot_quota_on() to trigger
security_quota_on(), therefore the 'file quotaon' permission is not tested
for SELinux

Richard Haines (1):
  selinux: Add xfs quota command types

 security/selinux/hooks.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.24.1

