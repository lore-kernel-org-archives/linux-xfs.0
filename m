Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E1DC10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiLMTpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiLMTpm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B282DDFF6;
        Tue, 13 Dec 2022 11:45:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BBE2CE1784;
        Tue, 13 Dec 2022 19:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9D4C433F0;
        Tue, 13 Dec 2022 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960737;
        bh=cZSwjbu/FjODDNMw6wcUSnuAStVdZcnAtsW3r0If3t8=;
        h=Subject:From:To:Cc:Date:From;
        b=KXrRkguUxm8ArwYvbkVrj3YTnaoXXKCxoYmCy3ZgkAYZVevWqd3BL7SGNBQrjSbN7
         Fv/BZOXynB55Vip765+HbtjzlgAt3YomkFtgv74KeUzjWhHmbfpxnYnLg0iFGnLa/h
         Dhv5MYFFe0JNpRQclhByhq1vLw0AX+D0RpegXUdASZTtiuWLSBWMecYgbvaHvYe68g
         +tpNUSayhvR08TRZSO0xK5p/TqJLbmDEzTmFMWO0NuraSqvmfk8d9oqcGkj2DYWv6m
         WaqZoO/IBbWQm70RkqbLJUAAjrhvaKFNQzOtIDhTc4eNziqX3uiE/ONaVx4z1qNCrk
         s6DzRBxYQA10w==
Subject: [PATCHSET 0/1] fstests: fix tests for kernel 6.1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:37 -0800
Message-ID: <167096073708.1750519.5668846655153278713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Adjust filesystem tests to accomodate bug fixes merged for kernel 6.1.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-fixes-6.1
---
 tests/xfs/122.out |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

