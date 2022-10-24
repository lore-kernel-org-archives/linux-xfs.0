Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7022FA373F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 19:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiJXTxS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 15:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiJXTwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 15:52:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FCF161FED
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 11:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69447B8120C
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 13:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E3FC433C1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 13:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666616565;
        bh=uKAsEs+OA5DcqoV+l8LS9d/fkAQkkhfAeQF78Es3ZAs=;
        h=Date:From:To:Subject:From;
        b=iJVGIZvXWvI469+v4qfRkHcEf7LeBhdRix/U/jbgQAfFcbLFfLFz8pV4jhGsbp2zY
         3B9TKnDdAps75hvJWuaiB1hoAH6+TFnPQswR7ecNXc0evQd1i7N1yLLj13uDB07z1M
         HeZFMmyXzsbbGgKCnGxJpNQfRqOrUMjg0y0qfXLugrD0zuA6KGfQXhtsqnn4eMiWNu
         VvIatNv4K8rkd4aCvEOEKWxACEEu/8b5K9j7Xz2cOD3p6wi8bx9Vk5AtJ/zRekPymG
         YciE/MmnvU53U75KPwUdbPaPKS8+S+1uq3M8VgEscXAWJtmzrzxGJHe3GDKsZ9Yfvz
         +e3JX+gkIpLNA==
Date:   Mon, 24 Oct 2022 15:02:41 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump: for-next (created and) updated to aaaa57f32a605
Message-ID: <20221024130241.55nbzxn5egzyn5fw@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Today I created a for-next branch on xfsdump repository, to keep it consistent
with xfsprogs and the kernel repository. It has a smaller patch flow than the
other tools, but yet, I'd rather have a staging area before releasing a new
version than pushing directly to the master branch doing a new release.

As usual, patches often get missed so please check if your outstanding patches
were in this update. If not please give me a heads up so I'll process them.

The new head of the for-next branch is commit:

aaaa57f32a605e4ebd2e4230fe036afc009ae0a0


New Commits:

Donald Douwsma (4):
      [06dd184] xfsrestore: fix on-media inventory media unpacking
      [6503407] xfsrestore: fix on-media inventory stream unpacking
      [7b843fd] xfsdump: fix on-media inventory stream packing
      [aaaa57f] xfsrestore: untangle inventory unpacking logic

Code Diffstat:

 inventory/inv_stobj.c | 42 +++++++++++++++---------------------------
 restore/content.c     | 13 +++++--------
 2 files changed, 20 insertions(+), 35 deletions(-)

Cheers.

-- 
Carlos Maiolino
