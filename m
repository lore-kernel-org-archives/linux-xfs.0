Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF8DCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E152121D56
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EDqJUgoS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfJ2Xae (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:30:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48468 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfJ2Xae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:30:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSfsj010454
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=EwjiA4uyPqHGs4NIGKo4zRBXCkrPnaCa6R1Jbp2mhA4=;
 b=EDqJUgoSoPCPlSrpAH/I8F7GTFMTAWtjYIxlGBS0yzK+o5+hNV5Oj8cbQrgqVdtcZs8R
 QuHp1UvegN1sXFQ6ucRMJfRmNlThk99wpaEEK2lk+QhqI+lH7Sia3cPfU2kn7THP/1R7
 spSc2G7rbQfnfwsKb3MiTOuQZI8z8CI1KDkhxWp0o+LVj7nRsgNe9Dtjv2b/YZVAxpxv
 srEiO3PczVFLetoJj8mNK+jL0UFXYdWDBmC20j0JgO0EwP/iValt86VNjyYwVuUO3ioO
 OIGQQFWK7Z4k8wcYprxUcSU3gI2Zjh/Rd8OIMpIqc5WVLDInIy7RqyQlwOZc3x/RRdYe 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vxwhfgavq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNS8ua179260
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vxwj54w82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNUVj8011180
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:30:31 -0700
Subject: [PATCH v2 0/3] xfs: fix online repair block reaping
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:30:30 -0700
Message-ID: <157239183075.1266870.1797402857427212175.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These patches fix a few problems that I noticed in the code that deals
with old btree blocks after a successful repair. First, we clarify how
the reaping function works w.r.t. bitmap lifetimes.  Next we fix a bug
where we could incorrectly invalidate old btree blocks if they were
crosslinked.  Finally, we convert the reap function to use EFIs so that
we can delete blocks without overloading a transaction.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-reap-fixes
