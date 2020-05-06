Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA14CC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 19:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B162207DD
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 19:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DJv+GJLP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgEFTLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 15:11:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44468 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgEFTLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 15:11:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046J7pEd054632;
        Wed, 6 May 2020 19:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=biiFCE2fEfRQhRaCyj0VITSYb8uTZh+Bm6C1lsSd/rs=;
 b=DJv+GJLPy5zIf6nQ40xx2TzejW6ZfHZdSeZAqRRMRVaNVc62BvcFK/pmeneCUn4cy6H1
 ZfpuUx7ZlVDxQLhID29+mIIXu16aCVdrxIc2A/ZNcnj8lVyKJerf18CPueifUbaNhBx9
 dTycLGrgfykvWsoUnG4oFx+GUStPOnZV87JCluZ5FxNozp4Bvtt6EBPJRjAQN5cpAdy1
 zD58qBk/HUzw4VmhbgxY3ZMdJ9NuiBMxKl8C0IYnRrahT1dKJcqASZRKDTIYQPScIZb/
 linyILLo7IwklnplgJsT/VexOcNtvLvw0NV/kVqJbfXu1dMjplzWbj/cKwZNaMI3XE8a DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30s1gnc35a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 19:11:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046J7mFT079482;
        Wed, 6 May 2020 19:11:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r8hbdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 19:11:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046JB2dh006638;
        Wed, 6 May 2020 19:11:02 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 12:11:02 -0700
Date:   Wed, 6 May 2020 12:11:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs: refactor xlog_recover_process_unlinked
Message-ID: <20200506191100.GC6714@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864115522.182683.9248036319539577559.stgit@magnolia>
 <1967481.PxtkyhZy26@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1967481.PxtkyhZy26@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=5
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=5 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 05, 2020 at 06:49:17PM +0530, Chandan Babu R wrote:
> On Tuesday 5 May 2020 6:42:35 AM IST Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Hoist the unlinked inode processing logic out of the AG loop and into
> > its own function.  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_unlink_recover.c |   91 +++++++++++++++++++++++++------------------
> >  1 file changed, 52 insertions(+), 39 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
> > index 2a19d096e88d..413b34085640 100644
> > --- a/fs/xfs/xfs_unlink_recover.c
> > +++ b/fs/xfs/xfs_unlink_recover.c
> > @@ -145,54 +145,67 @@ xlog_recover_process_one_iunlink(
> >   * scheduled on this CPU to ensure other scheduled work can run without undue
> >   * latency.
> >   */
> > -void
> > -xlog_recover_process_unlinked(
> > -	struct xlog		*log)
> > +STATIC int
> > +xlog_recover_process_iunlinked(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno)
> >  {
> > -	struct xfs_mount	*mp;
> >  	struct xfs_agi		*agi;
> >  	struct xfs_buf		*agibp;
> > -	xfs_agnumber_t		agno;
> >  	xfs_agino_t		agino;
> >  	int			bucket;
> >  	int			error;
> >  
> > -	mp = log->l_mp;
> > -
> > -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > -		/*
> > -		 * Find the agi for this ag.
> > -		 */
> > -		error = xfs_read_agi(mp, NULL, agno, &agibp);
> > -		if (error) {
> > -			/*
> > -			 * AGI is b0rked. Don't process it.
> > -			 *
> > -			 * We should probably mark the filesystem as corrupt
> > -			 * after we've recovered all the ag's we can....
> > -			 */
> > -			continue;
> > -		}
> > +	/*
> > +	 * Find the agi for this ag.
> > +	 */
> > +	error = xfs_read_agi(mp, NULL, agno, &agibp);
> > +	if (error) {
> >  		/*
> > -		 * Unlock the buffer so that it can be acquired in the normal
> > -		 * course of the transaction to truncate and free each inode.
> > -		 * Because we are not racing with anyone else here for the AGI
> > -		 * buffer, we don't even need to hold it locked to read the
> > -		 * initial unlinked bucket entries out of the buffer. We keep
> > -		 * buffer reference though, so that it stays pinned in memory
> > -		 * while we need the buffer.
> > +		 * AGI is b0rked. Don't process it.
> > +		 *
> > +		 * We should probably mark the filesystem as corrupt
> > +		 * after we've recovered all the ag's we can....
> >  		 */
> > -		agi = agibp->b_addr;
> > -		xfs_buf_unlock(agibp);
> > -
> > -		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> > -			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> > -			while (agino != NULLAGINO) {
> > -				agino = xlog_recover_process_one_iunlink(mp,
> > -							agno, agino, bucket);
> > -				cond_resched();
> > -			}
> > +		return error;
> 
> 
> This causes a change in behaviour i.e. an error return from here would cause
> xlog_recover_process_unlinked() to break "loop on all AGs". Before this
> change, XFS would continue to process all the remaining AGs as described by
> the above comment.

Hm, you're right.  I'll make this function return void and then mess
with the return values and whatnot later.

--D

> 
> > +	}
> > +
> > +	/*
> > +	 * Unlock the buffer so that it can be acquired in the normal
> > +	 * course of the transaction to truncate and free each inode.
> > +	 * Because we are not racing with anyone else here for the AGI
> > +	 * buffer, we don't even need to hold it locked to read the
> > +	 * initial unlinked bucket entries out of the buffer. We keep
> > +	 * buffer reference though, so that it stays pinned in memory
> > +	 * while we need the buffer.
> > +	 */
> > +	agi = agibp->b_addr;
> > +	xfs_buf_unlock(agibp);
> > +
> > +	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> > +		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> > +		while (agino != NULLAGINO) {
> > +			agino = xlog_recover_process_one_iunlink(mp,
> > +						agno, agino, bucket);
> > +			cond_resched();
> >  		}
> > -		xfs_buf_rele(agibp);
> > +	}
> > +	xfs_buf_rele(agibp);
> > +
> > +	return 0;
> > +}
> > +
> > +void
> > +xlog_recover_process_unlinked(
> > +	struct xlog		*log)
> > +{
> > +	struct xfs_mount	*mp = log->l_mp;
> > +	xfs_agnumber_t		agno;
> > +	int			error;
> > +
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > +		error = xlog_recover_process_iunlinked(mp, agno);
> > +		if (error)
> > +			break;
> >  	}
> >  }
> > 
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
