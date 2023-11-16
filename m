Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C322CC54E76
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 17:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjKPRa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjKPRa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 12:30:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A121A5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 09:30:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11452C433C7;
        Thu, 16 Nov 2023 17:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700155823;
        bh=whvlGAewUyyNv81IjxEH9a8EtnMq007T4dtXUXS1ods=;
        h=Subject:From:To:Cc:Date:From;
        b=JoKqgLcqmMAe753bSwUEAkPa6qzu03PE26l3TcqTU4LysezgcEJJcTrmFyoOFAsSE
         wUSwta8qzzUperHxG1Ypc5pbl12tgyuYXfP9M1Oqcss7lI/c5tdoX6sTRkHdZ/8XEi
         mKUYLLy3kyjZsfTK1YCCZVYb2jWRRSU0oYjx4Fo+m+jelke1AHnxHb1bbSF+BmOFzL
         LpUEqXJfshNBXIy3AULACwmvlO6gxuUKqSqqIhOnSnBjOO2VV+e0mc8AfYG/oDV1Kd
         toqkEI1CwYctdoqHLK11XYNG5T3/R7IUt+IqUlaX4/lmO0jAahBb+YXnhVem5tZO7o
         /UmJWG6BWz/3g==
Subject: [PATCHSET v3 0/1] fstests: updates for Linux 6.7
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Date:   Thu, 16 Nov 2023 09:30:22 -0800
Message-ID: <170015582256.3367688.4617567303528395778.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is pending fixes for things that are going to get merged in 6.7.
This time around it's merely a functional test for a locking relaxation
in the xfs FICLONE implementation.

v2: implement review suggestions
v3: add more review tags

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-merge-6.7

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-6.7
---
 configure.ac              |    1 
 include/builddefs.in      |    1 
 m4/package_libcdev.m4     |   13 ++
 src/Makefile              |    4 +
 src/t_reflink_read_race.c |  339 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1953        |   75 ++++++++++
 tests/generic/1953.out    |    6 +
 7 files changed, 439 insertions(+)
 create mode 100644 src/t_reflink_read_race.c
 create mode 100755 tests/generic/1953
 create mode 100644 tests/generic/1953.out

