Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF6EC4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3123221D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cs73JThD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfIYVei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58782 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfIYVei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYa4i054991;
        Wed, 25 Sep 2019 21:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=C6p1fSJZi6SNjHkFQPtqCuHY8mweUIo2ZZQdXB/fFmo=;
 b=cs73JThDq6rUyLkQDwpddCFusjls9X9tJOW1xVj9wsX71SbVfZVhxIJwtnF/PE13UBRO
 v/Tpn28a1pUgJmvHTUlar3k07Lyca0xMxisyU+pWq2glc69GeEen/YR1op35jruMZyIa
 uN2tH4h5D1r1x3HkRKYoehrmz6kGzY4pyCSRjStA/Slt1AkhBYRKAdhDkAKMLLMRfhFS
 liyOp/A1x1DQThVayJggKI0kyssIu2YgXwGRMOdAdFdPm+19clfyFwqjsRUhq98lu/cH
 sJCbR2EBMcPbixMRqD1yDo4PQD3zIeXOYa8Tf4PhDDXsO6AXOqZQa9SfukdJ8v4m1lKJ ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v5cgr7eu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYSEH078797;
        Wed, 25 Sep 2019 21:34:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2v82tkredc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLXOPU014443;
        Wed, 25 Sep 2019 21:33:24 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:33:24 -0700
Subject: [PATCH 00/13] libfrog/xfs_scrub: fix error handling
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:33:23 -0700
Message-ID: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=940
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The new code introduced by xfs_scrub do not deal with error returns in a
consistent fashion.  Some places we return -1 and set errno, some places
just do whatever libc does, others return positive error codes, and the
worst offenders do a combination of that.  Worse yet, sometimes we also
fail to check for error returns at all.

This series replaces all that with a single error handling strategy --
return positive error codes and always check the return codes from other
library functions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libfrog-error-handling
