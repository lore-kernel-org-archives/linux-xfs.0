Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7BFC0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbjGNOpI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235360AbjGNOpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69B92680
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64F2C61D3D
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0357C433C8;
        Fri, 14 Jul 2023 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345905;
        bh=CnGUGVwyWTfipj2vMnoPQALjnv2srQmSioBG/Fsn1gY=;
        h=Subject:From:To:Cc:Date:From;
        b=GSm/HLKf4HqocCFvTuN20mjVVsH3OJLeEz4OUmVP/5y/CyCteiDeeE2PYf1Elsb7S
         k8+mHwG0V3NjhmQZRVUX2MI1J6IXcUC1UN5s47aF04ucUwaP2BfSPTsgUMXLYsqRoR
         wMH85eFvdEo2HYXCFNme6r41JDXiCEQ8Lqfv7ZwsMjo0kHbxRny6Ya0cykU/CJEvVB
         yLYflAyGypfzgTuu9qO87o8RHfXBGQZ17pvxaOsSTJ2fnj6nlzyJMfcbeS6dmPZWtG
         QcHv3Ppm9149a5dPCJ/F8OOfaFWYiatcA85z5JIJ8lDtey36MOcWryQCIPx8NS2vml
         aOISojVUWYk6w==
Subject: [PATCHSET 0/3] xfsprogs: ubsan fixes for 6.5-rc2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, keescook@chromium.org,
        david@fromorbit.com
Date:   Fri, 14 Jul 2023 07:45:05 -0700
Message-ID: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix some UBSAN complaints, since apparently they don't allow flex array
declarations with array[1] anymore.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=ubsan-fixes-6.5

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=ubsan-fixes-6.5
---
 db/metadump.c          |    4 +--
 libxfs/xfs_da_format.h |   75 ++++++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_fs.h        |    4 +--
 3 files changed, 70 insertions(+), 13 deletions(-)

