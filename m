Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeFDQKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 12:10:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54G5xkd181043
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:24 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2jbvyp47tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 16:10:24 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w54GANYZ031943
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54GAMOb008565
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:23 GMT
Subject: [PATCH v2 0/4] xfs: fix various checking problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Jun 2018 09:10:20 -0700
Message-ID: <152812862079.2736.15381483104759513267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a series of patches to fix some inadequacies in the metadata
integrity checking of XFS.  The first patch teaches the directory code
to check the bestfree data while reading in the block instead of
ASSERTing later.  The last three refactor some btree debug code so that
it will always (even in non-debug mode) check pointers before loading
blocks.

Comments and questions are, as always, welcome.

--D
