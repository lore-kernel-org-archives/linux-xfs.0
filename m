Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21CAC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFA27206C2
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QpKe9AwN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfIPV0Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 17:26:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfIPV0Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 17:26:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GL3tBt171466;
        Mon, 16 Sep 2019 21:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=18OSvA7Ja4GH1BvHVUEPJg5SBXaVxEF9yYGA1NL6cno=;
 b=QpKe9AwNu8zk2ZL5nRBdTYP/R3F5ZDXnsXl89BcWnGjqi7YlEwnToEW5gq38RqUqoatn
 T50wlyAKwvv3JOVRmVQO+CW6aswie0CJbgAdtNKp1WlYIFcEusLj3Id813erBVgbZImv
 w9QmhQgtMjhBzITADIePU3h2gTppqkExxeALWuf8X1jSxCCrd2ALF5iibJ4VCpZWGTxO
 F69Bi8JkuNQJOsQHhZ5BYkvG2/Ddh3Tkv9C9gDxKtShhKLHUO7GkqU2acckRCzm4b0K5
 vDfxao3j8s0tm99qJk6tlVm1OltQrmr3G1mb6/mgUXotUPzDeT8Pi7UaI0loGmqDOac3 Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v0r5pa6h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 21:26:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GL4WoA139206;
        Mon, 16 Sep 2019 21:26:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v0nb5ddqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 21:26:20 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8GLQJQm022596;
        Mon, 16 Sep 2019 21:26:19 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 14:26:18 -0700
Date:   Mon, 16 Sep 2019 14:26:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_scrub: separate internal metadata scrub functions
Message-ID: <20190916212618.GN2229799@magnolia>
References: <156774080205.2643094.9791648860536208060.stgit@magnolia>
 <156774082719.2643094.12163874100429393033.stgit@magnolia>
 <20190910001933.GI16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910001933.GI16973@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160205
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160205
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 10, 2019 at 10:19:33AM +1000, Dave Chinner wrote:
> On Thu, Sep 05, 2019 at 08:33:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor xfs_scrub_metadata into two functions -- one to make a single
> > call xfs_check_metadata, and the second retains the loop logic.  The
> > name is a little easy to confuse with other functions, so rename it to
> > reflect what it actually does: scrub all internal metadata of a given
> > class (AG header, AG metadata, FS metadata).  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Minor nit:
> 
> > +/* Scrub non-inode metadata, saving corruption reports for later. */
> > +static int
> > +xfs_scrub_meta(
> > +	struct scrub_ctx		*ctx,
> > +	unsigned int			type,
> > +	xfs_agnumber_t			agno,
> > +	struct xfs_action_list		*alist)
> > +{
> > +	struct xfs_scrub_metadata	meta = {
> > +		.sm_type		= type,
> > +		.sm_agno		= agno,
> > +	};
> 
> This should be called xfs_scrub_meta_type() because it only
> scrubs the specific type passed into it....

Ok.

> >  /* Scrub metadata, saving corruption reports for later. */
> >  static bool
> > -xfs_scrub_metadata(
> > +xfs_scrub_meta_type(
> >  	struct scrub_ctx		*ctx,
> >  	enum xfrog_scrub_type		scrub_type,
> >  	xfs_agnumber_t			agno,
> >  	struct xfs_action_list		*alist)
> >  {
> > -	struct xfs_scrub_metadata	meta = {0};
> >  	const struct xfrog_scrub_descr	*sc;
> > -	enum check_outcome		fix;
> > -	int				type;
> > +	unsigned int			type;
> >  
> >  	sc = xfrog_scrubbers;
> >  	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
> > +		int			ret;
> > +
> 
> And this should be called xfs_scrub_all_metadata() because it
> walks across all the metadata types in the filesystem and calls
> xfs_scrub_meta_type() for each type to scrub them one by one....

Ok.  I think I'll update the comments for both to make it clearer what
"type" means.

--D

> Other than that, it looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
