Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8C8C43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8607920803
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WDSd4UD6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfLDRmk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:42:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRmk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:42:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4HT156020586;
        Wed, 4 Dec 2019 17:42:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hKsDrEOvHVMhd/rNL2/k2YpEgljl1jt2nv/jhyUoFis=;
 b=WDSd4UD6zS0OKm8AB2n5KPPG0uNokf4MmXvKcDc7//HL9MRi/rfgQmihSEBONbZoYonP
 DzVH9okR3Ra1HrgUBxGh/usf2YBFPpnN0K7C7Ny1sub6s8mJrhZoqga+gwsJVPasrPAZ
 bEsXwzwxyljlW7TkFjtsk9/GDsdlvJpJ0qQg+yfBFE/u4VgcFLFRqGZ5gQecGKFh5Eyd
 PiZ+RWC/314kAKWEG+gexbW6IV779BX1aLagPwKkIWN2srfn7SUjZNiwSf6gvBVikDIs
 /RWi5mOR0aTMke0EFU7wVwiLTAmX3Uys78hV2F48kt1T4v186au2+VyoJK44HxNqJqIE hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wkh2rftvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:42:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4HXmSl181068;
        Wed, 4 Dec 2019 17:42:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wp16bavpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:42:20 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB4HgIET025451;
        Wed, 4 Dec 2019 17:42:19 GMT
Received: from localhost (/10.159.145.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 09:42:18 -0800
Date:   Wed, 4 Dec 2019 09:42:16 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191204174216.GS7335@magnolia>
References: <20191128062139.93218-1-preichl@redhat.com>
 <BYAPR04MB5749DD0BFA3B6928A87E54B086410@BYAPR04MB5749.namprd04.prod.outlook.com>
 <1051488a-7f91-5506-9959-ff2812edc9e1@sandeen.net>
 <20191204172652.GA27507@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204172652.GA27507@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=858
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=921 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 09:26:52AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 04, 2019 at 10:24:32AM -0600, Eric Sandeen wrote:
> > It'd be great to fix this universally in the kernel but it seems like
> > that patch is in discussion for now, and TBH I don't see any real
> > drawbacks to looping in mkfs - it would also solve the problem on any
> > old kernel w/o the block layer change.
> 
> The problem is that we throw out efficiency for no good reason.

True...

> > I'd propose that we go ahead w/ the mkfs change, and if/when the kernel
> > handles this better, and it's reasonable to expect that we're running

How do we detect that the kernel will handle it better?

> > on a kernel where it can be interrupted, we could remove the mkfs loop
> > at a later date if we wanted to.
> 
> I'd rather not touch mkfs if a trivial kernel patch handles the issue.

Did some version of Tetsuo's patch even make it for 5.5?  It seemed to
call submit_bio_wait from within a blk_plug region, which seems way
worse.

--D
