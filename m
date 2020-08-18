Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A187FC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E09520738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JirsxOR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHRXKq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:10:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRXKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 19:10:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IN7t6j185505;
        Tue, 18 Aug 2020 23:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=F1wxF4lQU9Ys6QLdMO39GB5XoYcNA1c80w2D6QxOTtM=;
 b=JirsxOR41zpIHdJjkl7te5Do1Kl+AUjbbGB0vvEK5IWd9ndRbaw5QSlqti0xVQWM1vOK
 Ob3Y2ann+UqAnHk2kvqL5sgeBfL47Hrzj+md2BLXge8biuC/I3r0GHl0AMOiAdjk0hrS
 0Ak1qtn//gutAj21VtwTOgnyHIyT+YsIBbNa9EY+yhM9wJT+zs7tGSK3iccmvy8EnX8E
 KN0xlAPbl2zX73GJlo0IMyn7ncbx5iqyKxbqp93B8YmKwHa6JxtfoTO0BaJfFI2kIv99
 Iep+iKGfhNdQXy6Uj0ZihHSrM8luXTeB3/vuPhQSuHJZVe2WlmAOZR7ou1Tb6DvaIcEI YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bn7m97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 23:10:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IN8wIN130013;
        Tue, 18 Aug 2020 23:10:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsmxtj3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 23:10:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07INAZFq013979;
        Tue, 18 Aug 2020 23:10:36 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 16:10:35 -0700
Date:   Tue, 18 Aug 2020 16:10:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH v2 00/11] xfs: widen timestamps to deal with y2038
Message-ID: <20200818231033.GO6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <20200818230121.GC21744@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818230121.GC21744@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 09:01:21AM +1000, Dave Chinner wrote:
> On Mon, Aug 17, 2020 at 03:56:48PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This series performs some refactoring of our timestamp and inode
> > encoding functions, then retrofits the timestamp union to handle
> > timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
> > to the non-root dquot timer fields to boost their effective size to 34
> > bits.  These two changes enable correct time handling on XFS through the
> > year 2486.
> 
> A bit more detail would be nice :)

Heh, ok.

> Like, the inode timestamp has a range of slightly greater than 2^34
> because 10^9 < 2^30. i.e.
> 
> Inode timestamp range in days:
> 
> $ echo $(((2**62 / (1000*1000*1000) / 86400) * 2**2))
> 213500
> $
> 
> While the quota timer range in days is:
> $ echo $(((2**34 / 86400)))
> 198841
> $
> 
> There's ~15,000 days difference in range here, which in years is
> about 40 years. Hence the inodes have a timestamp range out to
> ~2485 from the 1901 epoch start, while quota timers have a range
> out to only 2445 from the epoch start.

Quota timers have always treated the d_{b,i,rtb}timer value as an
unsigned 32-bit integer, which means that it has /never/ been possible
to set a timer expiration before 1/1/1970.  The quota timer range is
therefore 198,841 days *after* 1970, not after 1901.

Therefore, the quota timer range in days is:

$ echo $(( ((2**34) + (2**31)) / 86400) ))
223696

So, technically speaking, the quota timers could go beyond 2486, but the
current patchset clamps the quota counters to the same max as the
inodes.  I guess I just proved the need for more details upfront.

--D

> 
> Some discussion of the different ranges, the problems it might cause
> and why we don't have to worry about it would be appreciated :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
