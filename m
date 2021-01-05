Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38041C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 01:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB9C122582
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 01:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhAEBPX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:15:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58232 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbhAEBPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 20:15:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10519pvZ050123;
        Tue, 5 Jan 2021 01:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f8IfE5rAKu34ysqIqeNAPMq783yDDGbSQ/TxvIKPJ8E=;
 b=U4GMbF0WHdhYdjJ3Lsk2SUWsL4/HPFQM6WEQ4XwMgDmsrry48Ao2wkOlfnnUhJm7z9wg
 MA4GoysPiXkH4kO9ApCwl65pSFqupmoclphkvQC7I7i+MQmkQB2fGDBNXJTWsqWeQodl
 fnptaipSOhRb2evYBouZCoyfniIFcT9Odx3VL8Dc4kJj7NGrxnp1nfDME0aiZ6hGhRs8
 TIIroUHLFgHbhJGwoxzJjy4AhKUv93J+1hMrMvV/F54/aW9cNNR8CT4TTNrcAu8gnnyO
 c5b5JsFCQGbNnsghf5PhSs5iCPe2cjfDqHQMreYF2uYFLPG1q9HC/Y/OA17cdVSLzNy5 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35tgskpsx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 01:14:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1051AJjS151340;
        Tue, 5 Jan 2021 01:14:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35uxnry1dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 01:14:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1051EX8M031600;
        Tue, 5 Jan 2021 01:14:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 01:14:33 +0000
Date:   Mon, 4 Jan 2021 17:14:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com
Subject: Re: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210105011432.GS6918@magnolia>
References: <20210104194437.GJ38809@magnolia>
 <20210104202714.GE254939@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104202714.GE254939@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 03:27:14PM -0500, Brian Foster wrote:
> On Mon, Jan 04, 2021 at 11:44:37AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When overlayfs is running on top of xfs and the user unlinks a file in
> > the overlay, overlayfs will create a whiteout inode and ask xfs to
> > "rename" the whiteout file atop the one being unlinked.  If the file
> > being unlinked loses its one nlink, we then have to put the inode on the
> > unlinked list.
> > 
> > This requires us to grab the AGI buffer of the whiteout inode to take it
> > off the unlinked list (which is where whiteouts are created) and to grab
> > the AGI buffer of the file being deleted.  If the whiteout was created
> > in a higher numbered AG than the file being deleted, we'll lock the AGIs
> > in the wrong order and deadlock.
> > 
> > Therefore, grab all the AGI locks we think we'll need ahead of time, and
> > in the correct order.
> > 
> > Reported-by: wenli xie <wlxie7296@gmail.com>
> > Tested-by: wenli xie <wlxie7296@gmail.com>
> > Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index b7352bc4c815..dd419a1bc6ba 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * For the general case of renaming files, lock all the AGI buffers we need to
> > + * handle bumping the nlink of the whiteout inode off the unlinked list and to
> > + * handle dropping the nlink of the target inode.  We have to do this in
> > + * increasing AG order to avoid deadlocks.
> > + */
> > +static int
> > +xfs_rename_lock_agis(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*wip,
> > +	struct xfs_inode	*target_ip)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_buf		*bp;
> > +	xfs_agnumber_t		agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
> > +	int			error;
> > +
> > +	if (wip)
> > +		agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
> > +
> > +	if (target_ip && VFS_I(target_ip)->i_nlink == 1)
> > +		agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
> > +
> > +	if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
> > +	    agi_locks[0] > agi_locks[1])
> > +		swap(agi_locks[0], agi_locks[1]);
> > +
> > +	if (agi_locks[0] != NULLAGNUMBER) {
> > +		error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	if (agi_locks[1] != NULLAGNUMBER) {
> > +		error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> This all looks reasonable to me, but I wonder if we can simplify
> a bit by reusing the sorted inodes array we've already created earlier
> in xfs_rename(). E.g., something like:
> 
> 	for (i = 0; i < num_inodes; i++) {
> 		if (inodes[i] != wip && inodes[i] != target_ip)
> 			continue;
> 		error = xfs_read_agi(...);
> 		...
> 	}
> 
> IOW, similar to how xfs_lock_inodes() and xfs_qm_vop_rename_dqattach()
> work.

I think it would be difficult to do that because we only need to grab
target_ip's AGI if we're going to droplink it, and we haven't yet taken
target_ip's ILOCK when we invoke the sorting hat so the link count isn't
stable.

--D

> Brian
> 
> > +
> >  /*
> >   * xfs_rename
> >   */
> > @@ -3130,6 +3172,10 @@ xfs_rename(
> >  		}
> >  	}
> >  
> > +	error = xfs_rename_lock_agis(tp, wip, target_ip);
> > +	if (error)
> > +		return error;
> > +
> >  	/*
> >  	 * Directory entry creation below may acquire the AGF. Remove
> >  	 * the whiteout from the unlinked list first to preserve correct
> > 
> 
