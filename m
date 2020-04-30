Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E728C83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE4720787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eDJjiPYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgD3Atj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46372 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3Ati (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nbsi193253
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Rrj18lcVYpnogim5AHTLzTJq13uAS/Vg//GXC/kLS4I=;
 b=eDJjiPYvr6zyF0Zh8hKKet6CMM87mydYMdatVAVskX8gf+dAyWfG63Goj6X7jeiEM6Sa
 Z38Ln1yKKKP7PpECU0SwnmDMqrmwgZs/mtZ8PkVIinFot3ooguo71ID9KK8ztmtX3e7D
 5BKJ3d9R78MU0kCB9pTc8pzWePgM1NFJugIRr/CpocdG7hdQY3/+L1sNJj+cYUlEbPAQ
 DkWttq4yGX9ilPH+BAo/vrDwIZQjQr+sHtd9sJI4YlaDi4i2tYc0Piq3Hof7ClKK9G2i
 S0YAapDnGq4EMMYiZ4Yvr96KcvjtHpaFMBPdiIFgqxlv+B0TTOeyExt7Mkbk+GE0Vmcm 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucg8qa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0l6OM119943
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30my0jqyra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:37 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03U0laAI003579
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:47:36 -0700
Subject: [PATCH v2 00/21] xfs: refactor log recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:47:35 -0700
Message-ID: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series refactors log recovery by moving recovery code for each log
item type into the source code for the rest of that log item type and
using dispatch function pointers to virtualize the interactions.  This
dramatically reduces the amount of code in xfs_log_recover.c and
increases cohesion throughout the log code.

In this second version, we dispense with the extra indirection for log
intent items.  During log recovery pass 2, committing of the recovered
intent and intent-done items is done directly by creating
xlog_recover_item_types for all intent types.  The recovery functions
that do the work are now called directly through the xfs_log_item ops
structure.  Recovery item sorting is less intrusive, and the buffer and
inode recovery code are in separate files now.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-log-recovery
