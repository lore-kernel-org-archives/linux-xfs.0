Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6A0C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461F02076E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N3nkS0ko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHRPSO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:18:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41732 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgHRPSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:18:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF6tVj127380;
        Tue, 18 Aug 2020 15:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Kf1G9J/Dx5fl5LW5N75rm3GEYrOYVccxpOrGlFQ0lBw=;
 b=N3nkS0ko0YUVINU+gj5GtlbQYXoL2MZcMrfp+F53+ZONPwHE0nm3QCEaTImebq35jkPS
 ihgI2+nPZgPCopFYEr2mnA0sQ0uH3+9rLagSBosclWBCTmGwoQ7YXjWhhJdnb7L8jqJP
 I/6mDUNpjUYmEPisT0rnJg08ddfJEZl6UNxJsR56o2LHrGC+Fuow04lizx7oFnj8sWSA
 9s1wYA7TYfQ4fu9vrzfpGkSMNihTpCjL9GB0bCCD++7J8TDbK+IZaQgkncr+yWtN3Np/
 6HXT1RQmB5KlZJnCsqjLJL85OrhMCj7cec2tiHyCgk+HXtEEfZWOl6rLtEYnp9fEkxMN zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn5d5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:18:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF8ESM003654;
        Tue, 18 Aug 2020 15:18:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfs0cwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:18:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IFI1tc032764;
        Tue, 18 Aug 2020 15:18:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:18:01 -0700
Date:   Tue, 18 Aug 2020 08:18:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Get rid of kmem_realloc()
Message-ID: <20200818151801.GJ6107@magnolia>
References: <20200813142640.47923-1-cmaiolino@redhat.com>
 <20200817065533.GG23516@infradead.org>
 <20200817101716.mmcgbdpkimc6wvl7@eorzea>
 <20200817153922.GJ6096@magnolia>
 <20200818100720.oiwqk3yi2dsvjqav@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818100720.oiwqk3yi2dsvjqav@eorzea>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=893
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=873 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180111
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 12:07:20PM +0200, Carlos Maiolino wrote:
> On Mon, Aug 17, 2020 at 08:39:22AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 17, 2020 at 12:17:16PM +0200, Carlos Maiolino wrote:
> > > On Mon, Aug 17, 2020 at 07:55:33AM +0100, Christoph Hellwig wrote:
> > > > Both patches looks good:
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > although personally I would have simply sent them as a single patch.
> > > 
> > > Thanks Christoph. I have no preference, I just submitted the patches according
> > > to what I was doing, 'remove users, nothing broke? Remove functions', but I
> > > particularly have no preference, Darrick, if the patches need to be merged just
> > > give me a heads up.
> > 
> > Yes, the two patches are simple enough that they ought to be merged.
> 
> Ok, you want me to resend or it's just a heads up for the next time?

Yes please.  You've got plenty of time. :)

(FWIW I'll probably put this in for-next after -rc6, though I guess it
mostly depends on whether or not anyone tries to land any huge patchsets
this cycle that would clash with this...)

--D

> 
> 
> -- 
> Carlos
> 
