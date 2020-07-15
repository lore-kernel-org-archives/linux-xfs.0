Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF39C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 16:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA17720672
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 16:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DQr4PBTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgGOQ53 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 12:57:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55832 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgGOQ52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 12:57:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FGq9Jx075886;
        Wed, 15 Jul 2020 16:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6RSQ7O3rl364QfIJw4dF8BogajQSrzsLV/OEGwMsOl8=;
 b=DQr4PBTrlhK9kEZbJ6vj6HqqKj6icrxQmlA32Vp2QlwKM2B3ujIvbtptq0xI7/bcvfPm
 P4pm34kfVBH1aAC0VTxGuQ3jQlNr2dhA8tx1zec6cApo/zSnXppbsUl7hyXjsBKgHgR0
 cuqwlZANPa21JD0k1EUfysm2CCj103Lh2rNAYtRfGD5QyPIBRR5OdzTWaDX776B3yPcu
 P8QPM3OwPJ/EmPNSLpJdhD9/7UzxJsLlmMZnOwFDyOJCJAlpEWmUGMzx2UaZ0LXgO0Om
 pDLJSsxaha6/NF/qYG91FvtC3RgtG30LAwOZMBe2t2aF434KxNRcDH9qs7KL08IWz0Xp 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urcnf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 16:57:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FGqiSe166085;
        Wed, 15 Jul 2020 16:57:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qc1b1br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 16:57:25 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FGvO15031140;
        Wed, 15 Jul 2020 16:57:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 09:57:24 -0700
Date:   Wed, 15 Jul 2020 09:57:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/010,030: filter AG header CRC error warnings
Message-ID: <20200715165723.GJ7625@magnolia>
References: <20200713184930.GK7600@magnolia>
 <20200714071346.GY1938@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714071346.GY1938@dhcp-12-102.nay.redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 03:13:46PM +0800, Zorro Lang wrote:
> On Mon, Jul 13, 2020 at 11:49:30AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Filter out the new AG header CRC verification warnings in xfs_repair
> > since these tests were built before that existed.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/010 |    6 +++++-
> >  tests/xfs/030 |    2 ++
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/010 b/tests/xfs/010
> > index c341795d..ec23507a 100755
> > --- a/tests/xfs/010
> > +++ b/tests/xfs/010
> > @@ -113,7 +113,11 @@ _check_scratch_fs
> >  # nuke the finobt root, repair will have to regenerate from the inobt
> >  _corrupt_finobt_root $SCRATCH_DEV
> >  
> > -_scratch_xfs_repair 2>&1 | sed -e '/^bad finobt block/d' | _filter_repair_lostblocks
> 
> I think this patch is based on another patch which hasn't been merged, right?
> Due to I can't find the *sed -e '/^bad finobt block/d'* on current xfstests-dev
> master branch, which HEAD is:
>   aae8fbec  generic/270: wait for fsstress processes to be killed

Oops, yeah, I forgot that my development branch has multiple patches to
those tests.  Now that xfsprogs for-next has updated I guess I should
clean all those up and send them for real.

--D

> Thanks,
> Zorro
> 
> > +filter_finobt_repair() {
> > +	sed -e '/^agi has bad CRC/d' -e '/^bad finobt block/d' | _filter_repair_lostblocks
> > +}
> > +
> > +_scratch_xfs_repair 2>&1 | filter_finobt_repair
> >  
> >  status=0
> >  exit
> > diff --git a/tests/xfs/030 b/tests/xfs/030
> > index 8f95331a..a270e36c 100755
> > --- a/tests/xfs/030
> > +++ b/tests/xfs/030
> > @@ -43,6 +43,8 @@ _check_ag()
> >  			    -e '/^bad agbno AGBNO for rmapbt/d' \
> >  			    -e '/^bad agbno AGBNO for refcntbt/d' \
> >  			    -e '/^bad inobt block count/d' \
> > +			    -e '/^agf has bad CRC/d' \
> > +			    -e '/^agi has bad CRC/d' \
> >  			    -e '/^bad finobt block count/d' \
> >  			    -e '/^Missing reverse-mapping record.*/d' \
> >  			    -e '/^unknown block state, ag AGNO, block.*/d'
> > 
> 
