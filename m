Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52738 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbeKNJkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 04:40:17 -0500
Subject: [PATCH 0/6] xfstests: add copy/dedupe/clone to fsx/fsstress
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 13 Nov 2018 15:39:37 -0800
Message-ID: <154215237717.21151.11976488103599724788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

This series adds to fsx support for FICLONERANGE, FIDEDUPERANGE, and
copy_file_range.  It adds to fsstress support for copy_file_range.
There are known failures in 4.20-rc2, particularly with copy_file_range,
so these patches provide a fstests base for everyone to start/continue
looking for bugs.

--D
