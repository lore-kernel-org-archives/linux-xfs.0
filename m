Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FB2C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 18:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19FE020842
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 18:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rNDjtjPJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfKJSVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 13:21:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44238 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfKJSVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 13:21:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAAIFC5C057755;
        Sun, 10 Nov 2019 18:20:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SVMQD8+h7EqIQnu4svpfUOGjUxl+82/PAPrNH8ZVkf0=;
 b=rNDjtjPJD7/+upPFF6M5k8D72fk9EzPEGfaei9+Ahi0Olph6KMGFWjPyuJUPASCzSd9m
 WwQJKpcuKbL5NhvtXNnq557nC8AegOU+PRInNy4SbLQpnkbuhl2OBPKTVORxNIjaBJeF
 Ebl/iPKe0EyTDQ8QIqIDqIWg1d99qQMrVOuGcFbBxWHHIW1wklxU9PBpY0g70Tvy3gi9
 l+NqZh20jATuxn/So7/8bGyu1nNB5zlN3a+DJ9UhD1tMVuyR5jSlTJkLJ51YuJZT2dG0
 MIIhZQFcC3+yndjslS+5fmCur9X7mf+pqJA7Y4uYjeAMaWqw2qYRyK53h3fkAK70eCsp Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndpumt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 18:20:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAAIDqBZ140411;
        Sun, 10 Nov 2019 18:20:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w67m0j3d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 18:20:57 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAAIKnuE003796;
        Sun, 10 Nov 2019 18:20:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 18:20:49 +0000
Date:   Sun, 10 Nov 2019 10:20:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191110182049.GQ6219@magnolia>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
 <157319672136.834699.13051359836285578031.stgit@magnolia>
 <20191109223238.GH4614@dread.disaster.area>
 <20191110001803.GP6219@magnolia>
 <20191110024919.GJ4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110024919.GJ4614@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911100182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911100182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 10, 2019 at 01:49:19PM +1100, Dave Chinner wrote:
> On Sat, Nov 09, 2019 at 04:18:03PM -0800, Darrick J. Wong wrote:
> > On Sun, Nov 10, 2019 at 09:32:38AM +1100, Dave Chinner wrote:
> > > On Thu, Nov 07, 2019 at 11:05:21PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > -		if (unlikely(
> > > > -		       be32_to_cpu(sib_info->back) != last_blkno ||
> > > > -		       sib_info->magic != dead_info->magic)) {
> > > > -			XFS_ERROR_REPORT("xfs_da_swap_lastblock(3)",
> > > > -					 XFS_ERRLEVEL_LOW, mp);
> > > > +		if (XFS_IS_CORRUPT(mp,
> > > > +		    be32_to_cpu(sib_info->back) != last_blkno ||
> > > > +		    sib_info->magic != dead_info->magic)) {
> > 
> > They're both ugly, IMHO.  One has horrible indentation that's too close
> > to the code in the if statement body, the other is hard to read as an if
> > statement.
> 
> I was more commenting on the new code. The old code is horrible,
> yes, but I don't think the new code is much better. :(
> 
> > > >  			error = -EFSCORRUPTED;
> > > >  			goto done;
> > > >  		}
> > > 
> > > This is kind of what I mean - is it two or three  logic statments
> > > here? No, it's actually one, but it has two nested checks...
> > > 
> > > There's a few other list this that are somewhat non-obvious as to
> > > the logic...
> > 
> > I'd thought about giving it the shortest name possible, not bothering to
> > log the fsname that goes with the error report, and making the if part
> > of the macro:
> > 
> > #define IFBAD(cond) if ((unlikely(cond) ? assert(...), true : false))
> > 
> > IFBAD(be32_to_cpu(sib_info->back) != last_blkno ||
> >       sib_info->magic != dead_info->magic)) {
> > 	xfs_whatever();
> > 	return -EFSCORRUPTED;
> > }
> > 
> > Is that better?
> 
> Look at what quoting did to it - it'll look the same as above in
> patches, unfortunately, so I don't think "short as possible" works
> any better.
> 
> Perhaps s/IFBAD/XFS_CORRUPT_IF/ ?
> 
> 		XFS_CORRUPT_IF(be32_to_cpu(sib_info->back) != last_blkno ||
> 				sib_info->magic != dead_info->magic)) {
> 			xfs_error(mp, "user readable error message");
> 			return -EFSCORRUPTED;
> 		}
> 
> That solves the patch/quote indent problem, documents the code well,
> and only sacrifices a single tab for the condition statements...

...but that's one character short of two full tabs, and I dislike typing
<tab><space><space><space><space><space><space><space> and having the
alignment be off by a single column.

> /me gets back on his bike and leaves the shed coated in wet paint.

/me takes out his paint sprayer and drowns everything in paint.

XCORRUPT_WHEN(
IF_XFS_CORRUPT(
XFS_CORRUPT_LOG(
LOG_XFS_CORRUPT(
IF_XFSCORRUPTED(
XFS_CORRUPT_IFF(
if_meta_corrupt(
if_xfs_meta_bad(moo,
		whatever) {
	grumble();
}

Ok, I'll change the whole thing to if_xfs_meta_bad(test) and hopes this
is the end of bikeshedding because changing this series is a pita.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
