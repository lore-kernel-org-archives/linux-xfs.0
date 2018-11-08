Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeKII5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 03:57:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA8NJIjP066178
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:04 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2nh4ar47u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Nov 2018 23:20:03 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA8NK2vI015126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:02 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA8NK2sp013732
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:02 GMT
Subject: [PATCH 0/5] xfs-5.0: miscellaneous cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 08 Nov 2018 15:20:01 -0800
Message-ID: <154171920164.30818.2178553842722589349.stgit@magnolia>
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
inode fixes posted earlier.

The first cleanup constifies the struct xfs_owner_inode pointers that
get passed around to the rmap calls.  This enables the second cleanup,
which is to create some global const XFS_RMAP_OINFO_* objects for static
fs metadata.  This enables us to reduce stack usage here and there, and
remove a surprising amount of oinfo setup clutter in the scrub code.

The last three patches add some inode <-> block conversion macros and
adds precomputed inode cluster size and alignment geometry information
in struct xfs_mount instead of calculating it over and over.

These cleanups are being submitted ahead of v2 of the scrub inode fixes
and the repair patches to be sent later.

Comments and questions are, as always, welcome.

--D
