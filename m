Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99EBC43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96214205ED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a/3pa/q7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfLDRE3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:04:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfLDRE3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:04:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GxKF7002315;
        Wed, 4 Dec 2019 17:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=UfC23OqQM0+If5JyI0cq+or369mpVTc1SIfF3aU483U=;
 b=a/3pa/q7KpAgFqFt3GRVIpUKGB0QomJNQxjnvzREsJVEBuMS6Koxs4kYR3nmVVMbbBbe
 69DUq6zh/6amMbjw4zblyelNbUT4UAC1htppIwPdTnLzF08oAMw/aJwerRsPXFe1tEnW
 rzR44AuS9UZyJwVRSmp4o5dF8zLKJdl0kHBycIQmc02U0C9HOuum3bBuS1ripBNNWdei
 5ekupZz5SXMFR57fKvsiu44PdkGXy5ugS5BEpLoHKkTK8pf2gbFeevdohpOPGt799ybj
 SuIjpEupQJ5r8CWOuxwioVe75Xxkqg8BE3YA13s5vz/yukkVc625P9sXE9IHI2upbdhQ 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wkgcqfpwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:04:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GwxB1040747;
        Wed, 4 Dec 2019 17:04:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wnvr0989g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:04:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB4H4O1L004853;
        Wed, 4 Dec 2019 17:04:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 09:04:24 -0800
Subject: [PATCH v2 0/6] xfs_repair: do not trash valid root dirs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Wed, 04 Dec 2019 09:04:22 -0800
Message-ID: <157547906289.974712.8933333382010386076.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=911
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=972 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Alex Lyakas observed that xfs_repair can accidentally trash the root
directory on a filesystem.  Specifically, if one formats a V4 filesystem
without sparse inodes but with sunit/swidth set and then mounts that
filesystem with a different sunit/swidth, the kernel will update the
values in the superblock.  This causes xfs_repair's sb_rootino
estimation to differ from the actual root directory, and it discards the
actual root directory even though there's nothing wrong with it.

Therefore, hoist the logic that computes the root inode location into
libxfs so that the kernel will avoid the sb update if the proposed
sunit/swidth changes would alter the sb_rootino estimation; and then
teach xfs_repair to retain the root directory even if the estimation
doesn't add up, as long as sb_rootino points to a directory whose '..'
entry points to itself.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
