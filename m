Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965ACC34031
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6927624654
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cK4atfqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgBSArk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:47:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40832 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBSArj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 19:47:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0VEWQ124324;
        Wed, 19 Feb 2020 00:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LCCX1RYOXK13vQaycX0fiamtcANvtrRKA3R/DRQw7Fw=;
 b=cK4atfqb3VgE0ElCnjcQ3vBwaAzNFRRBf32PwpPxz9zOlP8F4uc+B+jdVeyryEFxghYA
 kMvJPBxnEhv/WhwIkGgltpWP3XL1uammNrqCKW6jdJcoLPecAqpNEWOhMQ232Fry1pqJ
 rz02drkfa85iw0E/ZAZtq7S8WytoxlXadkopjtal4KMCe3CVXMC5L3dzyliWM/eNU4zm
 eo7tyIeZSvZHCthBL/LcFjXKNb3FL5WnGsx13R6AAXlcIR1Bb8VgkUmUQcQF5BfQARhG
 NPEzSspTazPQrFMepBhbvYcdkp7l1Q6ghCB6YEvYInlcoKnZ0S26D83z7i9h8eJxOrJB pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y7aq5w0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:47:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0RoK5058719;
        Wed, 19 Feb 2020 00:47:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2y6tc3eaqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:47:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01J0lWMG008695;
        Wed, 19 Feb 2020 00:47:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 16:47:31 -0800
Date:   Tue, 18 Feb 2020 16:47:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 30/31] xfs: remove XFS_DA_OP_INCOMPLETE
Message-ID: <20200219004729.GD9506@magnolia>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-31-hch@lst.de>
 <20200218022334.GD10776@dread.disaster.area>
 <20200218154856.GD21780@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218154856.GD21780@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:48:56PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 18, 2020 at 01:23:34PM +1100, Dave Chinner wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index d5c112b6dcdd..23e0d8ce39f8 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -898,7 +898,7 @@ xfs_attr_node_addname(
> > >  		 * The INCOMPLETE flag means that we will find the "old"
> > >  		 * attr, not the "new" one.
> > >  		 */
> > > -		args->op_flags |= XFS_DA_OP_INCOMPLETE;
> > > +		args->attr_namespace |= XFS_ATTR_INCOMPLETE;
> > 
> > So args->attr_namespace is no longer an indication of what attribute
> > namespace to look up? Unless you are now defining incomplete
> > attributes to be in a namespace?
> 
> It is the same field on disk.
> 
> > If so, I think this needs more explanation than "we can use the
> > on-disk format directly instead". That's just telling me what the
> > patch is doing and doesn't explain why we are considering this
> > specific on disk flag to indicate a new type of "namespace" for
> > attributes lookups. Hence I think this needs more documentation in
> > both the commit and the code as the definition of
> > XFS_ATTR_INCOMPLETE doesn't really make it clear that this is now
> > considered a namespace signifier...
> 
> Ok.  Also if anyone has a better name for the field, suggestions welcome..

The bureaucrat part of my brain suggests "attr_flags", with a
XFS_ATTR_NAMESPACE() helper to extract just the namespace part by using
#define XFS_ATTR_NAMESPACE_MASK (XFS_ATTR_ROOT | XFS_ATTR_SECURE)

I kind of dislike that idea because it seems like a lot of overkill to
keep the two namespace bits separate from the actual attr entry flags,
but maybe we need it...

--D
