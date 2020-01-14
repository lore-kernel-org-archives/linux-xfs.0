Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B46C33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 00:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7394207FD
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 00:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MOaCUgpb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgANAop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 19:44:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46968 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgANAop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 19:44:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E0h6wG068689;
        Tue, 14 Jan 2020 00:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qfiwmvZis5rahPycwN3N+z2/QBvh132fnBqzs01z4Ck=;
 b=MOaCUgpbm6Z7Rns5bgCd1fsaY+03Jo3QKWpDbPaWLtnn1/xf2XArP3OHXjKufSEDfdo9
 iEyf8nimrIdrMtnn4VrOBMO0mrLH1E7JMXDarpJB633TjTVsMw5bBuRqRcYdSX6xp7tI
 VUC+yROvtpGZN947QOvxNd6MKWwSvtEihYpnbq5SC95TohUycJA+yEngOgtEKOql0tN1
 4FnjSvuYUOAypm0EHn2sMJAM+fMOqojLZ4A0y0txUgGB65ALeSwDhdHxDsviWzqnp5dS
 o9XfuBXrjbRvcQfFAsi6HO7qHJaMs8IjV3eKmiDCb0Hv8q5W0+RLqJTwhbkJtm2Euji/ yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73tjg2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 00:44:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E0iJNs116524;
        Tue, 14 Jan 2020 00:44:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xh30xbh1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 00:44:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00E0h9ua006567;
        Tue, 14 Jan 2020 00:43:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 16:43:08 -0800
Date:   Mon, 13 Jan 2020 16:43:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: refactor remote attr value buffer invalidation
Message-ID: <20200114004307.GQ8247@magnolia>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859548668.164065.18078635787497973193.stgit@magnolia>
 <20200110115540.GC19577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110115540.GC19577@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=750
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=801 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 10, 2020 at 03:55:40AM -0800, Christoph Hellwig wrote:
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_buf		*bp;
> > +	xfs_daddr_t		dblkno;
> > +	int			dblkcnt;
> > +
> > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > +
> > +	dblkno = XFS_FSB_TO_DADDR(mp, map->br_startblock),
> > +	dblkcnt = XFS_FSB_TO_BB(mp, map->br_blockcount);
> > +
> > +	/*
> > +	 * If the "remote" value is in the cache, remove it.
> > +	 */
> > +	bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
> 
> Do we really need the dblkno and dblkcnt local variables here?

Eh, not really.

> > @@ -592,18 +614,8 @@ xfs_attr_rmtval_remove(
> >  		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> >  		       (map.br_startblock != HOLESTARTBLOCK));
> >  
> > -		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
> > -		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
> > -
> > -		/*
> > -		 * If the "remote" value is in the cache, remove it.
> > -		 */
> > -		bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
> > -		if (bp) {
> > -			xfs_buf_stale(bp);
> > -			xfs_buf_relse(bp);
> > -			bp = NULL;
> > -		}
> > +		if (map.br_startblock != HOLESTARTBLOCK)
> > +			xfs_attr_rmtval_stale(args->dp, &map);
> 
> I don't think we need the HOLESTARTBLOCK check here, given that we have
> the asserts above.  I also think the assert should move into
> xfs_attr_rmtval_stale and be split into two asserts, one each for the
> invalid values.

<nod> I'll upgrade them to proper fs corruption messages while I'm at
it.

--D
