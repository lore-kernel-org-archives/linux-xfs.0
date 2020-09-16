Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105CFC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 21:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC81D206D4
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 21:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mgKPL2ua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIPVIC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 17:08:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32778 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgIPVHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 17:07:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GL5FIm157017;
        Wed, 16 Sep 2020 21:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZjMXcRsrsvjEHFqTqgBX1phkrX531Zpn+V13oGidxs0=;
 b=mgKPL2ua9dD+kHq3pu2Hou1ne706NBhmeCbHpSUmxVN8Ldxv1WvDES82uVzyp97W9+fz
 UwzcyvJveW9kBNQKSWQTLOlS7qkOokbFoZRg9I1535h5QxAJZZq9RgfOjz/KEOOjK2g1
 T6DMZyXl0cc12GybseenvqJtPpr1H21VfPFNCE9vOGC3l7oTVMf8TFp+bsDNboi1j/70
 r0iiA4RBwvsKH7yMmZqhEyMMW2es/Amup3Mdh31TlzA4Nxu8jizpBRsL1PPMeImthZKe
 sDSjHIpXJ6JHIE4Rlk2NxIlfe21kp2mM1+rds8Z9yX+MthC4RM0vCz64FfQteogpW+qb uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33gp9mdh1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 21:07:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GL5WwJ163712;
        Wed, 16 Sep 2020 21:07:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h889a56r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 21:07:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GL7mU3022478;
        Wed, 16 Sep 2020 21:07:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 21:07:48 +0000
Date:   Wed, 16 Sep 2020 14:07:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs/194: actually check if we got 512-byte blocks
 before proceeding
Message-ID: <20200916210747.GK7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013427110.2923511.12673259176007024613.stgit@magnolia>
 <20200916113400.GF2937@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916113400.GF2937@dhcp-12-102.nay.redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:34:00PM +0800, Zorro Lang wrote:
> On Mon, Sep 14, 2020 at 06:44:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > This test has specific fs block size requirements, so make sure that's
> > what we got before we proceed with the test.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/194 |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > 
> > diff --git a/tests/xfs/194 b/tests/xfs/194
> > index 9001a146..90b74c8f 100755
> > --- a/tests/xfs/194
> > +++ b/tests/xfs/194
> > @@ -84,6 +84,9 @@ unset XFS_MKFS_OPTIONS
> >  # we need 512 byte block size, so crc's are turned off
> >  _scratch_mkfs_xfs -m crc=0 -b size=$blksize >/dev/null 2>&1
> >  _scratch_mount
> > +test "$(_get_block_size $SCRATCH_MNT)" = 512 || \
> > +	_notrun "Could not get 512-byte blocks"
> > +
> 
> If this case is only for 512 byte blocksize, the "blksize=`expr $pgsize / 8`"
> and all things with the "$blksize" looks redundant, right?

Hmm... in hindsight I shouldn't have hardwired the right hand argument.
This needs only to be a simple equivalence test:

test "$(_get_block_size $SCRATCH_MNT)" = $blksize || \
	_notrun "Could not get $blksize-byte blocks"

Will fix and resend.

--D

> Thanks,
> Zorro
> 
> >  
> >  # 512b block / 4k page example:
> >  #
> > 
> 
