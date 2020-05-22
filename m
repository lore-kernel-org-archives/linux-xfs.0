Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD83C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA15207FB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s3Ouu4iG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgEVD4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:56:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43916 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgEVD4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:56:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M3lqVs157590;
        Fri, 22 May 2020 03:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9b54GRLA02xECcpxZKF88+FSqx/BHB6vRpEhQ3ig9Dc=;
 b=s3Ouu4iGEsXscn0EKK04VuXS+pGY1lZTrlHPTq/eMCxQsJ4bKb5HNAkWphjLT2BbkI3r
 Ei9EJrULItsZqKFnAkDg39ap9btHHV2a+yf6zHGpEBj0W5Ij60LBQbaQ51POe+5q7EnC
 6UIZfsUfdwebyOlU0CSCoATdI+m+zm3tlAGHhVG58Y4VTmNcs7oHsIPYgfNsE+PvYT4c
 xwDyGBb325n3/zWGv58ZsbP9MYJgcpzB2bzVJVPGv9vOUfi7I2JoRGQPY7cygwIT9Ihw
 iiKssFB39GukLyjZuCMsyKTie4t/Jep8S0tdZdMgfztrPxPR2uRPQcoqa7sXz9ZgqxcR cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31501rj745-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 03:56:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M3nGU3108693;
        Fri, 22 May 2020 03:56:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 315023jx96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 03:56:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M3u104023666;
        Fri, 22 May 2020 03:56:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 20:56:01 -0700
Date:   Thu, 21 May 2020 20:56:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200522035600.GA8233@magnolia>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011600308.76931.7853207930055232164.stgit@magnolia>
 <20200522033102.GD2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522033102.GD2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:31:02PM +1000, Dave Chinner wrote:
> On Thu, May 21, 2020 at 07:53:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When writing to a delalloc region in the data fork, commit the new
> > allocations (of the da reservation) as unwritten so that the mappings
> > are only marked written once writeback completes successfully.  This
> > fixes the problem of stale data exposure if the system goes down during
> > targeted writeback of a specific region of a file, as tested by
> > generic/042.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Observation: yesterday I forced a 4kB file create workload
> to use unwritten extents by setting an extent size hint. That caused
> about 4,500 xfs-conv kworker threads to be spawned by the workload
> which had 16 userspace processes creating files...
> 
> I expect that any sort of "create lots of small files" worklaod is
> going to cause xfs-conv kworker explosions, so be prepared for users
> to start reporting kworker explosions with this in place...

Yes, I've been running this patch internally for months and /so far/ the
conv explosions haven't generated any additional support calls.

(That said, we probably ought to constrain that a bit, there's really no
point in allowing concurrency beyond some unholy mix of AG count and the
estimated iops capacity of the storage...)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
