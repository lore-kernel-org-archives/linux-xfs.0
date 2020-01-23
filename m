Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D241C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDCB24125
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mVPoU0L1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgAWHkT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:40:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgAWHkT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:40:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cX5k145014;
        Thu, 23 Jan 2020 07:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vURtgvz1hKSAWaGnOcBIfUdoVfzBg/PFxmrJhRjH5nM=;
 b=mVPoU0L1xESfV92LQJGe/Zk8DoHLt6yqxSlfv31+Uqd8l2fJrwnJTg4xn2W8AwAJBpmg
 4M9CK9MUSLQuWd/ioDA0eyYr27OmRM+YVKxRmheq8j6y3LF0Jy0Nd2b4zMpvk+MLROzC
 eVLAggPo3220B0J3XkVJCQ2ULq125zuazjrAtawuUvF2b+RgaNIH3Pwsl0NBjXSAqm1g
 wfZVHkkMc3fyPEfOSPR9bstbUNCbocrE8OF+tx6p5IUFbPKXFEr4J8USeiA/zbCzhErP
 QRliKCnlAy9guOHn+Emd+IsY+Jf+Yi9+1s2S4wKlz55zn+GiUoy2hRWQBUm4VdyF4gJu kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrg9qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:40:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cWuX062275;
        Thu, 23 Jan 2020 07:40:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xppq505gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:40:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N7e4vH017117;
        Thu, 23 Jan 2020 07:40:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:40:03 -0800
Date:   Wed, 22 Jan 2020 23:40:03 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 05/13] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200123074003.GU8247@magnolia>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
 <157956102137.1166689.2159908930036102057.stgit@magnolia>
 <20200121225228.GA11169@infradead.org>
 <20200122002046.GQ8247@magnolia>
 <20200122221207.GA29647@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122221207.GA29647@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=828
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=882 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230065
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 02:12:07PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 21, 2020 at 04:20:46PM -0800, Darrick J. Wong wrote:
> > I rearrange responsibility for dealing with buffer error handling in the
> > patch "xfs: move buffer read io error logging to xfs_buf_read_map" later
> > in this series.  Was that not what you were expecting?
> 
> I defintively don't expect a patch talking about logging to change error
> handling behavior.  And yes, I also expect that if we change a function
> to return an error code that is actually uses that to return errors.

Fair enough, I'll fold that one in here.

> > Though looking at that patch I guess we could set @error directly to the
> > return values of xfs_buf_reverify/_xfs_buf_read.
> 
> Yes.  Code outside xfs_buf.c and maybe xfs_buf_item.c really ever access
> b_error.

<nod>

--D
