Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755406AbdLORQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 12:16:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBFHGeSA177760
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:16:40 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2evje0r2fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:16:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBE3o014552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:15 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBEce029517
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:14 GMT
Subject: [PATCH 0/4] xfs: more reflink fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 15 Dec 2017 09:11:07 -0800
Message-ID: <151335786780.26575.15542999972223359181.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are more reflink fixes that I've accumulated over the past week.
I added CLONERANGE support to fsstress and reran xfstests, which very
rapidly found problems.  This series fixes a number of problems dug up
by xfs/017.

The first two patches disentangle a mess between the incore inode radix
tree tags and the corresponding inode flags.  We use the inode eofblocks
flags as a proxy for whether or not the same eofblocks tag is set for
the radix tree, which means that we can't use that single iflag to
represent the cowblocks radix tree tag, so give the cowblocks tag a
corresponding inode flag.  This fixes a bug where the cowblocks tag
silently isn't set if the inode already had the eofblocks tag set.

The second patch then fixes the clearing of the cow tag & reflink flag
when truncating the file -- we only want to clear the reflink flag if
both data & cow forks are empty, and we can only clear the cow tag if
the cow fork is totally empty; i_cnextents only tracks real extents.

The third patch flushes all the cow reservations when we remount the
filesystem ro, to put the fs in a clean quiesced state (i.e. no orphaned
cow staging extents) so that we can reduce mount times later.

The fourth patch sets the cow tag when we do direct allocations into the
cow fork so that any hint-aligned remnants are cleaned out at remount-ro
time.

These patches apply directly to the end of 'xfs: reflink fixes'.

--D
