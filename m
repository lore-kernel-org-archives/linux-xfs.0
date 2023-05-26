Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196AAC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241968AbjEZAhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241884AbjEZAg5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:36:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5320E45
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:36:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39CA264AFD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAC8C433EF;
        Fri, 26 May 2023 00:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061404;
        bh=nxR0dnEpyOeiEtfcq3mj+Dfw7dfzkE30/O2aIq/KfmQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ozyHwb2msUk+1ZKYOpw0Dz9yiClL186zpR+Y7DOlyrV1AeRRbw/uHaF4RIRJhpQaU
         00B8N1Xo1+4S6yicVmcHaDowv+EINwQuA0R0QsKEh7TSNlOZYyc6/1Fn+4lqfvNQ6+
         VIodO9zxs2se6FEohrKXjQrOOYSvP9c4vD4Di6KBzPR5+uPChnCZpT9hBHa7cUAja0
         ijg1bEKjZOFmgh89/aKMObxCNb5ytC7uqYp1QlOcOUDA+oph2dqOpEYvLhX94Djv++
         aFWtnAXqwvn9pf/1dvRaXAxpERAHlI7yGJ/VJsH/u61ssYCviLJX/rGCMucGO762Ct
         UXoI7aZeVcGSg==
Date:   Thu, 25 May 2023 17:36:44 -0700
Subject: [PATCHSET v25.0 0/1] xfs: online repair of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506068312.3737987.7281343869778307167.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the jumping-off point for rebuilding parent pointer information
and reconstructing directories with parent pointers.  The parent pointer
feature hasn't been merged yet, so this branch contains only a single
patch that refactors the xattr walking code in preparation for that.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-parent-pointers
---
 fs/xfs/Makefile          |    1 
 fs/xfs/scrub/attr.c      |  125 +++++++------------
 fs/xfs/scrub/listxattr.c |  309 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/listxattr.h |   17 +++
 4 files changed, 374 insertions(+), 78 deletions(-)
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h

