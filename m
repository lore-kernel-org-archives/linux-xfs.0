Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1567C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6207A2072C
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:59:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gluxDGFQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgAXE7x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:59:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbgAXE7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 23:59:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4xAWv007692;
        Fri, 24 Jan 2020 04:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=BjrfkmGKm+xWUlPYffDMumKhF5dpc3SszgqKNJX9jtk=;
 b=gluxDGFQeyBbVvfufqBarUgUzy/3xW77TIllJlgCqZnK5TzmAda6hTbdO7D6Klvp5IWG
 EHE2vjHS4wkEVtIDtiMuUSGTEa+nQLIYRmsCEchGSDne5FIHLMh4vQ/uLiXu/d2pYEb6
 oRPWyFsB60sY5pgqX+Vg3lylzktzKaasr64GIbaRyNuYvPSuQKXa3DYXH4VcVSzURsZ2
 uasCmNQmDolTk38YZMUjof9obp6sFGwkxhv5tjjyFlJ1R19CZE7OM88XO9tBmCh0SO0u
 j3vU8pKc/fWzD6jVQ7r2FglZ7y5MUN8zs+9ZSWABaEWoAaHknbrNZ8rieeqbgO+xBjdJ lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyqpv5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:59:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4w322068187;
        Fri, 24 Jan 2020 04:59:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xqmue377b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:59:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O4xhpC010190;
        Fri, 24 Jan 2020 04:59:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 20:59:43 -0800
Date:   Thu, 23 Jan 2020 20:59:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 05/12] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200124045942.GE8247@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976534245.2388944.13378396804109422541.stgit@magnolia>
 <20200123222441.GB15904@infradead.org>
 <20200124002321.GY8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124002321.GY8247@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 04:23:21PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 23, 2020 at 02:24:41PM -0800, Christoph Hellwig wrote:
> > On Wed, Jan 22, 2020 at 11:42:22PM -0800, Darrick J. Wong wrote:
> > > index fc93fd88ec89..df25024275a1 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -2956,14 +2956,13 @@ xfs_read_agf(
> > >  	trace_xfs_read_agf(mp, agno);
> > >  
> > >  	ASSERT(agno != NULLAGNUMBER);
> > > -	error = xfs_trans_read_buf(
> > > -			mp, tp, mp->m_ddev_targp,
> > > +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> > >  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> > >  			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> > > +	if (error == -EAGAIN)
> > > +		return 0;
> > >  	if (error)
> > >  		return error;
> > > -	if (!*bpp)
> > > -		return 0;
> > 
> > Shouldn't the change in calling conventions for xfs_trans_read_buf be
> > in another patch dealing just with xfs_trans_read_buf?
> 
> Actually ... it really needs to be in the next patch because it's the
> xfs_buf_get_map transition that makes it so that xfs_trans_read_buf can
> return EAGAIN.

Now that I've reshuffled the whole patchset I realize that it more or
less has to be this way because this particular change insulates the
callers of xfs_read_agf() from needing to learn about EAGAIN right now.

I /could/ change all of those callers in this patch instead of handling
it separately in "xfs: make xfs_*read_agf return EAGAIN to
ALLOC_FLAG_TRYLOCK callers", but now the patch would be changing the
behavior of three separate API calls, and I'm trying to avoid
monsters like that.

(Anyway, onward to v5...)

> > > +		/* bad CRC means corrupted metadata */
> > > +		if (error == -EFSBADCRC)
> > > +			error = -EFSCORRUPTED;
> > > +		return error;
> > 
> > Note that this coukd and should now also go away in the xfs_buf_read()
> > callers, not just the direct xfs_buf_read_map ones.
> 
> Huh?  This patch /does/ remove the EFSBADCRC->EFSCORRUPTED code in the
> xfs_buf_read callers... <confused>

The reshuffle makes adding this bit unnecessary since I converted
xfs_buf_read_map earlier in the sequence.

> > > +	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
> > > +	switch (error) {
> > > +	case 0:
> > > +		break;
> > > +	case -EFSCORRUPTED:
> > > +	case -EIO:
> > >  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
> > > +			xfs_force_shutdown(tp->t_mountp,
> > > +					SHUTDOWN_META_IO_ERROR);
> > > +		/* fall through */
> > > +	default:
> > 
> > Isn't it really EAGAIN the only special case here?  I.e. something
> > more like:
> > 
> > 	if (error && error != -EAGAIN) {
> >   		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
> > 			xfs_force_shutdown(tp->t_mountp,
> > 					SHUTDOWN_META_IO_ERROR);
> > 	}
> > 
> > 	return error;
> 
> Yes, I think so.
> 
> --D
