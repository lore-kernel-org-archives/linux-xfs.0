Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F1CC432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 07:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1060A20872
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 07:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G8C6J8Vj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfKUHPj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:15:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfKUHPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 02:15:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL7DxGT177400;
        Thu, 21 Nov 2019 07:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mNQoXW71xu/q5CLW8vz7JIOdwPXaF657fwpFaUVHMdQ=;
 b=G8C6J8Vjr+5Q5g7DaAH3F684kFULSi4qzmi/S14tnEeEp8FUm+eGZoa7m4wyIy4oUnU/
 ZblCU1cYvIp9lN0cd9HPAdx3ChUS28SsjxVsxkZbYP54hGgKjwaFHo4aZtRR9wgSJlq5
 Rt4CALatNht7XVf0LjRpIU2mO/9FlFKV7uCzdPOCQYVAbBOARpBpuFTpF/vT451km3Gu
 Sy2H01yWBIgnIqCecgAXl1sLlbIErK0z8bIx+VmU0BXABuU3UCTYqRXESlJLBDW1ruCs
 i2qJN7nxzkPJ6bhyWdlqxiTLdHKvl5TmBFhLA2C8WUzFpFRC/liRR7Ei7aOdlv/A7TUZ cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8hu286d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 07:15:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL7D9td132760;
        Thu, 21 Nov 2019 07:15:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wd47wfmbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 07:15:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAL7FWbR024550;
        Thu, 21 Nov 2019 07:15:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 23:15:32 -0800
Date:   Wed, 20 Nov 2019 23:15:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191121071530.GY6219@magnolia>
References: <20191120111727.16119-1-hch@lst.de>
 <20191120111727.16119-4-hch@lst.de>
 <20191120181708.GM6219@magnolia>
 <20191120182035.GA11912@lst.de>
 <20191121054458.GX6219@magnolia>
 <20191121060627.GA22808@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121060627.GA22808@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210063
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 07:06:27AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 20, 2019 at 09:44:58PM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 20, 2019 at 07:20:35PM +0100, Christoph Hellwig wrote:
> > > On Wed, Nov 20, 2019 at 10:17:08AM -0800, Darrick J. Wong wrote:
> > > > > -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> > > > > -				&mapp, &nmap);
> > > > > +	error = xfs_dabuf_map(dp, bno,
> > > > > +			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> > > > > +			whichfork, &mapp, &nmap);
> > > > >  	if (error) {
> > > > >  		/* mapping a hole is not an error, but we don't continue */
> > > > > -		if (error == -1)
> > > > > +		if (error == -ENOENT)
> > > > 
> > > > Shouldn't this turn into:
> > > > 
> > > > if (error || !nmap)
> > > > 	goto out_free;
> > > > 
> > > > Otherwise looks ok to me.
> > > 
> > > Yes, it should.  Looks like that hunk got lost in the reshuffle.
> > 
> > With that and the other change I mentioned, it seems to test ok.  Do you
> > want to respin the patch, or just let me keep my staged version?
> 
> I've just done the respin and was about to re-start testing.  If you
> have a sensible version I'll skip that and will let you proceed.

Here's what I've been testing with, though FWIW I'm about to go to bed
so you might as well keep going, particularly if you see anything funny
here.

--D

xfs: improve the xfs_dabuf_map calling conventions

Use a flags argument with the XFS_DABUF_MAP_HOLE_OK flag to signal that
a hole is okay and not corruption, and return 0 with *nmap set to 0 to
signal that case in the return value instead of a nameless -1 return
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix a few minor error and flags checking mistakes]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |   43 ++++++++++++++----------------------------
 fs/xfs/libxfs/xfs_da_btree.h |    3 +++
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e078817fc26c..4d582a327c12 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2460,19 +2460,11 @@ xfs_da_shrink_inode(
 	return error;
 }
 
-/*
- * Map the block we are given ready for reading. There are three possible return
- * values:
- *	-1 - will be returned if we land in a hole and mappedbno == -2 so the
- *	     caller knows not to execute a subsequent read.
- *	 0 - if we mapped the block successfully
- *	>0 - positive error number if there was an error.
- */
 static int
 xfs_dabuf_map(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
+	unsigned int		flags,
 	int			whichfork,
 	struct xfs_buf_map	**mapp,
 	int			*nmaps)
@@ -2527,7 +2519,7 @@ xfs_dabuf_map(
 
 invalid_mapping:
 	/* Caller ok with no mapping. */
-	if (XFS_IS_CORRUPT(mp, mappedbno != -2)) {
+	if (XFS_IS_CORRUPT(mp, !(flags & XFS_DABUF_MAP_HOLE_OK))) {
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
@@ -2575,13 +2567,11 @@ xfs_da_get_buf(
 		goto done;
 	}
 
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
-	if (error) {
-		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
-			error = 0;
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
+	if (error || nmap == 0)
 		goto out_free;
-	}
 
 	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
 done:
@@ -2630,13 +2620,11 @@ xfs_da_read_buf(
 		goto done;
 	}
 
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
-	if (error) {
-		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
-			error = 0;
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
+	if (error || !nmap)
 		goto out_free;
-	}
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
@@ -2677,14 +2665,11 @@ xfs_da_reada_buf(
 
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
-				&mapp, &nmap);
-	if (error) {
-		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
-			error = 0;
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
+	if (error || !nmap)
 		goto out_free;
-	}
 
 	mappedbno = mapp[0].bm_bn;
 	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap, ops);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ed3b558a9c1a..64624d5717c9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -194,6 +194,9 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 /*
  * Utility routines.
  */
+
+#define XFS_DABUF_MAP_HOLE_OK	(1 << 0)
+
 int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
 int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
 			      int count);
