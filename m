Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E84C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiL3XMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbiL3XMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:12:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1702BDE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:12:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C64A4B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8546FC433EF;
        Fri, 30 Dec 2022 23:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441948;
        bh=qBwyfTpqVGnMJ2XBjYuwhBaOpiIz4w4Jl35jBCmXW38=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qn01/utY96nofFZvVuPAPm2XD0bqDzpp0nSHoUJDaFnB3JabDm89/5qGzYGdUN703
         HLT8X9OSwBrXq0TMpG65/zi9C/eoShO3Dt0KEVqEVycmcllKCFTj+lukaTTV+uSPBX
         ZJDYh7JsaW2+Yu+EDT5w8qPYPnLBa4W6sohAHy6iEXaRonPlUtvMW5+Pga1XW5B5L7
         nBihnXvw0vUcjhySk/o0v7TLVYnB1Tu24Jc33B2dCs/WKvFZjmERfjeKIZw5iLojTK
         QURDmVn/OFw6LnA7nf6mN8APO2VwWumlCiwws18NjKwT74frJm4jDwFRETOch8ytRE
         oS84jEy6ishZQ==
Subject: [PATCHSET v24.0 0/1] xfs: online fsck of iunlink buckets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:04 -0800
Message-ID: <167243868463.714425.14936757185529800411.stgit@magnolia>
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

This series enhances the AGI scrub code to check the unlinked inode
bucket lists for errors, and fixes them if necessary.  Now that iunlink
pointer updates are virtual log items, we can batch updates pretty
efficiently in the logging code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-iunlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-iunlink
---
 db/Makefile       |    2 -
 db/command.c      |    1 
 db/command.h      |    1 
 db/unlinked.c     |  204 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   19 +++++
 5 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 db/unlinked.c

