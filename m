Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B6DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 21:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9187B2065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 21:20:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CH/6WtWu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgGOVUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 17:20:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOVUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 17:20:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FL70oJ025591;
        Wed, 15 Jul 2020 21:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wOiORsX8mPGfPT+tr+THqrhWzZgSbDn6++GLuwPGhd4=;
 b=CH/6WtWuiLVHFWqLclLfdWC4u2Hx4PrQsc2hnw7VBMpLdk+FM5rKu7+VbWlaOjVnjfQX
 fU54x5SL1muBRdOuMMgrc6zBo4xsdhEZv4+6TTpt1rY2PYMwzrVQt6PCXsezNOGoOm/m
 RQ0n2ooqDBzqZrhzOGIpvV7r8zu6NAhS5qNANJIcwEXbzefhI8bwFdlAT3E2lWdm+oEn
 j0GXasj3G2vBPek/h9t4OFknjBwFkJsspVqBXMPglkuO5dXHL0iuvb7MRgQ9HRxGmcJq
 8mCc4n2y+bl+Dim77kRBgSb+u+t0kz1kpbS3n8niuIjUQzjQAQ8VdSYSbzYe/ocp1kqe iA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cmdusr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 21:20:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FL7fD2101599;
        Wed, 15 Jul 2020 21:20:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0s181s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 21:20:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FLKX23031696;
        Wed, 15 Jul 2020 21:20:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 14:20:33 -0700
Date:   Wed, 15 Jul 2020 14:20:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate
 field
Message-ID: <20200715212032.GE3151642@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032038.2914673.4780928031076025099.stgit@magnolia>
 <20200714075756.GB19883@infradead.org>
 <20200714180502.GB7606@magnolia>
 <20200715174340.GB11239@infradead.org>
 <20200715183838.GD3151642@magnolia>
 <20200715183948.GA23249@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715183948.GA23249@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=947 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=962 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 07:39:48PM +0100, Christoph Hellwig wrote:
> On Wed, Jul 15, 2020 at 11:38:38AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 15, 2020 at 06:43:40PM +0100, Christoph Hellwig wrote:
> > > On Tue, Jul 14, 2020 at 11:05:02AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jul 14, 2020 at 08:57:56AM +0100, Christoph Hellwig wrote:
> > > > > On Mon, Jul 13, 2020 at 06:32:00PM -0700, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > Create a new type (xfs_dqtype_t) to represent the type of an incore
> > > > > > dquot.  Break the type field out from the dq_flags field of the incore
> > > > > > dquot.
> > > > > 
> > > > > I don't understand why we need separate in-core vs on-disk values for
> > > > > the type.  Why not something like this on top of the whole series:
> > > > 
> > > > I want to keep the ondisk d_type values separate from the incore q_type
> > > > values because they don't describe exactly the same concepts:
> > > > 
> > > > First, the incore qtype has a NONE value that we can pass to the dquot
> > > > core verifier when we don't actually know if this is a user, group, or
> > > > project dquot.  This should never end up on disk.
> > > 
> > > Which we can trivially verify.  Or just get rid of NONE, which actually
> > > cleans things up a fair bit (patch on top of my previous one below)
> > 
> > Ok, I'll get rid of that usage.
> > 
> > > > Second, xfs_dqtype_t is a (barely concealed) enumeration type for quota
> > > > callers to tell us that they want to perform an action on behalf of
> > > > user, group, or project quotas.  The incore q_flags and the ondisk
> > > > d_type contain internal state that should not be exposed to quota
> > > > callers.
> > > 
> > > I don't think that is an argument, as we do the same elsewhere.
> > > 
> > > > 
> > > > I feel a need to reiterate that I'm about to start adding more flags to
> > > > d_type (for y2038+ time support), for which it will be very important to
> > > > keep d_type and q_{type,flags} separate.
> > > 
> > > Why?  We'll just OR the bigtime flag in before writing to disk.
> > 
> > Ugh, fine, I'll rework the whole series yet again, since it doesn't look
> > like anyone else is going to have the time to review a 27 patch cleanup
> > series.
> 
> Let's just get your series in and I'll send an incremental patch
> after the bigtime series..

Seeing as I already refactored yesterday to produce v4 and am now midway
through refactoring to produce v5 I just going to keep going with even
more ******* cleanups.

--D
