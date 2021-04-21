Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDDFC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23A0461421
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhDUAXf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234223AbhDUAXe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4FC6141F;
        Wed, 21 Apr 2021 00:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964582;
        bh=tUpTx+mptWiOxu9jxLKZiaZmd4mk+hh5vORAPZGWHIY=;
        h=Subject:From:To:Cc:Date:From;
        b=XNeZXQ1As6L+LiP7aBd8kkUkbmVkNUEnqq7aFLiyap7y5UqhRArUqlCYt2F4uvcGM
         s4+KNFMFUfbyOQzX8yKkjaSPNVS/0Ho0Ik1nTzKvy2MuTmQ/f+n0kEyUkGHwFiKNAZ
         JnWXux2Ng9152eNg4PE6TZpeprXZ1/hXRzEQ0XJ7jIBMzHv9vj7JwjwhIpyzJZYDWL
         AJW8TihxVV41AQ2zanYQaQj4tAzeh9yg6cbjW4SHkU8lavjzKRXdpBRlsm0+Cq4g4K
         KZpRSJndIJfu/bcYw0F4PBQV167IBg+Kr1n4YCC2sRqzurXNLxLhYAvHBk9Z+JyOwp
         8qIA52D2d+K0w==
Subject: [PATCHSET v4 0/4] fstests: widen timestamps to deal with y2038+
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:23:01 -0700
Message-ID: <161896458140.776452.9583732658582318883.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series performs some refactoring of our timestamp and inode
encoding functions, then retrofits the timestamp union to handle
timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
to the non-root dquot timer fields to boost their effective size to 34
bits.  These two changes enable correct time handling on XFS through the
year 2486.

On a current V5 filesystem, inodes timestamps are a signed 32-bit
seconds counter, with 0 being the Unix epoch.  Quota timers are an
unsigned 32-bit seconds counter, with 0 also being the Unix epoch.

This means that inode timestamps can range from:
-(2^31-1) (13 Dec 1901) through (2^31-1) (19 Jan 2038).

And quota timers can range from:
0 (1 Jan 1970) through (2^32-1) (7 Feb 2106).

With the bigtime encoding turned on, inode timestamps are an unsigned
64-bit nanoseconds counter, with 0 being the 1901 epoch.  Quota timers
are a 34-bit unsigned second counter right shifted two bits, with 0
being the Unix epoch, and capped at the maximum inode timestamp value.

This means that inode timestamps can range from:
0 (13 Dec 1901) through (2^64-1 / 1e9) (2 Jul 2486)

Quota timers could theoretically range from:
0 (1 Jan 1970) through (((2^34-1) + (2^31-1)) & ~3) (16 Jun 2582).

But with the capping in place, the quota timers maximum is:
max((2^64-1 / 1e9) - (2^31-1), (((2^34-1) + (2^31-1)) & ~3) (2 Jul 2486).

v1: Initial RFC.
v2: Expand explanations due to questions from Amir.
v3: Fix a bunch more things that Amir pointed out.
v4: Fix some review comments from Amir and Eryu.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bigtime
---
 common/rc             |    2 -
 common/xfs            |   35 ++++++++++++
 tests/generic/721     |  123 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/721.out |    2 +
 tests/generic/722     |  125 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/722.out |    1 
 tests/generic/group   |    6 +-
 tests/xfs/122         |    1 
 tests/xfs/122.out     |    1 
 tests/xfs/908         |  117 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/908.out     |   29 ++++++++++
 tests/xfs/909         |  149 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out     |    6 ++
 tests/xfs/911         |   44 ++++++++++++++
 tests/xfs/911.out     |   15 +++++
 tests/xfs/group       |    3 +
 16 files changed, 656 insertions(+), 3 deletions(-)
 create mode 100755 tests/generic/721
 create mode 100644 tests/generic/721.out
 create mode 100755 tests/generic/722
 create mode 100644 tests/generic/722.out
 create mode 100755 tests/xfs/908
 create mode 100644 tests/xfs/908.out
 create mode 100755 tests/xfs/909
 create mode 100644 tests/xfs/909.out
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out

