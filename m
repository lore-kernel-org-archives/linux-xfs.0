Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C437C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C12132071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BjTTmnod"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgAXARF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAXARF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O09MsV183357;
        Fri, 24 Jan 2020 00:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=C5ipKU4BVGYGQAU07YPaghijI6NUrnGUdQM1nzVPMhE=;
 b=BjTTmnod3P7MSaQNRqDZ9vLTCMC6j/BdvJgiZT1ccqjsuNmb4f/iWz0Om6+emqgbJdVv
 zIYpXhicNHSLqaDlQl5MfldmXn2vbTKQbuWxOlZBFuDoNyvIgbnYolDwYYGGMN1VMQKU
 jGpdCWjJjVUwb7eaTisQegY8Lt9q+JJXRooPiZWsqwjBgNkFV+AgiMiSqQCAdRPzOyWo
 CYXIzVx1xoxjdAk6dl/bZzHPSVbvfegaeLFs/E0qu/jZ3Fq4JHBR+0MgAPb+mnLtzpfg
 1nqGDMqmbcaKins/lItjX/NM9P47qF9qQkyPucgaLOvTf81sfHF/rKmElvbR2FPf+P2q 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyqns17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0E4ch110960;
        Fri, 24 Jan 2020 00:17:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xqmwb1cup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0H1HM020047;
        Fri, 24 Jan 2020 00:17:01 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:00 -0800
Subject: [PATCH 4/8] man: document some missing xfs_db commands
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:16:56 -0800
Message-ID: <157982501686.2765410.2779527901724988940.stgit@magnolia>
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

The 'attr_set', 'attr_remove', and 'logformat' commands in xfs_db were
not documented.  Add sections about them to the manpage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attrset.c      |    4 ++--
 man/man8/xfs_db.8 |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 2 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 56972506..8eecf465 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -23,11 +23,11 @@ static void		attrset_help(void);
 
 static const cmdinfo_t	attr_set_cmd =
 	{ "attr_set", "aset", attr_set_f, 1, -1, 0,
-	  N_("[-r|-s|-p|-u] [-n] [-R|-C] [-v n] name"),
+	  N_("[-r|-s|-u] [-n] [-R|-C] [-v n] name"),
 	  N_("set the named attribute on the current inode"), attrset_help };
 static const cmdinfo_t	attr_remove_cmd =
 	{ "attr_remove", "aremove", attr_remove_f, 1, -1, 0,
-	  N_("[-r|-s|-p|-u] [-n] name"),
+	  N_("[-r|-s|-u] [-n] name"),
 	  N_("remove the named attribute from the current inode"), attrset_help };
 
 static void
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 53e34983..9f1ff761 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -179,6 +179,57 @@ Set current address to the AGI block for allocation group
 .IR agno .
 If no argument is given, use the current allocation group.
 .TP
+.BI "attr_remove [\-r|\-u|\-s] [\-n] " name
+Remove the specified extended attribute from the current file.
+.RS 1.0i
+.TP 0.4i
+.B \-r
+Sets the attribute in the root namespace.
+Only one namespace option can be specified.
+.TP
+.B \-u
+Sets the attribute in the user namespace.
+Only one namespace option can be specified.
+.TP
+.B \-s
+Sets the attribute in the secure namespace.
+Only one namespace option can be specified.
+.TP
+.B \-n
+Do not enable 'noattr2' mode on V4 filesystems.
+.RE
+.TP
+.BI "attr_set [\-r|\-u|\-s] [\-n] [\-R|\-C] [\-v " namelen "] " name
+Sets an extended attribute on the current file with the given name.
+.RS 1.0i
+.TP 0.4i
+.B \-r
+Sets the attribute in the root namespace.
+Only one namespace option can be specified.
+.TP
+.B \-u
+Sets the attribute in the user namespace.
+Only one namespace option can be specified.
+.TP
+.B \-s
+Sets the attribute in the secure namespace.
+Only one namespace option can be specified.
+.TP
+.B \-n
+Do not enable 'noattr2' mode on V4 filesystems.
+.TP
+.B \-R
+Replace the attribute.
+The command will fail if the attribute does not already exist.
+.TP
+.B \-C
+Create the attribute.
+The command will fail if the attribute already exists.
+.TP
+.B \-v
+Set the attribute value to a string of this length containing the letter 'v'.
+.RE
+.TP
 .B b
 See the
 .B back
@@ -737,6 +788,13 @@ Start logging output to
 .IR filename ,
 stop logging, or print the current logging status.
 .TP
+.BI "logformat [\-c " cycle "] [\-s " sunit "]"
+Reformats the log to the specified log cycle and log stripe unit.
+This has the effect of clearing the log destructively.
+If the log cycle is not specified, the log is reformatted to the current cycle.
+If the log stripe unit is not specified, the stripe unit from the filesystem
+superblock is used.
+.TP
 .B logres
 Print transaction reservation size information for each transaction type.
 This makes it easier to find discrepancies in the reservation calculations

