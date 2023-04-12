Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD62C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjDLDq4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLDqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4AF30E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D39862D90
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7639CC433D2;
        Wed, 12 Apr 2023 03:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271213;
        bh=zJ+FyYRRAJjL7+SS4ho8rQ+Oj15PD5C3vHyPaP2tstY=;
        h=Date:Subject:From:To:Cc:From;
        b=uAjmmibylhHcnrKhYGeqwXcxBGtN3SiRaANjD/0aUrr03ZSgZ0vYeDpDFVJLYheMF
         EHzwGrqW0K+E9klBwGpET89ayPI13jEDblZ8lSUTI/eV8lX1eejSfNXjXCXabd1lcv
         5xyBAq25zUFsLfP+9AUhnuJcDTX1oQwflwqYaRqOMPx6yq+xL7IsyHtixVr2t+0jQi
         TJ1P5Qp3wxi/+CR7CDddP41YfcfLfa0gL625q5aM4m+YWrt57BxhKupkariL7c+2TF
         YQDarYzjt56RlV1KPTDBQtS/FJVS7eWet2xzbDqT7YMVH8xnL7oeJ8alJphFh5/2Qh
         tnhfi7rKksf3w==
Date:   Tue, 11 Apr 2023 20:46:53 -0700
Subject: [GIT PULL 8/22] xfs: fix rmap btree key flag handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094461.417736.1444539165048108895.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit de1a9ce225e93b22d189f8ffbce20074bc803121:

xfs: hoist inode record alignment checks from scrub (2023-04-11 19:00:06 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/rmap-btree-fix-key-handling-6.4_2023-04-11

for you to fetch changes up to 38384569a2a8a721623d80c5ae3bcf80614ab792:

xfs: detect unwritten bit set in rmapbt node block keys (2023-04-11 19:00:07 -0700)

----------------------------------------------------------------
xfs: fix rmap btree key flag handling [v24.5]

This series fixes numerous flag handling bugs in the rmapbt key code.
The most serious transgression is that key comparisons completely strip
out all flag bits from rm_offset, including the ones that participate in
record lookups.  The second problem is that for years we've been letting
the unwritten flag (which is an attribute of a specific record and not
part of the record key) escape from leaf records into key records.

The solution to the second problem is to filter attribute flags when
creating keys from records, and the solution to the first problem is to
preserve *only* the flags used for key lookups.  The ATTR and BMBT flags
are a part of the lookup key, and the UNWRITTEN flag is a record
attribute.

This has worked for years without generating user complaints because
ATTR and BMBT extents cannot be shared, so key comparisons succeed
solely on rm_startblock.  Only file data fork extents can be shared, and
those records never set any of the three flag bits, so comparisons that
dig into rm_owner and rm_offset work just fine.

A filesystem written with an unpatched kernel and mounted on a patched
kernel will work correctly because the ATTR/BMBT flags have been
conveyed into keys correctly all along, and we still ignore the
UNWRITTEN flag in any key record.  This was what doomed my previous
attempt to correct this problem in 2019.

A filesystem written with a patched kernel and mounted on an unpatched
kernel will also work correctly because unpatched kernels ignore all
flags.

With this patchset applied, the scrub code gains the ability to detect
rmap btrees with incorrectly set attr and bmbt flags in the key records.
After three years of testing, I haven't encountered any problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: fix rm_offset flag handling in rmap keys
xfs: detect unwritten bit set in rmapbt node block keys

fs/xfs/libxfs/xfs_rmap_btree.c | 40 +++++++++++++++++++++++--------
fs/xfs/scrub/btree.c           | 10 ++++++++
fs/xfs/scrub/btree.h           |  2 ++
fs/xfs/scrub/rmap.c            | 53 ++++++++++++++++++++++++++++++++++++++++++
4 files changed, 95 insertions(+), 10 deletions(-)

