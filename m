Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45246 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbeK2K3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:29:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNN1Zh153084
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:26:14 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2nxy9rd70d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:26:14 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wASNQDgv003126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:26:13 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wASNQDBB026632
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:26:13 GMT
Subject: [PATCH 0/4] xfs-5.0: cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:26:12 -0800
Message-ID: <154344757198.3700.16167533135011546878.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are some cleanups I made against the rmap code and the inode
geometry code, which came up as part of review comments on the scrub
inode fixes posted earlier.  It then fixes some problems with the inode
btree scrub code, namely that the existing code does not handle the case
where a single inode cluster is mapped by multiple inobt records.

The first patch creates some global const XFS_RMAP_OINFO_* objects for
static fs metadata.  This enables us to reduce stack usage here and
there, and remove a surprising amount of oinfo setup clutter in the
scrub code.

The next three patches add some inode <-> block conversion macros and
adds precomputed inode cluster size and alignment geometry information
in struct xfs_mount instead of calculating it over and over.

Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
