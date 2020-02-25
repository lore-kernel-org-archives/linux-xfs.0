Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A05C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A13C121927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I0jxqkWC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBYAKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:10:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYAKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:10:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07bEg050100;
        Tue, 25 Feb 2020 00:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=fchqRWVV0jgfFqife62aybJqMetc+a/4KN2LXAM0jgM=;
 b=I0jxqkWCnSQkvX23BWg907TbhygsrA1tMvDW5/zIYHUYcx7mdZ5S1uBUVeIeMTpfdndT
 d6jPVPmYSAPViXc4IbPpZuaJMo/RTwecw+2QQhpcGm4pLuU/rhItuB6Vo4yU0WHaqsk2
 IuCHAV6X2O2u4D3g+b/aifWQiep98zqv0nCN7QmLVL2kdr9KmN10/d3/ZWicN05qsnCL
 AYq/MQ5k5RnGs3BNVIXAXV2pVmjPE9NmzLfKDL3ARgGvbzExGl1TtctZir7sv/ATOorc
 nBi2P6Xp3xsQ91mconaXTrTxasx5d5NpKYM8m0/iUoD2t88gJzfjjTTlivYCaBIKqXzu Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q32s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08ASK014708;
        Tue, 25 Feb 2020 00:10:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ybdshxurh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:30 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0ATGo029768;
        Tue, 25 Feb 2020 00:10:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:10:29 -0800
Subject: [PATCH v3 0/7] xfsprogs: actually check that writes succeeded
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:10:28 -0800
Message-ID: <158258942838.451075.5401001111357771398.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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
requests into the libxfs unmount function.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=buffer-write-fixes
