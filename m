Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4922EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiL3XNC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiL3XNB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:13:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F05DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:13:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F61B61C3A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E57C433D2;
        Fri, 30 Dec 2022 23:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441979;
        bh=erHlLSdsptxMk+WR0571K5xGZelfnNDAL2iUjmSL2Rg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GrJnuStebJ1kb1DRW76R0gzf4Q5RzKsTO93VWn8iTlreRcnhRHGnNTkFdVktEv8x0
         As4hICRJsSBeLcSvEs0jAG2+O+LzTFmvjOTPGyhPyi52SLqbUx6Rz+W8d8G0+Um+zk
         EjcsVTuB1FBAHTqVOsNKmx69W8+HcDZsiMF9f3qEigk/HuqRqOr/tMWOAgC00WUDAT
         PfA+rPOViqPtqVd1lD7upxQATiP3LWkKHwKgQ/IiVv5hioWaobsi49M5bx1xLvRfdO
         je3Znk3+3AoCjT3lKwv1OtMwQibVFnnT1nzaD3MgN+SY/v1pmbNqEf+VZwGNbw7S1I
         m8W1YG96nU/5A==
Subject: [PATCHSET v24.0 0/6] xfs_scrub: fixes to the repair code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:10 -0800
Message-ID: <167243869023.714771.3955258526251265287.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've landed the new kernel code, it's time to reorganize the
xfs_scrub code that handles repairs.  Clean up various naming warts and
misleading error messages.  Move the repair code to scrub/repair.c as
the first step.  Then, fix various issues in the repair code before we
start reorganizing things.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-fixes
---
 scrub/phase1.c        |    2 
 scrub/phase2.c        |    3 -
 scrub/phase3.c        |    2 
 scrub/phase4.c        |   22 ++++-
 scrub/phase5.c        |    2 
 scrub/phase6.c        |   13 +++
 scrub/phase7.c        |    2 
 scrub/repair.c        |  169 +++++++++++++++++++++++++++++++++++++++++
 scrub/repair.h        |   16 +++-
 scrub/scrub.c         |  202 +------------------------------------------------
 scrub/scrub.h         |   16 ----
 scrub/scrub_private.h |   55 +++++++++++++
 12 files changed, 273 insertions(+), 231 deletions(-)
 create mode 100644 scrub/scrub_private.h

