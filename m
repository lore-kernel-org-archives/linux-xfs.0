Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D531EC43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 19:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F6DC21D43
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 19:11:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KTWRFXdf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgIITLm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 15:11:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49816 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIITLl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 15:11:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089J5LfG162147;
        Wed, 9 Sep 2020 19:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XBbk/U11WU6wBMiUFAqHVZdHES2RDbvVjL/L06CU4xQ=;
 b=KTWRFXdfi4u86xhisN21sgnSBZK3bFc5S99KMTHAjZSoHESJJaT3mWyPvBqBsthiUDjV
 g2LJNE0Um0TzklfndF34/JjpQBs0ozIWUPPxBaGupwp57j9VECEraXAJ8VV1viIdkSPH
 AICxC2Gfh+UgROYM/LpIUCbvoJynOkc5i7MBDJh/8shg1JYrXafm8PP8eSw0vwLO6zUJ
 H4DPUjkw1WmA4Xglk2Md/2BA6kjajiB3uplm+39ETTFoYf20aXVDZRPMs5hVNI9HEwWY
 YWFpibobgBh6gpwHfckDxFHl8fdVA7EcCfq6W8ggixlyBTS05Whi2hBiS5EvBZAtCLJ1 XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23r3uub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 19:11:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089JBU54190884;
        Wed, 9 Sep 2020 19:11:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33cmetdpwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 19:11:31 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 089JBKWv019219;
        Wed, 9 Sep 2020 19:11:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 12:11:20 -0700
Date:   Wed, 9 Sep 2020 12:11:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] man: install all manpages that redirect to another
 manpage
Message-ID: <20200909191118.GM7955@magnolia>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950109644.567664.3395622067779955144.stgit@magnolia>
 <20200908143449.GB6039@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908143449.GB6039@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 08, 2020 at 03:34:49PM +0100, Christoph Hellwig wrote:
> On Mon, Sep 07, 2020 at 10:51:36AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Some of the ioctl manpages do not contain any information other than a
> > pointer to a different manpage.  These aren't picked up by the install
> > scripts, so fix them so that they do.
> 
> While the makefile code looks like black magic it works here, so:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> :)

TBH I've wondered why installing manpages isn't a simple matter of
creating the directory and copying the manpages into it, especially
since debuild already knows how to find and compress manpages in
whatever format is the debian default... but the less I have to do with
the rpm builds the better, so I left it alone. ;)

--D
