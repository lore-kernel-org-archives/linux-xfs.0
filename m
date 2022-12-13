Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403DDC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 18:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiLMSW5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 13:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbiLMSW4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 13:22:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9210DEE2C
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 10:22:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D563616CE
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 18:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DBBC433EF;
        Tue, 13 Dec 2022 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670955774;
        bh=Zb82dC59mciqWDt7ruj80s3pfBEkRtFm40SEZo7FkII=;
        h=Date:From:To:Cc:Subject:From;
        b=pOOH9RLOasETwQBlwBy1XcUaARP9V9CbDQKWyaJAe6NehbUnXJPOILp1z2cjrQxOa
         vh3mzXI7HYOLXMzrIwxGsrM/UIruWq9j+tw/+5XjNLGvyT4lnSltuINE3+919HAC1q
         /XE+lQz/J36C9lBkROU0xOA+kNYsBmMq1YaOrqNLeaj7P3YlowDypUI/FSMDyQwNtB
         omX8M+xhZJGSmhyT01V1HLgtWFiK/DOhnLeyoijQqC6/bWD13QUeNuzgLugZ/3+4LZ
         kjGEvAaNvpoZQmnSMy3/t1gpTg6amoRdkqEH5+sLei1mJhHkROpQC5+yxrrQe4D84z
         l0ohLDU9YOwww==
Date:   Tue, 13 Dec 2022 10:22:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        torvalds@linux-foundation.org
Cc:     bvanassche@acm.org, kbusch@kernel.org, kch@nvidia.com,
        linux-xfs@vger.kernel.org, willy@infradead.org
Subject: [GIT PULL] iomap: new code for 6.2
Message-ID: <167095574533.1670001.7908839050223801763.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for iomap for 6.2-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:

Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.2-merge-1

for you to fetch changes up to f1bd37a4735286585751dbd9db330b48525cb193:

iomap: directly use logical block size (2022-11-14 10:35:32 -0800)

----------------------------------------------------------------
New code for 6.2:

- Minor code cleanup to eliminate unnecessary bit shifting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Keith Busch (1):
iomap: directly use logical block size

fs/iomap/direct-io.c | 3 +--
1 file changed, 1 insertion(+), 2 deletions(-)

