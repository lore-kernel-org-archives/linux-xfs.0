Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217FBC77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 16:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjD0Qtb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 12:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243880AbjD0QtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 12:49:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138C24C2B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 09:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E1F263E54
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 16:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7592DC4339B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682614158;
        bh=TZ1hm4oxxBbR66/RWIJwHJZibxkwX3WtYNekAgeW7Z8=;
        h=Date:From:To:Subject:From;
        b=d0OvDQ+RhlblC48ebrWbMO+Om2EaKvaO9YaFBUltDOpCweUb9ptzZP4RlkkC46L3+
         r0e6mtygJmUIvyCDdby/5+YdtLWULjKjm476Jtmzbz6WpuMstFpphuxMU9GPwFVzqx
         Yg/frnzJIZm4kpDiQcQ92edH3rk5TYiyAaSrjTLXv4DQpVj5orthyLna4jKyn+md7F
         lE8ggKos0UMToPuT6ZG7UPrqdTvL3QhJp4fpq87TPdqivHS1mOrGByjRarnqZdIXSN
         CbyA5vebK2SteQWAFj9VRc1hUIGdZhPOMED9Hc1Md5Dj7EHrAnOzbIcpuh+9T8AaKS
         ZpJ+qsNYlH1xA==
Date:   Thu, 27 Apr 2023 18:49:14 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump: for-next **rebased** to dcfb054
Message-ID: <20230427164914.fbr5nzfwkvound6d@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsdump for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/?h=for-next

Has just been **REBASED**.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

This rebase aims to sync for-next with master branch as the maintainer forgot
to update the local for-next before pushing the new patch last Friday.

The new head of the for-next branch is commit:

d7cba7410710cd3ec2c2d9fafd4d93437097f473

1 new commits:

Gao Xiang (1):
      [dcfb054] xfsrestore: fix rootdir due to xfsdump bulkstat misuse

Code Diffstat:

 common/main.c         |  1 +
 man/man8/xfsrestore.8 | 14 ++++++++++
 restore/content.c     |  7 +++++
 restore/getopt.h      |  4 +--
 restore/tree.c        | 72 ++++++++++++++++++++++++++++++++++++++++++++++++---
 restore/tree.h        |  2 ++
 6 files changed, 94 insertions(+), 6 deletions(-)

-- 
Carlos Maiolino
