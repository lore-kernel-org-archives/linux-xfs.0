Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AD6C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjG0WUz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WUz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:20:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4224187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B3061F1F
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0060C433C8;
        Thu, 27 Jul 2023 22:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496453;
        bh=UhL8DeZ8cfCqxIn1TLZvbKzPz3yqKyYxtiQF5SM3wvs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SIqpsqXLEAOySRV2kfsqhCi4qfHQPduU3H6R+9BpLJ2oJJryxtRV891ltksHosO14
         Cx+BJr0bUcwZ/1fGTh3PHuMv+UzvOKwJxC9IAOvu88S6mRifeAfxCF1kYjoenSSZxe
         SYCL1zf76+4yicRXg3/S59wG48FCtn8NqraXZBaFJ2JcJSAFJljFQPEhtc86TJi9FB
         lVdPJlo+aRxf6kiJX1+miiLxKdfOImmqYN399WhFT7icVG86EsGFcsLUofpJzo6Hnu
         oA6vpCR7r+BWfJOxia4xTGbCgfHt0MBgPHC59Wc7HZaT0/RxTnJEhdS3Q6ltJuxgMx
         +QACg/FpWZbPg==
Date:   Thu, 27 Jul 2023 15:20:53 -0700
Subject: [PATCHSET v26.0 0/2] xfs: fixes for the block mapping checker
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626076.922440.10606459711846791721.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series amends the file extent map checking code so that nonexistent
cow/attr forks get the ENOENT return they're supposed to; and fixes some
incorrect logic about the presence of a cow fork vs. reflink iflag.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-bmap-fixes
---
 fs/xfs/scrub/bmap.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

