Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B01C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D539A21582
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:05:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mqqmpu1t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfLRVFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:05:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfLRVFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:05:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIKxTvo016388;
        Wed, 18 Dec 2019 21:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=IJGhoqKOjSCUQUw95smBSmdlEpLLxSO+Cmmu8cSErxU=;
 b=mqqmpu1t3Zk5T+0qZsV1uqYuMfKqotzihCyWFDfbtnqj0DkEWS96OeQomUInxNboto6P
 TXm4UZRK1mXNuZWcvnIuBd8ffgQRaqBK7RsUWU6yelJa2JOHhSxXyx6vZPv5PqdmBLbB
 1dDIVGnQ2VueexfCY7UdUhkPPhyQ+ZVidDN9T53roYRB28XbB4+IntzdYsy71Fw7TTab
 MRUBxteR6hL36619Rvc7ob93dl8onC9ZIWPLHlr5jZN9uha+ay4kSznjA6hWjGO2ICQj
 ocbKhQX3Etf70BvSBkqPSUzpI1aSfVWZNMzBME5e+B9QDGBOSlFB+LfgJ6ytK+1Cd5TR zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wvq5ur9dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:05:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIL3QUq177954;
        Wed, 18 Dec 2019 21:05:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wyp089ccd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:05:49 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBIL5m1K025523;
        Wed, 18 Dec 2019 21:05:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:05:48 -0800
Date:   Wed, 18 Dec 2019 13:05:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] man: list xfs_io lsattr inode flag letters
Message-ID: <20191218210547.GA7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The section of the xfs_io manpage for the 'chattr' command says to refer
to xfsctl(3) for information on the flags.  The inode flag information
was moved to ioctl_xfs_fssetxattr(2) ages ago, and it never actually
mapped the inode flag letters to inode flag bits, so fix the link and
add such a mapping to the xfs_io manpage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: don't duplicate the full descriptions, just map the letter to XFLAG
---
 man/man8/xfs_io.8 |   89 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 6 deletions(-)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 2f17c64c..e794c311 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -794,18 +794,95 @@ for all directory entries below the currently open file
 can be used to restrict the output to directories only).
 This is a depth first descent, it does not follow symlinks and
 it also does not cross mount points.
+
+The current inode flag letters are documented below.
+Please refer to the
+.BR ioctl_xfs_fsgetxattr "(2)"
+documentation for more details about what they mean.
+
+.PD 0
+.RS
+.TP 0.5i
+.B r
+realtime file (XFS_XFLAG_REALTIME)
+
+.TP
+.B p
+prealloc (XFS_XFLAG_PREALLOC)
+
+.TP
+.B i
+immutable (XFS_XFLAG_IMMUTABLE)
+
+.TP
+.B a
+append only (XFS_XFLAG_APPEND)
+
+.TP
+.B s
+synchronous file writes (XFS_XFLAG_SYNC)
+
+.TP
+.B A
+noatime (XFS_XFLAG_NOATIME)
+
+.TP
+.B d
+nodump (XFS_XFLAG_NODUMP)
+
+.TP
+.B t
+inherit realtime flag (XFS_XFLAG_RTINHERIT)"
+
+.TP
+.B P
+inherit project id (XFS_XFLAG_PROJINHERIT)
+
+.TP
+.B n
+no symlink creation (XFS_XFLAG_NOSYMLINKS)
+
+.TP
+.B e
+extent size hint (XFS_XFLAG_EXTSIZE)
+
+.TP
+.B E
+inherit extent size hint (XFS_XFLAG_EXTSZINHERIT)
+
+.TP
+.B f
+nodefrag (XFS_XFLAG_NODEFRAG)
+
+.TP
+.B S
+filestream allocator (XFS_XFLAG_FILESTREAM)
+
+.TP
+.B x
+direct access persistent memory (XFS_XFLAG_DAX)
+
+.TP
+.B C
+copy on write extent hint (XFS_XFLAG_COWEXTSIZE)
+
+.TP
+.B X
+has extended attributes (XFS_XFLAG_HASATTR)
+.RE
+
 .TP
 .BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfSxC " ]"
 Change extended inode flags on the currently open file. The
 .B \-R
 and
 .B \-D
-options have the same meaning as above. The mapping between each
-letter and the inode flags (refer to
-.BR xfsctl (3)
-for the full list) is available via the
-.B help
-command.
+options have the same meaning as above.
+
+See the
+.B lsattr
+command above for the list of inode flag letters.
+
 .TP
 .BI "flink " path
 Link the currently open file descriptor into the filesystem namespace.
