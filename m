Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B27C3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 23:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15DE322CED
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 23:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="amaSCeaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfICXhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 19:37:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60650 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfICXhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 19:37:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NYUgf190762;
        Tue, 3 Sep 2019 23:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qFs5Sq+vJkwEd3ZF0fL6P9ZO9MlY41piSI72es2vJpQ=;
 b=amaSCeaKsK9GEYyw9rr/cTBAQG89ivj6QBNSRCEwib3sEgrEhxXYCGYDbgiT4vRnkPAr
 2faCRZhMyDJq8HF9T1Eo9bDncuDqvsayOTh3/c9pGThKgkDJGKevyFqBpxq4dIgl9KFs
 /buj/ISAIZfQnwCclisx5aIClBAiw7qriUM46SI39/Kmo0i000qoqDCnbDgizuh6Igzq
 ef0hITPAkkOKWD3PKwl54xvrlNCuBdCNs51c3uOajudebR2r0KLR56OZHP7be2t5h/FE
 MiuHMZ4su7XTLutA8sGPUiOea2YTZc0umNVpvfP2fE2UG1UxB/1stySFK3C/qbg7Kz/h rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ut1x1g0np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:37:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NXTUx033260;
        Tue, 3 Sep 2019 23:37:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2us5phe8wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:37:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83Nb9Vu025019;
        Tue, 3 Sep 2019 23:37:09 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 16:37:08 -0700
Date:   Tue, 3 Sep 2019 16:37:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] libfrog: create xfd_open function
Message-ID: <20190903233707.GI568270@magnolia>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713887587.386621.8656028056753211579.stgit@magnolia>
 <20190903230121.GZ1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903230121.GZ1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030237
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030237
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 09:01:21AM +1000, Dave Chinner wrote:
> On Thu, Aug 29, 2019 at 09:21:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a helper to open a file and initialize the xfd structure.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> 
> >  
> > +/* Open a file on an XFS filesystem.  Returns zero or a positive error code. */
> > +int
> > +xfd_open(
> > +	struct xfs_fd		*xfd,
> > +	const char		*pathname,
> > +	int			flags)
> > +{
> > +	int			ret;
> > +
> > +	xfd->fd = open(pathname, O_RDONLY);
> 
> open(pathname, flags)

Will fix, good catch!

> And, to handle all future uses, shouldn't it also pass a mode?
> Though I think that can be done as a separate patch when we need
> O_RDWR for open....

<nod> Let's fix that when someone needs it, seeing as libfrog is an
internal static library anyway. :)

--D

> Otherwise it looks ok.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
