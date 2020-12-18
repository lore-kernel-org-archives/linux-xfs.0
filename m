Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B25C2BBD4
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7241A23A79
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732935AbgLRH0s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:26:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgLRH0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:26:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KYgU003295
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=q0Q8/0tChNSbUYlqvMePHuqJewVQH1LQ+zaZklvi/BM=;
 b=oE7QLmBp027LTXOm60u2yxGoLl6NHC11hYTvVY1F+4Plz/au7uXk7CeTDE8RVx5mO+49
 7RhkcqObfT6yFV9vtdzp04ZJdO3XmMSX3V7XPuki/AJiCMLjomhSmz8z7JJKRS23SO0R
 rclekg9T713tS0a03UE16R3CiDrkRcGH68hltyJeKMV+tnC0ieG8aCyEpQhsQDC00ntf
 xi7HlVPEX4IdV/Fur8ijg9SZa5wqhML2cCvGC6m0aM23FRyBu7wEuxKH3iPnP94Nhj9g
 CFadO4gLjQHBC3wjTtt2p0kNp5HZp+yymNSEnvqirPjPJFVZzJ7PljbcW3mJ6aPg8Aad QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35cn9rs17y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KIIV038336
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35d7t1h98t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7Q58R002041
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:05 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:05 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 00/14] xfsprogs: Delayed Attributes
Date:   Fri, 18 Dec 2020 00:25:41 -0700
Message-Id: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  This set also includes some patches from the kernel side that have
not yet been ported. This set also includes patches needed for the user space
cli and log printing routines

Additionally, the following updates have been made since v13:

xfsprogs: Add log item printing for ATTRI and ATTRD
   Modified print routines to print names and values as strings 
      if they are printable, or hexdump if they are not
   Added helper function is_printable
   Added helper function print_or_dump
   Misc alignment fixes in xlog_print_record

This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v14

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v14_extended

Thanks all!
Allison

Allison Collins (3):
  xfsprogs: Add helper xfs_attr_node_remove_step
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Add delayed attributes error tag

Allison Henderson (11):
  xfsprogs: Add xfs_attr_node_remove_cleanup
  xfsprogs: Hoist transaction handling in xfs_attr_node_remove_step
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines
  xfsprogs: Add state machine tracepoints
  xfsprogs: Rename __xfs_attr_rmtval_remove
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Skip flip flags for delayed attrs
  xfsprogs: Remove unused xfs_attr_*_args
  xfsprogs: Merge xfs_delattr_context into xfs_attr_item
  xfsprogs: Add log item printing for ATTRI and ATTRD

 include/libxfs.h         |   1 +
 include/xfs_trace.h      |   1 +
 io/inject.c              |   1 +
 libxfs/defer_item.c      | 128 ++++++++++
 libxfs/libxfs_priv.h     |   1 +
 libxfs/xfs_attr.c        | 632 ++++++++++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h        | 360 ++++++++++++++++++++++++++-
 libxfs/xfs_attr_leaf.c   |   5 +-
 libxfs/xfs_attr_remote.c | 126 ++++++----
 libxfs/xfs_attr_remote.h |   7 +-
 libxfs/xfs_defer.c       |   1 +
 libxfs/xfs_defer.h       |   2 +
 libxfs/xfs_errortag.h    |   4 +-
 libxfs/xfs_log_format.h  |  43 +++-
 logprint/log_misc.c      |  48 +++-
 logprint/log_print_all.c |  12 +
 logprint/log_redo.c      | 198 +++++++++++++++
 logprint/logprint.h      |  12 +
 18 files changed, 1331 insertions(+), 251 deletions(-)

-- 
2.7.4

