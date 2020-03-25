Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B3BC1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 05:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9567320714
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 05:53:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q+PPtHWO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgCYFxd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 01:53:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49092 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgCYFxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 01:53:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P5mJvk110448;
        Wed, 25 Mar 2020 05:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fYYk+RLmf8WRljwh6FgXmMeIAgWMVeiBuIr0K/+tGp0=;
 b=q+PPtHWOsDgiEI6XWFREf94xXcX5D8MLXpXl+z0rvAfHU2uWgRKaqaMOfK8er/PKxBMZ
 KJb2jXag2DxRmBREs+mOSJ1C2UbEBiZkUpBOCIsQrA/aMH1RMyAB9VQ0JF0ane1B5BVV
 Jia8esSDC2riRSijIc1DZJ4uk5AZvvUvEPZwJGcWKygumlFQi1D9mfnhEGJ3uUH9GsHA
 TgXNToIGGg15K6kgHJN1mA+S3FTFZiDd/uYdMuuLfdijRPRpVk1COb5aYV5UkCAsHx2G
 aj5OVUvsuFRKDYN+Y4sXrF9Pq1Sjx2QQLs7XZzjxdLspGWHwHc9y/zZy0+JYaqup7BMF DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8ac4usj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 05:53:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P5qSuJ038537;
        Wed, 25 Mar 2020 05:53:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yxw4qtrgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 05:53:30 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P5rTwT006176;
        Wed, 25 Mar 2020 05:53:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 22:53:29 -0700
Date:   Tue, 24 Mar 2020 22:53:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: validate the realtime geometry in
 xfs_validate_sb_common
Message-ID: <20200325055328.GU29339@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
 <158510668306.922633.16796248628127177511.stgit@magnolia>
 <20200325050028.GG10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325050028.GG10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 04:00:28PM +1100, Dave Chinner wrote:
> On Tue, Mar 24, 2020 at 08:24:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Validate the geometry of the realtime geometry when we mount the
> > filesystem, so that we don't abruptly shut down the filesystem later on.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c |   35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 2f60fc3c99a0..dee0a1a594dc 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -328,6 +328,41 @@ xfs_validate_sb_common(
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > +	/* Validate the realtime geometry; stolen from xfs_repair */
> > +	if (unlikely(
> > +	    sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE	||
> 
> Whacky whitespace before the ||
> 
> > +	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)) {
> > +		xfs_notice(mp,
> > +			"realtime extent sanity check failed");
> > +		return -EFSCORRUPTED;
> > +	}
> 
> We really don't need unlikely() in code like this. the compiler
> already considers code that returns inside an if statement as
> "unlikely" because it's the typical error handling pattern, for
> cases like this it really isn't necessary.
> 
> 
> > +
> > +	if (sbp->sb_rblocks == 0) {
> > +		if (unlikely(
> > +		    sbp->sb_rextents != 0				||
> > +		    sbp->sb_rbmblocks != 0				||
> > +		    sbp->sb_rextslog != 0				||
> > +		    sbp->sb_frextents != 0)) {
> 
> Ditto on the unlikely and the whitespace. That code looks weird...
> 
> 		if (sbp->sb_rextents || sbp->sb_rbmblocks ||
> 		    sbp->sb_rextslog || sbp->sb_frextents) {
> 
> > +			xfs_notice(mp,
> > +				"realtime zeroed geometry sanity check failed");
> > +			return -EFSCORRUPTED;
> > +		}
> > +	} else {
> > +		xfs_rtblock_t	rexts;
> > +		uint32_t	temp;
> > +
> > +		rexts = div_u64_rem(sbp->sb_rblocks, sbp->sb_rextsize, &temp);
> > +		if (unlikely(
> > +		    rexts != sbp->sb_rextents				||
> > +		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents)	||
> 
> And again.
> 
> At least you're consistent, Darrick :)

Copy-pastaing the weird style of the rest of that function. :)

I'll fix it & resend.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
