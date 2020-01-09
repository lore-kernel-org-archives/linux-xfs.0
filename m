Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BF6C282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0566020721
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dH4CAc0l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgAISoo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:44:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbgAISoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:44:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdTWZ140086
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=SJRaQHZnTIs6WdIv1NieiupYRjVd20eOUYvgTXs25Ow=;
 b=dH4CAc0lAYbkktVQmXHkwaMG8E9hF6hj9+z3T2dC+j/BEp4C5DW7q/0MjV484c3z4mjQ
 49taYBoQ5+bHkiUiDAIqKYy5quSreCrVZ8+q+aiTQB8TAiAcb/A3ZiY84l5RBnGNEWFT
 nSii/VTVdhX01qNHfzh+6z7Dc19U+aE67tiI30eP88bgGyvB3Q+YT23hcqq+L/0o4vk4
 F1Rmfn+ZSREcbtlvHFJyccjHwWmFw39/5D6gOHQTqDfe+Vj4HXlGNHop48wAp15EWgz0
 BnMzKxHJszZmrKCr3GBWw8Nk1Rtuv9Od1FRdkKTkAl4sWD3b6L/zqcA/XSe8fDmqoQey TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbr4pru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdFWf171489
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xdmryue2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 009IifKp011717
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:44:41 -0800
Subject: [PATCH v2 0/5] xfs: fix buf log item memory corruption on non-amd64
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:44:40 -0800
Message-ID: <157859548029.164065.5207227581806532577.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=494
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=555 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This second series corrects a memory corruption problem that I noticed
when running fstests on i386 and on a 64k-page aarch64 machine.  The
root cause is the fact that on v5 filesystems, a remote xattribute value
can be allocated 128K of disk space (64k for the value, 64 bytes for the
header).

xattr invalidation will try to xfs_trans_binval the attribute value
buffer, which creates a (zeroed) buffer log item.  The dirty buffer in
the buffer log item isn't large enough to handle > 64k of dirty data and
we write past the end of the array, corrupting memory.  On amd64 the
compiler inserts an invisible padding area just past the end of the
dirty bitmap, which is why we don't see the problem on our laptops. :P

Since we don't ever log remote xattr values, we can fix this problem by
making sure that no part of the code that handles remote attr values
ever supplies a transaction context to a xfs_buf function.  Finish the
series by adding a few asserts so that we'll shut down the log if this
kind of overrun ever happens again.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
