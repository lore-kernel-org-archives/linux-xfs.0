Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC04C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B08A92469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GHT22/Yh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB1Xfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:35:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgB1Xfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:35:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWmeK027898;
        Fri, 28 Feb 2020 23:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=AudmKea6VvSxMnjbkANTgqVMvv5uDJSnP5TSKQwgQk0=;
 b=GHT22/YhPrRIvOYbuCdeVDRgOoJTEdprK2KsHIcQnvtR/INfJ8RKsGluJOG0xGPwDmV3
 14gibYWtar+ZBFEMKzk0rd1/QANnvM3IPdsL3ZkUq7xWKK4DFS39CpyhMhi6nHkl65K6
 Z/RGiObJCJewXPiJALntIi3V/D1HmVKPv+xrN654qrvpJs9aqUYvB0YUfJeH7VqkVxSo
 vWYV0eFeB9sna/69GTXnkJsQZHBFiYpAwrEwFJNkaNqDhq7oihOHwzHcY/2jXGemQgks
 brPYP8JJB87kd74JVZaRwETe2/I9VMbSfhwgNm8+B9wxPQPNUq47MGLxT3a4yzXAYK3V 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct3nsxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:35:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWm5k097686;
        Fri, 28 Feb 2020 23:35:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ydcsgeemh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:35:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNZSm7012041;
        Fri, 28 Feb 2020 23:35:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:35:28 -0800
Subject: [PATCH v4 0/7] xfsprogs: actually check that writes succeeded
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 15:35:27 -0800
Message-ID: <158293292760.1548526.16432706349096704475.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A code audit demonstrated that many xfsprogs utilities do not check that
the buffers they write actually make it to disk.  While the userspace
buffer cache has a means to check that a buffer was written (which is to
reread the buffer after the write), most utilities mark a buffer dirty
and release it to the MRU and do not re-check the buffer.

Worse yet, the MRU will retain the buffers for all failed writes until
the buffer cache is torn down, but it in turn has no way to communicate
that writes were lost due to IO errors.  libxfs will flush the device
when it is unmounted, but as there is no return value, we again fail to
notice that writes have been lost.  Most likely this leads to a corrupt
filesystem, which makes it all the more surprising that xfs_repair can
lose writes yet still return 0!

Fix all this by making delwri_submit a synchronous write operation like
its kernel counterpart; teaching the buffer cache to mark the buftarg
when it knows it's losing writes; teaching the device flush functions to
return error codes; and adding a new "flush filesystem" API that user
programs can call to check for lost writes or IO errors.  Then teach all
the userspace programs to flush the fs at exit and report errors.

In v2 we split up some of the patches and make sure we always fsync when
flushing a block device.  In v3 we move the buffer and disk flushing
requests into the libxfs unmount function.  v4 added some extra messages
when repair writes fail.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=buffer-write-fixes
