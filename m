Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A199C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 230F721702
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EC69B7AW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgGQBFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:05:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgGQBFg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:05:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06H12RIB189330;
        Fri, 17 Jul 2020 01:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uF2VJ0wR2l6xrtMj7AUn7bZSlgUYOQPcByKM0JKgxYQ=;
 b=EC69B7AWdEFoYgRhTVfIzD5JUDoCa2aNyOE4JRgKIWXN5Q/vvXJwj8llyeICTzbbjyC0
 Fl4qSjodKoV9LLYPsjm0Nb+prSc6NiNWHBxGm/yRunIf95HasD7A8tlNAiGP029vGaLX
 4nfQccD7TnBLdZruHaHA50sYyP+9iMEw6iBGz3JGjZuQlYsGaNjRpGa83B5XdJgAj0Xe
 iXEey+4zwGUPZMqHk01SZGcYXY24lPIab3OQaVNUiX1y2o7Beg0vRinK8WVWNCCnP9M4
 32zcMaMXHm1mgg0hmAuPK0TJMXkKj0DMznoM4MbWwj5Jy8fThKXRgsYHj0Tlsoer+aU7 bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274urmkj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 01:05:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06H140Ex069046;
        Fri, 17 Jul 2020 01:05:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qbd340g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 01:05:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06H15Vxk021810;
        Fri, 17 Jul 2020 01:05:31 GMT
Received: from localhost (/10.159.154.157)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jul 2020 18:05:31 -0700
Date:   Thu, 16 Jul 2020 18:05:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: improve ondisk dquot flags checking
Message-ID: <20200717010528.GK3151642@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488198306.3813063.16348101518917273554.stgit@magnolia>
 <20200717001359.GW2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717001359.GW2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 10:13:59AM +1000, Dave Chinner wrote:
> On Wed, Jul 15, 2020 at 11:46:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create an XFS_DQTYPE_ANY mask for ondisk dquots flags, and use that to
> > ensure that we never accept any garbage flags when we're loading dquots.
> > While we're at it, restructure the quota type flag checking to use the
> > proper masking.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_dquot_buf.c |   11 ++++++++---
> >  fs/xfs/libxfs/xfs_format.h    |    2 ++
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> Ok, I looked at this and questioned why it existed and why the
> code didn't just use XFS_DQTYPE_REC_MASK directly. I think this
> change exists because you plan on adding a new on-disk flag for
> bigtime support and hence XFS_DQTYPE_ANY will grow to include the
> new flag, right?

Correct.

> If so, can you add that to the commit message?

Ok, will do.

--D

> Code looks fine assuming I've understood this correctly...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
