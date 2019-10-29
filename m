Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DEFCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 378F721906
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CtYPAxbQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfJ2XaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:30:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfJ2XaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:30:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNTBps038408
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=7qOWEokU9vVZme6+CH+JnEUecKPvfIo36I/JuUJoT/0=;
 b=CtYPAxbQBjnt3fpnntE4PF3ud/BrdibFMNbBcEQyznCco5f5SmG1H5vzBo1nPQTvqV5f
 2lGE8JrBqf2KV/QeLaBbtMwAit8v64i1beaG71Q3BnGJMPZqvZl76c+L4jjTs34UOWJP
 JtEP1EKNW17G76b+39ZCPOJQTCh/cy6T/vitZMY8I1qVjP8rza1817zOTS5OVgvvyqkc
 xLAEKiewzcvsTmCzfWIgWHdCd6W5RBUGaWRCmFC0ny8kbPPoCSniRk77j3l8b2rFskYw
 lfjlEDRkEdQQkixxvy+u8q10K46+rvLsBrAP7SP/F3flbgdL0CrIB5umWXsaGs2GZu1Q nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vxwhfgb17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNRmcL069205
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vxwhuvdrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:05 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TNU4sN010997
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:30:04 -0700
Subject: [PATCH v2 0/4] xfs: btree bulk loading
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:30:03 -0700
Message-ID: <157239180345.1266747.1586648446090389492.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=834
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=915 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-bulk-loading

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-bulk-loading
