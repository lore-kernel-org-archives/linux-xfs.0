Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11066FA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbiJ0RON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbiJ0ROH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7228F196082
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30354B82722
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF95C433D7;
        Thu, 27 Oct 2022 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890843;
        bh=agIsnpMeHBra2aZcNnjL18tqVPwa+TZAyKzKVI0BAC0=;
        h=Subject:From:To:Cc:Date:From;
        b=pOiPjtHvBvcs95ttgVCr9Isn5zR/QLh1jWqsbgedFbm3G0AcEg8uRT3Ysudx1UZYp
         laNaoMMaiq8po9ef2Q/EMVp0oeU7FjvmvyCdZBNlS9dw9g1wM7jOJVCI4D+wXTSqA4
         lkbu+p2WsC4uAsSYvXWKOWzArkKIcJ0ZQRkNj5r69nTmJOglH98hG/e20AsmvVwDik
         W6zXD2vHLXffxQHIWfQi+P9OTun8wlbIaoR88xaD9/aagBtnVuXlNfyyMRYP8qq6uS
         1pfFGlyfPkNOc5Ryb1bj5u8R5vCO+Ut1duvBY7Goorw5o00lV8QY3HiussZMeBOjlM
         mnZF04gLfItgA==
Subject: [PATCHSET v2 00/12] xfs: improve runtime refcountbt corruption
 detection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:03 -0700
Message-ID: <166689084304.3788582.15155501738043912776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fuzz testing of the refcount btree demonstrated a weakness in validation
of refcount btree records during normal runtime.  The idea of using the
upper bit of the rc_startblock field to separate the refcount records
into one group for shared space and another for CoW staging extents was
added at the last minute.  The incore struct left this bit encoded in
the upper bit of the startblock field, which makes it all too easy for
arithmetic operations to overflow if we don't detect the cowflag
properly.

When I ran a norepair fuzz tester, I was able to crash the kernel on one
of these accidental overflows by fuzzing a key record in a node block,
which broke lookups.  To fix the problem, make the domain (shared/cow) a
separate field in the incore record.

Unfortunately, a customer also hit this once in production.  Due to bugs
in the kernel running on the VM host, writes to the disk image would
occasionally be lost.  Given sufficient memory pressure on the VM guest,
a refcountbt xfs_buf could be reclaimed and later reloaded from the
stale copy on the virtual disk.  The stale disk contents were a refcount
btree leaf block full of records for the wrong domain, and this caused
an infinite loop in the guest VM.

v2: actually include the refcount adjust loop invariant checking patch;
    move the deferred refcount continuation checks earlier in the series;
    break up the megapatch into smaller pieces; fix an uninitialized list
    error.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refcount-cow-domain-6.1
---
 fs/xfs/libxfs/xfs_format.h         |   22 ---
 fs/xfs/libxfs/xfs_refcount.c       |  297 ++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_refcount.h       |   40 ++++-
 fs/xfs/libxfs/xfs_refcount_btree.c |   15 +-
 fs/xfs/libxfs/xfs_types.h          |   30 ++++
 fs/xfs/scrub/refcount.c            |   74 ++++-----
 fs/xfs/xfs_trace.h                 |   48 +++++-
 7 files changed, 362 insertions(+), 164 deletions(-)

