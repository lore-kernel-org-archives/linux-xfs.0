Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3264EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA122072C
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 00:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YDggkbmd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgESAlH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 20:41:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgESAlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 20:41:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0b42V138241;
        Tue, 19 May 2020 00:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bBJPQ66aGpqdRMx1GdJXq4QiNjnIKaUMcA7zGkCVMkk=;
 b=YDggkbmdM2XnhUOBZFwZhXLoUwL6qB0NwBoQz1LVyd8ms4j14TYXA35pz2Ko6qApEIw0
 Wc9dOXcQecIbtH2dzxcXotlDHtATAEsMc8KptcMcMIQ6RkUGRr3MZfFltEzKZSf8crQv
 MBXX+9v46dPVsg/yuYSS1l6gLKpVt+otlRy4HaLz4IEuECjwE18GoK3u/TH9wDzS5Rb9
 9DXUoCPgwZtic9Sl6N1HzbepAJ9RHk37z+ci9IQY6A9nDdNdF+dMLG6HdBhr4SpBiq1c
 hXrHNLRx70e9uq7CSbEcpDtYvrEeKDoAI9v26bTxq5AWQ3NEk0NSPJnCRkM1INFUPIK2 mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127kr269r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 00:40:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0cLek097488;
        Tue, 19 May 2020 00:40:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 312t3wr2fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 00:40:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04J0erT7030236;
        Tue, 19 May 2020 00:40:53 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 17:40:53 -0700
Date:   Mon, 18 May 2020 17:40:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200519004051.GF17627@magnolia>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
 <20200119204925.GC9407@dread.disaster.area>
 <20200203201445.GA6870@magnolia>
 <20200507103232.GB9003@bfoster>
 <20200514163317.GA6714@magnolia>
 <20200514174448.GE50849@bfoster>
 <20200517074843.GC32627@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517074843.GC32627@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 17, 2020 at 12:48:43AM -0700, Christoph Hellwig wrote:
> On Thu, May 14, 2020 at 01:44:48PM -0400, Brian Foster wrote:
> > It looks like Christoph already reviewed the patch. I'm not sure if his
> > opinion changed it all after the subsequent discussion, but otherwise
> > that just leaves Dave's objection. Dave, any thoughts on this given the
> > test results and broader context? What do you think about getting this
> > patch merged and revisiting the whole unwritten extent thing
> > independently?
> 
> Absolutely no change of mind.  I think we need to fix the issue ASAP
> and then look into performance improvements as soon as we get to it.

Hm, well, I do have a couple more patches to fix a couple of minor
regressions that fstests found...

--D
