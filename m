Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231F3C7618A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCPTT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCPTTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83B33FBB6;
        Thu, 16 Mar 2023 12:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACB38620F0;
        Thu, 16 Mar 2023 19:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A47CC433EF;
        Thu, 16 Mar 2023 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994365;
        bh=JFM/WHbd2FN1VN6E+izigydSdB9HPxhYIKM/IxRlYXY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=H6kpBgngzT6tsTA7sAcDOvRaD5/eRGFdZoVmONHx+box6Ifcnrea7dqXwqYhtFett
         lWgibBJDbqXd7kXZuXYfl/ung0GwkotaKURTol07fjz2+exU2gK08KNugn/71uivLf
         xTaDYR/x2Wrn1hsUd82xYCvvngrxgZn843L4X8FNf+LyBkkvRDvr5qIP6c2KD2pJrh
         KyGHF6/v0Mxeo/t3zgpyoH/KGafBb0NTMvfwEzJF5EW6uqQg43RjXxQiz8aKssa9ld
         TGy4KtwaTQzT01PfeiUwyvZJJXVIjY2mQZPjcp6aT/5JgSiAYTMw6rjpbT8dt50pMC
         fosTBxKeCuC3A==
Date:   Thu, 16 Mar 2023 12:19:24 -0700
Subject: [PATCHSET v10r1d2 0/1] xfs: bug fixes for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899418137.18288.9076901881477991507.stgit@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains the accumulated bug fixes from Darrick to make
fstests pass and online repair work.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-bugfixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-bugfixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-bugfixes
---
 tests/xfs/122.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

