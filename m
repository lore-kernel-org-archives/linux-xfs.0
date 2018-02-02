Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbeBBVgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 16:36:25 -0500
Subject: [PATCH 0/4] xfsprogs: 4.15 rollup pt. 4
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Feb 2018 13:36:21 -0800
Message-ID: <151760738102.29371.13542858379823064383.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Four more fixes -- disallow creation of reflink+realtime filesystems, two
things in scrub that coverity complained about, and an addition to scrub so
that it always logs whatever it finds in syslog, even if running
interactively.

The first three are very straightforward, but Eric wanted more comment on the
syslog thing, so if you have an opinion about how hard we try to record all of
scrub's comments to syslog for later QA retrieval, bikeshed now. :)

--D
