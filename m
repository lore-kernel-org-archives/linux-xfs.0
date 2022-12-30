Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D827CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 21:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiL3VN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3VNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 16:13:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795891C40D;
        Fri, 30 Dec 2022 13:13:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 365A9B81C26;
        Fri, 30 Dec 2022 21:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD8FC433EF;
        Fri, 30 Dec 2022 21:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672434801;
        bh=SHf6Q4nQqn/WFPsljH3FIiwRu8zRTh2NBmsBnXPz+X0=;
        h=Date:From:To:Cc:Subject:From;
        b=qn2blO/I5TKRjQ7MuGWpbIpCR7UxL/l922b0eL2F0SHtz9vGlqil3N3FQakH5Wwgb
         /YB7aY7zCEDMZovkImXPhWuBIl6e0yx/K4hfGAHTLnkm5ApfC6b9WENGoUPEcYRFW+
         WzBjWM4qAolNmHm3eO+83sxDkOMsUmjVAl71NkRS5VBGTP937PeYBM3l7fXnTGP0N2
         BM74AYDS5CbFke2pO0I+yVTI2UzS9NWkWyciETntZMRirCVzySCJI6sTsfXOR3EY6E
         +lgWx5Nyz3kSBIIOk7KtDVSwU4k2TxzPX070lFeB/imcyq5SyNbwXIeukWSXZVbmlk
         ySSkNXwn+W3OQ==
Date:   Fri, 30 Dec 2022 13:13:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Catherine Hoang <catherine.hoang@oracle.com>, djwong@kernel.org
Cc:     xfs <linux-xfs@vger.kernel.org>, greg.marsden@oracle.com,
        shirley.ma@oracle.com, konrad.wilk@oracle.com,
        fstests <fstests@vger.kernel.org>, Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [NYE DELUGE 1/4] xfs: all pending online scrub improvements
Message-ID: <Y69UceeA2MEpjMJ8@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

As I've mentioned several times throughout 2022, I would like to merge
the online fsck feature in time for the 2023 LTS kernel.  The first big
step in this process is to merge all the pending bug fixes, validation
improvements, and general reorganization of the existing metadata
scrubbing functionality.

This first deluge starts with the design document for the entirety of
the online fsck feature.  The design doc should be familiar to most of
you, as it's been on the list for review for months already.  It
outlines in brief the problems we're trying to solve, the use cases and
testing plan, and the fundamental data structures and algorithms
underlying the entire feature.

After that come all the code changes to wrap up the metadata checking
part of the feature.  The biggest piece here is the scrub drains that
allow scrub to quiesce deferred ops targeting AGs so that it can
cross-reference recordsets.  Most of the rest is tweaking the btree code
so that we can do keyspace scans to look for conflicting records.

For this review, I would like people to focus the following:

- Are the major subsystems sufficiently documented that you could figure
  out what the code does?

- Do you see any problems that are severe enough to cause long term
  support hassles? (e.g. bad API design, writing weird metadata to disk)

- Can you spot mis-interactions between the subsystems?

- What were my blind spots in devising this feature?

- Are there missing pieces that you'd like to help build?

- Can I just merge all of this?

The one thing that is /not/ in scope for this review are requests for
more refactoring of existing subsystems.  While there are usually valid
arguments for performing such cleanups, those are separate tasks to be
prioritized separately.  I will get to them after merging online fsck.

I've been running daily online scrubs of every computer I own for the
last five years, which has helped me iron out real problems in (limited
scope) production.  All issues observed in that time have been corrected
in this submission.

As a warning, the patches will likely take several days to trickle in.
All four patch deluges are based off kernel 6.2-rc1, xfsprogs 6.1, and
fstests 2022-12-25.

Thank you all for your participation in the XFS community.  Have a safe
New Years, and I'll see you all next year!

--D
