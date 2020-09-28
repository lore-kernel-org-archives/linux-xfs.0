Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB60EC2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 17:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BFD620739
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 17:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sCS5MDdw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgI1Rxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 13:53:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgI1Rxl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 13:53:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHrSX0115939;
        Mon, 28 Sep 2020 17:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=liScOL29Ds7K7dnqOO2IG7V7mcIIZ52UCsI6cNihIgc=;
 b=sCS5MDdwRW3vGxj5kwLW4dcC1D4eJ9rZfl6938dcbQ6eLZz4+nj0rTuoAuwCNVXokw/Z
 XiD5r8K+dEzneQzRSQiwYapd5Vgz4/RGZTpXDpWqbBro2C4tjdslkqLjL6U50JMTXIne
 ezkr8h6JHT0y/8QwIB3iBpTIPs7VR3SRBBVyopjBrSzl3sLeCC8SCOfrKaikPJw+JdWN
 pbHICfFmTTbcBpQYfB7TB/TEhvc0p4NEphobXHg7oF6BO/omvxC/ag3nmEH7bV6RwTjc
 2tAHoDk5vAk2UNbL9AbQtrZBj2gKFH0cq5nvEO73zic22Bxc+53tijOPs5NcEYuLdJcT eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkkpfqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 17:53:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHpfUk127016;
        Mon, 28 Sep 2020 17:53:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfjvctd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 17:53:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SHrWX6014710;
        Mon, 28 Sep 2020 17:53:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 10:53:32 -0700
Date:   Mon, 28 Sep 2020 10:53:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200928175331.GE49547@magnolia>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
 <160125008079.174438.4841984502957067911.stgit@magnolia>
 <20200928052618.GD14422@dread.disaster.area>
 <20200928063717.GB15425@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928063717.GB15425@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=935 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=5 mlxlogscore=959 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280139
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 08:37:17AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 28, 2020 at 03:26:18PM +1000, Dave Chinner wrote:
> > > +	struct xfs_mount		*mp = tp->t_mountp;
> > > +	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp);
> > > +	int				error;
> > > +
> > > +	/* If we don't capture anything, commit tp and exit. */
> > > +	if (!dfc)
> > > +		return xfs_trans_commit(tp);
> > > +
> > > +	/*
> > > +	 * Commit the transaction.  If that fails, clean up the defer ops and
> > > +	 * the dfc that we just created.  Otherwise, add the dfc to the list.
> > > +	 */
> > > +	error = xfs_trans_commit(tp);
> > > +	if (error) {
> > > +		xfs_defer_capture_free(mp, dfc);
> > > +		return error;
> > > +	}
> > > +
> > > +	list_add_tail(&dfc->dfc_list, capture_list);
> > > +	return 0;
> > > +}
> > 
> > And, really, this is more than a "transaction commit" operation; it
> > doesn't have anything recovery specific to it, so if the
> > xfs_defer_capture() API is "generic xfs_defer" functionality, why
> > isn't this placed next to it and nameed
> > xfs_defer_capture_and_commit()?
> 
> Agreed.  I find the xlog_recover_trans_commit naming pretty weird.

<nod>

The final list of functions are:

xfs_defer_ops_capture_and_commit: capture a transaction's dfops, commit
	the transaction, and add the capture structure to the list, just like
	xlog_recover_trans_commit did in this patch.

xfs_defer_ops_continue: restore the captured dfops and transaction state
	to a fresh transaction, and free the capture structure.

xfs_defer_ops_release: free all captured dfops and the structure, in case
	recovery failed somewhere and we have to bail out.

> > > @@ -2533,28 +2577,28 @@ xlog_recover_process_intents(
> > >  		 */
> > >  		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
> > >  
> > > +		if (test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags))
> > > +			continue;
> > > +
> > 
> > Why do we still need XFS_LI_RECOVERED here? This log item is going to get
> > removed from the AIL by the committing of the first transaction
> > in the ->iop_recover() sequence we are running, so we'll never find
> > it again in the AIL. Nothing else checks for XFS_LI_RECOVERED
> > anymore, so this seems unnecessary now...
> 
> We also never restart the list walk as far as I can tell.  So yes,
> XFS_LI_RECOVERED seems entirely superflous and should probably be
> removed in a prep patch.

Ok.

> > > -out:
> > > +
> > >  	xfs_trans_ail_cursor_done(&cur);
> > >  	spin_unlock(&ailp->ail_lock);
> > >  	if (!error)
> > > -		error = xlog_finish_defer_ops(parent_tp);
> > > -	xfs_trans_cancel(parent_tp);
> > > +		error = xlog_finish_defer_ops(log->l_mp, &capture_list);
> > >  
> > > +	xlog_cancel_defer_ops(log->l_mp, &capture_list);
> > >  	return error;
> > >  }
> > 
> > Again, why are we cancelling the capture list if we just
> > successfully processed the defer ops on the capture list?
> 
> Yes, we'll probably just want to assert it is non-empty at the end of
> xlog_finish_defer_ops.

Done.

--D
