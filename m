Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F497C7618E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 10:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjDXKsC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 06:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjDXKsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 06:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F29B7
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 03:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C722C61026
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 10:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8A3C433D2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 10:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682333280;
        bh=zS3IvXqY7yL1PDKmLby6RkAm7KP/s+rUexgjIZd9MzM=;
        h=Date:From:To:Subject:From;
        b=YGOrKlDnwFO6GUD8bQVWnYbiQV1vv5Wkju0xHGyZbtUR35gozpVKkimcmhsMgglN7
         FgmXSIRpDHnvzd32wPQFwKSnaQX9xiFrFJ22T5k6jyegPe/U53hs/3MHKzY1DweTMH
         zD9S/9v1GTA6Ke0h6tXQvkEgiPUO+Isvu7dTDqSrMO7mAkt+nP8zLSKtkpmhstlCAE
         jcEyEe8BWKDUmX7LJAmhezAzC3qV51NbXKRmbTpGz3/44qAq32V0PIMThPLKDcb7+G
         wI0mbQAhq/mnEK1MNCSoCn+d/SxTutIzm6nmZ+eHOzQ/1tB3gvsHW5jcOVn3xqReo/
         7ePTY3ju1h7dw==
Date:   Mon, 24 Apr 2023 12:47:56 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump: for-next updated to c3a72aa
Message-ID: <20230424104756.naou6t6uig4wt6wj@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsdump for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

c3a72aabb22bb3a79ed0f09762e6d81c0cbdadd6

1 new commits:

Gao Xiang (1):
      [c3a72aa] xfsrestore: fix rootdir due to xfsdump bulkstat misuse

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
