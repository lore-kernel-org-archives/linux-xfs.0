Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32140C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 20:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF5A2063A
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 20:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QTtQqNz1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgEDUxp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 16:53:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44162 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgEDUxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 16:53:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044KnBgm056804;
        Mon, 4 May 2020 20:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hz6Y4h7r1od9+Fq6LH6IyMOF0iRnKSeWf9rnJrlzzRo=;
 b=QTtQqNz1yWnL76o62WSQT+9ISV7wCZIyU7gF78hWtp5UClGjbvd8lA0CuZfme8L6JQST
 KDInJhgaV8Jf0dx9hrb5Spi4Iyi8rukrOdnjfa1YNw0yk5iD8VKqDDlr+zPijEvYsE+o
 4/wKtbHuk5p4bKg880dFuLyoGtBZ9a1m4p89U6fTdC5SwXcOBRnAiCt9uDNvGzD2tu41
 ofSmfO96uInUVfYyeFl7AVaKD798nCGKb8Sx+zi9v4O8uFjyFoTFGNQH2qAv37Xii+Qd
 HsFM0kCuQwH4gre2jjdghK3xKSmucmmd9QRCmTUy8jxhajjvPA5HG5cH9E21yf46gDAu xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tm99tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 20:53:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044KqXjY118540;
        Mon, 4 May 2020 20:53:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjwts6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 20:53:42 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044KreOP009187;
        Mon, 4 May 2020 20:53:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 13:53:40 -0700
Date:   Mon, 4 May 2020 13:53:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsdocs: capture some information about dirs vs.
 attrs and how they use dabtrees
Message-ID: <20200504205339.GL5703@magnolia>
References: <20200413194600.GC6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413194600.GC6742@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 13, 2020 at 12:46:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Dave and I had a short discussion about whether or not xattr trees
> needed to have the same free space tracking that directories have, and
> a comparison of how each of the two metadata types interact with
> dabtrees resulted.  I've reworked this a bit to make it flow better as a
> book chapter, so here we go.
> 
> Original-mail: https://lore.kernel.org/linux-xfs/20200404085203.1908-1-chandanrlinux@gmail.com/T/#mdd12ad06cf5d635772cc38946fc5b22e349e136f
> Originally-from: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ping?

--D

> ---
> v2: various fixes suggested by Dave; reflow the paragraphs about
> directories to describe the relations between dabtree and dirents only once;
> don't talk about an unnamed "we".
> ---
>  .../extended_attributes.asciidoc                   |   55 ++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> index 99f7b35..b7a6007 100644
> --- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> +++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> @@ -910,3 +910,58 @@ Log sequence number of the last write to this block.
>  
>  Filesystems formatted prior to v5 do not have this header in the remote block.
>  Value data begins immediately at offset zero.
> +
> +== Key Differences Between Directories and Extended Attributes
> +
> +Though directories and extended attributes can take advantage of the same
> +variable length record btree structures (i.e. the dabtree) to map name hashes
> +to directory entry records (dirent records) or extended attribute records,
> +there are major differences in the ways that each of those users embed the
> +btree within the information that they are storing.  The directory dabtree leaf
> +nodes contain mappings between a name hash and the location of a dirent record
> +inside the directory entry segment.  Extended attributes, on the other hand,
> +store attribute records directly in the leaf nodes of the dabtree.
> +
> +When XFS adds or removes an attribute record in any dabtree, it splits or
> +merges leaf nodes of the tree based on where the name hash index determines a
> +record needs to be inserted into or removed.  In the attribute dabtree, XFS
> +splits or merges sparse leaf nodes of the dabtree as a side effect of inserting
> +or removing attribute records.
> +
> +Directories, however, are subject to stricter constraints.  The userspace
> +readdir/seekdir/telldir directory cookie API places a requirement on the
> +directory structure that dirent record cookie cannot change for the life of the
> +dirent record.  XFS uses the dirent record's logical offset into the directory
> +data segment as the cookie, and hence the dirent record cannot change location.
> +Therefore, XFS cannot store dirent records in the leaf nodes of the dabtree
> +because the offset into the tree would change as other entries are inserted and
> +removed.
> +
> +Dirent records are therefore stored within directory data blocks, all of which
> +are mapped in the first directory segment.  The directory dabtree is mapped
> +into the second directory segment.  Therefore, directory blocks require
> +external free space tracking because they are not part of the dabtree itself.
> +Because the dabtree only stores pointers to dirent records in the first data
> +segment, there is no need to leave holes in the dabtree itself.  The dabtree
> +splits or merges leaf nodes as required as pointers to the directory data
> +segment are added or removed, and needs no free space tracking.
> +
> +When XFS adds a dirent record, it needs to find the best-fitting free space in
> +the directory data segment to turn into the new record.  This requires a free
> +space index for the directory data segment.  The free space index is held in
> +the third directory segment.  Once XFS has used the free space index to find
> +the block with that best free space, it modifies the directory data block and
> +updates the dabtree to point the name hash at the new record.  When XFS removes
> +dirent records, it leaves hole in the data segment so that the rest of the
> +entries do not move, and removes the corresponding dabtree name hash mapping.
> +
> +Note that for small directories, XFS collapses the name hash mappings and
> +the free space information into the directory data blocks to save space.
> +
> +In summary, the requirement for a free space map in the directory structure
> +results from storing the dirent records externally to the dabtree.  Attribute
> +records are stored directly in the dabtree leaf nodes of the dabtree (except
> +for remote attribute values which can be anywhere in the attr fork address
> +space) and do not need external free space tracking to determine where to best
> +insert them.  As a result, extended attributes exhibit nearly perfect scaling
> +until the computer runs out of memory.
