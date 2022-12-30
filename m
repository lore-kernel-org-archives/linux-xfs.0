Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BE7C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiL3XSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3XSQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:18:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29722FCCB;
        Fri, 30 Dec 2022 15:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBBD6B81DAD;
        Fri, 30 Dec 2022 23:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83391C433D2;
        Fri, 30 Dec 2022 23:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442292;
        bh=waG+f5g2wJPNSb5TzqD79ufVvdRfRLwNxjGsCC0MC30=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IjziZJSFfLTaMJE703lNKilDCkPpsi6cNxQOSLH48gtxpMQbQHbzr1MGPcKMVQp7P
         ckOMHz3cw5UCHDylJJlN2uZRAHh6DpW3nkIzXZHp0Zu0iR6lLGtcV1xK9QcuXRetAp
         vUWBJ+rAEvwn/h7jRhBJlQJwqDh/da7U16T2iK6z/ek7PES/aVSOJSVs2xui1a8PEy
         hdoInMoeXj5VE0GDNG20shSWWFPmWT+RcybBj2F9/EjSrKwcUz1IvJvrx/dvre2vno
         yyrgkEc8ydWpO7sxX3MTubnMIS52HlpkH5xQlRQArkrf5kFQaikvJ3x3YHnJHOdgjV
         YKqtUoMy6MmPA==
Subject: [PATCHSET v24.0 0/2] fstests: fix a few bugs in fs population
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877612.728350.1799909806305296744.stgit@magnolia>
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

Before we start on an intense patchset of improving the XFS fuzz testing
framework, let's fix a couple of bugs in the code that creates sample
filesystems with all types of metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-populate-problems
---
 common/populate |   70 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 24 deletions(-)

