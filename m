Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B66AC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjBPVzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBPVy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:54:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5194D63B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:54:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D9E8B829BF
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E23C433D2;
        Thu, 16 Feb 2023 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584368;
        bh=cEjqdxp6Wq9bX1mWhsvlke+IYyE8sR2VtbYHyzmefHU=;
        h=Subject:From:To:Cc:Date:From;
        b=ZXXHCdDCnjDDoTlGoF/N4Puz/k6pRQ54HcZevK/39Lj3l2fau+jnoiuLN5HZEOj8y
         b1l7DPMhckHguoOCMt0PgjfCihLaZkxmTvs17B2vAhbw4BfAS7bZb0y0tipCAd95qP
         4xDBn9/0kYoMJJR7qgPqxAi3r1A7sYLjdb41AixJVrqe/c7nZ/9a2r/8KbNCJOKmU2
         637m/oXB9Qjt2fnUhfEnmzynDN1auQ94lZzzAq8LXVZGAubTyeg+i3C9Emmvd1R13l
         blzUMHMlTtO5kzyBGZK9mk+Bfkry/Xo8ExPDeONRO1J45Qj4qta+34C/A1JXch1p52
         DdnQCvAYlpQYw==
Subject: [PATCHSET 0/5] xfsprogs: random fixes for 6.2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     tytso@mit.edu, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Date:   Thu, 16 Feb 2023 13:52:47 -0800
Message-ID: <167658436759.3590000.3700844510708970684.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of all the random fixes I've collected for xfsprogs 6.2.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.2
---
 io/bmap.c          |    2 +-
 io/open.c          |    3 ++-
 mkfs/proto.c       |   23 ++++++++++++++++++++++-
 scrub/fscounters.c |    2 +-
 spaceman/freesp.c  |    1 -
 5 files changed, 26 insertions(+), 5 deletions(-)

