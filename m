Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51379 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbeJJT7N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 15:59:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 729F330BDA0A
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 12:37:14 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4E825D9CB
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 12:37:13 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] xfs stats fixes - V2
Date: Wed, 10 Oct 2018 14:37:06 +0200
Message-Id: <20181010123708.7632-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

this is a new version of my fixes to xfsstats code, the V1 is here:
https://marc.info/?l=linux-xfs&m=153857014823217&w=2

This patchset main goal, is to fix a bug which makes /proc/fs/xfs/xqmstat to
display garbage data (patch 1), and a re-work of the offset marks in __xfsstats,
replacing the defines, by usage of offsetof(), as suggested by Eric and Dave.

Patch 2 isn't tagged as V2, because it's essentially different from the patch 2
of the first version. It still prevents offset mistakes in future updates of
__xfsstats, but in a different way than the V1 patchset

I'm not tagging stable here, because patch 2 only applies cleanly since 4.18


Carlos Maiolino (2):
  xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
  xfs: use offsetof() in place of offset macros for __xfsstats

 fs/xfs/xfs_stats.c | 52 +++++++++++++++++++++++++---------------------
 fs/xfs/xfs_stats.h | 28 +++----------------------
 2 files changed, 31 insertions(+), 49 deletions(-)

-- 
2.17.1
