Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD80C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 17:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9267C20665
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 17:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S1MKJWXo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfIRRHN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 13:07:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32848 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfIRRHM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 13:07:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGwkhH052783;
        Wed, 18 Sep 2019 17:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=AeIi/vCkl+0jzzPp4n8BQe1gP1zyirwgiRHhL5QKB/g=;
 b=S1MKJWXo9mcpONgsJB67JPn6/xEex2sPtEbGgJ7eR2lYaG7jhxJ+NMYs2iBZLeYPs7Yc
 VnByPsxUwQ6N+ICGcd+mUE1z5bSDJZaZ8QEnt3oj+Covl4+c3+XTHxxAztIKqWhFnmSY
 leZSq4SZTLc4v2uO8MJyKk8kX3GvZm6GHM7tMGtS74GKwOJQrtTfIDimzQwrN8rIo29n
 Cf4PanSNlCCUe1iHW3w6Z0GTpmNhykaYjVXPUgkAZNwa18ExbWuiXrEYEEvYavgJ23YF
 b3lx/UNA24YrakDEtIIEeq8DQ+YXnAFBMAhtw0Uj+sQPaHVU5j9FiZAqQmxh1eTFApE4 OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v385dwbja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 17:06:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGx5bT006314;
        Wed, 18 Sep 2019 17:06:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v37mnc96r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 17:06:53 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IH6qjf023142;
        Wed, 18 Sep 2019 17:06:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 10:06:52 -0700
Date:   Wed, 18 Sep 2019 10:06:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: shortcut xfs_file_release for read-only file
 descriptors
Message-ID: <20190918170651.GY2229799@magnolia>
References: <20190916122041.24636-1-hch@lst.de>
 <20190916122041.24636-3-hch@lst.de>
 <20190916125323.GC41978@bfoster>
 <20190918165000.GB19316@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918165000.GB19316@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=752
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=832 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 06:50:00PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 16, 2019 at 08:53:23AM -0400, Brian Foster wrote:
> > Didn't Dave have a variant of this patch for dealing with a
> > fragmentation issue (IIRC)? Anyways, seems fine:
> 
> I don't really remember one.  But maybe Dave can chime in.

He did[1], but IIRC the discussion petered out because we didn't have a
good way to measure the long term fragmentation effects of doing this.
I sent in a second patch[2] that only trimmed posteof blocks the first
time a file is closed, which reduced fragmentation dramatically on
workloads where there are a lot of synchronous open-append-close writes
(e.g. logging daemons).

None of that stuff ever got merged, so maybe it's time to revisit these.

--D

[1] https://lore.kernel.org/linux-xfs/20190207050813.24271-2-david@fromorbit.com/
[2] https://lore.kernel.org/linux-xfs/155259894034.30230.7188877605950498518.stgit@magnolia/
