Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34398C33CAF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F5720748
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PmVq6651"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgAPWeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:34:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729631AbgAPWeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 17:34:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMXVYq075657;
        Thu, 16 Jan 2020 22:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pX7tFV3hb6QTkb5qlwfd7GTqpDiuFkBW7OXtDASHxFA=;
 b=PmVq6651lnwTal6Ah/QINmnjFi6NJNsDFBgpnWC/B/c1mVCzHC/9WQWSFzgjIaXhKb7g
 ObgjliwHllIV7a2+W4NAG8rMgIAQsR6fY5qM3XMByw4VFCyLyh65ezlZISUx+WIDLwA9
 eOf6EKWLeH6UZIEr6nstoi0jJrEvxkoQ2qkPXCXP1gc0Fs+h9xIRT5x1ks2XOsnZLVOw
 GvCkHF21sTKNSs3xAFB5wWeNsDYn2V11IPQ5xTPfjsQeKt2wnMRb7gGV4lqQHK5ECeze
 3/Lu5WxXS7dRoE+Ht0MuzR8LCnBH2POLM65Xg6NWGfntmrmubtPrvcgRTbZMT2Ztck9f PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74snfbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:34:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMYCNL076733;
        Thu, 16 Jan 2020 22:34:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1ay3dku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:34:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00GMXxvT023010;
        Thu, 16 Jan 2020 22:33:59 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 14:33:59 -0800
Date:   Thu, 16 Jan 2020 14:33:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: make xfs_buf_get_map return an error code
Message-ID: <20200116223356.GI8247@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910785745.2028217.13992797354402280050.stgit@magnolia>
 <20200116162856.GF3802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116162856.GF3802@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=684
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=744 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:28:56AM -0800, Christoph Hellwig wrote:
> >  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
> > -
> >  	switch (error) {
> >  	case 0:
> >  		/* cache hit */
> >  		goto found;
> > -	case -EAGAIN:
> > -		/* cache hit, trylock failure, caller handles failure */
> > -		ASSERT(flags & XBF_TRYLOCK);
> > -		return NULL;
> >  	case -ENOENT:
> >  		/* cache miss, go for insert */
> >  		break;
> > +	case -EAGAIN:
> > +		/* cache hit, trylock failure, caller handles failure */
> > +		ASSERT(flags & XBF_TRYLOCK);
> > +		/* fall through */
> >  	case -EFSCORRUPTED:
> >  	default:
> > -		/*
> > -		 * None of the higher layers understand failure types
> > -		 * yet, so return NULL to signal a fatal lookup error.
> > -		 */
> > -		return NULL;
> > +		return error;
> 
> I think two little if statements would be cleaner with two ifs instead
> of the switch statement:
> 
> 	if (!error)
> 		goto found;
> 	if (error != -ENOENT)
> 		return error;
> 
> Otherwise looks good:

Will fix.

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
