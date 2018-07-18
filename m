Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731105AbeGRQ3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 12:29:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6IFnlgj167500
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:33 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2k9yjx28sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:33 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFoW4j031399
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:32 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFoTN4006881
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:29 GMT
Subject: [PATCH 0/8] xfs-4.19: fixes & cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 08:50:28 -0700
Message-ID: <153192902811.31685.11590100183112248407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a series of bugfixes and cleanups for 4.19.

The first patch enhances the extended attribute leaf block checks to
sanitize the freemap.  This is essential to prevent asserts on totally
garbage freemap info from taking the fs down during an xattr update.

The second patch ensures that we always return from xfs_defer_finish
with a clean transaction so that any new work added to the transaction
after that does not overflow the reservation.

The next two patches clean up xfs_btree_del_cursor usage.  Callers can
pass negative error numbers into the function to signal a full btree
cursor buffer cleanup so they do not need to use ternary expressions to
select XFS_BTREE_{NO,}ERROR.

The four patches after that shorten name prefixes in the online fsck
code.  The xfs_scrub_* functions are shortened to xchk_*; the
xfs_repair_* functions become xrep_*; struct xfs_scrub_context becomes
struct xfs_scrub; and the final patch of the series cleans up all the
whitespace and indenting problems.  That last patch I did by hand; the
first three were mechanical changes with simple sed scripts.

Comments and questions are, as always, welcome.

--D
