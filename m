Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC24C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D42FD206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ap/iaZGs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgAABO4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EWYL094474
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=nMVYFWBtIxq+iKATehGIPcGa22denwlQOJ/XFR10Wss=;
 b=ap/iaZGsvG2tKeXRFG69VbHsPTLY9ATWGPme3vXj/Bzbnd1HdMUi7uANah0a42sHxQac
 +eRfhF40HKSE6m47i3olimCaHhtzsSJIPBLgFqH9u6+ABKopq2EJqE/qrckT4F9z5hIE
 qX5+sAuMfDF353vFLqKnIZiiLZkyJ1ZVjZ/HezESWMsx5O6dr4Vm8E7rNgd+wNaWQmj+
 yDg4VgY9se8WxoFvvzOOZat+DE4a4YIvwzvycyum0uvPSvcvApI9Qc7fjU+C2YPELu3i
 dPnIFFpgapjmPxyKRcipo3T2hnAAPlG4d/Cz8jTxtaNRDNuYTX1fE7KxsVWAfME7lXSK 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118urW045247
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x7medfen5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:53 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011EreT029699
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:53 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:53 -0800
Subject: [PATCH v2 00/13] xfs: metadata inode directories
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:50 -0800
Message-ID: <157784129036.1366873.17175097590750371047.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=859
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=909 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series delivers a new feature -- metadata inode directories.  This
is a separate directory tree (rooted in the superblock) that contains
only inodes that contain filesystem metadata.  Different metadata
objects can be looked up with regular paths.

We start by creating xfs_imeta_* functions to mediate access to metadata
inode pointers.  This enables the imeta code to abstract inode pointers,
whether they're the classic five in the superblock, or the much more
complex directory tree.  All current users of metadata inodes (rt+quota)
are converted to use the boilerplate code.

Next, we define the metadir on-disk format, which consists of marking
inodes with a new iflag that says they're metadata.  This we use to
prevent bulkstat and friends from ever getting their hands on fs
metadata.

Finally, we implement metadir operations so that clients can create,
delete, zap, and look up metadata inodes by path.  Beware that much of
this code is only lightly used, because the five current users of
metadata inodes don't tend to change them very often.  This is likely to
change if and when the subvolume and multiple-rt-volume features get
written/merged/etc.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir
