Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32002C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiFWUkA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiFWUkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:40:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BA65638D
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B896BCE26B0
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 20:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE14CC341C0;
        Thu, 23 Jun 2022 20:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656016796;
        bh=g+Fx6GW92HUrSKp7EbpcLjIJoeYJ9CWAJUd1NBRsjDw=;
        h=Subject:From:To:Cc:Date:From;
        b=tL6h2gZ4VbGy45aMx5kF+N1buO216VBq/bn6QtZQW5TeCRmyk+F4sGbXtuSDWuWDZ
         2dU20E1nL+ewVVJLnCT5jK4yQ+xLXUuzWatp0ZmPYN9rS2tABdf+eCaaaHP3GcFOAv
         IsfPTjY7Q/QCve7flVwOZVxJ60zo9ejcRR9+XYkdP/5Ko+OBOlCxyoSRNzYyhH8gk0
         FC1344lScNVnhmjOmGypEG+kN4ma3JE+pfxT9kQ6IYB6HuYfzKp0S06fry1KJdH+LD
         EfCfmoy5oHd1UvDm9o4WVzllrUp3uq1hW+ZmnyOfGGnJ+DDOZO4NSXNTq74mV3NtdJ
         A0PoVToLFTO3A==
Subject: [PATCHSET v2 0/2] xfs: random fixes for 5.19-rc4
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Thu, 23 Jun 2022 13:39:55 -0700
Message-ID: <165601679540.2928801.11814839944987662641.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix some unmount hangs during recovery of larp xattr operations.

v2: clean up function prologue, fix bugs in v1 patch

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-5.19
---
 fs/xfs/xfs_attr_item.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

