Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB1AC33C9E
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5F40206ED
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fqjPM82t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgAHEVT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:21:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAHEVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:21:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JEhk026686
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=SJRaQHZnTIs6WdIv1NieiupYRjVd20eOUYvgTXs25Ow=;
 b=fqjPM82tBWQj+S35gnrY22eLANERMggpzxMY3IOOG2e0Vif89Z6jbPOpWXJK81ViDSlO
 DhbhmeUrRvcGlM2D9h6aA/WUPPyEZLePG5QXlsoS6g472mNLuiUIrjnPbS7grt2ULcD2
 U2iKzV4t8hpotKz54B6VKyOzg/hZIMpWhsA4Pvy8Cw3rUKHRvBTFUoGU9l8Dp8BhnWwL
 CmQd+yAJENfjP/cJesFVMTfhhd+rN0WWbdfgK1rNwww5zRW0dlrZnvfe/asoB2U/QOEz
 20mqhfCwcuqT5EQqGbOaW9zOMgrFivzcPre+GFE2BPWEOWJxs4mdv0UXp0IfipXAfEVJ rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xajnq1ett-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:21:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JHXO060962
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:19:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xcqbjvjgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:19:16 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0084I7PJ007938
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:18:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:18:07 -0800
Subject: [PATCH 0/3] xfs: fix buf log item memory corruption on non-amd64
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:18:03 -0800
Message-ID: <157845708352.84011.17764262087965041304.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=499
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=560 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080037
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
