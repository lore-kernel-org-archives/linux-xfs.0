Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38B0C3F2CE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9703120866
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgCEBpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 20:45:42 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33198 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgCEBpm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 20:45:42 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A70FE3A28AD
        for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2020 12:45:38 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0005xA-Cz
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0002vx-AI
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7] xfs: make btree cursor private unions anonymous
Date:   Thu,  5 Mar 2020 12:45:30 +1100
Message-Id: <20200305014537.11236-1-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=SS2py6AdgQ4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=s2OCZSvGNsbFMDbw-MgA:9 a=AjGcO6oz07-iQ99wixmX:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a "make things less verbose" cleanup from looking at the
changes Darrick is making to add a staging/fake cursor to the union
for bulk btree loading.

The process is to create a @defines of the new name to the existing
union name, then replace all users of each union via a script. Then
the union is made anonymous and the members renamed to match the new
code. Then the #defines get removed.

We do this for the bc_private union, then we name the ag and btree
structures and make them use anonymous unions internally via the
same process.

That means we go from doubly nested private stuff like this:

cur->bc_private.a.priv.abt.active

To the much cleaner, less verbose and more readable:

cur->bc_ag.abt.active

Simples, yes?

This series can be found at:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/h?xfs-btree-cursor-cleanup

Note: the code changes are all scripted, I have not done any
followup to do things like aggregate split lines back into single
lines as that is out of scope of the structure definition cleanup
I'm trying to acheive here. That can be done in future as we modify
the code that now has lines that can be merged....

Signed-off-by: Dave Chinner <dchinner@redhat.com>


Dave Chinner (7):
  xfs: introduce new private btree cursor names
  xfs: convert btree cursor ag private member name
  xfs: convert btree cursor btree private member name
  xfs: rename btree cursur private btree member flags
  xfs: make btree cursor private union anonymous
  xfs: make the btree cursor union members named structure
  xfs: make the btree ag cursor private union anonymous

 fs/xfs/libxfs/xfs_alloc.c          |  16 ++---
 fs/xfs/libxfs/xfs_alloc_btree.c    |  24 +++----
 fs/xfs/libxfs/xfs_bmap.c           |  46 ++++++------
 fs/xfs/libxfs/xfs_bmap_btree.c     |  50 ++++++-------
 fs/xfs/libxfs/xfs_btree.c          |  62 ++++++++--------
 fs/xfs/libxfs/xfs_btree.h          |  51 ++++++-------
 fs/xfs/libxfs/xfs_ialloc.c         |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  20 +++---
 fs/xfs/libxfs/xfs_refcount.c       | 110 ++++++++++++++---------------
 fs/xfs/libxfs/xfs_refcount_btree.c |  28 ++++----
 fs/xfs/libxfs/xfs_rmap.c           | 110 ++++++++++++++---------------
 fs/xfs/libxfs/xfs_rmap_btree.c     |  28 ++++----
 fs/xfs/scrub/agheader_repair.c     |   2 +-
 fs/xfs/scrub/alloc.c               |   2 +-
 fs/xfs/scrub/bmap.c                |   4 +-
 fs/xfs/scrub/ialloc.c              |   8 +--
 fs/xfs/scrub/refcount.c            |   2 +-
 fs/xfs/scrub/rmap.c                |   2 +-
 fs/xfs/scrub/trace.c               |   4 +-
 fs/xfs/scrub/trace.h               |   4 +-
 fs/xfs/xfs_fsmap.c                 |   4 +-
 21 files changed, 291 insertions(+), 288 deletions(-)

-- 
2.24.0.rc0

