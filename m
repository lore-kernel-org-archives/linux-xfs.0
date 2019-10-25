Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44725CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F0B821872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i3LwDX88"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409775AbfJYRZm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 13:25:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58432 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388862AbfJYRZm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:25:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PHOSYl172514;
        Fri, 25 Oct 2019 17:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LZd6l7tVz75vopLB9DZESEJt2SCvWl9a8JI5kWtxH4k=;
 b=i3LwDX88B4XyDEQ9dYPUe4UEcDk7Dqk9+vE1Qf4fHqwiLtns/r98weBDKC6/uiJK7q01
 vxZOrXxXk6C2cYyhgvjxdfDRESs+8jGWYPRkVlJlp6y/pdLjLQ4rxsm1x4TdSUgRX3ej
 4tTY5+8CPDrMQKvC50jsyLiB56NdgKnNPCLBiig0IGu51mXYPHJ9RnqYBMAfQ7Dlv3Wc
 9bcpGLYNb46UEjWp1dmOryDxJ/ykSLlrPQOUhhnZ1Q6EHOMvctxUhgl5XxPwNYMPTnZ+
 3DNy3U83eTvj6kvvSEz4VnnV7st1fyS716Js/C0nQWKvco/M4LODw4L6bBuzYeQYpRv5 DQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteqcgdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 17:25:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PHNMID187012;
        Fri, 25 Oct 2019 17:25:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vunbmuaf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 17:25:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9PHPa2v011991;
        Fri, 25 Oct 2019 17:25:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 10:25:36 -0700
Date:   Fri, 25 Oct 2019 10:25:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: refactor xfs_iread_extents to use
 xfs_btree_visit_blocks
Message-ID: <20191025172535.GO913374@magnolia>
References: <157198051549.2873576.10430329078588571923.stgit@magnolia>
 <157198052776.2873576.12691586684307027826.stgit@magnolia>
 <20191025125332.GB16251@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025125332.GB16251@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=864
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=945 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:53:32AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 24, 2019 at 10:15:27PM -0700, Darrick J. Wong wrote:
> > +struct xfs_iread_state {
> > +	struct xfs_iext_cursor	icur;
> > +	struct xfs_ifork	*ifp;
> 
> Given that the btree cursor contains the whichfork information there is
> not real need to also pass a ifork pointer.
> 
> > +	xfs_extnum_t		loaded;
> > +	xfs_extnum_t		nextents;
> 
> That can just use XFS_IFORK_NEXTENTS() directly in the callback.
> 
> > +	int			state;
> 
> Same here.  The xfs_bmap_fork_to_state is cheap enough to just do it
> inside the callback function.

Ok.

> > +	block = xfs_btree_get_block(cur, level, &bp);
> 
> This is opencoded in almost all xfs_btree_visit_blocks callbacks.
> Any chance we could simply pass the buffer to the callback?

Ok.

> > +/* Only visit record blocks. */
> > +#define XFS_BTREE_VISIT_RECORDS_ONLY	(0x1)
> 
> I find these only flags a little weird.  I'd rather have two flags,
> one to to visit interior nodes, and one to visit leaf nodes, which makes
> the interface very much self-describing.

Hm, good suggestion, will do.

--D
