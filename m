Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC706C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE524208E4
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="utF//xTA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgEFQrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 12:47:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59632 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgEFQrW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 12:47:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046Gk86Z190020;
        Wed, 6 May 2020 16:47:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KQkGz0YNoWYCEElu5XA46g6NZm3G8N1bdu2V1ddrsbQ=;
 b=utF//xTAbvsGfc8zz7DemFOc71hrgbMT5GhNXpfcEi2fTsBpHnx8O+uwvSQIFmSbdypU
 a+F6H40NUveW7l8Y1+3UmJKiOQZvAbjGqcEB1D5J1As/Puj9HtPGhXvSar0hx//v7oiC
 ew+2FuLotOQ0DPRET3pek36e0DRttMwnag1ydnpwoqmBwEyqDBKp4eWF+b7gmPSHCAb4
 jyY6q61hJGcRyuAPZq6x4dvxlhrRGQkKMKExRpTaaRgtDpR0NbN9hkSHIoGkSqmMJ59w
 sqjSoOkqHx7ar2NmgUyczo32Nh9lS540jxFmlAPk1YX9alsh+bys12AohjxwYkf8lfLs 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gnbc65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:47:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GbSPY044046;
        Wed, 6 May 2020 16:45:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnk10xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:45:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046GjHSw021691;
        Wed, 6 May 2020 16:45:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 09:45:17 -0700
Date:   Wed, 6 May 2020 09:45:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: clean up the metadata validation in
 xfs_swap_extent_rmap
Message-ID: <20200506164515.GU5703@magnolia>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
 <158864102271.182577.2059355876586003107.stgit@magnolia>
 <20200506145633.GB7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506145633.GB7864@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 07:56:33AM -0700, Christoph Hellwig wrote:
> On Mon, May 04, 2020 at 06:10:22PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Bail out if there's something not right with either file's fork
> > mappings.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c |   31 +++++++++++++++++++++++--------
> >  1 file changed, 23 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index cc23a3e23e2d..2774939e176d 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1342,8 +1342,16 @@ xfs_swap_extent_rmap(
> >  				&nimaps, 0);
> >  		if (error)
> >  			goto out;
> > -		ASSERT(nimaps == 1);
> > -		ASSERT(tirec.br_startblock != DELAYSTARTBLOCK);
> > +		if (nimaps != 1 || tirec.br_startblock == DELAYSTARTBLOCK) {
> > +			/*
> > +			 * We should never get no mapping or a delalloc extent
> > +			 * since the donor file should have been flushed by the
> > +			 * caller.
> > +			 */
> > +			ASSERT(0);
> > +			error = -EINVAL;
> > +			goto out;
> > +		}
> 
> I'm not even sure the !nimaps case still exists.  Usually this will
> return a hole extent, which we don't seem to handle here?

xfs_bmap_unmap_extent and xfs_bmap_map_extent are NOPs if you pass
them a hole.

But yeah, the !nimaps case doesn't seem to exist anymore.

> In general I think this code would be improved quite a bit by using
> xfs_iext_lookup_extent instead of xfs_bmapi_read.
> 
> Same for the second hunk.

I'd rather not make major changes to this code because my long range
plan is to replace all this with a much cleaner implementation in the
atomic file update series[1].  This patchset bandages the wtfs that I
found while writing that series, projecting that review of atomic file
updates is going to take a while...

--D

[1] https://lwn.net/ml/linux-fsdevel/158812825316.168506.932540609191384366.stgit@magnolia/
