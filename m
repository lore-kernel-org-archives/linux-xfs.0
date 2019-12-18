Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C0DC43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78F6B21D7D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kD9hmz6Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfLRVTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:19:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfLRVTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:19:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIL9uI1002090;
        Wed, 18 Dec 2019 21:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ne1bPCQjMvyjr5GPjN2TJHRC6FVV8lfi+mMqMIQjoKc=;
 b=kD9hmz6Qdq3uwg/jfjigHf9GxRN1qf4SFynBoUoBynvMNsjtWJOkN6U/TOPFAQYN70bU
 NEMAN1lHkbW3THSCdNO4CVXU5RKfaMLS4oXon2Fpo3IkSrHXO0Ia7vEz74ww5cs7v1IJ
 BPPUvBemDXoW7oAD5jK5L8UDOWIYkCZzERsXdWzW6TS4BGrlCrOirIhwVtBLPfmKH8bX
 RffSn8NrOaSt0F9sX1li5YuSA6HsxZtCbKjis/A9p9u1ub091OjJHZrzRUcSlG3yKcbC
 qAHMAZ9op4c2f5eEpGcbzMNjZrRL6qomtMiq+hHEaB4WD8uaLBKXqLJralcmNbUeoI1u Tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wvqpqg7fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:19:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIL8mpp033917;
        Wed, 18 Dec 2019 21:19:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wyk3btcu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:19:08 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBILJ66w011234;
        Wed, 18 Dec 2019 21:19:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:19:06 -0800
Date:   Wed, 18 Dec 2019 13:19:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rework collapse range into an atomic operation
Message-ID: <20191218211905.GC7489@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-4-bfoster@redhat.com>
 <20191218023958.GI12765@magnolia>
 <20191218121120.GB63809@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218121120.GB63809@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 07:11:20AM -0500, Brian Foster wrote:
> On Tue, Dec 17, 2019 at 06:39:58PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 13, 2019 at 12:12:58PM -0500, Brian Foster wrote:
> > > The collapse range operation uses a unique transaction and ilock
> > > cycle for the hole punch and each extent shift iteration of the
> > > overall operation. While the hole punch is safe as a separate
> > > operation due to the iolock, cycling the ilock after each extent
> > > shift is risky similar to insert range.
> > 
> > It is?  I thought collapse range was safe because we started by punching
> > out the doomed range and shifting downwards, which eliminates the
> > problems that come with two adjacent mappings that could be combined?
> > 
> > <confused?>
> > 
> 
> This is somewhat vague wording. I don't mean to say the same bug is
> possible on collapse. Indeed, I don't think that it is. What I mean to
> say is just that cycling the ilock generally opens the operation up to
> concurrent extent changes, similar to the behavior that resulted in the
> insert range bug and against the general design principle of the
> operation (as implied by the iolock hold -> flush -> unmap preparation
> sequence).

Oh, ok, you're merely trying to prevent anyone from seeing the inode
metadata while we're in the middle of a collapse-range operation.  I
wonder then if we need to take a look at the remap range operations, but
oh wow is that a gnarly mess of inode locking. :)

> IOW, it seems to me that a similar behavior is possible on collapse, it
> just might occur after an extent has been shifted into its new target
> range rather than before. That wouldn't be a corruption/bug because it
> doesn't change the semantics of the shift operation or the content of
> the file, but it's subtle and arguably a misbehavior and/or landmine.

<nod> Ok, just making sure. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Brian
> 
> > --D
> > 
> > > To avoid this problem, make collapse range atomic with respect to
> > > ilock. Hold the ilock across the entire operation, replace the
> > > individual transactions with a single rolling transaction sequence
> > > and finish dfops on each iteration to perform pending frees and roll
> > > the transaction. Remove the unnecessary quota reservation as
> > > collapse range can only ever merge extents (and thus remove extent
> > > records and potentially free bmap blocks). The dfops call
> > > automatically relogs the inode to keep it moving in the log. This
> > > guarantees that nothing else can change the extent mapping of an
> > > inode while a collapse range operation is in progress.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 29 +++++++++++++++--------------
> > >  1 file changed, 15 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index 555c8b49a223..1c34a34997ca 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -1050,7 +1050,6 @@ xfs_collapse_file_space(
> > >  	int			error;
> > >  	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
> > >  	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
> > > -	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> > >  	bool			done = false;
> > >  
> > >  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > > @@ -1066,32 +1065,34 @@ xfs_collapse_file_space(
> > >  	if (error)
> > >  		return error;
> > >  
> > > -	while (!error && !done) {
> > > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
> > > -					&tp);
> > > -		if (error)
> > > -			break;
> > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> > > +	if (error)
> > > +		return error;
> > >  
> > > -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > -		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
> > > -				ip->i_gdquot, ip->i_pdquot, resblks, 0,
> > > -				XFS_QMOPT_RES_REGBLKS);
> > > -		if (error)
> > > -			goto out_trans_cancel;
> > > -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > +	xfs_trans_ijoin(tp, ip, 0);
> > >  
> > > +	while (!done) {
> > >  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
> > >  				&done);
> > >  		if (error)
> > >  			goto out_trans_cancel;
> > > +		if (done)
> > > +			break;
> > >  
> > > -		error = xfs_trans_commit(tp);
> > > +		/* finish any deferred frees and roll the transaction */
> > > +		error = xfs_defer_finish(&tp);
> > > +		if (error)
> > > +			goto out_trans_cancel;
> > >  	}
> > >  
> > > +	error = xfs_trans_commit(tp);
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > >  	return error;
> > >  
> > >  out_trans_cancel:
> > >  	xfs_trans_cancel(tp);
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > >  	return error;
> > >  }
> > >  
> > > -- 
> > > 2.20.1
> > > 
> > 
> 
