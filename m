Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001C8C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiL3XTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiL3XTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:19:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B522E1D0C6;
        Fri, 30 Dec 2022 15:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D1E2B81DA2;
        Fri, 30 Dec 2022 23:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18917C433D2;
        Fri, 30 Dec 2022 23:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442355;
        bh=UVRMdKaqgi1mM0fvysQykRVVMYim3jzmi8F0T5Ad4cs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SyI/Nu3LIJES9vEMwx/amRCnpG9SFbjCM99h/Lq2MUx1lKAts37PMCayJ1fAq4C2c
         pUOGCXPG35rjZPKlhBkhaLAvCGRPktXrke04KP/O8f5ha7iHVLyfvgNF/3pAXn+lg+
         MWIlfGUS6IK4EnNd97qJRpzzIWOdiD0BVA0REkeC+yr6e/Z/LCo2wuXH/4dX101FcJ
         xaD5azLbhYL1eIELYc7yqND97TbEBp9DUJjBIr3+i+TMDZ32xiIauYyOcCz+fL8Opw
         eQFiCOciCO5lvzEQ8ygvdp8atKsoarZbnZq8SOko+tJ3vrQGHGxcQkyZICdAbSgCM6
         45fh/rBGzYLuA==
Subject: [PATCHSET v24.0 0/1] fstests: online repair of realtime summaries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:51 -0800
Message-ID: <167243879193.732554.7976867017693507837.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

We now have all the infrastructure we need to repair file metadata.
We'll begin with the realtime summary file, because it is the least
complex data structure.  To support this we need to add three more
pieces to the temporary file code from the previous patchset --
preallocating space in the temp file, formatting metadata into that
space and writing the blocks to disk, and swapping the fork mappings
atomically.

After that, the actual reconstruction of the realtime summary
information is pretty simple, since we can simply write the incore
copy computed by the rtsummary scrubber to the temporary file, swap the
contents, and reap the old blocks.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtsummary

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rtsummary
---
 tests/xfs/813     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/813.out |    2 ++
 2 files changed, 50 insertions(+)
 create mode 100755 tests/xfs/813
 create mode 100644 tests/xfs/813.out

