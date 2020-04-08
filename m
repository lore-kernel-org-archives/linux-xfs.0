Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7DEC2BA2B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 23:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5206820857
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 23:27:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NAkYzEhN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDHX15 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 19:27:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgDHX15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 19:27:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038NOI6E099032;
        Wed, 8 Apr 2020 23:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=JndbcRn2mXIjnMRwJFTBNQZkyY8sttdu3bObO/TksJk=;
 b=NAkYzEhNl625WT31bRKYZFR5bY9O19EnmDcJpAWbSuiSiT7VopZn9bKOUEmCYEbRmnuW
 ckaaDX80nga4wsa2Xu+aUzd6VmR1UyQ74/Fmo02/FaVlU3EX8OJHcW7JOcEVsFRADxv+
 TarpO6/JonnWaSnotTc1QfuAqzNZs12jXJN9x63POB4Y0US0Fb/1QZi1xy4dGyv80Tww
 CqPYRESkmktL2L5ZuevEIMrm3mMd/MmoX2H8E/h0qUrZaBzI/sRDzyqxQndHC+zbcrsn
 htMK5sf7U90zxS9FKAB+H2VGii9C0Anv3hMgApBbqbvSt+6AH/YZT4+FyCqpvujbhRCj Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3091m3edxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 23:27:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038NNODH099798;
        Wed, 8 Apr 2020 23:27:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3091m2cc3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 23:27:55 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038NRsuf028817;
        Wed, 8 Apr 2020 23:27:54 GMT
Received: from localhost (/10.159.145.57)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 16:27:54 -0700
Date:   Wed, 8 Apr 2020 16:27:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsdocs: capture some information about dirs vs. attrs and
 how they use dabtrees
Message-ID: <20200408232753.GC6741@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9585 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9585 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Dave and I had a short discussion about whether or not xattr trees
needed to have the same free space tracking that directories have, and
a comparison of how each of the two metadata types interact with
dabtrees resulted.  I've reworked this a bit to make it flow better as a
book chapter, so here we go.

Original-mail: https://lore.kernel.org/linux-xfs/20200404085203.1908-1-chandanrlinux@gmail.com/T/#mdd12ad06cf5d635772cc38946fc5b22e349e136f
Originally-from: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../extended_attributes.asciidoc                   |   49 ++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 99f7b35..d61c649 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -910,3 +910,52 @@ Log sequence number of the last write to this block.
 
 Filesystems formatted prior to v5 do not have this header in the remote block.
 Value data begins immediately at offset zero.
+
+== Key Differences Between Directories and Extended Attributes
+
+Though directories and extended attributes can take advantage of the same
+variable length record btree structures (i.e. the dabtree) to map name hashes
+to disk blocks, there are major differences in the ways that each of those
+users embed the btree within the information that they are storing.
+
+Directory blocks require external free space tracking because the directory
+blocks are not part of the dabtree itself.  The dabtree leaves for a directory
+map name hashes to external directory data blocks.  Extended attributes, on
+the other hand, store all of the attributes in the leaves of the dabtree.
+
+When we add or remove an extended attribute in the dabtree, we split or merge
+leaves of the tree based on where the name hash index tells us a leaf needs to
+be inserted into or removed.  In other words, we make space available or
+collapse sparse leaves of the dabtree as a side effect of inserting or
+removing attributes.
+
+The directory structure is very different.  Directory entries cannot change
+location because each entry's logical offset into the directory data segment
+is used as the readdir/seekdir/telldir cookie, and the cookie is required to
+be stable for the life of the entry.  Therefore, we cannot store directory
+entries in the leaves of a dabtree (which is indexed in hash order) because
+the offset into the tree would change as other entries are inserted and
+removed.  Hence when we remove directory entries, we must leave holes in the
+data segment so the rest of the entries do not move.
+
+The directory name hash index (the dabtree bit) is held in the second
+directory segment.  Because the dabtree only stores pointers to directory
+entries in the (first) data segment, there is no need to leave holes in the
+dabtree itself.  The dabtree merges or splits leaves as required as pointers
+to the directory data segment are added or removed.  The dabtree itself needs
+no free space tracking.
+
+When we go to add a directory entry, we need to find the best-fitting free
+space in the directory data segment to turn into the new entry.  This requires
+a free space index for the directory data segment.  The free space index is
+held in the third directory segment.  Once we've used the free space index to
+find the block with that best free space, we modify the directory data block
+and update the dabtree to point the name hash at the new entry.
+
+In other words, the requirement for a free space map in the directory
+structure results from storing the directory entry data externally to the
+dabtree.  Extended atttributes are stored directly in the leaves of the
+dabtree (except for remote attributes which can be anywhere in the attr fork
+address space) and do not need external free space tracking to determine where
+to best insert them.  As a result, extended attributes exhibit nearly perfect
+scaling until we run out of memory.
