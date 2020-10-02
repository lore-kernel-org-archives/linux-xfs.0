Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C38C4363C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 17:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629812085B
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 17:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V4Pny/PF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgJBR6V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 13:58:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBR6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 13:58:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092HtWuU118922;
        Fri, 2 Oct 2020 17:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wOW9FtpZhpdHP1UiRjUHifV8zxWmFXtvfXVkbXwwrFU=;
 b=V4Pny/PFeqL6ElO2RJfaPe7FsvMY1gYhMxQ/lQSfD7JD3Nr0ft8NyBR7S69djhiubnAN
 xz5aHBefMSY5Ylh7UI0/UVrad0VQPrzaNwC4tR25v+C9Gx3BqBv7aMCE5d30ka+fw9ik
 iLtUCVONOD7LMFBmtDJ3hCvxHrg2SKh9u3niw8oMG4yybY+JKdkfO/ficjkOFAJkKkRs
 QZLCgWGdIbrqzXdMTKiFF91W9r5swXma8OcEwrMYU+k+uKdUXNgkCB0vzobAcld6wEhu
 2GAnRPMQs7/b/P0AFJc6eVbY9JNlT8/huj084dAPHpB8AhLTEoctrbaTEbFReYA/dr0E Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9nm5qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 17:58:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092Hp2bO144037;
        Fri, 2 Oct 2020 17:58:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33uv2jmvky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 17:58:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 092HwBeN023514;
        Fri, 2 Oct 2020 17:58:11 GMT
Received: from localhost (/10.159.250.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 10:58:11 -0700
Date:   Fri, 2 Oct 2020 10:58:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: streamline xfs_getfsmap performance
Message-ID: <20201002175808.GZ49547@magnolia>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia>
 <160161417069.1967459.11222290374186255598.stgit@magnolia>
 <20201002071505.GB32516@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002071505.GB32516@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020131
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 08:15:05AM +0100, Christoph Hellwig wrote:
> On Thu, Oct 01, 2020 at 09:49:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor xfs_getfsmap to improve its performance: instead of indirectly
> > calling a function that copies one record to userspace at a time, create
> > a shadow buffer in the kernel and copy the whole array once at the end.
> > This should speed it up significantly.
> 
> So we save an indirect call and uaccess_enable/disable per entry,
> but pay for it with the cost of a memory allocation (and actually
> using that memory).
> 
> Doesn't seem like an obvious win to me, do you have numbers?

On my 2TB /home partition, the runtime to retrieve 6.4 million fsmap
records drops from 107s to 85s.

It also occurs to me that the current code also copies to userspace
while holding the AGF buffer lock (or the rt bitmap ilock) which we
shouldn't be doing because the userspace buffer could very well be a
mmap file on the same volume, in which case a page_mkwrite could cause
allocation activity.

Hmm, maybe I should tamp down the allocation behavior too, since we
could just do 64k or pagesize or whatever; userspace can call us back
since we set it up for easy iteration.

--D
