Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40284 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752000AbeDZUSz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Apr 2018 16:18:55 -0400
Received: from Liberator-5.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DC7A215D89
        for <linux-xfs@vger.kernel.org>; Thu, 26 Apr 2018 15:17:48 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.16.0 released
Message-ID: <a4832ea0-8ea1-c9f6-1741-8b0c85505ab5@sandeen.net>
Date: Thu, 26 Apr 2018 15:18:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.16.0

Here's the condensed version of notable changes:

xfsprogs-4.16.0 (25 Apr 2018)
        - No further changes

xfsprogs-4.16.0-rc1 (12 Apr 2018)
        - platforms: warn of impending deprecation of irix, freebsd, darwin
        - mkfs.xfs : enable sparse inodes by default (Darrick Wong)
        - fsck.xfs: allow forced boot-time repairs using xfs_repair (Jan Tulak)
        - xfs_repair: new -e flag alters exit code for fixed errors (Jan Tulak)
        - xfs_repair: fix to allow zeroing of corrupt log (Xiao Yang)
        - xfs_repair: remove old dead code (Eric Sandeen)
        - xfs_io: fix operation time reporting (Dave Chinner)
        - xfs_io: add RWF_DSYNC support to pwrite (Dave Chinner)
        - xfs_io: support a basic extent swap command (Brian Foster)
        - xfs_scrub: Many updates, still experimental (Darrick Wong)
        - xfs_db: print transaction reservation type information
        - libxfs: framework to detect memory leaks (Eric Sandeen)
        - misc: Fix up new warnings from gcc 7.3 (Darrick Wong)
        - misc: enable link time optimization, if requested (Darrick Wong)
        - misc: enable retpolines across all xfsprogs utilities (Darrick Wong)

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

9048c8b xfsprogs: Release v4.16.0

