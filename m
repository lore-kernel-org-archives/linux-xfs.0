Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:33889 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdH3OML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:12:11 -0400
MIME-Version: 1.0
In-Reply-To: <20170830134629.GA32355@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com> <20170830134629.GA32355@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Aug 2017 17:12:10 +0300
Message-ID: <CAOQ4uxhqjwZv+H=6RXai2_ap_1OktNje+DtHFR3ZoXoDtxuC0g@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, stable <stable@vger.kernel.org>

On Wed, Aug 30, 2017 at 4:46 PM, Christoph Hellwig <hch@lst.de> wrote:
> Oops.
>
> Yes, except for the case of calling xlog_state_release_iclog
> ourselves we can't claim that the cache has been flushed.  In
> fact I'm not even sure that is save, if ic_refcnt makes
> xlog_state_release_iclog exit early, so we might have to
> pass additional information around there.

With this change, for the multiple fsyncing tasks workload, the majority won't
be optimized, so the remaining code is only really optimizing the single
process doing seldom fsync case.

I wonder if it's worth keeping the optimization around at all?
