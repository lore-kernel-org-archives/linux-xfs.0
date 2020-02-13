Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C5BC352A4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 02:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 340B920724
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 02:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nJR0vAUR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgBMCBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 21:01:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbgBMCBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 21:01:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1xA5b192204;
        Thu, 13 Feb 2020 02:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YmvH1V1pmiZ1IYHUvm0+xeaaCCq30sjWdv9JD7GKc4s=;
 b=nJR0vAURT99+OnNr8VIRCBIUgRUQKbLGmbQqlmmmiCObrGA4En9lAajQ6IsON5KfKu9q
 HmNddkJ61h5bk6yNxWIQ6PFnOJTLNH7C0WnSgw0tUXR5SZASZ3A8FC5/OQef9PrgaD6b
 dCYdI4r1/1wH3qNEn2KBTplNwRcUFNBv11toIM2FTnBK8m4w/N9XGr3PLQSU+EWBLwte
 A08XJ0YWpGJ3m+HS+JcW4YswjmR42Cc/l68q/1ihrjDLScDEmepHZLRgWP9e59qNSbEX
 mXX9vwhcUmdAz5FRlnzOdHQqpl62+GQU5THeOGecOCzOh4Uu6ock56C06fIQXkC0VSCx +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y2p3spfwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 02:01:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1vtZn184324;
        Thu, 13 Feb 2020 01:59:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y4k7xsmhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 01:59:07 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01D1x7dv021017;
        Thu, 13 Feb 2020 01:59:07 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 17:59:06 -0800
Date:   Wed, 12 Feb 2020 17:59:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: refactor quota exceeded test
Message-ID: <20200213015904.GB6870@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784108138.1364230.6221331077843589601.stgit@magnolia>
 <b979d33d-361b-88cd-699c-7e5f1c621698@sandeen.net>
 <20200213014121.GX6870@magnolia>
 <d7682836-77ae-bd1d-14ff-4365fbb022da@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7682836-77ae-bd1d-14ff-4365fbb022da@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 07:52:30PM -0600, Eric Sandeen wrote:
> On 2/12/20 7:41 PM, Darrick J. Wong wrote:
> > On Wed, Feb 12, 2020 at 05:51:18PM -0600, Eric Sandeen wrote:
> >> On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Refactor the open-coded test for whether or not we're over quota.
> >>
> >> Ooh, nice.  This was horrible.
> 
> ...
> 
> >>> +}
> >>> +
> >>>  /*
> >>>   * Check the limits and timers of a dquot and start or reset timers
> >>>   * if necessary.
> >>> @@ -117,6 +128,8 @@ xfs_qm_adjust_dqtimers(
> >>>  	struct xfs_mount	*mp,
> >>>  	struct xfs_disk_dquot	*d)
> >>>  {
> >>> +	bool			over;
> >>> +
> >>>  	ASSERT(d->d_id);
> >>>  
> >>>  #ifdef DEBUG
> >>> @@ -131,71 +144,47 @@ xfs_qm_adjust_dqtimers(
> >>>  		       be64_to_cpu(d->d_rtb_hardlimit));
> >>>  #endif
> >>>  
> >>> +	over = xfs_quota_exceeded(&d->d_bcount, &d->d_blk_softlimit,
> >>> +			&d->d_blk_hardlimit);
> >>>  	if (!d->d_btimer) {
> >>> -		if ((d->d_blk_softlimit && (be64_to_cpu(d->d_bcount) > be64_to_cpu(d->d_blk_softlimit))) ||
> >>> -		    (d->d_blk_hardlimit && (be64_to_cpu(d->d_bcount) > be64_to_cpu(d->d_blk_hardlimit)))) {
> >>> +		if (over) {
> >>
> >> I wonder why we check the hard limit.  Isn't exceeding the soft limit
> >> enough to start the timer?  Unrelated to the refactoring tho.
> > 
> > Suppose there's only a hard limit set?
> 
> then you get EDQUOT straightaway and timers don't matter?

Hm.  Maybe the idea here was that you always start the timer even if you
just hard-failed the operation?  So that we don't have to deal with
weird cases where timers don't always get started?

> I guess if you set a soft limit after you go over a hard-limit-only and ...
> meh, ain't broke don't fix?

"Behavior changes should be not be in refactoring patches"? :)

> -Eric
> 
