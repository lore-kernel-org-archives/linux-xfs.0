Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54E5C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 22:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjBPWDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 17:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBPWDQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 17:03:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0533C2B9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 14:03:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A724760C6D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 22:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3B7C433D2;
        Thu, 16 Feb 2023 22:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584994;
        bh=pmIFGeXTMgGFfRahz1hSYr/0RUsu1K1C5b6sCKPTfpc=;
        h=Date:From:To:Cc:Subject:From;
        b=n+u7+iOw+T9+uEMC55RpJBpqsHntLDeN0e5Cbnmc7OD8KWYyzRcCR/TK3d0c+wI+E
         Gv8j1xF7DyikvtqAIyfae8MSiD9xiov9QyCH+14RzrVVKIdBmejAnRPsZtbzwYfFom
         Wa+KA3iqHjg80u2Zaoq2XL975PMJDi/y+f3Z14cUXZA3Gmx2h3xb15K4kPSKMxA8f8
         0JMuRsCf4HlSBFRXT0Y7RpTdfu65Dx/t24IikImsufX/VZWc++f4zrAckNCMH8BLvt
         5Kcn35R4Cq1HyVJ/HY1dou7V8ly+a3GrXCuSWGb62GGXUKNGsmLqFYBtPoW+hYD2OW
         jhHvoYUBQI7xA==
Date:   Thu, 16 Feb 2023 14:03:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     darrick.wong@oracle.com
Cc:     allison.henderson@oracle.com, chandan.babu@oracle.com,
        chenk@redhat.com, dchinner@redhat.com, djwong@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-documentation: master updated to 858b0667
Message-ID: <167658495502.3598511.9392507365873979958.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The master branch of the xfs-documentation repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the master branch is commit:

858b0667 design: document extended attribute log item changes

4 new commits:

Csaba Henk (1):
[512a88b8] xfsdocs: add epub output

Darrick J. Wong (3):
[bc5c9521] design: update group quota inode information for v5 filesystems
[40255004] design: document the large extent count ondisk format changes
[858b0667] design: document extended attribute log item changes

Code Diffstat:

.gitignore                                         |   1 +
admin/Makefile                                     |  13 ++-
admin/XFS_Performance_Tuning/Makefile              |  13 ++-
design/Makefile                                    |  13 ++-
design/XFS_Filesystem_Structure/Makefile           |  13 ++-
.../allocation_groups.asciidoc                     |  25 +++--
.../journaling_log.asciidoc                        | 109 +++++++++++++++++++++
design/XFS_Filesystem_Structure/magic.asciidoc     |   2 +
.../XFS_Filesystem_Structure/ondisk_inode.asciidoc |  61 ++++++++++--
9 files changed, 229 insertions(+), 21 deletions(-)
