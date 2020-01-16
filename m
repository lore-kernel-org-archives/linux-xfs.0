Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F597C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF162064C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:31:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hdUQ1Trm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgAPWbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:31:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389966AbgAPWbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 17:31:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMSPWS035684;
        Thu, 16 Jan 2020 22:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ydYsheEcWgR0ji2mYTQ3f26b329n7PoHq/y0lw6uv+I=;
 b=hdUQ1TrmZ5LtwyfQOW6Mb1EzmnmTBGR423ORlo2XV1rLKMplSiG9E83bdkX/mD+PJ1hj
 uwjWO5/zzdeMaKyhaG1hrKzA4KmXvL0gMZvu3C6ft8LTxetBGzwmZus9pKm9tqzbLg7Z
 /24ccU7XWF65VdVV43+syVcCsEVLjWqg5J9jYCzETNW4lS+trvHFzAuFkB7WwuWKpSPb
 OTI0/NlbjiGginpt7LtRj3kaJRoyffpsN9Ko3m75HuLl7GaWba+WfA7qNZ8871kTgK90
 uqsfbLALE0LB1m1X4TWBDTGyX27ANF2OZ9BhbTqlCF+1k6HFo0eZPyEpZ4ouTc1saBcH 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73u5db9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:31:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMTEDG190304;
        Thu, 16 Jan 2020 22:30:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xj61nbk57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:30:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00GMUxW5009748;
        Thu, 16 Jan 2020 22:30:59 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 14:30:59 -0800
Date:   Thu, 16 Jan 2020 14:30:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: make xfs_buf_read return an error code
Message-ID: <20200116223056.GH8247@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910783215.2028217.1338010488330820754.stgit@magnolia>
 <20200116161538.GB3802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116161538.GB3802@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:15:38AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 15, 2020 at 09:03:52AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert xfs_buf_read() to return numeric error codes like most
> > everywhere else in xfs.
> 
> It also does a few more things:
> 
> > +	error = bp->b_error;
> > +	if (error) {
> > +		xfs_buf_ioerror_alert(bp, __func__);
> 
> Adds a new call to xfs_buf_ioerror_alert, which exists in most callers.
> 
> > +		xfs_buf_stale(bp);
> > +		xfs_buf_relse(bp);
> > +
> > +		/* bad CRC means corrupted metadata */
> > +		if (error == -EFSBADCRC)
> > +			error = -EFSCORRUPTED;
> 
> .. and it remaps this error value.
> 
> Both of which look sensible to me, so with that mentioned in the
> commit log:

Fixed.

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
