Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BACC7619A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCPTTJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjCPTTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:19:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ABDDDF06
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F57B620C9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A8FC4339B;
        Thu, 16 Mar 2023 19:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994302;
        bh=/qW5pKqGKAO8+GWxw9dCcvdY5LDVV0UxgTfWN3s/iWI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ZsROU48fQOn8jugOaU1jaLpmmydBrJtz0bpfDaM5P9kH9Mxhc7Q+v0sRm2FcFRyHb
         DcCusaN0qYeB1zl9iTnYELBz3WgSeHaw1Mf9UCVfmCYkprLW+Z+zZoV8nBW3jFE9Nc
         UjDyJotRQO71bGutUQt75gMEC9RqwzQHkDsIip/wZubccymAAGzYgVh8MKr7PNwMLt
         dSnr/ECBc58K9P3hU1DpSYPUdZbQD9mobDp/OAD4vniYDRJaHE78qtmKm6dXPbg0vg
         ye+OUEBx8oxx8o4zPWlG93Qujpijnj+h5kdvZuglmwyl4+LCbtaUbqna+y6mlrjA2S
         5QuU7ATTsLWgQ==
Date:   Thu, 16 Mar 2023 12:18:22 -0700
Subject: [PATCHSET v10r1d2 0/7] libfrog: fix parent pointer library code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series moves the parent pointer library code out of libhandle and
into libfrog.  This is necessary because libhandle is exported as a
userspace library, and we don't want to export the parent pointer stuff
until we're absolutely ready to do that.  So that move is made in the
first patch.

The rest of the patchset fixes various bugs and inconsistencies and
bitrot that have cropped up since I wrote this code in 2017.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-fix-libfrog-code
---
 include/parent.h   |   25 ------
 io/parent.c        |  117 +++++++++++++++++-----------
 libfrog/Makefile   |    2 
 libfrog/paths.c    |   46 +++++++++--
 libfrog/paths.h    |    8 +-
 libfrog/pptrs.c    |  217 ++++++++++++++++++++++------------------------------
 libfrog/pptrs.h    |   25 ++++++
 libhandle/Makefile |    2 
 8 files changed, 237 insertions(+), 205 deletions(-)
 rename libhandle/parent.c => libfrog/pptrs.c (50%)
 create mode 100644 libfrog/pptrs.h

