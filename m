Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19695 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933891AbdKAVqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:46:33 -0400
Subject: [PATCH 00/14] rollup of fstests fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:46:28 -0700
Message-ID: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

This is a rollup of all the patches I've been sending to the list,
because the previous thread is a mess of resent patches and patch
series cramming.

Patches 1-2,4,6,8 are unchanged from last week.  They've possibly even
gone in already, but I can't tell what's in Eryu's private branch. :/

Patch 3 is the same as "PATCH v3 5/6" from the last series.

Patch 5 now checks that repair can fix the corruption introduced.

Patch 7 is new, it checks for /usr/sbin/thin_check before running
generic/459 per an earlier discussion on the list.

Patches 9-14 are new; I've been trying to clean up all the minor test
failures in preparation for 4.15 madness.

--D
