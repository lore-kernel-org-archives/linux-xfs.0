Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5DFC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE9421655
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M+T4KQjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgJLVat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 17:30:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37406 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgJLVat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 17:30:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09CLUkcZ010496;
        Mon, 12 Oct 2020 21:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=57/7PvgefuwvBViJTzXDI1wO5O11oxG43FfDTGjLdFc=;
 b=M+T4KQjQZqXdta2/ebDgLSKxjr09u8QUuWsM6DBV0W5iYjAMUZg7UbKZ23FBSW0ADmr/
 vYWLKfcNRtsNOZJ8E6xTJ8ESZvzLc4JN0C6c1kRXiVWV9HAnCJ4mtMtXNIZbpOOeyCsK
 WcJ2O7pvfuvAY4c/87kvaipZLV+kgk8DdBSVwkwleYt4acDDaxz9TpwOpg9CV0Z2GKoL
 8sSPNwBKj94kmMceZdoot4D++ekEcWyFmBG5Pq7zxcJemKKD0faNXD4gBP4gUhW7DFd9
 TGt2/E1z401w7zK2X0jwUdD1OdJCCLHc7gZOgZqr94N1T5vfNWgnBNgqSY/lFoe3Gjg7 FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 343pajnutq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Oct 2020 21:30:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09CLUVwQ188054;
        Mon, 12 Oct 2020 21:30:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 343pvvfuw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 21:30:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09CLUieU010527;
        Mon, 12 Oct 2020 21:30:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Oct 2020 14:30:44 -0700
Date:   Mon, 12 Oct 2020 14:30:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201012213043.GY6540@magnolia>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com>
 <20201012160412.GK917726@bfoster>
 <a6afba10-64a2-a30c-94de-e99a324a6114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6afba10-64a2-a30c-94de-e99a324a6114@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9772 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010120161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9772 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010120161
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 11:02:51PM +0200, Pavel Reichl wrote:
> 
> > ...
> >> @@ -384,16 +385,17 @@ xfs_isilocked(
> >>  	struct xfs_inode	*ip,
> >>  	uint			lock_flags)
> >>  {
> >> -	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> >> -		if (!(lock_flags & XFS_ILOCK_SHARED))
> >> -			return !!ip->i_lock.mr_writer;
> >> -		return rwsem_is_locked(&ip->i_lock.mr_lock);
> >> +	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> >> +		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
> >> +		return __xfs_rwsem_islocked(&ip->i_lock,
> >> +				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
> >>  	}
> >>  
> >> -	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> >> -		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> >> -			return !!ip->i_mmaplock.mr_writer;
> >> -		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> >> +	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> >> +		ASSERT(!(lock_flags &
> >> +			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
> >> +		return __xfs_rwsem_islocked(&ip->i_mmaplock,
> >> +				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
> >>  	}
> >>  
> >>  	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> > 
> > Can we add a similar assert for this case as we have for the others?
> > Otherwise the rest looks fairly straightforward to me.
> > 
> 
> Sure we can! But do we want to?
> 
> I think that these asserts are supposed to make sure that only flags
> for one of the inode's locks are used eg. ILOCK, MMAPLOCK or IOLOCK
> but no combination! So if we reach this 3rd condition we already know
> that the flags for ILOCK and MMAPLOCK were not set. However if there's
> possibility for more locks to be added in the future or just for the
> 'code symmetry' purposes - I have no problem to update the code.

It's generally a good idea not to leave logic bombs of the sort where
where the debugging code can bitrot into incorrectness if someone
unwittingly adds another level of locking later.

(That said, I really hope we don't; I already consider it a little
strange to have separate io and mmap locks...)

--D
