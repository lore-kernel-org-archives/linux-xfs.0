Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4681C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 02:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3CF32076C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 02:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zVp40kGK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGPCTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 22:19:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37374 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgGPCTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 22:19:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G2I50I023842;
        Thu, 16 Jul 2020 02:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/bqE8BDnHGGxYGu9v59M5kN5658UntngIT2OHkVbtqY=;
 b=zVp40kGKo4M83aJzGXzF5RvKJPN2qQBM3HUDRoYhgAUXcuyL8ROr8vYX3pefuQYjoqKA
 i/ngakYZXOf6DcC/Z93zLCTmz8z/d6TOaCdOE6CPVREMWB/xXLftyWvzDtTMCgTQi954
 Ixafk6WUoPJhQGyO0C7tHAOT3/1EeAhqwBvfvdorWY3n8Mf9nL/SGtzCG+isqyAUwWg5
 BfSaMhzNR/OW813wtwIWo/OrR7UbOZqS8rAT74oPAcPpYbDwjAQnpAPyIku5QSov12+i
 J8zJHwKDPdiYk8RqefECv5FjIRpq5A7yt91pZKqNz4y6HPyfQUImgL4hPgBAf1ewpY0B Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 327s65mwsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Jul 2020 02:19:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G2He4p018683;
        Thu, 16 Jul 2020 02:17:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32a4crr8ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 02:17:40 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06G2HYk4006547;
        Thu, 16 Jul 2020 02:17:34 GMT
Received: from localhost (/10.159.238.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 19:17:34 -0700
Date:   Wed, 15 Jul 2020 19:17:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate
 field
Message-ID: <20200716021733.GI3151642@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032038.2914673.4780928031076025099.stgit@magnolia>
 <20200714075756.GB19883@infradead.org>
 <20200714180502.GB7606@magnolia>
 <20200715174340.GB11239@infradead.org>
 <20200715183838.GD3151642@magnolia>
 <20200715183948.GA23249@infradead.org>
 <20200715212032.GE3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715212032.GE3151642@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=1 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 02:20:32PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 15, 2020 at 07:39:48PM +0100, Christoph Hellwig wrote:
> > On Wed, Jul 15, 2020 at 11:38:38AM -0700, Darrick J. Wong wrote:
> > > On Wed, Jul 15, 2020 at 06:43:40PM +0100, Christoph Hellwig wrote:
> > > > On Tue, Jul 14, 2020 at 11:05:02AM -0700, Darrick J. Wong wrote:
> > > > > On Tue, Jul 14, 2020 at 08:57:56AM +0100, Christoph Hellwig wrote:
> > > > > > On Mon, Jul 13, 2020 at 06:32:00PM -0700, Darrick J. Wong wrote:
> > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > 
> > > > > > > Create a new type (xfs_dqtype_t) to represent the type of an incore
> > > > > > > dquot.  Break the type field out from the dq_flags field of the incore
> > > > > > > dquot.
> > > > > > 
> > > > > > I don't understand why we need separate in-core vs on-disk values for
> > > > > > the type.  Why not something like this on top of the whole series:
> > > > > 
> > > > > I want to keep the ondisk d_type values separate from the incore q_type
> > > > > values because they don't describe exactly the same concepts:
> > > > > 
> > > > > First, the incore qtype has a NONE value that we can pass to the dquot
> > > > > core verifier when we don't actually know if this is a user, group, or
> > > > > project dquot.  This should never end up on disk.
> > > > 
> > > > Which we can trivially verify.  Or just get rid of NONE, which actually
> > > > cleans things up a fair bit (patch on top of my previous one below)
> > > 
> > > Ok, I'll get rid of that usage.
> > > 
> > > > > Second, xfs_dqtype_t is a (barely concealed) enumeration type for quota
> > > > > callers to tell us that they want to perform an action on behalf of
> > > > > user, group, or project quotas.  The incore q_flags and the ondisk
> > > > > d_type contain internal state that should not be exposed to quota
> > > > > callers.
> > > > 
> > > > I don't think that is an argument, as we do the same elsewhere.
> > > > 
> > > > > 
> > > > > I feel a need to reiterate that I'm about to start adding more flags to
> > > > > d_type (for y2038+ time support), for which it will be very important to
> > > > > keep d_type and q_{type,flags} separate.
> > > > 
> > > > Why?  We'll just OR the bigtime flag in before writing to disk.
> > > 
> > > Ugh, fine, I'll rework the whole series yet again, since it doesn't look
> > > like anyone else is going to have the time to review a 27 patch cleanup
> > > series.
> > 
> > Let's just get your series in and I'll send an incremental patch
> > after the bigtime series..
> 
> Seeing as I already refactored yesterday to produce v4 and am now midway
> through refactoring to produce v5 I just going to keep going with even
> more ******* cleanups.

To elaborate on that, I've split all the patches that /have/ been
reviewed into one branch, and all the flags cleanups into a second
branch.  If that second branch passes testing I'll mail it out in the
morning.

--D

> --D
