Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE285C10DAA
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91305218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIIITS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:19:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45179 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgIIITS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 04:19:18 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A76023A83F3
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 18:19:14 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJx-00005J-Em
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:13 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJw-004yNx-V7
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] [RFC] xfs: intent recovery reservation changes
Date:   Wed,  9 Sep 2020 18:19:09 +1000
Message-Id: <20200909081912.1185392-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=reM5J-MqmosA:10 a=FCFb4MqYS3293_AYh3cA:9 a=cTKxcIzwyN92SNIB:21
        a=VsIaKifoHKnFggNa:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

A recent bug report of a log recovery hang led to an analysis of a
metadump image that indicates that an intent can pin the tail of the
log and leave less space in the log than is require to begin
recovery of that intent. In this case, it was an EFI that pinned the
log tail, and the transaction reservation required to replay the EFI
was larger than the remaining free space in the log.

Long story short: the EFI recovery log space reservation is larger
than the log space reservation required to complete the operation at
runtime.

This appears to be a general problem with intents - the reservation
to replay the intent is the reservation of the entire permanent
transaction reservation that logged the intent, not the amount of
log space that is required to _execute_ the intent and record the
intent done item.

This patch series does not attempt to solve this generic problem,
just address the specific EFI reservation for a single EFI that pins
the tail of the log. If deferops and rolling transactions are
required, then recovery of multiple EFIs that all pin the tail of
the log at the same LSN becomes very complex, very fast. I have no clear idea
how to deal with that problem yet, but for the single case where the
extent free (and subsequent defer ops for refcnt and rmap mods) all
complete within the initial EFI reservation, the solution is
relatively straight forward.

That is, EFI recovery is an itruncate reservation minus the unit
reservation for the initial transaction that logs the EFI. At
runtime, this log space will be reserved by both the reserve and
write grant heads, hence we are guaranteed to have at least that
amount of space free in the log when we start recoverying the EFI.

For a single EFI pinning the tail of the log, once we free the
extent and log the EFD, the log tail is unpinned and the rest of
defered ops can be run without issue.

If there are multiple log tail pinning intents, then we cannot allow
the defered ops in an intent chain to roll once they run out of
initial recovery grant space. If they have to reserve more log space
rather than just regrant from the initial reservation, then they are
stealing log space from other intents that may pin the tail of the
log and need that space to guarantee that they can be replayed to
unpin the tail of the log. i.e. it gets complex real fast.

Hence this patchset does not attempt to solve the generic problem,
just the simple one-off EFI case. THe first patch is a back-portable
"minimal fix" for the problem, the second patch creates a formal
reservation construct for freeing a single extent to the AG free
list and converts the EFI recovery reservation to use it, and the
third patch factors all the existing reservation calculations to use
the free extent reservation instead of open coding it everywhere.

This last patch fixes some inconsistencies, too, in that some
extent alloc/free reservations fail to take into account AGFL
modifications. I also noted some concerns about the number of
extent alloc/free operations that certain transactions reserve space
for - if they are too large, then we should be able to reduce the
size of some of the large transactions significantly.

But doing any of that requires much, much more investigation than I
can do in a couple of hours, so if anyone is looking for something
they can sink a bit of time into, this would be a good thing to look
at.....

Anyway, this has run through fstests with reflink+rmap enabled
without regressions, so the patchset is not an obvious disaster.
Comments, thoughts, ideas all welcome...

Cheers,

Dave.


Dave Chinner (3):
  xfs: EFI recovery needs it's own transaction reservation
  xfs: add a free space extent change reservation
  xfs: factor free space tree transaciton reservations

 fs/xfs/libxfs/xfs_trans_resv.c | 143 ++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_trans_resv.h |   2 +
 fs/xfs/xfs_extfree_item.c      |   2 +-
 3 files changed, 74 insertions(+), 73 deletions(-)

-- 
2.28.0

