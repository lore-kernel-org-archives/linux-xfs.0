Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34600 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755373AbeAIUpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 15:45:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09KfflT075020
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:45:55 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fd4kxr4ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 20:45:55 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w09Kjs0V015887
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:45:54 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09KjsjO009421
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:45:54 GMT
Subject: [PATCH 0/3] xfs: printk fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Jan 2018 12:45:53 -0800
Message-ID: <151553075309.16288.5030700495895866371.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a trio of patches that clean up '%p'-related printk format
strings.  The first patch removes redundant '0x' prefixes; the second
makes us use '%pS' consistently for instruction pointers; and the third
undoes the new "don't leak pointers to dmesg" code in 4.15-rc1 if
CONFIG_XFS_DEBUG=y so that we can actually chase pointers again.

--D
