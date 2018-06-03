Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbeFCXWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:22:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NMOxW139674
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:24 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2jbvyp9fw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:22:24 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w53NMO9Z029460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:24 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w53NMNHn010995
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:24 GMT
Subject: [PATCH 00/10] xfs: fix various checking problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:22:22 -0700
Message-ID: <152806814253.18187.4009340462930782844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a somewhat longer series of patches to fix some bugs and other
inadequacies in the metadata integrity checking of XFS.  The first patch
makes it so that we can set the dax file flag on a directory so that the
daxiness propagates to new files even if the data device itself does not
support dax.

The rest of the series replaces various ASSERTs in the btree and
directory handling code with error logging and EFSCORRUPTED returns so
that maliciously corrupted filesystem images error out immediately (now
that ASSERT is no longer always fatal).  All of these fixes were found
via online scrub fuzz tests.

Comments and questions are, as always, welcome.

--D
