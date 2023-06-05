Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6952C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbjFEPgP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbjFEPgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:36:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460D6109
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC87D6271F
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A9BC433EF;
        Mon,  5 Jun 2023 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979367;
        bh=ZTsSltqRsaceU1FbemhHWO3L2/jB6S12hd2X8tEPEn0=;
        h=Subject:From:To:Cc:Date:From;
        b=sRlWntelD1BUJxOkZuubfZuGUU5SWXD+OxxWb1gUz9K17Uu+gtgkStuU+hh+ep6NF
         gAXnOWiNKGKUWqe0DRfvOv9iNcdvAbCC9gVfpEU0Cxff2Fxn9yQuJUWS/kDkGLYLTm
         cMNlX3Huz6Nxr7EJ2DP//CmPMlVs4abgFUDsceGZL8RyEXeCn4oPjyKI0B1GXT5zyA
         fcSK5nwbt+Cvr4W3hRdx7o+cpgBzCTCJCXI/1rj+sK19wcfrDBLiwiOZ1MbphVSzW/
         WE6X8W86VqJWiFZfDTkS5ocw/fLOiCwq0w+emtSxOIExIxpSJHy/IWSdErDrXVv8lf
         a0BQjfvZt511g==
Subject: [PATCHSET v24.0 0/3] xfsprogs: fix rmap btree key flag handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:36:06 -0700
Message-ID: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

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
Online scrub is amended to recommend rebuilding of rmap btrees with the
unwritten flag set in key records.

The xfsprogs counterpart to this series amends xfs_repair to report key
records with the unwritten flag bit set, just prior to rebuilding the
rmapbt.  It also exposes the bit via xfs_db to enable testing back and
forth.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-btree-fix-key-handling

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rmap-btree-fix-key-handling
---
 db/btblock.c  |    4 ++++
 repair/scan.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 1 deletion(-)

