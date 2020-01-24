Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92177C35242
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 652162071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fd38l/RZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgAXErj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:47:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbgAXErj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 23:47:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4cvCA006289;
        Fri, 24 Jan 2020 04:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=n/N0G/ckzr19ojekiLDT3DGoZPzeNToFq2pegdIlt54=;
 b=Fd38l/RZNrTBwxax0BiIp0UcSe2pqgHGsfeLx0Dfteskp6aczsxoR0Oxz7oh1P131SAn
 vx4+LIjcHjwNCPEF+D1D/PiHIuT/wixUo4lbQhTWM6yfZAU71Ite9zk3F11VFyYtuWCh
 XehL7ZFwObNVC8gwiy72F5xbMG0N0tWV6u3q+o+JYHvQ/CdF0CHEgwDGIoffQFG1a9t3
 DvwdeMyrt9CbCk7zfzT3W2dd5a245OGw+bmNf/P6hplU7lxFuU8hWf/P3+uDTQKVcRrW
 E5REChmR4QWSSJtzcgo9U/2CDJRM9X2rv1LJDJD/fORx8AWAIRaoPqL3w2vyE2fqoApd 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrpnfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:47:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4dZwZ150970;
        Fri, 24 Jan 2020 04:47:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xqmwceda6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:47:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O4lULq028174;
        Fri, 24 Jan 2020 04:47:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 20:47:29 -0800
Date:   Thu, 23 Jan 2020 20:47:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 10/12] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
Message-ID: <20200124044728.GD8247@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976537480.2388944.15713995061702153624.stgit@magnolia>
 <20200124020054.GK7090@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124020054.GK7090@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240036
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 24, 2020 at 01:00:54PM +1100, Dave Chinner wrote:
> On Wed, Jan 22, 2020 at 11:42:54PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
> > caller passed TRYLOCK and we weren't able to get the lock; and change
> > the callers to recognize this.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c |   34 +++++++++++++++-------------------
> >  fs/xfs/libxfs/xfs_bmap.c  |   11 ++++++-----
> >  fs/xfs/xfs_filestream.c   |   11 ++++++-----
> >  3 files changed, 27 insertions(+), 29 deletions(-)
> .....
> > @@ -2992,10 +2987,11 @@ xfs_alloc_read_agf(
> >  	error = xfs_read_agf(mp, tp, agno,
> >  			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
> >  			bpp);
> > -	if (error)
> > +	if (error) {
> > +		/* We don't support trylock when freeing. */
> > +		ASSERT(error != -EAGAIN || !(flags & XFS_ALLOC_FLAG_FREEING));
> >  		return error;
> 
> Shouldn't we check this with asserts before we call xfs_read_agf()?
> i.e.
> 
> 	/* We don't support trylock when freeing. */
> 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
> 			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
> 	....

Yeah.

> > -	if (!*bpp)
> > -		return 0;
> > +	}
> >  	ASSERT(!(*bpp)->b_error);
> >  
> >  	agf = XFS_BUF_TO_AGF(*bpp);
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index cfcef076c72f..9a6d7a84689a 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3311,11 +3311,12 @@ xfs_bmap_longest_free_extent(
> >  	pag = xfs_perag_get(mp, ag);
> >  	if (!pag->pagf_init) {
> >  		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
> > -		if (error)
> > -			goto out;
> > -
> > -		if (!pag->pagf_init) {
> > -			*notinit = 1;
> > +		if (error) {
> > +			/* Couldn't lock the AGF, so skip this AG. */
> > +			if (error == -EAGAIN) {
> > +				*notinit = 1;
> > +				error = 0;
> > +			}
> >  			goto out;
> >  		}
> >  	}
> > diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> > index 5f12b5d8527a..3ccdab463359 100644
> > --- a/fs/xfs/xfs_filestream.c
> > +++ b/fs/xfs/xfs_filestream.c
> > @@ -159,16 +159,17 @@ xfs_filestream_pick_ag(
> >  
> >  		if (!pag->pagf_init) {
> >  			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
> > -			if (err && !trylock) {
> > +			if (err == -EAGAIN) {
> > +				/* Couldn't lock the AGF, skip this AG. */
> > +				xfs_perag_put(pag);
> > +				continue;
> > +			}
> > +			if (err) {
> >  				xfs_perag_put(pag);
> >  				return err;
> >  			}
> 
> Might neater to do:
> 
> 		if (!pag->pagf_init) {
> 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
> 			if (err) {
> 				xfs_perag_put(pag);
> 				if (err != -EAGAIN)
> 					return err;
> 				/* Couldn't lock the AGF, skip this AG. */
> 				continue;
> 			}
> 		}
> 
> Otherwise it all looks ok.

Cool.  Will fix.

--D

> 
> -Dave
> -- 
> Dave Chinner
> david@fromorbit.com
