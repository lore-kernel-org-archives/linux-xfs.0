Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4512CC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiF1Uu6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1Uu6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A5731912
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E3C4B81E04
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D060DC341CB;
        Tue, 28 Jun 2022 20:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449454;
        bh=XGpCXCwOQ9KuOEuz5nUZ41Q0GZQwL+poSvQws8h5H1k=;
        h=Subject:From:To:Cc:Date:From;
        b=Lq7u+VRlIKuP32x4JgdGJD+dGtNVzGKyimAVby0P0GmWnm3VJnuxIxc9Vn7Q36nj+
         4sOprkfiai4QoRH6m5ASLl2UVt10xjBnB/wh3X/OdZ/XPHDSEGyxDiBFTMqSKOrSSd
         DBGLljLdM1fFTT3p8l3DXL1C8bfs2XSGSa8jQmo69Flv79i2XVhJXsFNBdmHuzBafN
         7XBIjjZIaRu7LSpWot8cGzjV7eaDtjOlFNdh1M2i3sggnIOsIuyG/fyCpqeYDNPp/u
         tsuW//jTvO660A24z1JgqUchzMhI9q1prQcJsLSxciTnPgW3zU0oR/bpRr1wY49AVN
         tS4Zrc5VanmbA==
Subject: [PATCHSET 0/1] xfs_db: improve output of the logres command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:54 -0700
Message-ID: <165644945449.1091822.7139201675279236986.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Tweak the output of xfs_db's logres command so that it's more obvious
that the last line is the transaction reservation size used to compute
the minimum log size.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=db-improve-minlogsize-reporting
---
 db/logformat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

