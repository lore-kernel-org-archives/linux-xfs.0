Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F3DC77B61
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Apr 2023 00:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbjDZAOU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Apr 2023 20:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbjDZAOU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2023 20:14:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7714B769B;
        Tue, 25 Apr 2023 17:14:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15C9362E29;
        Wed, 26 Apr 2023 00:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF97C433D2;
        Wed, 26 Apr 2023 00:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682468058;
        bh=+twEy4aJJMHmlcK3We4f3aZ6ZX4WNcRpQPYPjXrWc04=;
        h=Subject:From:To:Cc:Date:From;
        b=c+Ov+X2vnUSk6CNuuBDXXS3wE+MCXIqWm9NQgAkxa7qlktq38iB+hwzEydz78lhr+
         va6DiNmW1l+Mc6VT6vzZXkv9YV05h0gnxGM+TRO1gveuR3cDtZOY3ntrsk6/qyIV2B
         b+oOY4w7KsGdhMsUdqNnnti6h4xlOALNjw46/rP2dhMGK+PZmqqT7FtHhN0YRQZ+W+
         5+6EDXQaco+8AJOPmydQdMBWtGkBhx4aLSGFkhX24gHIG64swGrwY9Nlbw9IRK0K5z
         U5ZvosDvkgheBoWeOGI4IFdcggoXOHaEscfKb7oo8BX3Mv8HNtkCOUK4ZHYhrhp1pL
         SdizciMij2MZg==
Subject: [PATCHSET v2 0/4] fstests: direct specification of looping test
 duration
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Apr 2023 17:14:17 -0700
Message-ID: <168246805791.732186.9294980643404649.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

One of the things that I do as a maintainer is to designate a handful of
VMs to run fstests for unusually long periods of time.  This practice I
call long term soak testing.  There are actually three separate fleets
for this -- one runs alongside the nightly builds, one runs alongside
weekly rebases, and the last one runs stable releases.

My interactions with all three fleets is pretty much the same -- load
current builds of software, and try to run the exerciser tests for a
duration of time -- 12 hours, 6.5 days, 30 days, etc.  TIME_FACTOR does
not work well for this usage model, because it is difficult to guess
the correct time factor given that the VMs are hetergeneous and the IO
completion rate is not perfectly predictable.

Worse yet, if you want to run (say) all the recoveryloop tests on one VM
(because recoveryloop is prone to crashing), it's impossible to set a
TIME_FACTOR so that each loop test gets equal runtime.  That can be
hacked around with config sections, but that doesn't solve the first
problem.

This series introduces a new configuration variable, SOAK_DURATION, that
allows test runners to control directly various long soak and looping
recovery tests.  This is intended to be an alternative to TIME_FACTOR,
since that variable usually adjusts operation counts, which are
proportional to runtime but otherwise not a direct measure of time.

With this override in place, I can configure the long soak fleet to run
for exactly as long as I want them to, and they actually hit the time
budget targets.  The recoveryloop fleet now divides looping-test time
equally among the four that are in that group so that they all get ~3
hours of coverage every night.

There are more tests that could use this than I actually modified here,
but I've done enough to show this off as a proof of concept.

v2: document TIME/LOAD_FACTOR, redefine the soak tag, remove extranous
changes to g482

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=soak-duration
---
 README                |   11 +++++++
 check                 |   12 ++++++++
 common/config         |    2 +
 common/fuzzy          |    7 ++++
 common/rc             |   34 +++++++++++++++++++++
 common/report         |    1 +
 doc/group-names.txt   |    3 +-
 ltp/fsstress.c        |   78 +++++++++++++++++++++++++++++++++++++++++++++++--
 ltp/fsx.c             |   50 +++++++++++++++++++++++++++++++
 src/soak_duration.awk |   23 ++++++++++++++
 tests/generic/019     |    1 +
 tests/generic/388     |    2 +
 tests/generic/475     |    2 +
 tests/generic/476     |    7 +++-
 tests/generic/482     |    1 +
 tests/generic/521     |    1 +
 tests/generic/522     |    1 +
 tests/generic/642     |    1 +
 tests/generic/648     |    8 +++--
 19 files changed, 231 insertions(+), 14 deletions(-)
 create mode 100644 src/soak_duration.awk

