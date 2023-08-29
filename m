Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5638C6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjH2XIW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241218AbjH2XIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:08:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC735E49;
        Tue, 29 Aug 2023 16:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B46A61208;
        Tue, 29 Aug 2023 23:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2884C433C8;
        Tue, 29 Aug 2023 23:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350472;
        bh=+e9bSjVsULzUvrS/CNFvsjK71SywEfwIyoDnYb8Fsr0=;
        h=Subject:From:To:Cc:Date:From;
        b=a6VbhDvM0wkreOJm15eTuWVobssP8h/b/c4lonCXEuCVkOlan3JH106XFVyWbwHau
         Qj+GnZhpG6Q6Bx4cXwInPVsNzrJNYg2bk7Ta7sJ34Zh+TYCtZzyto5zb8pE2Jlv5y/
         B2VZVp4YPyDTWAZjRStZ7oLLLTItzbjxBzLyNAWcJ45WAufy8fVeZGXUCzi5G449BK
         ab1AA8AaY5wRJT2il9aIf/5zZX4h1eND36dTg+5JhfXJLHzmIrFWcxojv4ViePdEoS
         o8XX6iDBbN1jTt15MqosS32pjx7ihPUPw6BcPTpa6CeXbjXG2nWAP7eLhYva0n00QY
         wSIPA+bIZDnYQ==
Subject: [PATCHSET v2 0/2] fstests: fix cpu hotplug mess
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com, ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:07:52 -0700
Message-ID: <169335047228.3523635.3342369338633870707.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Ritesh and Eric separately reported crashes in XFS's hook function for
CPU hot remove if the remove event races with a filesystem being
mounted.  I also noticed via generic/650 that once in a while the log
will shut down over an apparent overrun of a transaction reservation;
this turned out to be due to CIL percpu list aggregation failing to pick
up the percpu list items from a dying CPU.

Either way, the solution here is to eliminate the need for a CPU dying
hook by using a private cpumask to track which CPUs have added to their
percpu lists directly, and iterating with that mask.  This fixes the log
problems and (I think) solves a theoretical UAF bug in the inodegc code
too.

v2: fix a few put_cpu uses, add necessary memory barriers, and use
    atomic cpumask operations

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-percpu-lists
---
 tests/generic/650 |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

