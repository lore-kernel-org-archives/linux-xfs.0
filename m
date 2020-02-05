Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F63C3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E4C2214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l6cd80Ss"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBEAqm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:46:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBEAqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:46:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150e5af113562;
        Wed, 5 Feb 2020 00:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=UHjMTHe6I0+slyHEFgbBzH8h7rqbBYuDACZmjSNhaT4=;
 b=l6cd80SsnV6T+vaO7qE/0YmfvlsVr4g1f4z3gclp3LpvTjiX3Xr1rzrGWaVpVqGqTX9W
 GitDbtBCGvXoRtOjRevkZdEnE9t6J81V2BQ0j3ONQXELoW3UH6Yp/pNutG1PYF7ZDbFk
 RGevwZsyYnEX/moRSj++bZ8EJon/2VHlf0/hnc6SFE+UaJqz6ff+4pVHtb3lHi8149fd
 8YNxc6UPefBrMfGH5vcmYUkK0OzckgyIkj1DWMIUVfcDFWJb3Lz7NwEbmCebnBaWLpys
 ctuGDMcWDEq3LSf61UKlQzaWly5zUHz/T5u+t3ndapyQEf4TLsir0EvPW6JFyEhBlIsJ 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xykbp80k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dZ7h125077;
        Wed, 5 Feb 2020 00:46:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xykc1ge75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0150kdC1023515;
        Wed, 5 Feb 2020 00:46:39 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:46:38 -0800
Subject: [PATCH v4 0/7] xfs_repair: do not trash valid root dirs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Tue, 04 Feb 2020 16:46:37 -0800
Message-ID: <158086359783.2079685.9581209719946834913.stgit@magnolia>
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
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Alex Lyakas observed that xfs_repair can accidentally trash the root
directory on a filesystem.  Specifically, if one formats a V4 filesystem
without sparse inodes but with sunit/swidth set and then mounts that
filesystem with a different sunit/swidth, the kernel will update the
values in the superblock.  This causes xfs_repair's sb_rootino
estimation to differ from the actual root directory, and it discards the
actual root directory even though there's nothing wrong with it.

Therefore, hoist the logic that computes the root inode location into
libxfs so that the kernel will avoid the sb update if the proposed
sunit/swidth changes would alter the sb_rootino estimation; and then
teach xfs_repair to retain the root directory even if the estimation
doesn't add up, as long as sb_rootino points to a directory whose '..'
entry points to itself.

v4 rebases on the latest for-next and adds in a few things that Eric
and I discussed during the review of v3.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-find-rootdir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-find-rootdir
