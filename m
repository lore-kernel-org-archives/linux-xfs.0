Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FB7C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiF1Uua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1Uua (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DF331357
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DCD5ECE2306
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7C9C341C8;
        Tue, 28 Jun 2022 20:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449426;
        bh=eaAimQvo+6EsyUznaMB/DNGgxKD4o7amaPIqrFrTbwU=;
        h=Subject:From:To:Cc:Date:From;
        b=o3Beh1ZsaQC5UKjxti35C/HDYWe329AUDMG2He8m22IperIbw7axdUX7euikr66Ok
         /bEp05tQgP91nm66ZJNerYC7tsX6JAniIONea0l+Pv7jbAbG8XgOSRfKqBEe3C3XX3
         d1iJEWBFJTGeCW39h5M6ntnUkIBpUJ5oBzxz65YI1+rsLlQ38rQOxAiIw99uK9ERhy
         pouQGyKhe/VMTuVowXCw/DD+Q6qF0TqyQCwNKa/puATtB675mW1PudwNHtzOtvHNFh
         T8CJjDPGfhkOk8Xbc1vNI8f1TJ+K7DK144B3sGMgJOmQntN8ti9kOi3wKBUb/8jJ1c
         Pdz9NdnEIyVyA==
Subject: [PATCHSET 0/1] mkfs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:25 -0700
Message-ID: <165644942559.1091646.1065506297333895934.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The maintainers have been besieged by a /lot/ of complaints recently
from people who format tiny filesystems and growfs them into huge ones,
and others who format small filesystems.  We don't really want people to
have filesystems with no backup superblocks, and there are myriad
performance problems on modern-day filesystems when the log gets too
small.

Empirical evidence shows that increasing the minimum log size to 64MB
eliminates most of the stalling problems and other unwanted behaviors,
so this series makes that change and then disables creation of small
filesystems, which are defined as single-AGs fses, fses with a log size
smaller than 64MB, and fses smaller than 300MB.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-forbid-tiny-fs
---
 mkfs/xfs_mkfs.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

