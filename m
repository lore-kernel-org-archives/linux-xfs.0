Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44262 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeI1HZ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 03:25:29 -0400
Subject: [PATCH v2 0/6] xfsprogs-4.19: transaction cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Sep 2018 18:04:21 -0700
Message-ID: <153809666117.32548.6836488790026631787.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Here are six cleanups to the userspace transaction code that make the
commit and roll code more closely resemble their kernel counterparts,
and fix a number of problems where client code did not check the return
values of the transaction functions.  They should apply to Eric's
libxfs-4.19-sync branch.

--D
