Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49231C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1886E20720
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a6qEhity"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgAZW1H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:27:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58460 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZW1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:27:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMIfsQ045084;
        Sun, 26 Jan 2020 22:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=75kDf/NRuby2znEVD7ohUwAq53U6X0h+ER4pBaVAsa4=;
 b=a6qEhitywXXA64KIjtUKcpYz7SvIbrM9ldxVfuPZAFD2RJXzMJkHMAlqVFdkj3Gy6Nux
 IPyZ42/NUTCcFC9qBxwV+OvtASfL+/LpTXK5IYfTfUeBfwetoEs4EKq0+ikXYhe/rlBY
 fejJLJgDobtFPv7KzqXu0rewGzTiBMUQFzh9DCfBb+Ws8oH52dHPt+icztW89OiA8bJ0
 tx/8lkjAR6DB028WEjeXiXqHWNEFVDp/XfeMbh3eFvKZhve0fqQfFTNeknLfOuwlU7BN
 Nu/gKD6OdG59a75ZDHXk4j3xvavxVSuBYJiSmk5je0LT/lh5JGaqyT2Wc/StXr3XGAWL GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xreaqvccr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:26:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMJb0I159199;
        Sun, 26 Jan 2020 22:24:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xrytnq9qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:24:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00QMOw9W023621;
        Sun, 26 Jan 2020 22:24:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:24:58 -0800
Date:   Sun, 26 Jan 2020 14:24:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 27/29] xfs: clean up the attr flag confusion
Message-ID: <20200126222457.GK3447196@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-28-hch@lst.de>
 <20200121194440.GC8247@magnolia>
 <20200124232413.GB22102@infradead.org>
 <20200125231047.GB15222@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125231047.GB15222@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 25, 2020 at 03:10:47PM -0800, Christoph Hellwig wrote:
> On Fri, Jan 24, 2020 at 03:24:13PM -0800, Christoph Hellwig wrote:
> > > > +	u32			ioc_flags)
> > > > +{
> > > > +	unsigned int		namespace = 0;
> > > > +
> > > > +	if (ioc_flags & XFS_IOC_ATTR_ROOT)
> > > > +		namespace |= XFS_ATTR_ROOT;
> > > > +	if (ioc_flags & XFS_IOC_ATTR_SECURE)
> > > > +		namespace |= XFS_ATTR_SECURE;
> > > 
> > > Seeing as these are mutually exclusive options, I'm a little surprised
> > > there isn't more checking that both of these flags aren't set at the
> > > same time.
> > > 
> > > (Or I've been reading this series too long and missed that it does...)
> > 
> > XFS never rejected the combination.  It just won't find anything in that
> > case.  Let me see if I could throw in another patch to add more checks
> > there.
> 
> So for the get/set ioctl this was all fixed by
> 
> "xfs: reject invalid flags combinations in XFS_IOC_ATTRMULTI_BY_HANDLE"
> 
> for listattr it is rather harmless, but I can throw in a patch to
> explicitly reject it.

I think that's a good idea.

--D
