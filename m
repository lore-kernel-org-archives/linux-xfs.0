Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3401C35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B67BF206EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h6UN4sAZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgBUPwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:52:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgBUPwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:52:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFi05q163639;
        Fri, 21 Feb 2020 15:52:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=s/vN5nJIVnN8AU4EGYAw+wHcCZeT3kjC5LN2JbDj/ig=;
 b=h6UN4sAZWp0nJ6IGZDbeOs6UOa+gOyDxdm3X3+B3TthVE6ZVJRZi+9V9GlNMtzA90D6c
 HtPI2cy8BIzPvz+fFXSRBMuNodIFSZ/x19UPqb7Qn2CDzAbJi+6BbBcZjzBaEAWVPEpv
 6src5nWO10wAaTnIw89+kYxYwEeidzCGnsDTd/Bm5oq5NSyfbTEY+qycIxbRvoBYRo9t
 XsmLSpT6kp8KFmettTJ3d4sNcXkR2UAOukm9/GpzoANnKA2Ik353fukZ56OdLP8X40ky
 NI8fpNptQ1Oco6VVdVboIlXC2+4ad17QfI3l7DuO29LicU98QcR6FN2qdPItDXQQnv11 wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udksapd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:52:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFgo7M126930;
        Fri, 21 Feb 2020 15:52:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y8udfdcsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:52:04 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LFq37d007356;
        Fri, 21 Feb 2020 15:52:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:52:03 -0800
Date:   Fri, 21 Feb 2020 07:52:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] libxfs: use uncached buffers for initial mkfs
 writes
Message-ID: <20200221155200.GS9506@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216302984.602314.15196666031325406487.stgit@magnolia>
 <20200221145101.GJ15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221145101.GJ15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:51:01AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:43:49PM -0800, Darrick J. Wong wrote:
> > +/* Prepare an uncached buffer, ready to write something out. */
> > +static inline struct xfs_buf *
> > +get_write_buf(
> > +	struct xfs_buftarg	*btp,
> > +	xfs_daddr_t		daddr,
> > +	int			bblen)
> > +{
> > +	struct xfs_buf		*bp;
> > +
> > +	bp = libxfs_buf_get_uncached(btp, bblen, 0);
> > +	bp->b_bn = daddr;
> > +	bp->b_maps[0].bm_bn = daddr;
> > +	return bp;
> > +}
> 
> I'd call this alloc_write_buf.

Agreed, will fix.

--D

> But the patch itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
