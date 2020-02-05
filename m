Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD981C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90AAB214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LacLZ7kD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgBEAta (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:49:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBEAta (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:49:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150mAr7129622;
        Wed, 5 Feb 2020 00:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=/UCGI5boFXiKeRq60MxlceY6XCNMwqfhGgl7nxmFRz0=;
 b=LacLZ7kDhq1Zhqyx4HC5t3RW2F/rVYZ6QXf4IJIPhaZqUrCU5dk4Pv0vy8lJDx3x+MB0
 o/y3nluLqMrjKuQ2/9Q7I9EqHi1OCp/oT+GtAjkHL/WXeVKDBl1HsvvlOJ9vh94puiiW
 bAimPvG0iaXPz9h5kZNL63C+CJv8ZxHLuSg9Qt/J+53jpTjJfpA294kQ2ahP6AKFiNPB
 yt5jTbhwecP1ieVO+m8kwBGSjGDawDkCcm6CpgzwxzVKmjPWXfr7fI/eI2kwg5wOGde/
 B2GM3FJuU6FHqrHuQTM8IPg7Nc2FrYXgXY4WZJRtX5Nbr3chyPo+eDWo0DmqVj37QU6s 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xykbp00r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:49:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150cvKO165952;
        Wed, 5 Feb 2020 00:47:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xykbqgdvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:26 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150lQcc011273;
        Wed, 5 Feb 2020 00:47:26 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:47:25 -0800
Subject: [PATCH 0/4] libxfs: actually check that writes succeeded
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:47:25 -0800
Message-ID: <158086364511.2079905.3531505051831183875.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050003
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=buffer-write-fixes
