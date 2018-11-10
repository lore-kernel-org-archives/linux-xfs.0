Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbeKJK21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 05:28:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAA0hlfC078066
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:21 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2nh33uhtrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:21 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAA0jF1c019439
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:15 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAA0jFgf022913
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:15 GMT
Subject: [PATCH 0/6] xfsprogs-4.20: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 09 Nov 2018 16:45:15 -0800
Message-ID: <154181071499.3727.3910572718199592407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Here are some patches for xfsprogs 4.20.

The first patch splits up the commands documented in the xfs_io manpage
into more categories than "file i/o", "mmap i/o", and "everything else".

The second patch (re)fixes a bug in xfs_repair where it would assert if
the first record in a directory da btree block pointed to block 0.

The third patch fixes a problem where we try to allocate a transaction
with an unnecessary block reservation in order to fix the AGFL.  AGFL
blocks are counted in fdblocks, and at that point we haven't written out
the new fdblocks anyway.

The fourth patch fixes xfs_scrub's bulkstat code to handle the case of
an inode chunk with all 64 inodes free, which can happen when more than
64 inodes can be stored in a fs block.

The fifth patch fixes scrub's phase 7 reporting so that we don't print
single-unit numbers ("3.0 inodes") with fractional components.

The sixth patch moves xfs_scrub and xfs_scrub_all to /usr/sbin because
they both depend on components that live in /usr.

--D
