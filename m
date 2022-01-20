Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0F1C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 01:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiATBkz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:40:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50418 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiATBkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 20:40:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2C4461541
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 01:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DB0C004E1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 01:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642642818;
        bh=LtC++d8vEw8cg0dHSCznwyYiWheukIDesMyn4e58/IM=;
        h=Date:From:To:Subject:From;
        b=r+TYH2VGyWAmn6kRP0+QlQ1Miwv2/gHezAGV2GhhpgxAirfFVmtFOxe3GHLcmle6k
         76L1yfIRTsv7ASUkGDxegS5SThlNOXd8mKis3mKWw4JnrcqAx3n1OxvGobwMVpUIZ/
         CAEgCgSUuZ+hnQku0vlbPr9Cj0stX55bEuI7mV9zOa4eOC3E/XgT8veeJ5jftvBbaZ
         MI+gyO4SOb0WTfIx1112s25lun6sOl93BVH89hO9y25tpVuM33Q2bb38jchgs4g9Ea
         6XcNFFkbw0KzBKxVNwRVHeXNrmf4m2b+5b0DJo0neoxLt10nYVPQSd30gozXpijcaJ
         uVNIaRqOjzKqQ==
Date:   Wed, 19 Jan 2022 17:40:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: master updated to f1de072
Message-ID: <20220120014017.GK13540@magnolia>
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

f1de072 design: fix computation of buffer log item bitmap size

New Commits:

Darrick J. Wong (1):
      [f1de072] design: fix computation of buffer log item bitmap size

Code Diffstat:

 design/XFS_Filesystem_Structure/journaling_log.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
