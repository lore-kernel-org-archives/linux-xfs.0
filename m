Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95E4CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00C320848
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jMicukPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbfKEB7f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:59:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbfKEB7f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 20:59:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xLw5152679;
        Tue, 5 Nov 2019 01:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pno3s/Rm0Ld7+FjvBBG+MUoMXOdtcWQ/F/4IilisGzQ=;
 b=jMicukPfcgLMIF7K4eizYMhwzcgMBpu/MHOyOhqRH0qNwJxUPAweEFvjb4zGY5sqAaHa
 MpjAwJb/8uMKYJdFPdnu1PcjdN7DsVmT4nqe6I4OPWRe1+xvns4o3vNwLUN+qBLZ1JyF
 uaVyzpR8MkQTDCK8aNS/NdmnzMGCuA5lAzfqL6+lipiWvdLThQnZ5MmU6JkNlURYQyWi
 WcWA1etFUg7joAFkhDVQBoE5D17+RGqGqCAtVfDWqvLLl4UCBpFJO/rP8LpR0JH4DemO
 J0a5yz73yPCmoYHWoPYwS4b2N9r5dqMmqemMcMOI+OwF0Z95B0TXHEEvVYXt9Q/DeVdR Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12er2wmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:59:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xOfS011565;
        Tue, 5 Nov 2019 01:59:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w1kxndjsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:59:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA51waTl027805;
        Tue, 5 Nov 2019 01:58:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 17:58:36 -0800
Date:   Mon, 4 Nov 2019 17:58:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/34] xfs: add a btree entries pointer to struct
 xfs_da3_icnode_hdr
Message-ID: <20191105015835.GX4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-6-hch@lst.de>
 <20191104195233.GF4153244@magnolia>
 <20191105013832.GB32531@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105013832.GB32531@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 02:38:32AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 04, 2019 at 11:52:33AM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 01, 2019 at 03:06:50PM -0700, Christoph Hellwig wrote:
> > > All but two callers of the ->node_tree_p dir operation already have a
> > > xfs_da3_icnode_hdr from a previous call to xfs_da3_node_hdr_from_disk at
> > > hand.  Add a pointer to the btree entries to struct xfs_da3_icnode_hdr
> > > to clean up this pattern.  The two remaining callers now expand the
> > > whole header as well, but that isn't very expensive and not in a super
> > > hot path anyway.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/libxfs/xfs_attr_leaf.c |  6 ++--
> > >  fs/xfs/libxfs/xfs_da_btree.c  | 68 ++++++++++++++++-------------------
> > >  fs/xfs/libxfs/xfs_da_btree.h  |  1 +
> > >  fs/xfs/libxfs/xfs_da_format.c | 21 -----------
> > >  fs/xfs/libxfs/xfs_dir2.h      |  2 --
> > >  fs/xfs/scrub/dabtree.c        |  6 ++--
> > >  fs/xfs/xfs_attr_inactive.c    | 34 +++++++++---------
> > >  fs/xfs/xfs_attr_list.c        |  2 +-
> > >  8 files changed, 55 insertions(+), 85 deletions(-)
> > > 
> > 
> > <snip>
> > 
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> > > index 69ebf6a50d85..63ed45057fa5 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > > @@ -135,6 +135,7 @@ struct xfs_da3_icnode_hdr {
> > >  	uint16_t		magic;
> > >  	uint16_t		count;
> > >  	uint16_t		level;
> > > +	struct xfs_da_node_entry *btree;
> > 
> > This adds to the incore node header structure a pointer to raw disk
> > structures, right?  Can we make this a little more explicit by naming
> > the field "raw_entries" or something?
> 
> Hmm, is that really so much of an issue?  Even something that a comment
> wouldn't help?  I'd kinda hate making identifiers extremely long, but
> if that's what is needed I can change it.  Same for the other patches
> doing something similar.

<shrug> I think a comment would work.  Or just "__btree"...?

--D
