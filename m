Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38645 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbdJRXhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:37:33 -0400
Subject: [PATCH 0/5] miscellaneous fstests fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Oct 2017 16:37:30 -0700
Message-ID: <150836985024.27213.3715197937819365388.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Miscellaneous fstests fixes, starting with a patch to reduce periodic
failures seen in generic/23[23] on XFS; continuing with a bunch of
cleanups to xfs_scrub invocations in preparation for actually landing
xfs_scrub in 4.15; and ending with a few new tests to check for resource
leaks when mounting fails after a log recovery.

--D
