Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022D4C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 20:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5DE20723
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 20:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UqZD14cq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgEVUnR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 16:43:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42844 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730946AbgEVUnP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 16:43:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MKcXPm149064;
        Fri, 22 May 2020 20:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=quI2zEc1mVlKqo7MOUVtLur/RjisA9Xl2MQru5ETCoQ=;
 b=UqZD14cqanSTf8g5Re/I286sgYOTxi84PYNeT69jEB7z1JkywfnVZRzrnAGjTCVL44zT
 rdoqwiz9BRRD6VEbFnPQUuCVW8T2IPpQw1tZuIKYo+Z4SV+N28GgWZqB5qAwhAqf9KLh
 TojCh0jjuqMxk3f8ppmoTCu0aIGHazQf1mw2VeMcHi8JcgkDxrsoB0olaiiTsF0z/+N5
 BF5mv4NB8/okHBmE2tddImRu4erV8fjh0QfM4NJtMmIISvEpk4w7anDjwqH2CvwYVGKq
 KKKOGEgYI9+qutd/QXZE1O4+mVwT+mt+tYClbloMdGIrQ0QoRcYwvkMAxv2tP3d5jeFG Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krqr9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 20:43:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MKcbp0190645;
        Fri, 22 May 2020 20:43:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 314gmbsn2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 20:43:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MKh9We009064;
        Fri, 22 May 2020 20:43:09 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 13:43:09 -0700
Date:   Fri, 22 May 2020 13:43:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Dave Airlie <airlied@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: lockdep trace with xfs + mm in it from 5.7.0-rc5
Message-ID: <20200522204308.GC8230@magnolia>
References: <CAPM=9tyy5vubggbcj32bGpA_h6yDaBNM3QeJPySTzci-etfBZw@mail.gmail.com>
 <20200521231312.GJ17635@magnolia>
 <20200522003027.GC2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522003027.GC2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 10:30:27AM +1000, Dave Chinner wrote:
> On Thu, May 21, 2020 at 04:13:12PM -0700, Darrick J. Wong wrote:
> > [cc linux-xfs]
> > 
> > On Fri, May 22, 2020 at 08:21:50AM +1000, Dave Airlie wrote:
> > > Hi,
> > > 
> > > Just updated a rawhide VM to the Fedora 5.7.0-rc5 kernel, did some
> > > package building,
> > > 
> > > got the below trace, not sure if it's known and fixed or unknown.
> > 
> > It's a known false-positive.  An inode can't simultaneously be getting
> > reclaimed due to zero refcount /and/ be the target of a getxattr call.
> > Unfortunately, lockdep can't tell the difference, and it seems a little
> > strange to set NOFS on the allocation (which increases the chances of a
> > runtime error) just to quiet that down.
> 
> __GFP_NOLOCKDEP is the intended flag to telling memory allocation
> that lockdep is stupid.
> 
> However, it seems that the patches that were in progress some months
> ago to convert XFS to kmalloc interfaces and using GFP flags
> directly stalled - being able to mark locations like this with
> __GFP_NOLOCKDEP was one of the main reasons for getting rid of all
> the internal XFS memory allocation wrappers...

Question is, should I spend time adding a GFP_NOLOCKDEP bandaid to XFS
or would my time be better spent reviewing your async inode reclaim
series to make this go away for real?

(Dang, now that I phrase it that way, Imma go read that series.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
