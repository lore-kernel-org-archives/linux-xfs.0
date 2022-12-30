Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3F5C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiL3XQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiL3XQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:16:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED123186B6;
        Fri, 30 Dec 2022 15:16:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABE2AB81DAD;
        Fri, 30 Dec 2022 23:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAA6C433D2;
        Fri, 30 Dec 2022 23:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442214;
        bh=6Xr76c8YT7ofH81tR0uo46c5qyGZEDw+6pkKzR1yrhs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gqresdVIWb5w5EDdCjYOO7kP2pL8dQIsydzHJ/r/lvn21yvmkkXP33jpWNvy1sjxJ
         sUpxJaqShMPUFlXp0jBpTaiRwtpa/VQ1VIOSNMKTlrvCHzRevMmERv60Sm4AqOuCJA
         B/goj7NOF7tBAP5YXj2SoGg3+zMJ+nXegeaOwEJ9ID3YE8kBkkh8cqiZyJ+XZqT7kB
         jSm0TGdqM5q3C8FfJ5+UfeIXylSPBGhaGTxE9Z2KfAJhmIdY0Mv+4SN5IOXX0pkJd5
         BObcAPlWCpMFp0EoYeQNTH9Ynh3uU80Y81Tb6xRjqsLMWboiXMXW06WOj0QKxxsh6B
         OsRVyG41xtkgg==
Subject: [PATCHSET v24.0 0/1] fstests: online repair of quota and counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876170.726678.17872891128076933126.stgit@magnolia>
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

XFS stores quota records and free space bitmap information in files.
Add the necessary infrastructure to enable repairing metadata inodes and
their forks, and then make it so that we can repair the file metadata
for the rtbitmap.  Repairing the bitmap contents (and the summary file)
is left for subsequent patchsets.

We also add the ability to repair file metadata the quota files.  As
part of these repairs, we also reinitialize the ondisk dquot records as
necessary to get the incore dquots working.  We can also correct
obviously bad dquot record attributes, but we leave checking the
resource usage counts for the next patchsets.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quota

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quota

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quota
---
 tests/xfs/809     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/809.out |    2 ++
 tests/xfs/810     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/810.out |    2 ++
 tests/xfs/811     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/811.out |    2 ++
 6 files changed, 126 insertions(+)
 create mode 100755 tests/xfs/809
 create mode 100644 tests/xfs/809.out
 create mode 100755 tests/xfs/810
 create mode 100644 tests/xfs/810.out
 create mode 100755 tests/xfs/811
 create mode 100644 tests/xfs/811.out

