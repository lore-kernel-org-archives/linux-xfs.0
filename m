Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17318C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 22:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4CFA20874
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 22:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JzGKJKvP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgETW2o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 18:28:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbgETW2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 18:28:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KMRnuM150801;
        Wed, 20 May 2020 22:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nhclSrEpVIoSmfclibicUrE0avdp5pQo6i8De2JgbA8=;
 b=JzGKJKvP8CajiZchlgqTsvl7HRVhgAxW7JBpuN2b9MyJBfy9CzNStYNSMb1qe0VX86sb
 T+kNPGC2dVVDX7lyS6rsuG82A3Zi2S1BfeQ2n09lFYt9yt4s4NLEUJv3IPxOGOicOnx2
 J4/nIU6oD30hmfe7eIWa/UuL0OnQyxTxucmuHejfa8hnnTEFWflM0O3ZknQWJtifznex
 foJJUGONxSZCM5ChhrjAJk1jSiYf4rqCtngDTvBpkIbvLUlLY43ZIgLRVVa/plI9xHUx
 KwNtkQyP1Fm/5wN6xNgzq5n/RQAHx4/CdJj67GHuTXmfRqOA9t9dgojJ85WX6J6qbB+b EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284m5nqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 22:28:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KMSUoF022055;
        Wed, 20 May 2020 22:28:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm7y2sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 22:28:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KMSMHA005497;
        Wed, 20 May 2020 22:28:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 15:28:22 -0700
Date:   Wed, 20 May 2020 15:28:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20200520222821.GI17627@magnolia>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-2-david@fromorbit.com>
 <20200520073358.GX2040@dread.disaster.area>
 <20200520074805.GA21299@infradead.org>
 <20200520202702.GA17627@magnolia>
 <20200520215530.GZ2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520215530.GZ2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:55:30AM +1000, Dave Chinner wrote:
> On Wed, May 20, 2020 at 01:27:02PM -0700, Darrick J. Wong wrote:
> > On Wed, May 20, 2020 at 12:48:05AM -0700, Christoph Hellwig wrote:
> > > On Wed, May 20, 2020 at 05:33:58PM +1000, Dave Chinner wrote:
> > > > +	/*
> > > > +	 * Debug checks outside of the spinlock so they don't lock up the
> > > > +	 * machine if they fail.
> > > > +	 */
> > > > +	ASSERT(mp->m_sb.sb_frextents >= 0);
> > > > +	ASSERT(mp->m_sb.sb_dblocks >= 0);
> > > > +	ASSERT(mp->m_sb.sb_agcount >= 0);
> > > > +	ASSERT(mp->m_sb.sb_imax_pct >= 0);
> > > > +	ASSERT(mp->m_sb.sb_rextsize >= 0);
> > > > +	ASSERT(mp->m_sb.sb_rbmblocks >= 0);
> > > > +	ASSERT(mp->m_sb.sb_rblocks >= 0);
> > > > +	ASSERT(mp->m_sb.sb_rextents >= 0);
> > > > +	ASSERT(mp->m_sb.sb_rextslog >= 0);
> > 
> > Except for imax_pct and rextslog, all of these are unsigned quantities,
> > right?  So the asserts will /never/ trigger?
> 
> In truth, I didn't look that far. I just assumed that because all
> the xfs_sb_mod*() functions used signed math that they could all
> underflow/overflow.  IOWs, the checking for overflow/underflow was
> completely wrong in the first place.
> 
> Should I just remove the ASSERT()s entirely?

It causes a bunch of gcc 9.3 warnings, so yes please. :)

(Granted, I ripped out all the asserts except for the two I mentioned
above, so if nobody else have complaints then no need to resend.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
