Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C03C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C65F20866
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gAJOz50j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHXQb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:31:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33248 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHXQb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 12:31:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OGThWB138227;
        Mon, 24 Aug 2020 16:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Id9u+5KxjP8gsFfRgQLvETDVss6Qum7OZ8hyI2UGRxs=;
 b=gAJOz50j51XE7XBdooj0QVV2ArGMKFAvHZpEJjSG0ZYKY5IH4M3UiLnpZp1T/lqAKKzF
 4mIff7Eh4dzxM5bk8fftkxSLToYgjUmv/VnpkX1jqA5JT5d/viY95HvcoTixbdQmIBvo
 wGkAeJgyXdriJzcC7w2etRJZLG9uhR9ZI/KhoyrlN1YkaNiAVOur3FP9sO90vPjJ1na1
 JRI9OQTN8I3u0tA8Z6Q4eag2Ct9Wj7M7nVlfEZCwUiawVTrkNIFteybso3KOYpAaq9AM
 8z6PSR8U/4J7OSTSnh91OfHbJPnRqEmuuM7tcpbzmSmgkcgE5R3ah8AFTalHiS3BonFf oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 333dbrnkvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 16:31:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OGQ8pZ191923;
        Mon, 24 Aug 2020 16:29:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 333ru575xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 16:29:46 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07OGTjEA004196;
        Mon, 24 Aug 2020 16:29:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 09:29:45 -0700
Date:   Mon, 24 Aug 2020 09:29:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
Message-ID: <20200824162944.GX6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797589388.965217.3068074933916806311.stgit@magnolia>
 <20200822071218.GA1629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822071218.GA1629@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=1 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 22, 2020 at 08:12:18AM +0100, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index acb9b737fe6b..48a64fa49f91 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -15,6 +15,18 @@
> >  		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
> >  		"expected " #off)
> >  
> > +#define XFS_CHECK_VALUE(value, expected) \
> > +	BUILD_BUG_ON_MSG((value) != (expected), \
> > +		"XFS: value of " #value " is wrong, expected " #expected)
> > +
> > +static inline void __init
> > +xfs_check_limits(void)
> > +{
> > +	/* make sure timestamp limits are correct */
> > +	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
> > +	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> 
> I have to admit I don't get why you'd define a constant and then
> check that it has the value you defined it to.  Seems a little cargo
> cult.

Testing the timestamp min/max is more important for bigtime, since the
supported ranges are not conveniently aligned with S32_MIN/MAX.  But it
felt strange to build-check bigtime without doing the same for !bigtime,
so I included it here for completeness.

--D
