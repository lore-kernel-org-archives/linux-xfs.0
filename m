Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B1DC34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D835E208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lL+AaqJE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgBSEjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 23:39:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBSEjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 23:39:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4Uwms166369;
        Wed, 19 Feb 2020 04:39:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f8rB3F43sHL9Fso5gjfDq1O2c+zHB0HjGwHmAHsboHM=;
 b=lL+AaqJECxLRh+72oaFx1j5BeQy0fUToxGpjuCF098/9VX+YnzA8DPEX5n9ysrJR7c/K
 lwdvs3mrXb4VswCR+Iv4d4qTuO4I7wRS/FnW4/TWMyTm45GZVYkdjcDJJClF9cSLQvY7
 5/j3RPRrEIuee7yFIWp92KiuO0zagxn8PKnrOP0lvYLBxWwO8KwKkKIY63LPC6OJDevd
 4kXRG8NNFhfGnx/FtlvqPwGp0yp6goSwW499cF5W9vkeZoFlevNtEFpzjdqJhMgZON9M
 WDDwBej946mKvZvGjMz79I8ue6fQ/qbAj7HSYdu3cL89iaJTg4BtZ8y/hc5ZQPMqeHoB 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y8udd0g3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:39:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4RoKW108049;
        Wed, 19 Feb 2020 04:39:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y8ud077hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:39:14 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J4dCNM029446;
        Wed, 19 Feb 2020 04:39:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 20:39:12 -0800
Date:   Tue, 18 Feb 2020 20:39:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] libxfs: return flush failures
Message-ID: <20200219043910.GJ9506@magnolia>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086366333.2079905.16346740147118345650.stgit@magnolia>
 <20200217140023.GN18371@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217140023.GN18371@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 06:00:23AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 04, 2020 at 04:47:43PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Modify platform_flush_device so that we can return error status when
> > device flushes fail.
> 
> The change itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But the existing logic in platform_flush_device looks suspicious.
> Even on a block device fsync is usually the right thing, so we
> should unconditionally do that first.  The BLKFLSBUF ioctl does some
> rather weird things which I'm not sure we really want here, but if we
> do I'd rather see if after we've flushed out the actual data..

BLKFLSBUF flushes the data and then shoots down the page cache, right?
That's certainly odd, but I think (at least as far as old kernels go) we
aren't actively losing data.

However, I agree that we should fsync() files and block devices equally.

--D
