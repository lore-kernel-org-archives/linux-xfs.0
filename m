Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18106C33C9E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 22:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE80C21D56
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 22:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RWfsXr+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgAQW7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 17:59:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbgAQW7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 17:59:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HMhuAS174554;
        Fri, 17 Jan 2020 22:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=MOuuH6bt+kWzm17Pt+DueZLRdw+xIeUVQbP2UVQT8e8=;
 b=RWfsXr+cKjzDojDZp6eR4teR6bFeqjLIrqDRLR9kZOPQH4J9WX78bUj8ksjYCifDMlMr
 EOytELv7or/1/dEICjdTtG/KOreYYAQCwXIeABkFR1F3arlCG8m148XDBzlzQnOPuNkB
 jv63Q7/FUVmt9bYxOga6W/qDj4Fr25F8NVMmKnuU0xxhas4HHYhQycuGVJdR/Y9RcT9G
 kHwyFTB8L8LKoqMAP9RZgOGYIyJki3n2eITK5IAj8/l2CZKV4vo0STaMjusJK0/YlUDM
 SZONI3hGqNlMrQohs4kLEMnDCUfvYfbXRFkpqJscR867ZTubFx1wfmg8pmq8LAXmEkJ2 NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xf7403c0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 22:58:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HMi2EQ180048;
        Fri, 17 Jan 2020 22:58:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xjxp5y3xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 22:58:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00HMwm79016401;
        Fri, 17 Jan 2020 22:58:48 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jan 2020 14:58:48 -0800
Date:   Fri, 17 Jan 2020 14:58:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200117225847.GU8247@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924224846.3029431.3421957295562306193.stgit@magnolia>
 <20200117065020.GA26438@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117065020.GA26438@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=958
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:50:20PM -0800, Christoph Hellwig wrote:
> > @@ -842,13 +845,15 @@ xfs_buf_read_map(
> >  		 * drop the buffer
> >  		 */
> >  		xfs_buf_relse(bp);
> > -		return NULL;
> > +		*bpp = NULL;
> 
> We already set *bpp to NULL at the very beginning, so this line is
> redundant.

Will fix.

> > @@ -860,19 +865,18 @@ xfs_buf_read(
> >  	struct xfs_buf		**bpp,
> >  	const struct xfs_buf_ops *ops)
> >  {
> >  	int			error;
> >  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> >  
> > -	*bpp = NULL;
> > -	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
> > -	if (!bp)
> > -		return -ENOMEM;
> > -	error = bp->b_error;
> > +	error = xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
> > +	if (error)
> > +		return error;
> > +	error = (*bpp)->b_error;
> >  	if (error) {
> > +		xfs_buf_ioerror_alert(*bpp, __func__);
> > +		xfs_buf_stale(*bpp);
> > +		xfs_buf_relse(*bpp);
> > +		*bpp = NULL;
> >  
> >  		/* bad CRC means corrupted metadata */
> >  		if (error == -EFSBADCRC)
> 
> I still think we have a problem here.  We should not have to check
> ->b_error, and the xfs_buf_ioerror_alert should be either in the callers
> or in xfs_buf_read_map, as xfs_buf_read is just supposed to be a trivial
> wrapper for the single map case, not add functionality of its own.

Yeah.  I've redone the patchset to keep xfs_buf_read() as a static
inline function, then refactored the ioerror/stale/relse bits as a
separate patch on the end.

--D
