Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B6EC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 00:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C27217F4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 00:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oVvZOHV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAVAXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 19:23:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 19:23:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M08d8D089909;
        Wed, 22 Jan 2020 00:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tH4FhMg5IPbSpAVutFzGZsmesNoyuqTtlyPE0MFLCjg=;
 b=oVvZOHV18mn7FgtyuNhSNiq4k9VTOP4S3c2lDapFbXygwvUBU8NWbPt1x7sNdK/HjjRa
 3X+xB/0cTkx2Abzo19swfhN0xThTjho2qC0xrpunkupOkkbiAVrVWbwKKDJvxqT41U4c
 rnMLwNWMBVX9wc+G2sGd2KsOeo9G4B1TWmloBrn5MJC5coVPJkFPjDFWqDUO8odV0jP6
 u1CFDKjfM+ayovvquuFvqIvMo02p0cherMtffMtErKM9P/+43hzQzlo+WlLrCeX9BnRW
 Zo1GuFvs3Dxz54kpG+TJMrUd49vaEd9tYtw02JUWMYvB1jiGrOuX6zbLreH6wp6EyzRz 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseugpxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 00:22:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M08h9d110040;
        Wed, 22 Jan 2020 00:20:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xnpeh303p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 00:20:53 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00M0KnUr021825;
        Wed, 22 Jan 2020 00:20:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 16:20:48 -0800
Date:   Tue, 21 Jan 2020 16:20:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 05/13] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200122002046.GQ8247@magnolia>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
 <157956102137.1166689.2159908930036102057.stgit@magnolia>
 <20200121225228.GA11169@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121225228.GA11169@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=690
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=755 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 02:52:28PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 20, 2020 at 02:57:01PM -0800, Darrick J. Wong wrote:
> > @@ -831,7 +833,8 @@ xfs_buf_read_map(
> >  		XFS_STATS_INC(target->bt_mount, xb_get_read);
> >  		bp->b_ops = ops;
> >  		_xfs_buf_read(bp, flags);
> > -		return bp;
> > +		*bpp = bp;
> > +		return 0;
> 
> _xfs_buf_read can return an error, and we are losing that here.  So
> we should return the value from _xfs_buf_read, an ensure *bpp is NULL
> if it returns an error.  That also means all the b_error check in the
> callers of xfs_buf_read_map and xfs_buf_read (and with that the biggest
> wart in the buffer cache API) can go away.

I rearrange responsibility for dealing with buffer error handling in the
patch "xfs: move buffer read io error logging to xfs_buf_read_map" later
in this series.  Was that not what you were expecting?

Though looking at that patch I guess we could set @error directly to the
return values of xfs_buf_reverify/_xfs_buf_read.

--D
