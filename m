Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16754C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 16:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B1A206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 16:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ivr2mrU+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390939AbgFYQvq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 12:51:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53944 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390917AbgFYQvq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 12:51:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PGmHgb174193;
        Thu, 25 Jun 2020 16:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nb7wg0i4qGT1aAh5h5okUNwj3RXpMoJGst4XCsmZuGU=;
 b=ivr2mrU++4SXjxO3ucHSJgK0IRCNn4A3QcTkx+ujSsOn1BGVbPr6X1rrPb/ihDu3r7Bm
 q8hZf+46+PAu+CAuOvNG7X5EwRSHHGlKYHJWBTT2ONmIwh081bLlrASOj3qgN0bdGncz
 fsuYUN58IVX8wtUnkzXBJ69yvWLQpW0VOJoWjxAVsidaE771HWNXezfeKPUiyAYHoFVy
 WIkIa5AZBA+D3WljtXYLanxLfcXrgGSGum0ohZxdpfKWo4tCUyzwBIz3bzMR814cxdTe
 bjK9Pdt/DWx6jKo1dp5AGHW7GfXUL4WNkj3VvIKT1s4CpmnlCflgsFZqMr1aE6/1YogR Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31uusu1nhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 16:51:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PGmHOj119839;
        Thu, 25 Jun 2020 16:49:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31uur9svj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 16:49:40 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PGnXFU022961;
        Thu, 25 Jun 2020 16:49:33 GMT
Received: from localhost (/10.159.246.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 16:49:33 +0000
Date:   Thu, 25 Jun 2020 09:49:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 6/9] xfs: reflink can skip remap existing mappings
Message-ID: <20200625164932.GM7606@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304789856.874036.15102270304208951038.stgit@magnolia>
 <20200625122818.GH2863@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625122818.GH2863@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250105
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 08:28:18AM -0400, Brian Foster wrote:
> On Wed, Jun 24, 2020 at 06:18:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If the source and destination map are identical, we can skip the remap
> > step to save some time.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_reflink.c |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 72de7179399d..f1156f121b7d 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1031,6 +1031,23 @@ xfs_reflink_remap_extent(
> >  
> >  	trace_xfs_reflink_remap_extent_dest(ip, &smap);
> >  
> > +	/*
> > +	 * Two extents mapped to the same physical block must not have
> > +	 * different states; that's filesystem corruption.  Move on to the next
> > +	 * extent if they're both holes or both the same physical extent.
> > +	 */
> > +	if (dmap->br_startblock == smap.br_startblock) {
> > +		ASSERT(dmap->br_startblock == smap.br_startblock);
> 
> That assert duplicates the logic in the if statement. Was this intended
> to be the length check I asked for? If so it looks like that was added
> previously so perhaps this can just drop off. With that fixed up:

Yep, I got hopelessly distracted while trying to figure out why Dave's
inode flush series keep crashing here. Will fix. :/

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +		if (dmap->br_state != smap.br_state)
> > +			error = -EFSCORRUPTED;
> > +		goto out_cancel;
> > +	}
> > +
> > +	/* If both extents are unwritten, leave them alone. */
> > +	if (dmap->br_state == XFS_EXT_UNWRITTEN &&
> > +	    smap.br_state == XFS_EXT_UNWRITTEN)
> > +		goto out_cancel;
> > +
> >  	/* No reflinking if the AG of the dest mapping is low on space. */
> >  	if (dmap_written) {
> >  		error = xfs_reflink_ag_has_free_space(mp,
> > 
> 
