Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB1CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 18:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE0A2074F
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 18:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O5vn17/7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgG0SwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 14:52:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG0SwU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 14:52:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RIpZeV110220
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 18:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hHmGEiTsae6apXliAIiLfSjF1J+pMBxhUGmXBJhqXXs=;
 b=O5vn17/7KDoclQ4NlF5bz34H1aQtaK8EXNg/M4l7w8ZQ5QfhndwE9Luadsu57RcqPEZ0
 8tEQLLBOviehj+Q2IG3ihAud5SJi+49aMxiHQvjy3hSFwySaAfxYrVTEwGpuMn4ktzYZ
 l6UF7nD4NpTnOtH+yFTmOcwptBPOJ31A62QN6JtMnjCyK+uh02Hez+lBG3bOcmznt803
 kLDOa7cGH82iWDXTOdghYncNym/dPMt/GS2tki7txWtiVuXhielSua99PsyorjidsNTy
 QBorPfNUIT07yeUW7RgDRrKokDPfDGK5ESR+4erIupWD0CtHN64r9vbfgVSYuo/3eZy8 bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32hu1j39fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 18:52:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RIiO9x038128
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 18:50:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32hu5rf7bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 18:50:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06RIoHas026583
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 18:50:18 GMT
Received: from localhost (/10.159.140.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 11:50:17 -0700
Date:   Mon, 27 Jul 2020 11:50:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: Fix compiler warning in
 xfs_attr_node_removename_setup
Message-ID: <20200727185016.GB3151642@magnolia>
References: <20200727022608.18535-1-allison.henderson@oracle.com>
 <20200727022608.18535-2-allison.henderson@oracle.com>
 <20200727154611.GA3151642@magnolia>
 <a641cbc8-6cda-25b2-f6e6-63e52fde572a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a641cbc8-6cda-25b2-f6e6-63e52fde572a@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=2 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 27, 2020 at 09:51:54AM -0700, Allison Collins wrote:
> 
> 
> On 7/27/20 8:46 AM, Darrick J. Wong wrote:
> > On Sun, Jul 26, 2020 at 07:26:07PM -0700, Allison Collins wrote:
> > > Fix compiler warning for variable 'blk' set but not used in
> > > xfs_attr_node_removename_setup.  blk is used only in an ASSERT so only
> > > declare blk when DEBUG is set.
> > > 
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index d4583a0..5168d32 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -1174,7 +1174,9 @@ int xfs_attr_node_removename_setup(
> > >   	struct xfs_da_state	**state)
> > >   {
> > >   	int			error;
> > > +#ifdef DEBUG
> > >   	struct xfs_da_state_blk	*blk;
> > > +#endif
> > 
> > But now a non-DEBUG compilation will trip over the assignment to blk:
> > 
> > 	blk = &(*state)->path.blk[(*state)->path.active - 1];
> > 
> > that comes just before the asserts, right?
> > 
> > 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
> > 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> > 		XFS_ATTR_LEAF_MAGIC);
> > 
> > In the end you probably just want to encode the accessor logic in the
> > assert body so the whole thing just disappears entirely.
> Are you sure you'd rather have it that way, then once up in the declaration?
> Like this:
> 
> #ifdef DEBUG
> 	struct xfs_da_state_blk	*blk = &(*state)->path.blk[(*state)->path.active -
> 1];
> #endif

I thought xfs_attr_node_hasname could allocate the da state and set
*state, which means that we can't dereference *state until after that
call?

--D

> > 
> > --D
> > 
> > >   	error = xfs_attr_node_hasname(args, state);
> > >   	if (error != -EEXIST)
> > > -- 
> > > 2.7.4
> > > 
