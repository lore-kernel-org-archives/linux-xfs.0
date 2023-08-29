Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B520C6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240072AbjH2XQG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240353AbjH2XPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:15:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB3CFD;
        Tue, 29 Aug 2023 16:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F6C60FB9;
        Tue, 29 Aug 2023 23:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C4DC433C8;
        Tue, 29 Aug 2023 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350948;
        bh=E5eOPbF/cU6TSl5cPEhNe3C7KuPUhzRGRMN5CaxDkWk=;
        h=Subject:From:To:Cc:Date:From;
        b=F9m8j43/Z2zorzu8uK2gGT4vXuRMt2+HRo1ThP98OEUlmutD9JhW6YQqMeYWfTKvc
         YBuUY7qz3odNI/aYwSCfvqDJ+WnvMLcgqUoLYdhf/vQhEUvQf8U+c/PeCm9LPZtBuV
         yPDRz2LjA5Y0oCe42mprnGbRO3mUISZ3eKqpYI6MwMyNm6dOEUPMoLBYBoyPnjDE48
         ObHNXAUYG3Uk6dWRS+UcfiEFiGA1K6C6HjfoNTbTp5oxxekKDFLYsocwOtc6p2TLuq
         wJ80KiMoH5YduzjY3vNSw339RtXgyEm2t2p++MXAcesLmPY7Sj+2N/rUhn0INWsVGd
         gRdYWJRxI0GRA==
Subject: [PATCHSET 0/2] fstests: io_uring tweaks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 29 Aug 2023 16:15:48 -0700
Message-ID: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I recently added io_uring to my main testing configuration, and a couple
of things stood out to me: First, generic/616 and generic/617 are long
soak test cases specifically for io_uring.  Therefore, we ought to allow
control via SOAK_DURATION.

The second problem is nastier.  If liburing is present, fsstress will
/always/ try to use it, unlike fsx, which requires a -U argument.  I
think both tools should require explicit opt-in to facilitate A/B
testing between the old IO paths and this new one, so I added a similar
-U switch to fsstress and a new testcase for it.

While I was doing that, I noticed quite a few regressions in fstests,
which fell into two classes.  The first class is umount failing with
EBUSY.  Apparently this is due to the kernel uring code hanging on to
file references even after the userspace program exits.  Tests that run
fsstress and immediately unmount now fail due to the EBUSY.  As a
result, nearly all of the online fsck functional test cases and the
metadata update stress tests now exhibit sporadic failures.  Requiring
explicit opt-in to uring makes that go away.

The second problem I noticed is that fsstress now lodges complaints about
sporadic heap corruption.  I /think/ this is due to some kind of memory
mishandling bug when uring is active but IO requests fail, but I haven't
had the time to go figure out where that happens.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=uring-tweaks
---
 ltp/fsstress.c         |   17 ++++++++++++++---
 tests/generic/1220     |   43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1220.out |    2 ++
 tests/generic/616      |    1 +
 tests/generic/617      |    1 +
 5 files changed, 61 insertions(+), 3 deletions(-)
 create mode 100755 tests/generic/1220
 create mode 100644 tests/generic/1220.out

