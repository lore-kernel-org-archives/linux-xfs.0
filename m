Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B138FC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 865C224670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fboxSSvq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBly (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:41:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43518 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgBTBly (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:41:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1cps8164554;
        Thu, 20 Feb 2020 01:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=FZifl53lDd/XSt6FXlYJ+6LyLxnh1+O3f7XhskpfqGs=;
 b=fboxSSvqQb/v0inXhNlicCnuJOohOJFZpWRoJl9WrzSZ/wVtUzz3jKncDCpnJlIBBy9a
 14xskJDJcOcKLNox+UpysXB0daWckcwLTe8pe6pCP0/4ZblbWkcbrEO0Zo0lIEYLCFdw
 PUbX7pgqYGeFClouvOrn7IKU25WTx+6OIzLuavpVUu/RzCWKCLB8TVqnTYbWxQiFwdVD
 B6rlCSBxeJRhsu7N0p08wuCQd/k3zQ0sM3BBZpS7yn5lrWuP0eXVqoso8rjTBmeNjKSo
 hl+NkRqIMHXFn1YFHWbZarxUmlIxc4LFa9Q/EmgTsvaJzLxmHthM4yqFqJN1c8+rvyny /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y8udd6ta7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:41:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1fnDj188245;
        Thu, 20 Feb 2020 01:41:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2y8ud96rfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:41:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1fhnw002175;
        Thu, 20 Feb 2020 01:41:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:41:42 -0800
Subject: [PATCH v2 0/8] xfsprogs: actually check that writes succeeded
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:41:41 -0800
Message-ID: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200010
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
flushing a block device.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=buffer-write-fixes
