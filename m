Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3A5C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C50464E23
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhBMFes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhBMFer (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF03664EA0;
        Sat, 13 Feb 2021 05:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194430;
        bh=521zbSg0hZpEm6SYfwUfRR4XE6GrKoVTn80rJ1vmOik=;
        h=Subject:From:To:Cc:Date:From;
        b=iq2e7VTT9MKaTawpzeIuDKUwRG1VQPlc3TJBbRMhzd6T4Go5PT65we8iYFnGywhaR
         0nXxLcN51/xSbGJIipjpgejyZ9PI122v1jVeSc7Tn92uDlRUbMwy7ODlLE+RWqOrQW
         94sbxBLg8wURr9lJ7W4ykY/wMU2EKFJIIhAsX8hWv97k+Y0WDgNIVeTivboGOPxuNh
         SjeyRClttxq4GoVf8MNLPR8beewr81yg19sm7iFxLnoBygkWOKof0WkVeH+N+MYN02
         8gzVawhxHq/q/sBSs+oYHsT047qyxnFRkp/elndHSEoDiYIwuj60BJd50wxB3x25YY
         ezOj4/ERotUXA==
Subject: [PATCHSET RFC 0/4] fstests: widen timestamps to deal with y2038+
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:50 -0800
Message-ID: <161319443045.403615.18346950431837086632.stgit@magnolia>
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
 common/xfs            |   32 ++++++++++
 tests/generic/721     |  123 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/721.out |    2 +
 tests/generic/722     |  125 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/722.out |    1 
 tests/generic/group   |    6 +-
 tests/xfs/122         |    1 
 tests/xfs/122.out     |    1 
 tests/xfs/908         |   95 +++++++++++++++++++++++++++++++
 tests/xfs/908.out     |   14 +++++
 tests/xfs/909         |  150 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out     |    4 +
 tests/xfs/911         |   44 ++++++++++++++
 tests/xfs/911.out     |   15 +++++
 tests/xfs/group       |    3 +
 16 files changed, 615 insertions(+), 3 deletions(-)
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

