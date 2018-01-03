Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49935 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbeACSkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 13:40:10 -0500
Subject: [PATCH 0/5] xfsprogs: 4.15 rollup pt. 2
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Jan 2018 10:39:58 -0800
Message-ID: <151500479880.7713.6538509149156363572.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are some patches fixing up random odds and ends in 4.15.  We fix some
CoW staging extent misreporting in xfs_db, an xfs_db crash when address
selectors have a trailing slash, libxfs api violations in xfs_repair, and
a grep pattern error in the libxfs api violation checking tool.

Eric: You might already have the first few of these; they haven't changed.

--D
