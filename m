Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B77C33C9E
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 23:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09EF62467A
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 23:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O+2xtEs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgANXCQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 18:02:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbgANXCQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 18:02:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00EMwZCS181893;
        Tue, 14 Jan 2020 23:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xb4av4evUZEt3aXBtMFCYzvK8oTtiBFJ16001F/fCCs=;
 b=O+2xtEs3HZrYGNlEodfg0+Q9Lhvlto5i13xqGOPf6ZLzV02XlNieHELvawL02K/JZjCj
 fJPzFWMYabQ8G3hwfnSoM7Rs3xzBenSoXeGHcTyGa9Jk41nMTZurIdPwjgZRHWOsENEb
 3G04PlgqoSp5tpHwRKS8BdUm1kyeMQmqER1I14+g8vBq4heHP8Dl6fRd4tq4phd/SGjE
 /O8GfiMP1eCZy9b59PUkp+GJlUIvIQlUzbaVlk7gMYApXhkQscWT5Zs2MZdaLHR36iCy
 h7kugKxW7CMOtdgOT4lWiouLyjpM4SJbKGDn0wiinzlHmZNc23c5jb0EdGUTfTLFcRN2 jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73ts1nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 23:02:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00EMxL64099993;
        Tue, 14 Jan 2020 23:02:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xh314f9ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 23:02:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00EN23vE030627;
        Tue, 14 Jan 2020 23:02:03 GMT
Received: from localhost (/10.159.156.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jan 2020 15:02:02 -0800
Date:   Tue, 14 Jan 2020 15:02:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix memory corruption during remote attr value
 buffer invalidation
Message-ID: <20200114230201.GW8247@magnolia>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
 <157898350371.1566005.2641685060877851666.stgit@magnolia>
 <20200114084011.GB10888@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114084011.GB10888@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 12:40:11AM -0800, Christoph Hellwig wrote:
> > Fortunately for us, remote attribute values are written to disk with
> > xfs_bwrite(), which is to say that they are not logged.  Fix the problem
> > by removing all places where we could end up creating a buffer log item
> > for a remote attribute value and leave a note explaining why.
> 
> This is stil missing a comment that you are using a suitable helper
> for marking the buffer stale, and why rmeoving the HOLEBLOCK check
> is safe (which I now tink it is based on looking at the caller).

Oops, I forgot to update the changelog.


> > -			error = xfs_trans_read_buf(mp, args->trans,
> > +			error = xfs_trans_read_buf(mp, NULL,
> >  						   mp->m_ddev_targp,
> >  						   dblkno, dblkcnt, 0, &bp,
> >  						   &xfs_attr3_rmt_buf_ops);
> > @@ -411,7 +428,7 @@ xfs_attr_rmtval_get(
> >  			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
> >  							&offset, &valuelen,
> >  							&dst);
> > -			xfs_trans_brelse(args->trans, bp);
> > +			xfs_buf_relse(bp);
> 
> FYI, I don't think mixing xfs_trans_read_buf and xfs_buf_relse is a good
> pattern.

Yeah, you're right.  I didn't want to go opencoding the !bp or
bp->b_error > 0 cases that happen in xfs_trans_buf_read to make this bug
fix an even bigger pile of patches, but maybe it's just time to clean up
xfs_buf_read() to return error values like most everywhere else.

> > @@ -48,8 +45,8 @@ xfs_attr3_leaf_freextent(
> >  	 * Roll through the "value", invalidating the attribute value's
> >  	 * blocks.
> >  	 */
> > -	tblkno = blkno;
> > -	tblkcnt = blkcnt;
> > +	tblkno = lp->valueblk;
> > +	tblkcnt = lp->valuelen;
> 
> Nit: these could be easily initialized on the declaration lines.  Or
> even better if you keep the old calling conventions of passing the
> blockno and count by value, in which case we don't need the extra local
> variables at all.
> 
> > @@ -174,9 +155,7 @@ xfs_attr3_leaf_inactive(
> >  	 */
> >  	error = 0;
> >  	for (lp = list, i = 0; i < count; i++, lp++) {
> > -		tmp = xfs_attr3_leaf_freextent(trans, dp,
> > -				lp->valueblk, lp->valuelen);
> > -
> > +		tmp = xfs_attr3_rmt_inactive(dp, lp);
> 
> So given that we don't touch the transaction I don't think we even
> need the memory allocation to defer the marking stale of the buffer
> until after the xfs_trans_brelse.  But that could be a separate
> patch, especially if the block/count calling conventions are kept as-is.

These last two I'll clean up in a followup patch that gets rid of the
pointless local variables in the first function and the pointless memory
allocation in the second function.

--D
