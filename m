Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932239AbeAXXxW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 18:53:22 -0500
Subject: [PATCH 0/5] xfstests: fixes and reflink quota tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 24 Jan 2018 15:53:17 -0800
Message-ID: <151683799705.17051.9987269343206294671.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

This series contains the kmemleak checks for xfstests, a bunch of minor
fixes to existing tests, and some new tests that check quota accounting
regressions in xfs.  The quota accounting tests will fail until the
series "xfs: reflink/scrub/quota fixes" goes into 4.16.

--D
