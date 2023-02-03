Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682B3C05027
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Feb 2023 13:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjBCNOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Feb 2023 08:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjBCNOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2023 08:14:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736F466F8A
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 05:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F29AB82A58
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 13:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFE5C433EF
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 13:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675430048;
        bh=7BZMd9ZDAbfbXo0oc5TpPJjI4iesnDTZW08SPkHp40Q=;
        h=Date:From:To:Subject:From;
        b=Q193N0DChetrZjE0oGxibndcnwR2v2EZBmTDnIz3JdSM0nR7DDmDYk18ZBH6jHrW+
         Opg/qMVeVyzrRFEJTxiCjtixYmnOH3gjodk4B8R5GZa7YqLhiCZTnkpZjyeXNfDUSq
         QwLz7MK2XdPkWMhF7xX7yttsseLdKDCYkewv1qCjAhezUJQdbHaiEccJD+OhtQPLRT
         qcbc/LBnAdqVGG5tWjmJ2UrRLToYvO6XhypLK/Y9gq1utdqcKpNV2I8jHr/5d2keXE
         da6788uea4Wf1Aw44/q94EkHh5KmUcWHkPg8JG9TjlHgcBOm54GlvW25haoe+MZ98q
         kKn1p3//Q0XwA==
Date:   Fri, 3 Feb 2023 14:14:05 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to e9f142486
Message-ID: <20230203131405.rtugzt76gtvx4kii@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

e9f1424863be2201711ba7fc97f9a628a8358535

2 new commits:

Catherine Hoang (2):
      [77e8ce78c] xfs_admin: correctly parse IO_OPTS parameters
      [e9f142486] xfs_admin: get/set label of mounted filesystem

Code Diffstat:

 db/xfs_admin.sh | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
Carlos Maiolino
