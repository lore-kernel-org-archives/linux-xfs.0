Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4519C2D0C3
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F1A20717
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kMMl/NXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfLPQxH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 11:53:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40116 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQxG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 11:53:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBGGdQkn177871;
        Mon, 16 Dec 2019 16:52:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=oH792E1g+c2r1jTYIOSYQuD9bJc7sNwBPaUEDxddHEo=;
 b=kMMl/NXh7R245BYTr/CdHVQk4LF/jaPyBywMc+CQG9Ta6UN43kboBALlYPCyaUh8gAn1
 OE9K5znQgwdHdYU/3QQ/2zfPo6Onm+K6AX6ITa7rP6MKV1iUUOMsEeO5t3nIpMqZ7gj2
 rxS1UcqR8n5+5+kC0aJkfyvSLFZscZayxVPZ430ZHldtuqVSxmcBfI+5RTjGPRnfdjyw
 gbaKz2XA1JXwOjBHh5/BdwheIH4HzcT2NGgivVGoC7xgjOU4mTrYlG2HjumTWV3l3V9X
 vDSyKvuyfamL78pxch2/ZgYkWUOUOlRxTipGIEB4NZFzIX2J6iNZgbZMujub7XYDGcuJ vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcr0t1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 16:52:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBGGdXlg135713;
        Mon, 16 Dec 2019 16:52:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ww98s5uet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 16:52:52 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBGGqoKS002723;
        Mon, 16 Dec 2019 16:52:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Dec 2019 08:52:50 -0800
Date:   Mon, 16 Dec 2019 08:52:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 20/24] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20191216165249.GG99884@magnolia>
References: <20191213204936.3643476-1-arnd@arndb.de>
 <20191213205417.3871055-11-arnd@arndb.de>
 <20191213210509.GK99875@magnolia>
 <CAK8P3a10wQuHGV3c2JYSkLsKLFK8t9fOmpE=fwULe8Aj41Kshg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a10wQuHGV3c2JYSkLsKLFK8t9fOmpE=fwULe8Aj41Kshg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912160146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912160146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 05:45:29PM +0100, Arnd Bergmann wrote:
> On Fri, Dec 13, 2019 at 10:05 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > On Fri, Dec 13, 2019 at 09:53:48PM +0100, Arnd Bergmann wrote:
> > > When building a kernel that disables support for 32-bit time_t
> > > system calls, it also makes sense to disable the old xfs_bstat
> > > ioctls completely, as they truncate the timestamps to 32-bit
> > > values.
> >
> > Note that current xfs doesn't support > 32-bit timestamps at all, so for
> > now the old bulkstat/swapext ioctls will never overflow.
> 
> Right, this patch originally came after my version of the 40-bit
> timestamps that I dropped from the series now.
> 
> I've added "... once the extended times are supported." above now.
> 
> > Granted, I melded everyone's suggestions into a more fully formed
> > 'bigtime' feature patchset that I'll dump out soon as part of my usual
> > end of year carpetbombing of the mailing list, so we likely still need
> > most of this patch anyway...
> 
> What is the timeline for that work now? I'm mainly interested in
> getting the removal of 'time_t/timeval/timespec' and 'get_seconds()'
> from the kernel done for v5.6, but it would be good to also have
> this patch and the extended timestamps in the same version
> just so we can claim that "all known y2038 issues" are addressed
> in that release (I'm sure we will run into bugs we don't know yet).

Personally, I think you should push this whenever it's ready.  Are you
aiming to send all 24 patches as a treewide pull request directly to
Linus, or would you rather the 2-3 xfs patches go through the xfs tree?

The y2038 format changes are going to take a while to push through
review.  If somehow it all gets through review for 5.6 I can always
apply both and fix the merge damage, but more likely y2038 timestamps is
a <cough> 5.8 EXPERIMENTAL thing.

Or later, given that Dave and I both have years worth of unreviewed
patch backlog. :(

> > > @@ -617,6 +618,23 @@ xfs_fsinumbers_fmt(
> > >       return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
> > >  }
> > >
> > > +/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
> > > +static bool xfs_have_compat_bstat_time32(unsigned int cmd)
> >
> > The v5 bulkstat ioctls follow an entirely separate path through
> > xfs_ioctl.c, so I think you don't need the @cmd parameter.
> 
> The check is there to not forbid XFS_IOC_FSINUMBERS at
> the moment, since that is not affected.

Aha.

> > > @@ -1815,6 +1836,11 @@ xfs_ioc_swapext(
> > >       struct fd       f, tmp;
> > >       int             error = 0;
> > >
> > > +     if (xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {
> >
> > if (!xfs_have...()) ?
> 
> Right, fixed now.

<nod>

--D

>        Arnd
