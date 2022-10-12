Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCB3C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJLBpZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLBpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82EE59243;
        Tue, 11 Oct 2022 18:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A3C261343;
        Wed, 12 Oct 2022 01:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BE8C433D6;
        Wed, 12 Oct 2022 01:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539122;
        bh=KBU7M2St2tO9e5xiwUwhadfQSsol2VZQ395PvuKtbbk=;
        h=Subject:From:To:Cc:Date:From;
        b=j18Dd8QpUEcyWTwUlh1kkZdHSvJbO8/g3UNkAJYxU7z0XFQjaJejQQa6DEtT8uQbY
         VlkOdXg1e1yiCZUQcToDVw9atAPJyuI5paFSCBN6cZjt+YsyxnGrnbSIo4LKQ9TMLe
         lV3pTIQQqAdSs0P1ia9f5RfLz0g+h+VADxSMQetpX1+9xnmiS2+Hbh10UtqkU5nWRv
         2d2qOvR23gajsLbkm3wF/6Y26tpVd4gdbuB/mcsjMDOJsX+dMNR7I2LNCRmkOjmip9
         9QLfWYGRDckVF0/RS2rrsvcld5hgo9IvYXwOfu2XOg8fAb3qQv+jcb/SDR3UsudZL/
         8gSbumzXE8DsA==
Subject: [PATCHSET 0/5] fstests: support external logs when caching
 prepopulated images
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:22 -0700
Message-ID: <166553912229.422450.15473762183660906876.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset fixes the code that manages prepopulated fs images so that
it deals with external log devices properly.  The cached image generator
requires a clean filesystem, so it's safe to reformat the external
journal whenever we restore a cached image; this fixes various
regressions when external journals are in use.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=cached-image-external-log
---
 common/config   |    1 +
 common/fuzzy    |    2 +-
 common/populate |   49 +++++++++++++++++++++++++++++++++++++++++--------
 tests/xfs/129   |    3 ++-
 tests/xfs/234   |    3 ++-
 tests/xfs/253   |    3 ++-
 tests/xfs/284   |    3 ++-
 tests/xfs/291   |    3 ++-
 tests/xfs/336   |    3 ++-
 tests/xfs/432   |    3 ++-
 tests/xfs/503   |    9 +++++----
 11 files changed, 62 insertions(+), 20 deletions(-)

