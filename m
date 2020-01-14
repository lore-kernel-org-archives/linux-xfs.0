Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AD7C33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0696420678
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XGCXibx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgANGdh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 01:33:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43082 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgANGdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 01:33:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6XWUR131517;
        Tue, 14 Jan 2020 06:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=1YO3jWZIe7OEYlzhqS7JA5JSEafPt6Q+kbDA9Pmlayo=;
 b=XGCXibx5Z7j9ji/fRoyon6+S4fUd9dKKGY1Lt+yVbYT5gkXV3qDAArp5CQtGVSE8Nr6H
 kHBHuDaUqPsmbIvaaw2jfQP2eomud+Ya5uZEHpYzOMuaLmS+ZpSTe0WlinUXPNMZLgis
 MnJyaPOB9/vFZVxDOZsYIP7DHzDcbhEorrPwMqXW9yqcdmKz8oyrmkWqOwgz0t3Q+47O
 VN8lHH+k6yChZfJc0mhdxmGfvdO775kEBPuKoNKcgPcuMy4it19Sg7q7C6xXKEPCtd8E
 VPHXmXV8qrP+/YC8dVumOFLjdocRimL/xQBizoIpdGTuSUQuy4ERhSXFtnk6KsHjk65n 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73tks5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:33:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6UEDG167087;
        Tue, 14 Jan 2020 06:31:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xh2tn5sxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:31:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00E6VUVR031972;
        Tue, 14 Jan 2020 06:31:30 GMT
Received: from localhost (/10.159.236.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 22:31:30 -0800
Subject: [PATCH v3 0/6] xfs: fix buf log item memory corruption on non-amd64
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 13 Jan 2020 22:31:29 -0800
Message-ID: <157898348940.1566005.3231891474158666998.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=451
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=509 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140056
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series corrects a memory corruption problem that I noticed
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
