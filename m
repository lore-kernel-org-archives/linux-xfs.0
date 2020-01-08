Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED5DC282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D45412067D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:06:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R1oJzvMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgAHRGn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 12:06:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36774 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729516AbgAHRGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 12:06:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008H3fhb068605;
        Wed, 8 Jan 2020 17:06:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=jgB9ejWbSoubGLtlWlE/W5saZAXAPMSB2C30lQRny9o=;
 b=R1oJzvMK9IyGi3JRL7pgF0D1/L7UFrbMJlF60qZWN7p5OIwcMR/m+EbvBWBXHRF2oyvp
 B2lfR5IhoRMWGUF58n+tgTIxnKOv8XEJWi+rIguwFppGXtfksRg7s9FVdNvdmdyd7Ipa
 RB2ZcZsrZLqf7OtSmbynKo9WbSmYmlGHuJqqLnU4v8aoz2vTtN6JkIESzuDNezE0mc2Q
 YoZSnZaiY7qzudS7F7t5jDIM/XgdMn/TbfNmwzNGfwhl4dkm27CH+o9NlVVpcdsorWCa
 iQpZEqGXZDitN3D008S5ACrfd9kPtK4HRp0ttXTfdlNEgT+vh1fmyG1vmk/WmjpNbsXJ Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xakbqw616-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 17:06:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008H3VRc104522;
        Wed, 8 Jan 2020 17:06:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xcqbprmnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 17:06:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 008H6Zvh016312;
        Wed, 8 Jan 2020 17:06:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 09:06:35 -0800
Date:   Wed, 8 Jan 2020 09:06:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: refactor remote attr value buffer invalidation
Message-ID: <20200108170633.GH5552@magnolia>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845709180.84011.3139453026212575913.stgit@magnolia>
 <20200108084922.GA12889@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108084922.GA12889@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 08, 2020 at 12:49:22AM -0800, Christoph Hellwig wrote:
> The refactor in the subject is very misleading.  You are not refactoring
> code, but fixing a bug.

Ok, I'll make that clearer.

> > -			error = xfs_trans_read_buf(mp, args->trans,
> > +			error = xfs_trans_read_buf(mp, NULL,
> >  						   mp->m_ddev_targp,
> >  						   dblkno, dblkcnt, 0, &bp,
> >  						   &xfs_attr3_rmt_buf_ops);
> 
> xfs_trans_read_buf with an always NULL tp is a strange interface.  Any
> reason not to use xfs_buf_read directly?

If the remote value checksum fails validation, xfs_trans_read_buf will
collapse EFSBADCRC to EFSCORRUPTED.  It'll also take care of releasing
the buffer.

I agree that xfs_buf_read is a more logical choice here, but it doesn't
do those things and I think we'd be better off changing xfs_buf_read
(and _buf_get) to return EFSBADCRC/EFSCORRUPTED/ENOMEM.

> > +/* Mark stale any buffers for the remote value. */
> > +void
> > +xfs_attr_rmtval_stale(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_bmbt_irec	*map)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_buf		*bp;
> > +	xfs_daddr_t		dblkno;
> > +	int			dblkcnt;
> > +
> > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > +	if (map->br_startblock == HOLESTARTBLOCK)
> > +		return;
> > +
> > +	dblkno = XFS_FSB_TO_DADDR(mp, map->br_startblock),
> > +	dblkcnt = XFS_FSB_TO_BB(mp, map->br_blockcount);
> 
> Now this helper seems like a real refactoring in that it splits out a
> common helper.  It matches one o the call sites exactly, while the
> other has a major change, so I think it shouldn't just be one extra
> patch, but instead of two extra patche to clearly document the changes.

Ok.

> > -		/*
> > -		 * If it's a hole, these are already unmapped
> > -		 * so there's nothing to invalidate.
> > -		 */
> > -		if (map.br_startblock != HOLESTARTBLOCK) {
> 
> Isn't this something we should keep in the caller?  That way the actual
> invalide helper can assert that the map contains neither a hole or
> a delaystartblock.

Yeah, we could keep that in the caller.

> > -			bp = xfs_trans_get_buf(*trans,
> > -					dp->i_mount->m_ddev_targp,
> > -					dblkno, dblkcnt, 0);
> > -			if (!bp)
> > -				return -ENOMEM;
> > -			xfs_trans_binval(*trans, bp);
> 
> And this is a pretty big change in that we now trylock and never read
> a buffer from disk if it isn't in core.  That change looks fine to me
> from trying to understand what is going on, but it clearly needs to
> be split out and documented.

<nod>

"Find any incore buffers associated with the remote attr value and mark
them stale so they go away."

> > -			/*
> > -			 * Roll to next transaction.
> > -			 */
> > -			error = xfs_trans_roll_inode(trans, dp);
> > -			if (error)
> > -				return error;
> > -		}
> > +		xfs_attr_rmtval_stale(dp, &map);
> >  
> >  		tblkno += map.br_blockcount;
> >  		tblkcnt -= map.br_blockcount;
> >  	}
> >  
> > -	return 0;
> > +	return xfs_trans_roll_inode(trans, dp);
> 
> xfs_attr3_leaf_freextent not doesn't do anything with the trans but
> rolling it.  I think you can drop both the roll and the trans argument.

Yeah, I was 90% convinced of that too.  That'll be another prep patch.

--D
