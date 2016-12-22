Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45134 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941783AbcLVXEf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 18:04:35 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A44D8550
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 17:04:19 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.9.0-rc1 released
Message-ID: <ca13058e-d3a6-fd0e-4ea3-ac13bf22fe8c@sandeen.net>
Date: Thu, 22 Dec 2016 17:04:33 -0600
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

has just been updated and tagged with v4.9.0-rc1.

This is the first release candidate with support for the new
reflink & dedupe support, and contains several other updates and
fixes. See the doc/CHANGES file summary included below for details.

xfsprogs-4.9-rc1 (22 Dec 2016)
        - add reflink and dedupe support (Darrick Wong)
        - Convert from off64_t to off_t (Felix Janda)
        - xfs_io: add command line option to start an idle thread (Amir Goldstein)
        - xfs_repair: junk leaf attribute if count == 0 (Eric Sandeen)
        - xfs_quota: handle wrapped id from GETNEXTQUOTA (Eric Sandeen)
        - xfs_repair: fix some potential null pointer deferences (Darrick Wong)
        - libxfs_apply: filtering fixes (Dave Chinner)

Note, when this release is complete I'll get all the other pending
patches merged, and you can bug me about anything that got missed.

The new head of the master branch is commit:

3ad9120 xfsprogs: Release v4.9.0-rc1

New Commits:

Eric Biggers (1):
      [5c0599b] Fix building xfsprogs on 32-bit platforms

Eric Sandeen (2):
      [c89be81] xfs_quota: Fix test for wrapped id from GETNEXTQUOTA
      [3ad9120] xfsprogs: Release v4.9.0-rc1


Code Diffstat:

 VERSION               |  4 ++--
 configure.ac          |  5 +----
 doc/CHANGES           |  9 +++++++++
 include/builddefs.in  |  2 +-
 m4/package_libcdev.m4 | 16 ----------------
 quota/report.c        | 20 ++++++++++----------
 6 files changed, 23 insertions(+), 33 deletions(-)
