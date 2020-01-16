Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1F1C33CB3
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 300582072E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PkCnGwWH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389419AbgAPXmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 18:42:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389373AbgAPX02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 18:26:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GNNEPx074893;
        Thu, 16 Jan 2020 23:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=jQrsnBG25YJ4dpmATeaO81jBCA0GA31riYUpFn6T8Bg=;
 b=PkCnGwWHCfe85johfZGrUZXy3UVrPraBM05UoOU6F3uH+eE2ocVq+y9/2LoHH56hqOCl
 JHN6mbRWumKJm3QP4M8T7UEFdGGj4+F2K7vJiEoDtpsoVTA/6CbDyj4kRZ6OdT6vRn7p
 8vPAmwiXEnnMvWTuJIMx4EdEktC86D3J8dDevp5PPLPKKq0xgUkU3ZpNxihOcdAGDkpD
 2t1F0gi2R6GMSI7u44nVnia3Gb1KMIyKxXsRZJYSRNDZuNvz/GwOrRq1bTIdSvS8SuBO
 J3rdmrOaD9z0a+awS5DBcbPx7KqT+p5XceRq9/u+EZSS/NdP2osU9pOb+hQzrUsN20S/ UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73u5k3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:26:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GNNI8x138322;
        Thu, 16 Jan 2020 23:26:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xjxp3yqan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:26:21 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00GNQLQE000384;
        Thu, 16 Jan 2020 23:26:21 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 15:26:21 -0800
Date:   Thu, 16 Jan 2020 15:26:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200116232618.GN8247@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910785108.2028217.14921731819456574224.stgit@magnolia>
 <20200116162148.GE3802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116162148.GE3802@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=720
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=779 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160187
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:21:48AM -0800, Christoph Hellwig wrote:
> > @@ -2960,6 +2960,10 @@ xfs_read_agf(
> >  			mp, tp, mp->m_ddev_targp,
> >  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> >  			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> > +	if (error == -EAGAIN && (flags & XBF_TRYLOCK)) {
> 
> Given that EAGAIN is only returned in the XBF_TRYLOCK case the check
> for XBF_TRYLOCK should not be required.

Ok.

> > +		*bpp = NULL;
> > +		return 0;
> 
> Also we should make sure in the lowest layers to never return a
> non-NULL bpp if returning an error to avoid this boilerplate code.

<nod>

At some point I was planning to audit the ALLOC_TRYLOCK cases to make
sure that they can handle an EAGAIN, so we can get rid of this chunk
entirely.

> > -	if (!bp)
> > -		return -ENOMEM;
> > +	error = xfs_buf_read_map(target, &map, 1, flags, &bp, ops);
> > +	if (error)
> > +		return error;
> >  	error = bp->b_error;
> >  	if (error) {
> >  		xfs_buf_ioerror_alert(bp, __func__);
> 
> The extra checking of bp->b_error shoudn't be required now.  That almost
> means we might have to move the xfs_buf_ioerror_alert into
> xfs_buf_read_map.
> 
> That also means xfs_buf_read can be turned into a simple inline
> function again.

Yeah, I'll add another patch to factor that out.

--D
