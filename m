Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E989C4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F39A61008
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243201AbhIAANE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243134AbhIAANA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B8E6103D;
        Wed,  1 Sep 2021 00:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455124;
        bh=bRtBTsxOp+S3Xph+SBFEf6SsWCKi+EYHVW+KYdf5J9U=;
        h=Subject:From:To:Cc:Date:From;
        b=JDmhsu473ZAI5zUADbSKnNKZ+QO3o+2CuALFIT4TbrjlAmoSEIZ9XAwgCP8Fe15wC
         nz8DndTmvjgSmn10rbh0HZaUmlmBE/T5ETwyJxt4Lo369fsE4P0DhAx1G15XkxeMHS
         VSFvFnmQ34ZxkSNYjiwTnSR/ZxV8iYAgdF0TMuMGgm2blT/srwLPf4ho5XStJ7Vc3V
         1XN9F24ih+WEoGqYJtuStnw9MPEmCUZZv1KccXM9PlVErYIOLM6LIHPQx7+XArqcfH
         cjKXjFu+lwbZEsJKjXJAPA1tXpf/qp6DubpnECpro1u3AaazqL1AAbxzLWK/6DjNxL
         B8xtSXCp2V4rQ==
Subject: [PATCHSET 0/4] fstests: exercise code changes in 5.15
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:04 -0700
Message-ID: <163045512451.771394.12554760323831932499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new tests to exercise bug fixes appearing in 5.15.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.15
---
 tests/generic/729     |   77 ++++++++++++++++++
 tests/generic/729.out |    2 
 tests/xfs/108         |    1 
 tests/xfs/780         |  207 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/780.out     |   18 ++++
 tests/xfs/922         |  183 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/922.out     |    2 
 7 files changed, 490 insertions(+)
 create mode 100755 tests/generic/729
 create mode 100644 tests/generic/729.out
 create mode 100755 tests/xfs/780
 create mode 100644 tests/xfs/780.out
 create mode 100755 tests/xfs/922
 create mode 100644 tests/xfs/922.out

