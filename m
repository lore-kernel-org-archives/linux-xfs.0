Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E51C3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 23:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4370622CED
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 23:40:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sU6dsZ8x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfICXkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 19:40:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfICXkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 19:40:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NckBZ009263;
        Tue, 3 Sep 2019 23:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7YLWe2rAbu4YL4rdGNPAV+/nwitQljiZIsggDRIACTQ=;
 b=sU6dsZ8xXsSlvN6XEMHFj+PvYjJSsiERodPiCdZ1aJ/E0ezsBaIljB+A0xAwRz0fRtiQ
 8LYxGGHYAfOb9AftO3CVLIClaDbVSl3EeNKO5oMDuug0BOCCXZ//t7OHNLPtlfVSO7pe
 wVSflJZl0zBXwQ/EM8q7wcnVrFiDkiei9/OcJgmHCpyUNT4DUxW7qPYsgqe+s9BF5+gY
 XuznlPjcPcAdtV5/sThDw6WOxPhhZhqX5d5a3yUYYCshuR0CA1JILCAeVw/dfFQ3y/Qf
 +ghKzQwy+LffKK8Fx1IffSWu0QjtlDyGqY/+PAtYbXQn/CF41LAfBivU1R9KjwcLoxzR LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ut1xeg0nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:40:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NcYqJ008531;
        Tue, 3 Sep 2019 23:40:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ut1hmh4kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:40:27 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83NePYr026367;
        Tue, 3 Sep 2019 23:40:26 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 16:40:24 -0700
Date:   Tue, 3 Sep 2019 16:40:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 1baa2800e62d
Message-ID: <20190903234023.GJ568270@magnolia>
References: <20190831193917.GA568270@magnolia>
 <20190901073311.GA13954@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901073311.GA13954@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030238
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030238
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 01, 2019 at 12:33:11AM -0700, Christoph Hellwig wrote:
> On Sat, Aug 31, 2019 at 12:39:17PM -0700, Darrick J. Wong wrote:
> > Dave Chinner (13):
> >       [0ad95687c3ad] xfs: add kmem allocation trace points
> >       [d916275aa4dd] xfs: get allocation alignment from the buftarg
> >       [f8f9ee479439] xfs: add kmem_alloc_io()
> 
> Btw, shouldn't these go into 5.3-rc?  Linus also mentioned to me in a
> private mail that he is going to do a -rc8 due to his travel schedule,
> so we'd at least have some soaking time.

/me shrugs -- it's been broken for years, apparently, and we've been
arguing with almost no action for months.  Developers who are building
things off of 5.3 should probably just add the patch (or turn off slub
debugging)....

--D
