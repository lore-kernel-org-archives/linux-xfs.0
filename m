Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58120 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032941AbdAEWzf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Jan 2017 17:55:35 -0500
Received: from Liberator.example.com (74-95-67-117-Minnesota.hfc.comcastbusiness.net [74.95.67.117])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 26395D4B
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2017 16:54:59 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.9.0 released
Message-ID: <1cae2699-b903-638a-5313-b096d61d05c1@sandeen.net>
Date: Thu, 5 Jan 2017 16:55:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.9.0.

This is the first release with support for the new
reflink & dedupe features, and contains several other updates and
fixes. See the doc/CHANGES file summary included below for details.

xfsprogs-4.9.0 (5 Jan 2017)
        - no changes from v4.9.0-rc1

xfsprogs-4.9-rc1 (22 Dec 2016)
        - add reflink and dedupe support (Darrick Wong)
        - Convert from off64_t to off_t (Felix Janda)
        - xfs_io: add command line option to start an idle thread (Amir Goldstein)
        - xfs_repair: junk leaf attribute if count == 0 (Eric Sandeen)
        - xfs_quota: handle wrapped id from GETNEXTQUOTA (Eric Sandeen)
        - xfs_repair: fix some potential null pointer deferences (Darrick Wong)
        - libxfs_apply: filtering fixes (Dave Chinner)

The new head of the master branch is commit:

95d8518 xfsprogs: Release v4.9.0

New Commits:

Eric Sandeen (1):
      [95d8518] xfsprogs: Release v4.9.0


Code Diffstat:

 VERSION          |  2 +-
 configure.ac     |  2 +-
 debian/changelog |  6 ++++++
 doc/CHANGES      | 13 ++++++++-----
 4 files changed, 16 insertions(+), 7 deletions(-)

