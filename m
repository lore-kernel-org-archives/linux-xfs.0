Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BCCCA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 16:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8805821835
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 16:12:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lDR3GAG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfJ3QM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 12:12:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJ3QM4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 12:12:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UGCOx6068259;
        Wed, 30 Oct 2019 16:12:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3v7udcpd1lsjHdyIeCc7QduABx7yF/udjHZaG8hx+6Q=;
 b=lDR3GAG/1p2YtwH59huONBGA8V8f8+Gwvppv5hz+WQFFiqqon9Ygro9o3zaLy/LC0K6J
 7tT3Y3/BOSdiFBFuLZe62TdquktPytOVXuDS9G2GZifBllxHTGcQfECnb2pryfFddta/
 eabVF/+4rz64rgS/tztzkhev+DwQZLuUUw7liZDl9VxBmojeHOpEf+jIO+xuZH4s6N0g
 7SLsH37957pb7DYItVLiqgtRHNw2/s3D56ehQJrHrTChSc2vDqvJ4wQ4zpG6pAbWubp5
 lu03xS+8GYT4YES3y3wtFQsqa2F1G1xfkyO5Hu9vPeypvlcTuotLG1M/bFaIWugn0KCM Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vxwhfddtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 16:12:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UGAvs3180835;
        Wed, 30 Oct 2019 16:12:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vxwja83bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 16:12:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9UGCnSA018725;
        Wed, 30 Oct 2019 16:12:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 09:12:49 -0700
Date:   Wed, 30 Oct 2019 09:12:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: don't log the inode in xfs_fs_map_blocks if it
 wasn't modified
Message-ID: <20191030161248.GI15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-5-hch@lst.de>
 <20191028161245.GD15222@magnolia>
 <20191029075843.GD18999@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029075843.GD18999@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=921
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 08:58:43AM +0100, Christoph Hellwig wrote:
> On Mon, Oct 28, 2019 at 09:12:45AM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 25, 2019 at 05:03:32PM +0200, Christoph Hellwig wrote:
> > > Even if we are asked for a write layout there is no point in logging
> > > the inode unless we actually modified it in some way.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_pnfs.c | 43 +++++++++++++++++++------------------------
> > >  1 file changed, 19 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> > > index 9c96493be9e0..fa90c6334c7c 100644
> > > --- a/fs/xfs/xfs_pnfs.c
> > > +++ b/fs/xfs/xfs_pnfs.c
> > > @@ -147,32 +147,27 @@ xfs_fs_map_blocks(
> > >  	if (error)
> > >  		goto out_unlock;
> > >  
> > > -	if (write) {
> > > -		enum xfs_prealloc_flags	flags = 0;
> > > -
> > > +	if (write &&
> > > +	    (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
> > >  		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> > 
> > The change in code flow makes this assert rather useless, I think, since
> > we only end up in this branch if we have a write and a hole.  If the
> > condition that it checks is important (and it seems to be?) then it
> > ought to be hoisted up a level and turned into:
> > 
> > ASSERT(!write || !nimaps || imap.br_startblock != DELAYSTARTBLOCK);
> > 
> > Right?
> 
> Actually even for !write we should not see delalloc blocks here.
> So I'll fix up the assert in a separate prep patch.

<shrug> I could just fix it, unless you're about to resend the whole series?

--D
