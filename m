Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E77DC32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C20217F4
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OdmRT1Cg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgATWU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:20:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgATWU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:20:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMJV5A014603;
        Mon, 20 Jan 2020 22:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=n77ylg2HD8+ealTxGTUP5+FdhOYqmbywMSO1xugQ7Bc=;
 b=OdmRT1Cg3dmT7d7btBynrR3fIxw5WcuGXEpo11a7pRv9CLGHhNA+ceGohdU4VeX9867I
 w0KtTe+50EeI4XuW/2krR+ziQV5bQtFmkby985KWF3kHaSf/Qk2GExG1IeK46C0jZ5y9
 nPvrj5CI0VeAFOldXp7DOpHXZjiXa3dUX3pXSdI06gdyLNAkABDxmX5TZWdXEJkj72hB
 qpIpkIRa6d0oMUcuDGEBTxvGwFsBgD9LWGKyORdounOjT4/FFQhUg59miD4aLLkHOt1d
 ApK6uWH9OLIjD4Cb5W47LCc6//LnK9A1zODp4mDZrR2GqbMkizCaS2c0ExY8ty+yaiaz eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyq1k7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:20:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMJJA3186414;
        Mon, 20 Jan 2020 22:20:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xmc5mantr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:20:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KMJxru010201;
        Mon, 20 Jan 2020 22:19:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:19:59 -0800
Date:   Mon, 20 Jan 2020 14:19:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] xfs: make xfs_buf_alloc return an error code
Message-ID: <20200120221958.GY8247@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924221800.3029431.576491686056157423.stgit@magnolia>
 <20200119214903.GD9407@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119214903.GD9407@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=934
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=982 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200187
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 20, 2020 at 08:49:03AM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2020 at 10:23:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert _xfs_buf_alloc() to return numeric error codes like most
> > everywhere else in xfs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> ....
> > @@ -715,8 +718,8 @@ xfs_buf_get_map(
> >  		return NULL;
> >  	}
> >  
> > -	new_bp = _xfs_buf_alloc(target, map, nmaps, flags);
> > -	if (unlikely(!new_bp))
> > +	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
> > +	if (unlikely(error))
> >  		return NULL;
> 
> You can kill the unlikely() while you are at it. They are largely
> unnecessary as the compiler already considers branches with returns
> in them as unlikely and we don't need "unlikely" as code
> documentation for error conditions like this...
> 
> >  	error = xfs_buf_allocate_memory(new_bp, flags);
> > @@ -917,8 +920,8 @@ xfs_buf_get_uncached(
> >  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
> >  
> >  	/* flags might contain irrelevant bits, pass only what we care about */
> > -	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
> > -	if (unlikely(bp == NULL))
> > +	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
> > +	if (unlikely(error))
> >  		goto fail;
> 
> here too.

Will fix.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
