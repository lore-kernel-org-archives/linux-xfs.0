Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C51C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C92C321582
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:09:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CRy8+4Li"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLQRJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:09:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfLQRJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 12:09:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHH99RF011259;
        Tue, 17 Dec 2019 17:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=Zfn1SnEjyNYLhWcHyNo+1oA/0/fzYUh93RWwaESx+u8=;
 b=CRy8+4LiEMhCwBULcNZGhw1d2mfIkgeuavj0dZj4eJvmbZKN91ubixwwuoBP/12cKJPX
 0T/YCWupKXBpap6S/jlMPpFwyCqwgKu8LNpow+MygLW3oA8DpWlYrd6fJxc8o8KnbXj7
 tegghoOUIMgE8JygZg0TQPjCS+zIq3HQaQhph63V6LSRVx/xIFC7n4+gwtHLX1R09u+0
 GKMdSQ61ypNTfhg6QJL87BtghKGaJ4cpRRrVdSwa2tKTtJjg5PS8txY1E9zI/Zhoo443
 RLeW+idwBDBkYFvDGHgi+ESPoIQK7PPN66fUyUb+BucSx5ku6t2JB+tzL4pZbeobRfdr Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcr7ybp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 17:09:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHH3bBi078398;
        Tue, 17 Dec 2019 17:09:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wxm72pvua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 17:09:07 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBHH97n6009928;
        Tue, 17 Dec 2019 17:09:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 09:09:06 -0800
Date:   Tue, 17 Dec 2019 09:09:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20191217170905.GC12765@magnolia>
References: <20191216215245.13666-1-david@fromorbit.com>
 <20191217115401.GC48778@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191217115401.GC48778@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 06:54:01AM -0500, Brian Foster wrote:
> On Tue, Dec 17, 2019 at 08:52:45AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > gcc 9.2.1 throws lots of new warnings during the build like this:
> > 
> > xfs_format.h:790:3: warning: taking address of packed member of ‘struct xfs_agfl’ may result in an unaligned pointer value [-Waddress-of-packed-member]
> >   790 |   &(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
> >       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > xfs_alloc.c:3149:13: note: in expansion of macro ‘XFS_BUF_TO_AGFL_BNO’
> >  3149 |  agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> >       |             ^~~~~~~~~~~~~~~~~~~
> > 
> > We know this packed structure aligned correctly, so turn off this
> > warning to shut gcc up.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> I'm wondering if we could just use offsetof() in this case so we don't
> have to disable a warning for the entire project, particularly if this
> is triggered by a small number of macros..

...and maybe kill the shouty macro while we're at it. :)

--D

> Brian
> 
> >  include/builddefs.in | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 4700b52706a7..6fdc9ebb70c7 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -13,7 +13,7 @@ OPTIMIZER = @opt_build@
> >  MALLOCLIB = @malloc_lib@
> >  LOADERFLAGS = @LDFLAGS@
> >  LTLDFLAGS = @LDFLAGS@
> > -CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
> > +CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -Wno-address-of-packed-member
> >  BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
> >  
> >  LIBRT = @librt@
> > -- 
> > 2.24.0.rc0
> > 
> 
