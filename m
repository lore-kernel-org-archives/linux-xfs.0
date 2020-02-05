Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEDBC352A2
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 16:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDEAB217BA
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 16:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xAkIiemF";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BWkqe8Gh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgBEQX5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 11:23:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgBEQX5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 11:23:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015GNfG3055101;
        Wed, 5 Feb 2020 16:23:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=J/fES2Y5R94gR/eUkZh9IEGoNdWhxMpx8GqM1eCQF0Y=;
 b=xAkIiemFF1QfOTIOCk4xpI5jgTzQX0RezgqIJiFATbsNlQJ3mbToFsin1rhQY3/sB2Oj
 DaiigIi6NZvlNfDDfnvT2GUf2pt2803eColsd6vtFvkwPLIimNZrDeAmRejKOADEDBC/
 6KvBJhvhpYo+Mz2b5bF8twne999qHId0TlaKgvoym3vP/AhkFJ1i6qTQcGIQlu6slGeH
 h0Ky2AiVFpE8inxxrbSbBxlV4jaMFKYWkUn/YOAVBuRCDHvTICtGNhvtPOnTkmgVA6Wl
 xCR3c8OkcnEf3dywpecDqdll3QcGPZR6d3CuqatCjvh32RWnwo/lk64uwynskvM/+pSc 2w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=J/fES2Y5R94gR/eUkZh9IEGoNdWhxMpx8GqM1eCQF0Y=;
 b=BWkqe8GhhgnJnFWZwBFUzBtC7QCjs9/KPpfVx9HqUhjDqQSMbwkwY28WulDc3B0nbxqR
 6XMPE1Zj6HqCElj2e6En3NXFKZhtfiAlOFZC5LBMajJpybeRsiVWVlBn+m2Qo4D1CY3q
 rlOc/EnVb9K/VsidgZReq61HQsQzFpW9XUROM7B5jDgC7p/SdcyMIp+IphncDVcfoFTS
 eassApviR0ricniX/qROqv6oc/GfrP46kkdCXw5BGX/zYybouMWOAv9UU7pUubgZG7ot
 gD75uOCC0pGxChETyrVJfUAWhO3wqBcFOp0ej/8Tzt9ns3gpfrqnOCyn0X0RZeYIHVx3 Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xykbp44jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 16:23:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015GNlpw058703;
        Wed, 5 Feb 2020 16:23:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xymut3ngs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 16:23:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 015GNF1w032560;
        Wed, 5 Feb 2020 16:23:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Feb 2020 08:23:14 -0800
Date:   Wed, 5 Feb 2020 08:23:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: refactor calls to xfs_admin
Message-ID: <20200205162313.GE6869@magnolia>
References: <158086094707.1990521.17646841467136148296.stgit@magnolia>
 <158086095320.1990521.15734406558551927388.stgit@magnolia>
 <CAOQ4uxjYZGAMXy+PVpyCr9+hiWt7BrmruLgsG7s2w7Z-4pfpAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjYZGAMXy+PVpyCr9+hiWt7BrmruLgsG7s2w7Z-4pfpAg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 05, 2020 at 08:35:05AM +0200, Amir Goldstein wrote:
> On Wed, Feb 5, 2020 at 2:02 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Create a helper to run xfs_admin on the scratch device, then refactor
> > all tests to use it.
> 
> all tests... heh overstatement :)

"all tests that use xfs_admin"?

> Maybe say something about how logdev is needed as argument and
> supported only since recent v5.4 xfsprogs.
> Does older xfsprogs cope well with the extra argument?

Prior to 5.4, xfs_admin will reject the logdev argument and exit; and
if you try to work around it by constructing the xfs_db command by hand,
xfs_db will reject the filesystem because the log device isn't
specified.

IOWs, prior to 5.4 it just plain didn't work at all.

--D

> Thanks,
> Amir.
> 
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/config |    1 +
> >  common/xfs    |    8 ++++++++
> >  tests/xfs/287 |    2 +-
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> >
> >
> > diff --git a/common/config b/common/config
> > index 9a9c7760..1116cb99 100644
> > --- a/common/config
> > +++ b/common/config
> > @@ -154,6 +154,7 @@ MKSWAP_PROG="$MKSWAP_PROG -f"
> >  export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
> >  export XFS_REPAIR_PROG="$(type -P xfs_repair)"
> >  export XFS_DB_PROG="$(type -P xfs_db)"
> > +export XFS_ADMIN_PROG="$(type -P xfs_admin)"
> >  export XFS_GROWFS_PROG=$(type -P xfs_growfs)
> >  export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
> >  export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
> > diff --git a/common/xfs b/common/xfs
> > index 706ddf85..d9a9784f 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -218,6 +218,14 @@ _scratch_xfs_db()
> >         $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
> >  }
> >
> > +_scratch_xfs_admin()
> > +{
> > +       local options=("$SCRATCH_DEV")
> > +       [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > +               options+=("$SCRATCH_LOGDEV")
> > +       $XFS_ADMIN_PROG "$@" "${options[@]}"
> > +}
> > +
> >  _scratch_xfs_logprint()
> >  {
> >         SCRATCH_OPTIONS=""
> > diff --git a/tests/xfs/287 b/tests/xfs/287
> > index 8dc754a5..f77ed2f1 100755
> > --- a/tests/xfs/287
> > +++ b/tests/xfs/287
> > @@ -70,7 +70,7 @@ $XFS_IO_PROG -r -c "lsproj" $dir/32bit
> >  _scratch_unmount
> >
> >  # Now, enable projid32bit support by xfs_admin
> > -xfs_admin -p $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_admin failed"
> > +_scratch_xfs_admin -p >> $seqres.full 2>&1 || _fail "xfs_admin failed"
> >
> >  # Now mount the fs, 32bit project quotas shall be supported, now
> >  _qmount_option "pquota"
> >
