Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2DECA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3061F217D6
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sv55LpPG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733275AbfJ1S1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:27:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbfJ1S1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 14:27:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SINWHd146609;
        Mon, 28 Oct 2019 18:27:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VOrlMQMS5hqKn94FTzqKak0UXURKYzN7kCmxPOHCkRk=;
 b=Sv55LpPGdOLGfVXscfoF/rFDA/jkYIJ8jIUDg04lcH9/Z/xVykJtWk5i72XOlfoCA9lw
 JX2q19BJvMcWTXNCnD+XsVqhyV0xowhfiIJ0dYA53QPNThKO81W8cQOfa0CBJV6RbtCl
 pH/Z1z0AJtafL7WfrRueKuo4mTjyf4TOtGZ6aPNfT9gQjgfUO00akQu06c043EkzkhxM
 Hbfm1fC+IIrfh7bne6ls+zPhSiR19ZwisR16lL3d0DPzDs884vnrgDOO+VUMNmyEDAep
 6O7B8D3nHC6AUSn3OXVAsBQScr3yE5/72bH4u+Jo1/zNCcNJ9zdIDWA7jevGwlbP6RgT pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vve3q3u70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 18:27:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SIN8l9181846;
        Mon, 28 Oct 2019 18:27:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vvykscbyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 18:27:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SIRSML005279;
        Mon, 28 Oct 2019 18:27:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 11:27:28 -0700
Date:   Mon, 28 Oct 2019 11:27:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check attribute leaf block structure
Message-ID: <20191028182727.GY15222@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198049357.2873445.8604948103647704008.stgit@magnolia>
 <20191028181813.GB26529@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028181813.GB26529@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 02:18:13PM -0400, Brian Foster wrote:
> On Thu, Oct 24, 2019 at 10:14:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add missing structure checks in the attribute leaf verifier.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c |   63 ++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 61 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index ec7921e07f69..8dea3a273029 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -232,6 +232,57 @@ xfs_attr3_leaf_hdr_to_disk(
> >  	}
> >  }
> >  
> > +static xfs_failaddr_t
> > +xfs_attr3_leaf_verify_entry(
> > +	struct xfs_mount			*mp,
> > +	char					*buf_end,
> > +	struct xfs_attr_leafblock		*leaf,
> > +	struct xfs_attr3_icleaf_hdr		*leafhdr,
> > +	struct xfs_attr_leaf_entry		*ent,
> > +	int					idx,
> > +	__u32					*last_hashval)
> > +{
> > +	struct xfs_attr_leaf_name_local		*lentry;
> > +	struct xfs_attr_leaf_name_remote	*rentry;
> > +	char					*name_end;
> > +	unsigned int				nameidx;
> > +	unsigned int				namesize;
> > +	__u32					hashval;
> > +
> > +	/* hash order check */
> > +	hashval = be32_to_cpu(ent->hashval);
> > +	if (hashval < *last_hashval)
> > +		return __this_address;
> > +	*last_hashval = hashval;
> > +
> > +	nameidx = be16_to_cpu(ent->nameidx);
> > +	if (nameidx < leafhdr->firstused || nameidx >= mp->m_attr_geo->blksize)
> > +		return __this_address;
> > +
> > +	/* Check the name information. */
> > +	if (ent->flags & XFS_ATTR_LOCAL) {
> > +		lentry = xfs_attr3_leaf_name_local(leaf, idx);
> > +		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
> > +				be16_to_cpu(lentry->valuelen));
> > +		name_end = (char *)lentry + namesize;
> > +		if (lentry->namelen == 0)
> > +			return __this_address;
> 
> I think this reads a little better if we check the lentry value before
> we use it (same deal with rentry in the branch below).
> 
> Also, why the == 0 checks specifically? Or IOW, might there also be a
> sane max value to check some of these fields against?

Attributes have a maximum name length of 255 characters, and the ondisk
namelen field is u8, so it's never possible to exceed the maximum.

> > +	} else {
> > +		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
> > +		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
> > +		name_end = (char *)rentry + namesize;
> > +		if (rentry->namelen == 0)
> > +			return __this_address;
> > +		if (rentry->valueblk == 0)
> > +			return __this_address;
> 
> Hmm.. ISTR that it's currently possible to have ->valueblk == 0 on an
> incomplete remote attr after a crash. That's not ideal and hopefully
> fixed up after the xattr intent stuff lands, but in the meantime I
> thought we had code sprinkled around somewhere to fix that up after the
> fact. Would this turn that scenario into a metadata I/O error?

<urk> Yes, it would.  I'll fix that.

--D

> 
> Brian
> 
> > +	}
> > +
> > +	if (name_end > buf_end)
> > +		return __this_address;
> > +
> > +	return NULL;
> > +}
> > +
> >  static xfs_failaddr_t
> >  xfs_attr3_leaf_verify(
> >  	struct xfs_buf			*bp)
> > @@ -240,7 +291,10 @@ xfs_attr3_leaf_verify(
> >  	struct xfs_mount		*mp = bp->b_mount;
> >  	struct xfs_attr_leafblock	*leaf = bp->b_addr;
> >  	struct xfs_attr_leaf_entry	*entries;
> > +	struct xfs_attr_leaf_entry	*ent;
> > +	char				*buf_end;
> >  	uint32_t			end;	/* must be 32bit - see below */
> > +	__u32				last_hashval = 0;
> >  	int				i;
> >  	xfs_failaddr_t			fa;
> >  
> > @@ -273,8 +327,13 @@ xfs_attr3_leaf_verify(
> >  	    (char *)bp->b_addr + ichdr.firstused)
> >  		return __this_address;
> >  
> > -	/* XXX: need to range check rest of attr header values */
> > -	/* XXX: hash order check? */
> > +	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
> > +	for (i = 0, ent = entries; i < ichdr.count; ent++, i++) {
> > +		fa = xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ichdr,
> > +				ent, i, &last_hashval);
> > +		if (fa)
> > +			return fa;
> > +	}
> >  
> >  	/*
> >  	 * Quickly check the freemap information.  Attribute data has to be
> > 
> 
