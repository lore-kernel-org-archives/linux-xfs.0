Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34845C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 02:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiD0C0N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357158AbiD0C0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 22:26:12 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFAEB14B67F
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 19:23:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D6A2C10E5ECB
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:23:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-004yy6-O5
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 12:23:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-002uuo-MT
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 12:23:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/8 v5] xfs: intent whiteouts
Date:   Wed, 27 Apr 2022 12:22:51 +1000
Message-Id: <20220427022259.695399-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6268a906
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=z5N34AlkwVaS4wSXBg8A:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a patchset inspired by the performance regressions that were
seen from logging 64k xattrs with Allison's delayed attribute
patchset and trying to work out how to minimise the impact of
logging xattrs. Most of that is explained in the "xfs: intent item
whiteouts" patch, so I won't repeat it here.

The whiteouts massively reduce the journal write overhead of logging
xattrs - with this patchset I've reduced 2.5GB/s of log traffic (16
way file create w/64k xattr workload) down to approximately 220MB of
log traffic, and performance has increased from 9k creates/s to 36k
creates/s. The workload still writes to disk at 2.5GB/s, but that's
what writing 35k x 64k xattrs to disk does.

This is still short of the non-logged attribute mechanism, which
runs at 40-45k creates a second and 3.5-4GB/s to disk, but it brings
logged attrs to within roughly 5-15% of non-logged attrs across the
full range of attribute sizes.

So, while this patchset was clearly insired and has major positive
impact on Allison's delayed attribute work, it also applies
generically to all other intent/intent done pairs that already
exist. Hence I've created this patchset as a stand-alone patchset
that isn't dependent on the delayed attributes being committed, nor
does the delayed attribute patchset need this to funciton properly.
IOWs, they can be merged in parallel and then the attribute log item
implementation be updated to support whiteouts after the fact.

This patchset is separate to the attr code, though, because
intent whiteouts are not specific to the attr code. They are a
generic mechanism that can be applied to all the intent/intent done
item pairs we already have. This patch set modifies all those
intents to use whiteouts, and so there is benefits from the patch
set for all operations that use these intents.

With respect to the delayed attribute patchset, it can be merged
with/without whiteout support and still work correctly with/without
this patchset in place. Once both intent whiteouts and delayed attrs
are merged, we can add whiteout support to delayed attributes with
only a few lines of extra code.

-Dave.

Changelog:

Version 5:
- rebased on 5.18-rc2 + linux-xfs/for-next
- converted transaction flags to unsigned to match tp->t_flags definition

Version 4:
- not published
- rebased on 5.17 + for-next + log shutdown fixes + xlog-write-rework
- fixed memory leak of CUI shadow buffers from log recovery when clearing
  leftover reflink entries.

Version 3:
- https://lore.kernel.org/linux-xfs/20220314220631.3093283-1-david@fromorbit.com/
- rebased on 5.17-rc4 + xlog-write-rework
- no longer dependent on xfs-cil-scalability, so there's some porting changes
  that was needed to remove all the per-cpu CIL dependencies.

Version 2:
- not published
- rebased on 5.15-rc2 + xfs-cil-scalability
- dropped the kvmalloc changes for CIL shadow buffers as that's a
  separate perf problem and not something related to intent
  whiteouts.
- dropped all the delayed attribute modifications so that the
  patchset is not dependent on Allison's dev tree.
- Thanks to Allison for an initial quick review pass - I haven't
  included those RVB tags because every patch in the series has
  changed since the original RFC posting.

RFC:
- https://lore.kernel.org/linux-xfs/20210909212133.GE2361455@dread.disaster.area/

