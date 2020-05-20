Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90547C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3FF20829
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a+AHZwCX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgETU1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 16:27:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52474 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgETU1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 16:27:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKLH2A188923;
        Wed, 20 May 2020 20:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Yj5KdGJsZi4h3bR/zW+fvQ5GTpJ66M/H2gPI7wdYo+I=;
 b=a+AHZwCXHz7/PPAj0ZLsk+6z0ScitNB/2FI0eH3we39A1LKci4K2QtcRlV8fpEhEAG6Q
 L2N1F4AgNRYQLYXAUHj+sDvucd15Ivp8xzYCJc1eyhEICylv2sR8R7reOHk90XtmcYT2
 xTqAF0EBCsHufYbVl1IY2ugqkj+5Z8W02Rf1n9d4WbiAGDPP/EkmpnKs7S2VcBMwUiC6
 HGC0r0cKhMnPYUNaidSljt+pXlygRcEtvoctH7PnRqfag6OHPuMieYN7mn1cYraDllyz
 dM86uhi2VB6ZgwvuACTBA+TjEe97l3StaT5uH0IAkZZM8tpP2SyG0vdeeRrZF4vO6bxq EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127krd9v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 20:27:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKJDZ7170991;
        Wed, 20 May 2020 20:27:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 315020y6u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 20:27:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KKR56Y024327;
        Wed, 20 May 2020 20:27:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 13:27:05 -0700
Date:   Wed, 20 May 2020 13:27:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20200520202702.GA17627@magnolia>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-2-david@fromorbit.com>
 <20200520073358.GX2040@dread.disaster.area>
 <20200520074805.GA21299@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520074805.GA21299@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 12:48:05AM -0700, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 05:33:58PM +1000, Dave Chinner wrote:
> > +	/*
> > +	 * Debug checks outside of the spinlock so they don't lock up the
> > +	 * machine if they fail.
> > +	 */
> > +	ASSERT(mp->m_sb.sb_frextents >= 0);
> > +	ASSERT(mp->m_sb.sb_dblocks >= 0);
> > +	ASSERT(mp->m_sb.sb_agcount >= 0);
> > +	ASSERT(mp->m_sb.sb_imax_pct >= 0);
> > +	ASSERT(mp->m_sb.sb_rextsize >= 0);
> > +	ASSERT(mp->m_sb.sb_rbmblocks >= 0);
> > +	ASSERT(mp->m_sb.sb_rblocks >= 0);
> > +	ASSERT(mp->m_sb.sb_rextents >= 0);
> > +	ASSERT(mp->m_sb.sb_rextslog >= 0);

Except for imax_pct and rextslog, all of these are unsigned quantities,
right?  So the asserts will /never/ trigger?

--D

> >  	return;
> 
> No need for the return here at the end of the function.
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
