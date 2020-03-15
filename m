Return-Path: <SRS0=0KAm=5A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACF4C10DCE
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1C820663
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RUGCnX2R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgCOXur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 19:50:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgCOXur (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 19:50:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNd0qu100178;
        Sun, 15 Mar 2020 23:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YesNJqIi2MJeqHQKA6jHD+7wLDeMHZ7opVzqdNd3VQA=;
 b=RUGCnX2RXro5C18dJUvPraKlI+JqImwFvjeFiYt7A/CD3l2V4f9ZNdpMtlxFRy3kTTpQ
 H/k8osXJF9Xpg02pcJoJ0NI0m9sDwYdE7FzUncE1g0jJNSUXMhUmlaf49s0QuxHBSlBj
 11aVrMxatq0qAy93RUIL017Zou6IHiVBQgm3A14WyY0P8qIVK61/cMO7P/8BEpaM0FPK
 spOLWgNzE4IgjG/Wpr8C6WI0exI3tFParW4V//p+azLh3rGBEAbuPdKea1FeuhWRH3wl
 0XmQHDCzwP/Crv8FyVRg2funcsXGkDkoGwsHHW/o+7/fz0wDk2aS66UcqdDsCgOjk6YF nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7km333-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:50:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNoNKB049874;
        Sun, 15 Mar 2020 23:50:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ys927r9en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:50:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02FNof19002866;
        Sun, 15 Mar 2020 23:50:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Mar 2020 16:50:41 -0700
Subject: [PATCH v5 0/7] xfs: btree bulk loading
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 15 Mar 2020 16:50:40 -0700
Message-ID: <158431623997.357791.9599758740528407024.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=933
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=994 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series creates a bulk loading function for metadata btree cursors.

We start by creating the idea of a "fake root" for each of the btree
root types (AG header and inode) so that we can use a special btree
cursor to stage a new btree without altering anything that might already
exist.

Next, we add utility functions to compute the desired btree shape for a
given number of records, load records into new leaf blocks, compute the
node blocks from that, and present the new root ready for commit.

Finally we extend all four per-AG btree cursor types to support staging
cursors and therefore bulk loading.  This will be used by upcoming patch
series to implement online repair and refactor offline repair.

For v4, fix a lot of review comments from Brian Foster, most of which
relate to disentangling thornier parts of the code; and clarifying the
documentation so that someone other than the author can understand what
is going on here. :)

For v5, a few documentation tweaks and moving the btree staging code to
a separate file since it's really a new use for btree cursors.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-bulk-loading-5.7
