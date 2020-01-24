Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AC6C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 909BA2071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ffDgloUW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgAXASo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:18:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34340 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAXASo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:18:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08r6p182936;
        Fri, 24 Jan 2020 00:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=l6YttYBI5+Vagm6LiwE+vW/MFl/6//TJhcXrZU9Q204=;
 b=ffDgloUW53vgV7yF639ku9qFgLrvc+bRJTPRBLCMTgjOCFRzTA/PbF095seSsQDw3cw0
 PhSHBxRIx21LFH4nbh1Oy4B63N46ITrzxInt0kY+iRYJ4z3xhrSND8xAFpdaee3oQjzN
 HPmwOV2OPFuOEzjeIPvHCir8CWEvU3eeoV0+3SDqu/XnS5RypcjaCzeJeuLsabmPGr4k
 em/ESwP3VraepDa5DhVPObwJwiS79T2zSMszFRR2A7OQAj6qBDHgv+Eb+cHzH/rEM7ns
 SCu8olu34SSdLSv2geTYSqNXgScJ0xwaGanXHFn6IehXRE2Z69GtkdzRXdVJIHmNVZzz Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xksyqns9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:18:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0DWQA037212;
        Fri, 24 Jan 2020 00:16:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xqmuxkgwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:16:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0GeMB030363;
        Fri, 24 Jan 2020 00:16:40 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:16:40 -0800
Subject: [PATCH 1/8] man: list xfs_io lsattr inode flag letters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:16:38 -0800
Message-ID: <157982499817.2765410.16336840066253160007.stgit@magnolia>
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
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
 man/man8/xfs_io.8 |   89 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 6 deletions(-)


diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c69b295d..f5431a8c 100644
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

