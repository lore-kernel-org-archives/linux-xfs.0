Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C70C2D0C3
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 21:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322C720663
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 21:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XbvcwBFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLXV1j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 16:27:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfLXV1j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 16:27:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOLLRDO079948;
        Tue, 24 Dec 2019 21:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=L5kfHo9IDWLlcQJz77wRukHJslS8eIHJrcUXsSHxlzA=;
 b=XbvcwBFX1B37aSJsqMwKaJR5dc0sY/R+T4uy/dvXeez5pd4f1KsH/vwxg0VinZCEX5Ci
 duaMq8/71upmmQwd+CC2kS/x/4EJjhsUGOmL3yppKKQHLIOE2n4yMwLwVKJzRXpNOuP0
 AN0s9CuMAjW+5iVVt/N9kB7fWRySjARy//YA8fY0Mfc40qSKQW+6xPR23RRr5tJwyslo
 g5HwSPePxhLe9DIXJ2mYV0qm+KxFvIdEQbTTewl3MtKFOviPOzgu/1oL4BD4xpOCz3kj
 uKKc4TCTZ8W5x37hr/yssKfwDo+XCNoh7iCjHXqC3X1TUN/GYWu/XVXgzrsNtis3Qln5 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x1bbpw1hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 21:27:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOLJaw3022724;
        Tue, 24 Dec 2019 21:27:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x3amsrdhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 21:27:26 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBOLRP4l006019;
        Tue, 24 Dec 2019 21:27:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 13:27:25 -0800
Date:   Tue, 24 Dec 2019 13:27:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: make resync with the userspace libxfs easier
Message-ID: <20191224212724.GF7476@magnolia>
References: <20191217023535.GA12765@magnolia>
 <20191224082954.GA20650@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224082954.GA20650@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 12:29:54AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 16, 2019 at 06:35:35PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Prepare to resync the userspace libxfs with the kernel libxfs.  There
> > were a few things I missed -- a couple of static inline directory
> > functions that have to be exported for xfs_repair; a couple of directory
> > naming functions that make porting much easier if they're /not/ static
> > inline; and a u16 usage that should have been uint16_t.
> > 
> > None of these things are bugs in their own right; this just makes
> > porting xfsprogs easier.
> 
> Instead of exporting random low-level helpers can you please look
> into refactoring repair to not require such low level access.  E.g.
> the put_ino helper seems to be mostly used for convert short form
> directories from and to the 8 byte inode format, for which we already
> have kernel helpers in a slighty different form.

We do?  I didn't find /any/ helpers to fix shortform inums and ftype.
xfs_repair directly manipulates a lot of directory structures directly
with libxfs functions.

> I'm also kinda pissed that this was rushed into mainline after -rc2
> despite not fixing anything in the kernel.  That is not how the
> development cycle is supposed to work.

Frankly, I trust you (and everyone else) to know when a kernel patchset
heading upstream is going to require a lot of non-trivial changes to
xfsprogs and to send a patchset to make whatever cleanups to xfsprogs
are necessary and then port the kernel patches.

95% of the time, the API changes are pretty minor, and Eric and I can
just figure it out between the two of us.  The directory refactoring you
sent for 5.5 turned out to involve a lot more work and I didn't want
Eric to be 100% stuck with the burden of figuring out how to apply
everything.

But maybe I should start asking submitters always to send kernel +
xfsprogs patches at the same time.  Allison's been doing that with the
deferred attr patches and it's very helpful not to have to imagine what
the userspace changes will look like.

So anyway, I am sorry for ruffling your feathers.  I am particularly bad
at handling small cleanups to smooth over xfsprogs when reviewers are
short.

--D
