Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13388C55185
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF76020704
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fqS3lEFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgDVX4D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:56:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDVX4D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 19:56:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MNrHh7133993
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Wm/+4S/fDCfalJNu6bDt+6VMZ948lVsRDhKlhVXjRuk=;
 b=fqS3lEFrjIaYrTge4Nh1uf4ekRwOTrTqLKB7uL5mK9rEP4O2KWp2WFJiEksO5ZwETPkh
 s/aooCPCnu7rYyNRnyWGy8xyaMUA2NYW7PJN004IMvLxYO4J/wnOo+sDeBBBUjmDZOXp
 SDbE5e8dDGeEBG0UMe+vYak5zOJSMaoT3WSs823tfwfUBIdUelLytNSNVz3PLjb42xu9
 DXkxv1u1Y9fICI+rW8cpQkaEybqzV7nfpspJWZhJvbxTCW5H11bHHLa47oO5+Q9h0eYO
 PHk7VCksXYmk4HyoWJgftfvfJ/q/dyINB1Y4vbUqsCtoPGWzi5m/Dvk8k9hSiLjkYhnu /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30jvq4rqm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:56:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MNqZEk092901
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:56:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbj9jyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:56:00 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03MNu0dJ017331
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:56:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 16:55:59 -0700
Date:   Wed, 22 Apr 2020 16:55:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [XFS SUMMIT] Online Fsck Status Update
Message-ID: <20200422235559.GK6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

This one is meant to be a status update about where I am with online
repair.  The btree bulk loading code went upstream for 5.7, which will
enable us to refactor a lot of boilerplate code out of xfs_repair.

At this point, I have finished fleshing out nearly all of the online
repair functionality.  We can rebuild all per-AG btrees and the inode
fork mapping btrees.  With the deferred inactivation series and fs
freezing, we can also rebuild the rmapbt and run quotacheck on a frozen
filesystem, which means that quotas can be repaired too.

More recently, I've written repair code for the realtime bitmap and
summary files; and preliminary versions of extended attribute and
directory salvaging.  With the new atomic extent swap series, I can now
commit rebuilt metadata atomically.

However, the directory tree reconstruction part is /very/ difficult to
achieve without parent pointers, since we cannot easily reconnect
orphaned files without scanning the entire directory tree under fs
freeze.  We also can't do nlink verification easily without parent
pointer validation.

--D

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-rtsummary
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inode-data
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fsfile-metadata
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-metadata-atomically
