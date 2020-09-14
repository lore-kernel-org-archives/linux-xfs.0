Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405FAC43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 21:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F089E208B3
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 21:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q1rhguVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgINVM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 17:12:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgINVM4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 17:12:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08ELAKmb167657;
        Mon, 14 Sep 2020 21:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QxLeAY7TBRhgaVioyflN043SBjVb3icuSay6m4wkE7M=;
 b=Q1rhguVZCEy5TxnPipZoOTV+EOQk8M1aKXYf2KLjqWw2d7mO5bhjFmwahWeG4jEomQI0
 V8ItDExsNHA7+6YwekMIY0KZXCZnA7T6p0o4uBF+KmynXvXlMcGEG7FKtPHY5F7K7M7y
 nLFWgcHDiFacRVL3QqJyvXrrz2UCtwVc6n791Vh/Bqfr4YoZ5gRaRgWlnvy7hiutvxjR
 vq7CbY0GlpfZsUmPjA4DiFjtZWTlp9Ka/WUrbvfnsT/2zPhyRgg4Wp6LBGqY1Hn4qwFt
 rGP0uyRSurXms4HkQCmQJzeb7NwOhLeZjQrFcjhOsYepQpejKDiTDODZnKxT/aLYWerG jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dasfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Sep 2020 21:12:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EL4fff019702;
        Mon, 14 Sep 2020 21:12:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h88wqeg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 21:12:44 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08ELCh7X022865;
        Mon, 14 Sep 2020 21:12:43 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Sep 2020 21:12:42 +0000
Date:   Mon, 14 Sep 2020 14:12:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <20200914211241.GA7955@magnolia>
References: <20200911164311.GU7955@magnolia>
 <20200914072909.GC29046@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914072909.GC29046@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009140165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 08:29:09AM +0100, Christoph Hellwig wrote:
> On Fri, Sep 11, 2020 at 09:43:11AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The V4 filesystem format contains known weaknesses in the on-disk format
> > that make metadata verification diffiult.  In addition, the format will
> > does not support dates past 2038 and will not be upgraded to do so.
> > Therefore, we should start the process of retiring the old format to
> > close off attack surfaces and to encourage users to migrate onto V5.
> > 
> > Therefore, make XFS V4 support a configurable option.  For the first
> > period it will be default Y in case some distributors want to withdraw
> > support early; for the second period it will be default N so that anyone
> > who wishes to continue support can do so; and after that, support will
> > be removed from the kernel.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v3: be a little more helpful about old xfsprogs and warn more loudly
> > about deprecation
> > v2: define what is a V4 filesystem, update the administrator guide
> 
> Whie this patch itself looks good, I think the ifdef as is is rather
> silly as it just prevents mounting v4 file systems without reaping any
> benefits from that.
> 
> So at very least we should add a little helper like this:
> 
> static inline bool xfs_sb_is_v4(truct xfs_sb *sbp)
> {
> 	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
> 		return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
> 	return false;
> }
> 
> and use it in all the feature test macros to let the compile eliminate
> all the dead code.

Oh, wait, you meant as a means for future patches to make various bits
of code disappear, not just as a weird one-off thing for this particular
patch?

I mean... maybe we should just stuff that into the hascrc predicate,
like Eric sort of implied on irc.  Hmm, I'll look into that.

--D
