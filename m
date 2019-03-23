Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60296 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfCWAKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Mar 2019 20:10:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2N03d8A186726
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 00:10:38 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r8rjv8m1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 00:10:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2N0Abbt009814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 00:10:37 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2N0AbST031807
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 00:10:37 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Status report 3/18 - 3/22
Message-ID: <270152f8-f3e2-3e4b-aec5-a623a06aa773@oracle.com>
Date: Fri, 22 Mar 2019 17:10:36 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Shirley Ma <shirley.ma@oracle.com>

Status report 3/18 - 3/22

[1] PMEM bug and performance
https://bug.oraclecorp.com/pls/bug/webbug_print.show?c_rptno=29494898
   Attended XFS performance meeting to discuss performance differences 
seen between xfs and ext4
   Need to understand why performance increase is only seen when double 
write featured is enabled
   Need to wait for block trace output for further analysis

   Fix for xfs crash on pmem moved to bugzilla to release fix
   http://ca-bugzilla.us.oracle.com/bugzilla/show_bug.cgi?id=47146

[2] XFS Parent Pointer update
   Started updating previous parent pointer solution onto latest 
development code
   Some adjustments needed for delayed operations and protofiles
   Will send out set for review once all the bugs are worked out again

[3] Patches reviewed:
    [PATCH] xfs: serialize unaligned dio writes against all other dio writes

Thanks everyone!
Allison
