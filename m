Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EE5C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 23:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B73F20663
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 23:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kVf2zsYX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGYXBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jul 2020 19:01:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgGYXBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jul 2020 19:01:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PMsVqf077802
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=o4036Gll7UDn7ZDNfNKKgWkV4zXYz0BEUEbIEQlHh6k=;
 b=kVf2zsYXyhu3d0kqnde9j7KJWYyptviSsFO2OkNg0LFCkBnbDC1P2V7jmQddXwxJtRID
 oZgw4jbBoHMHf2pdh71jxFdD6BAT0P7xO1F82zp92OYk2SMsvGkO/r1lQORFPLeRGnYX
 +DLTENzNAoR9BtHe3LwQbLFSA/TbEqpOLYQl0jS9B0/SkbVv8t22nGSAQ0QZOd7T/Zra
 vH9jNxfUP8QT44LmVt4mXluspMaW4nt37o7tIYANOOUCe22hCGbutgbWu/fq2UDkE8oV
 xhNH11H7E/4mToyi0WTmfzZMDNdJIzbtVDecuL2iEMvB8lKg8mwkzYNdmzUi6DuFPm1p Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32gdcn1qa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PMwHg2056232
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32gj35hbme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06PN18a6006864
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:08 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 16:01:08 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: Fix compiler warnings
Date:   Sat, 25 Jul 2020 16:01:00 -0700
Message-Id: <20200725230102.22192-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=1 mlxscore=0 adultscore=0 mlxlogscore=823 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=828 priorityscore=1501 suspectscore=1 phishscore=0
 impostorscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250190
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some variables added in the delayed attr series were only used in ASSERT checks.
This caused some compiler warnings.  This is a quick set to add some extra
error handling to quiet those warnings.

Allison Collins (2):
  xfs: Fix compiler warning in xfs_attr_node_removename_setup
  xfs: Fix compiler warning in xfs_attr_shortform_add

 fs/xfs/libxfs/xfs_attr.c      | 10 ++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c | 11 ++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
 3 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.7.4

