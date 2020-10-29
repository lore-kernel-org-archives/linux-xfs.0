Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FEEC4741F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 20:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6DBC20759
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 20:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ggoS7ZiV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgJ2U1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:27:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59902 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ2U1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 16:27:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKP98G105560;
        Thu, 29 Oct 2020 20:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CZgaH/yqYkMmjnyoMn2opY2SgpJHlkU2LygKW/dIu/Y=;
 b=ggoS7ZiVbgVUiw6OrfoVaJ32pMpGZi6KCzyJCkpxv6emHTa3hPcrlzec6qZZJ7sIWfEd
 OXzIgyWU1Zw9Bljjh5eVtyTn4uHe1D7eacLnEY0oyrlnkrLMKK3TSlcPYE+v81nF5mpp
 RGq/CHlgDwPgDic6OiJuFJelG4CBW2rKQxeof2LHRytzdUokI7HpNkPDDCrETD5YEgkO
 aVOhQQNZtKRXzg7u6CP8Zx558SrwJYWC6Zn6tWUT1e+xMQrbEijVGGOHcvxcDIsUpZhF
 vc4eaokXJuMKCtjU8HzWXTj43mVbZwFkdvRgKy6OxBUhL0SlJVb9aNxxXIjwkfBDYeKo aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7m6vq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:27:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKKQaA070674;
        Thu, 29 Oct 2020 20:27:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1tn8ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:27:17 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TKRG8O007213;
        Thu, 29 Oct 2020 20:27:16 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:27:16 -0700
Date:   Thu, 29 Oct 2020 13:27:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
Message-ID: <20201029202715.GA1061252@magnolia>
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
 <160382542261.1203756.6377970904886103725.stgit@magnolia>
 <20201029173920.GB1660404@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029173920.GB1660404@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 01:39:20PM -0400, Brian Foster wrote:
> On Tue, Oct 27, 2020 at 12:03:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make the expected AGI size larger for the inobtcount feature.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> It would be nice for the commit log to have a sentence or two about the
> other changes as well, but either way:

I think I'll just make them a separate patch.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  tests/xfs/010     |    3 ++-
> >  tests/xfs/030     |    2 ++
> >  tests/xfs/122.out |    2 +-
> >  3 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/010 b/tests/xfs/010
> > index 1f9bcdff..95cc2555 100755
> > --- a/tests/xfs/010
> > +++ b/tests/xfs/010
> > @@ -113,7 +113,8 @@ _check_scratch_fs
> >  _corrupt_finobt_root $SCRATCH_DEV
> >  
> >  filter_finobt_repair() {
> > -	sed -e '/^agi has bad CRC/d' | \
> > +	sed -e '/^agi has bad CRC/d' \
> > +	    -e '/^bad finobt block/d' | \
> >  		_filter_repair_lostblocks
> >  }
> >  
> > diff --git a/tests/xfs/030 b/tests/xfs/030
> > index 04440f9c..906d9019 100755
> > --- a/tests/xfs/030
> > +++ b/tests/xfs/030
> > @@ -44,6 +44,8 @@ _check_ag()
> >  			    -e '/^bad agbno AGBNO for refcntbt/d' \
> >  			    -e '/^agf has bad CRC/d' \
> >  			    -e '/^agi has bad CRC/d' \
> > +			    -e '/^bad inobt block count/d' \
> > +			    -e '/^bad finobt block count/d' \
> >  			    -e '/^Missing reverse-mapping record.*/d' \
> >  			    -e '/^bad levels LEVELS for [a-z]* root.*/d' \
> >  			    -e '/^unknown block state, ag AGNO, block.*/d'
> > diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> > index cfe09c6d..b0773756 100644
> > --- a/tests/xfs/122.out
> > +++ b/tests/xfs/122.out
> > @@ -113,7 +113,7 @@ sizeof(struct xfs_scrub_metadata) = 64
> >  sizeof(struct xfs_unmount_log_format) = 8
> >  sizeof(xfs_agf_t) = 224
> >  sizeof(xfs_agfl_t) = 36
> > -sizeof(xfs_agi_t) = 336
> > +sizeof(xfs_agi_t) = 344
> >  sizeof(xfs_alloc_key_t) = 8
> >  sizeof(xfs_alloc_rec_incore_t) = 8
> >  sizeof(xfs_alloc_rec_t) = 8
> > 
> 
