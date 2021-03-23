Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883BAC433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F39619BA
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCWEVF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbhCWEUp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC761619AD;
        Tue, 23 Mar 2021 04:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473245;
        bh=Gob8Un+7fAMA5YE+h1EEswq5u2AAuM35SF6ryseMBTQ=;
        h=Subject:From:To:Cc:Date:From;
        b=kJ9LsBHwEd3LuB/HhFOyjuwxlQ70qKpoItQ5i420WUrxmQMNMRkK/O/ZsoCkHrVrl
         Pt2Z6Chh7xB+oqnQiztwDexW25a65HiUjdHGYhWE8dAqn8jTrUvNC3x7oGpfaaOIpc
         UsPwYSt6z+NOTZksVBIO3v282Ar2luWcMFC9AblHh9OsoGbyhnsWfONgRrlLGInrH4
         vwV2oa1vUO4H7yBuR/gQX0sY4aO6+JhQbJqWM4x+bqdJ75ls329uSCZcTDJy2CCWhZ
         uCzEqUYoPXhorlDMnqKPwRuuyxvfEi/xn560iZJNYxl7SUy47cJSnPFdo5nmfm8tAS
         31nW5ty0A10Nw==
Subject: [PATCHSET 0/3] fstests: add inode btree blocks counters to the AGI
 header
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:44 -0700
Message-ID: <161647324459.3431131.16341235245632737552.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Years ago, Christoph diagnosed a problem where freeing an inode on a
totally full filesystem could fail due to finobt expansion not being
able to allocate enough blocks.  He solved the problem by using the
per-AG block reservation system to ensure that there are always enough
blocks for finobt expansion, but that came at the cost of having to walk
the entire finobt at mount time.  This new feature solves that
performance regression by adding inode btree block counts to the AGI
header.  The patches in this series amend fstests to handle the new
metadata fields and to test that upgrades work properly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inobt-counters

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inobt-counters

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=inobt-counters
---
 common/xfs        |   20 ++++++
 tests/xfs/010     |    3 +
 tests/xfs/030     |    2 +
 tests/xfs/122.out |    2 -
 tests/xfs/764     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/764.out |   27 ++++++++
 tests/xfs/910     |   84 +++++++++++++++++++++++
 tests/xfs/910.out |   12 +++
 tests/xfs/group   |    2 +
 9 files changed, 340 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/764
 create mode 100644 tests/xfs/764.out
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out

