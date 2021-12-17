Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D445C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 20:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhLQUjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 15:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbhLQUjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 15:39:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8AEC061574
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 12:39:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9236B82A99
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 20:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C28C36AE5;
        Fri, 17 Dec 2021 20:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639773540;
        bh=fWpdAjXugK2yQBU54T75wHABBnG8hwwdib0UblYcKjU=;
        h=Date:From:To:Cc:Subject:From;
        b=tIhLrDXeh06KgT+ztIq+SlaebbB83guerf3x/F9rghunzpdhq0JRo48dVkn2Y4Fiu
         wDDfEnGWNVsL6dkWvzyEk8xnxGxALmVHQg260yMxqQS7aOI4WFUDoNKFtF+55HD78c
         reqNN21RyQYY5O99ukDa5Y21bw6EixQy+w/9+ZqiM1HwsA+HEGydHzJj/lCazF4wPG
         B607N9Fhuk4b6dIwxfqpUkGnA30M/pLAFHLYXJujZHDz54xa3tzRIVevhuBtIyY1WY
         P6Ypyl4ngcbCDZ/QSyhxPIsoG4N7M4HOO58pRu10qALI3E8PcCs+4iQFHNbBIQ11sf
         BfQaqH3JX7GGA==
Date:   Fri, 17 Dec 2021 12:39:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: mkfs: document sample configuration file location
Message-ID: <20211217203900.GQ27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the documentation to note where one can find sample configuration
files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4d292dbe..7984f818 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -159,6 +159,7 @@ The configuration options will be sourced from the file specified by the
 option string.
 This option can be use either an absolute or relative path to the configuration
 file to be read.
+Sample configuration files can be found in /usr/share/xfsprogs/mkfs/.
 .RE
 .PP
 .PD 0
