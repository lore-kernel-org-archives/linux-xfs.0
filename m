Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953FBC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69F7420818
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AQtQrCHi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfKKBSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 20:18:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfKKBSy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 20:18:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1ITrB117127;
        Mon, 11 Nov 2019 01:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=050OqlPCrwoyJtzBX3mvGexvbx5dbAwQw8i2h4nAafs=;
 b=AQtQrCHiiSzvKMWKSjdZ2jCJiQtjsuAaQpndUNb6H4WsFRBr8FvlSlAvSuBNtBYSLrp6
 URC4Go25ExAm59OYV1poeAuE5FVU95wFmoJ+Ca6nK/6WP0DSiPa4alSe6ESyMyGjAOW8
 Hn7wX1+LRMSUmR7QaXpn3SETtblYIjBg9ks1C7I7iigeL4fwCFEbyi8D2j45FNt8KWG7
 9fRztatbNkqzekTK+yMYwxmhwi85eXBG7OTOq7f5+2SJ2V25692JZhXO9XMjfzHJxNaL
 oyA9t4mYSvXQ6hCyvb5gSfS00OQ8ChDQRpkqQn0KqGYla8Bh4RaPvoMjC8k6XAk8SM3m lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w5mvtc674-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IcsI111876;
        Mon, 11 Nov 2019 01:18:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w67kjbvd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAB1IGZw017535;
        Mon, 11 Nov 2019 01:18:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 17:18:16 -0800
Subject: [PATCH 0/3] xfs: various fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Sun, 10 Nov 2019 17:18:15 -0800
Message-ID: <157343509505.1948946.5379830250503479422.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=987
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contians various unrelated fixes: the first one shuts up a
Coverity complaint in the btree islastblock predicate by turning it into
an assert.  The second patch fixes a 17yo bug where the iomap unwritten
extent conversion code forgets to ensure that dquots are attached to the
inode, which means we fail to account for bmbt splits and thus the quota
accounting is incorrect.  The third fixes the same problem but with the
swap extents ioctl.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
