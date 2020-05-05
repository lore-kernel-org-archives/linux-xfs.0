Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A48C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0220D206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WNcr5f6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgEEBKq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:10:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:10:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513u0c055596;
        Tue, 5 May 2020 01:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Rrj18lcVYpnogim5AHTLzTJq13uAS/Vg//GXC/kLS4I=;
 b=WNcr5f6VRDrPB9EHfzQ/zxRaWmfyLGZLSnmHHUQwY+0fH18qbp4MqIHmxHEzJuv1l/aG
 Wj5AMuC7/XJFlYM5Q047fJy8FbKGnxVgZJUmQVDf/nBHvUJCaf+QB7O/br4sH1ukzEUz
 COoygGvJGKAvXXs8os0mgnUoAv0ZvJAmhYSns01B9+a2xKLW0maVD9m0Nm42k7oIifjU
 /G/D2zggz+l7NVkCvtaqGPVFUcnzjnmI+ORrq2Z3fKJBla56pQX31KkzTUFEyjJWclnZ
 zSwqchSdjJP4wthymc/BGTejU2kH67R+AAlQBW6tQ5uJ8fddsyxwdVg7zxnS3TQm+/EL dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn1vgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:10:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516fdx149322;
        Tue, 5 May 2020 01:10:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30sjjxake6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:10:34 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451AXRl014541;
        Tue, 5 May 2020 01:10:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:10:33 -0700
Subject: [PATCH v3 00/28] xfs: refactor log recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:10:32 -0700
Message-ID: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
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
