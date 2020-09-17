Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC5EC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 17:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33BA6208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 17:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DFowoCdK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgIQRor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 13:44:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgIQRnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 13:43:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFjBDc113795;
        Thu, 17 Sep 2020 16:04:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=d73m7uS8G6+jWeZJMZFeOQgtSU+yH+vD8bd+fqiBmUE=;
 b=DFowoCdKu9jamTuiAXvOiN/i9hgnob/0aKqjMCDubUwZeuLZExibvTCyuutmVbAyWvGN
 pcSQZMPi6nGwuHB1xtpWlrKvgOZX/cCacrw1nOZuMH18naZKuGx1E+wxq14YjUdnpxDU
 /zf6Gx5j3TqnCR1YdrBvVj4gF8CKOyrec41zzYEZtxCSzsCxlDxQRIKaKM3ynGkIawZ3
 wOGPm39m/MRy7eUykrDO1WB35Ls3C4STGi6LTPF1Tmd6VUMiAUoStdhV+CcwgAo9sP2Q
 ltoHgzv2ddgXJ52Eu6EXMLFMbD4SpepJDcVg6oenzgwb07NG4EekcmoQ77AU1HcQDszp vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9mj76d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 16:04:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFkLgi067186;
        Thu, 17 Sep 2020 16:04:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33khpn9m78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 16:04:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HG4E8P025968;
        Thu, 17 Sep 2020 16:04:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 16:04:13 +0000
Date:   Thu, 17 Sep 2020 09:04:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 21/24] common/rc: teach _scratch_mkfs_sized to set a size
 on an xfs realtime volume
Message-ID: <20200917160412.GC7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013430895.2923511.7033338053997588353.stgit@magnolia>
 <20200917080054.GQ26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917080054.GQ26262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 09:00:54AM +0100, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 06:45:08PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Generally speaking, tests that call _scratch_mkfs_sized are trying to
> > constrain a test's run time by formatting a filesystem that's smaller
> > than the device.  The current helper does this for the scratch device,
> > but it doesn't do this for the xfs realtime volume.
> > 
> > If fstests has been configured to create files on the realtime device by
> > default ("-d rtinherit=1) then those tests that want to run with a small
> > volume size will instead be running with a huge realtime device.  This
> > makes certain tests take forever to run, so apply the same sizing to the
> > rt volume if one exists.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/rc |   10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index f78b1cfc..b2d45fa2 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -976,14 +976,20 @@ _scratch_mkfs_sized()
> >  	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
> >      fi
> >  
> > +    if [ "$HOSTOS" == "Linux" ] && [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
> > +	local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
> > +	[ "$fssize" -gt "$rtdevsize" ] && _notrun "Scratch rt device too small"
> > +	rt_ops="-r size=$fssize"
> > +    fi
> 
> The indentation here looks rather weird.  I also don't think we need
> the HOSTOS check.

<nod> it's copy-pastaing the clause above it.  I guess I could just send
an indentation cleanup for that, since it's a bit fugly.

--D

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
