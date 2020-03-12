Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA5EC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11BD5206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lICZvjps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgCLDpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:45:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDpg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:45:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3efbL168086;
        Thu, 12 Mar 2020 03:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=5+LXxWM8SifkF2IEBEYJ2KWLx7cwYFa9lfssWA81Wb0=;
 b=lICZvjpsRo9+QZYQt9VTZeD122jh6ooQRh8wMVOzeW/y9E6FglIeT2CXLb7Ml/+k7mXY
 cQ0c+0F4UQc22+06YxhNyJnR20bcjfJNnMq2xXIhbBWq+w0P4LJS4WUJuXKSeH5isr6Y
 5G4dpMBHZKK539nPRlkFoJzZRfE45l0l82C1+RzUnIt3gUtjgndVR0Qy7WHNjbT/i35Z
 aOnbAnVRUTgx5ZihM8QBudMY0BZBMjj4iMIet1WNF5toeraPBGWPMcrJMyo1jcDeACJG
 7rlqBDL327ETdvHGv0gaMAPB/awB6UQc8o0dePnoeDF2iniEaD1dL97bxuv7FlP0KsIJ 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yp9v6a9vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3c8MZ054864;
        Thu, 12 Mar 2020 03:45:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yp8p5qyva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:32 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3jWCE022381;
        Thu, 12 Mar 2020 03:45:32 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:31 -0700
Subject: [PATCH v4 0/7] xfs: btree bulk loading
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 11 Mar 2020 20:45:30 -0700
Message-ID: <158398473036.1308059.18353233923283406961.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=863
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=923
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-bulk-loading-5.7
