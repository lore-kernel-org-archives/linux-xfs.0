Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44DCC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 04:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB154206D7
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 04:32:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZwjEoCNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgG1Ec3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 00:32:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgG1Ec2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 00:32:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S4RgiC053816
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=8jY2uQhDWafT8QYnSK6Fatgg1tPaDxlzXYnC/wEJcno=;
 b=ZwjEoCNNckLKrKxVORZIECeQryR82Xt+ZlO2eXNn+q+NS1j8xzeh26XwHtMTRMKfJhd3
 ZRnu+MvMhrsBuhg63fmRXvFtla2UkpbFu+pLfFrr0MYfXEhmudKSfO/sAPgZd0yho4i+
 S36POQABl3L+1ekHDf08DRsYm7bjTpc2ffVR8uFaGtJsv98xCmXFhDIQnQXbPMCRbNM7
 EoGC5DPAxETGe363LFvtW86Qhiff39mnLDnCRUz00LucsYVarUNUfCJR/lW8TMc2Qfvv
 8oA2ngEgW0mWg2DD6KIqIa0/UanZKPt+ypxmAsN1Fk0gkTY0CzNeC+b2JKxmD6ch8Xuw bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32hu1j53gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S4SOZP161235
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32hu5snf16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:27 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06S4WRrM019971
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:27 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 21:32:26 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 0/2] xfs: Fix compiler warnings
Date:   Mon, 27 Jul 2020 21:32:18 -0700
Message-Id: <20200728043220.17231-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=891 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=895
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some variables added in the delayed attr series were only used in ASSERT
checks, and caused some compiler warnings.  This set fixes these warnings by
removing the convenience variable.

Allison Collins (2):
  xfs: Fix compiler warning in xfs_attr_node_removename_setup
  xfs: Fix compiler warning in xfs_attr_shortform_add

 fs/xfs/libxfs/xfs_attr.c      | 7 +++----
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 +++---
 2 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.7.4

