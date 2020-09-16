Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF106C35256
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 06:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9422B221EB
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 06:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vBL8lq6t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIPGcW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:32:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgIPGcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 02:32:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G3eVBQ179527;
        Wed, 16 Sep 2020 03:42:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4K2q3HEVLZlgcxDncK5+AWn8OSgFujLQUjz/mYPrKFY=;
 b=vBL8lq6tPhSWbX6hmkT1zPNUd7MznZlZOPGeFc0z2MscHdSuu66ndSMhMMqaJgFamiqH
 eBvSgG1BkpQubS8kyB/LOJ4CgbWUUtM+52rWqOfPm+wGbFZUCYNl0uUzrMDgCnFcGG95
 Y8rJB0RO/40N2Ff6hrhLET3HLxGc2vMZrgnvZ8WT9ljXwxvEcFlJfQ6RlUwDm7jub2gr
 xDKsXhdCsYUwn7kb4RTUYKHSkgBgs08/1i8JB2wQiE2FD3Pxy4scK0I6uR0+PbZqW2HD
 x3u61gnn5w8LKQTkH71i1g+8RXEbZi3hzGcudxLhTcFOZpRhz21gtVLc2pfmdHMLVxWD 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dj6t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 03:42:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G3ei4K061687;
        Wed, 16 Sep 2020 03:42:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33h890kba5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 03:42:02 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08G3g2A8006084;
        Wed, 16 Sep 2020 03:42:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 03:42:02 +0000
Date:   Tue, 15 Sep 2020 20:42:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/24] xfs/070: add scratch log device options to direct
 repair invocation
Message-ID: <20200916034201.GC7954@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013423329.2923511.3252823001209034556.stgit@magnolia>
 <20200916024247.GA2937@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916024247.GA2937@dhcp-12-102.nay.redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=2 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=2 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 10:42:47AM +0800, Zorro Lang wrote:
> On Mon, Sep 14, 2020 at 06:43:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/070 |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/xfs/070 b/tests/xfs/070
> > index 5d52a830..313864b7 100755
> > --- a/tests/xfs/070
> > +++ b/tests/xfs/070
> > @@ -41,9 +41,11 @@ _cleanup()
> >  _xfs_repair_noscan()
> >  {
> >  	# invoke repair directly so we can kill the process if need be
> > +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > +		log_repair_opts="-l $SCRATCH_LOGDEV"
> >  	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
> >  		rt_repair_opts="-r $SCRATCH_RTDEV"
> > -	$XFS_REPAIR_PROG $rt_repair_opts $SCRATCH_DEV 2>&1 |
> > +	$XFS_REPAIR_PROG $log_repair_opts $rt_repair_opts $SCRATCH_DEV 2>&1 |
> >  		tee -a $seqres.full > $tmp.repair &
> 
> Why not use _scratch_xfs_repair at here?
> 
> Thanks,
> Zorro
> 
> >  	repair_pid=$!

        ^^^^^^^^^^^^^
Because this test needs to hang on to the pid of the repair process in
order to kill it, which you can't do if do if you use the wrapper.

--D

> >  
> > 
> 
