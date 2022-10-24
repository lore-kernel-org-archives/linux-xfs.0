Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521B4FA373D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiJXXNX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiJXXND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:13:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6273016655A
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1685615C4
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B72AC433D7;
        Mon, 24 Oct 2022 21:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647152;
        bh=Yj/3Uj9N3thFLk8r6kC9iopOF6DRIKbDP4CoH2rWQpk=;
        h=Subject:From:To:Cc:Date:From;
        b=NQ8BjTsEGOjjoEHLVcA1KD0C5/W66F4JuEc2QR5JRRO3k2SAat3kNzuqdoeBwx8bZ
         i/B8jMMOEa2ABi30nMls70mGB9BskFA09yjqR5SPCjtUcc1LZzkWZgPXe0JVhtzE1A
         Cfct1FVGaj0XmlCSzzsiwepwiRDU0SIgGmB/hhPwHfrONmziLZrnU9cHn8YPzyIpVG
         g02ENcCCVWonOzFprbNO9XW7FXTK9fxx/6zSTYpg5UmjMa11FxZVPsMd5rtqC2qU+j
         +KdFuIW0gPS7xyRV75wCvVO0HL8hhWybtozF1joz30NTGrB3JY1J4nmrNUsyNfT4F+
         tkkJKXhXNpWRw==
Subject: [PATCHSET 0/6] xfs: fix various problems with log intent item
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 24 Oct 2022 14:32:31 -0700
Message-ID: <166664715160.2688790.16712973829093762327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Starting with 6.1-rc1, CONFIG_FORTIFY_SOURCE checks became smart enough
to detect memcpy() callers that copy beyond what seems to be the end of
a struct.  Unfortunately, gcc has a bug wherein it cannot reliably
compute the size of a struct containing another struct containing a flex
array at the end.  This is the case with the xfs log item format
structures, which means that -rc1 starts complaining all over the place.

Fix these problems by memcpying the struct head and the flex arrays
separately.  Although it's tempting to use the FLEX_ARRAY macros, the
structs involved are part of the ondisk log format.  Some day we're
going to want to make the ondisk log contents endian-safe, which means
that we will have to stop using memcpy entirely.

While we're at it, fix some deficiencies in the validation of recovered
log intent items -- if the size of the recovery buffer is not even large
enough to cover the flex array record count in the head, we should abort
the recovery of that item immediately.

The last patch of this series changes the EFI/EFD sizeof functions names
and behaviors to be consistent with the similarly named sizeof helpers
for other log intent items.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-log-recovery-misuse-6.1
---
 fs/xfs/libxfs/xfs_log_format.h |   60 ++++++++++++++++++++++++++++---
 fs/xfs/xfs_attr_item.c         |   54 ++++++++++++----------------
 fs/xfs/xfs_bmap_item.c         |   46 +++++++++++-------------
 fs/xfs/xfs_extfree_item.c      |   78 +++++++++++++++-------------------------
 fs/xfs/xfs_extfree_item.h      |   16 ++++++++
 fs/xfs/xfs_ondisk.h            |   23 ++++++++++--
 fs/xfs/xfs_refcount_item.c     |   45 +++++++++++------------
 fs/xfs/xfs_rmap_item.c         |   58 ++++++++++++++----------------
 fs/xfs/xfs_super.c             |   12 ++----
 9 files changed, 216 insertions(+), 176 deletions(-)

