Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF68CC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA71206F7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CzV1LGn1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgHXCia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:38:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgHXCi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 22:38:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2ZILO095809;
        Mon, 24 Aug 2020 02:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=c/2ofQx276N6lqjqIpB+jG75+KnvssLZiJ9/4RK5No0=;
 b=CzV1LGn1kP3v1uCM9RjGf5/uKY0GDBku6u6hQOgq2copE5s/W+PqIkWFSEiXPP8B8C5z
 Jlag0pJRoGLT1rvlq8d9give6YzlBOyEUzBBuX1+5h9ntl3PzuARfMFLZLMHSmsNv7f7
 uESRRGB5oFkaf3ut5mvc/RJEp+/ryfBoFYpKHrP77bFJHhqdXUa1i+gZgO8biJq9QxpF
 U/rUTsPHTNNdKpW0DPAeu7sICIg/tv7QUdfAw/SMIvkdqeRI/HQWLO6WzmxvCsxkNIP7
 tyMCJOwGFEm9j+hUxAi6MA+qQrH0O1y53Sf98LoBSg6Nj7dwvGS8YPAzKdN9JY5StIIL cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6tgkm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 02:38:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2ZBSi063898;
        Mon, 24 Aug 2020 02:38:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 333r9gm9td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 02:38:23 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07O2cLru028742;
        Mon, 24 Aug 2020 02:38:22 GMT
Received: from localhost (/10.159.140.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Aug 2020 19:38:21 -0700
Date:   Sun, 23 Aug 2020 19:38:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 09/11] xfs: refactor quota timestamp coding
Message-ID: <20200824023819.GR6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594823.965217.2346364691307432620.stgit@magnolia>
 <20200822073356.GI1629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822073356.GI1629@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008240009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 22, 2020 at 08:33:56AM +0100, Christoph Hellwig wrote:
> > +/* Convert an on-disk timer value into an incore timer value. */
> > +void
> > +xfs_dquot_from_disk_timestamp(
> > +	struct xfs_disk_dquot	*ddq,
> > +	time64_t		*timer,
> > +	__be32			dtimer)
> > +{
> > +	*timer = be32_to_cpu(dtimer);
> > +}
> > +
> > +/* Convert an incore timer value into an on-disk timer value. */
> > +void
> > +xfs_dquot_to_disk_timestamp(
> > +	struct xfs_dquot	*dqp,
> > +	__be32			*dtimer,
> > +	time64_t		timer)
> > +{
> > +	*dtimer = cpu_to_be32(timer);
> 
> Why not return the values?

I'll fix those return vlaues too.

--D
