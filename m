Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40637 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdLKCUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 21:20:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBB2CCXB010465
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:20:01 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2esh08r184-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:19:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GC1c018250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:12 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GBZ7007905
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:12 GMT
Subject: [PATCH 0/6] xfs: reflink fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 10 Dec 2017 18:16:14 -0800
Message-ID: <151295857424.30614.8269461794142248028.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

Hi all,

Here's a rollup of some reflink fixes that I've accumulated over the
past couple of weeks.  I added CLONERANGE support to fsstress and wrote
a fstest to run a long write-mostly fsstress, which very rapidly found
problems.

The first patch fixes a trivial null pointer problem; the second fixes
an ftrace stale data reporting problem; the third fixes a problem where
we ought to clear post-eof preallocations prior to allowing a reflink at
a higher offset than i_size; the fourth relaxes a locking assert
condition that is actually possible; the fifth fixes an infinite loop
when cancelling cow rservations; and the sixth one allows cow remap
operations to use the transaction block reserve to avoid enospc'ing
after a successful cow.

These patches apply directly to the end of 'xfs: logging fixes'.

--D
