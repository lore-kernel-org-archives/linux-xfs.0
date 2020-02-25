Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C22C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37B62084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:59:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKA5jgbF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgBYS7L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:59:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbgBYS7L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:59:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIrXIW186198;
        Tue, 25 Feb 2020 18:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zw6N80af2qWrUoSCf/8fzGdnGlbQRdE5hZYZRJkWFkI=;
 b=MKA5jgbF4SUgvvwErP2rj84GihD8xYjk5CltenfNQVazKtdcHmOHw855wAEunXvuK4de
 1mat7cB9bNFqTU8Qa523FePHGX1PviSNGHV2NCkkMbJXNI+rUvxnMWHFIf9YDCvFJQ3V
 V0434Z0f/2Ku/1gOMlH1R904hmmUX51jZXKWMejfbydEbwVATvqqpPzCwH1H7NMTAHrk
 lR59V7OxFHGOg0QLg+GF6MlssYovRd5Z85r31e3tKFqTgeZfzh4J27E7dSUvrWIvyWd0
 axWkbF3+ISmIzr4JH8pimGdf9rVLRTZMiQoxlmPAvYcWkbvnVicU/GfhiCuxk1tJrF8p xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yd0njkewn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:59:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIwEO4092485;
        Tue, 25 Feb 2020 18:59:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yd0vv87sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:59:05 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PIx47T029558;
        Tue, 25 Feb 2020 18:59:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:59:04 -0800
Date:   Tue, 25 Feb 2020 10:59:03 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] libxfs: make libxfs_buf_read_map return an error
 code
Message-ID: <20200225185903.GO6740@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
 <158258968040.453666.4902763032639084601.stgit@magnolia>
 <20200225175524.GA4129@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225175524.GA4129@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:55:24AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 04:14:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make libxfs_buf_read_map() and libxfs_readbuf() return an error code
> > instead of making callers guess what happened based on whether or not
> > they got a buffer back.
> > 
> > Add a new SALVAGE flag so that certain utilities (xfs_db and xfs_repair)
> > can attempt salvage operations even if the verifiers failed, which was
> > the behavior before this change.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/io.c            |    4 +--
> >  libxfs/libxfs_io.h |   25 ++++++++++++------
> >  libxfs/rdwr.c      |   71 +++++++++++++++++++++++++++++++++++++++++-----------
> >  libxfs/trans.c     |   24 ++++--------------
> >  repair/da_util.c   |    3 +-
> >  5 files changed, 82 insertions(+), 45 deletions(-)
> > 
> > 
> > diff --git a/db/io.c b/db/io.c
> > index b81e9969..5c9d72bb 100644
> > --- a/db/io.c
> > +++ b/db/io.c
> > @@ -542,8 +542,8 @@ set_cur(
> >  		if (!iocur_top->bbmap)
> >  			return;
> >  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
> > -		bp = libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
> > -					bbmap->nmaps, 0, ops);
> > +		libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b, bbmap->nmaps,
> > +				LIBXFS_READBUF_SALVAGE, &bp, ops);
> >  	} else {
> >  		bp = libxfs_buf_read(mp->m_ddev_targp, blknum, len, 0, ops);
> >  		iocur_top->bbmap = NULL;
> 
> I think instead of ignorining the error and checkig b_error further down
> that should be moved to work based on the return value.

Yeah, I'll add a cleanup patch for that on the end, after we convert
libxfs_buf_read.  Thanks for reviewing!

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
