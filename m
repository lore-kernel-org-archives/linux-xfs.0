Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D31C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 20:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91890222B6
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 20:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbhAKUqM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 15:46:12 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:44597 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391209AbhAKUqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 15:46:06 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id EC1B41109765;
        Tue, 12 Jan 2021 07:45:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kz441-005ShW-LU; Tue, 12 Jan 2021 07:45:21 +1100
Date:   Tue, 12 Jan 2021 07:45:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Subject: Re: improve sub-block size direct I/O concurrency
Message-ID: <20210111204521.GN331610@dread.disaster.area>
References: <20210111161212.1414034-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161212.1414034-1-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=oqzWlZWtK5bIS3trCDgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:12:09PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series avoids taking the iolock exclusively for direct I/O
> writes that are not file system block size aligned, but also do
> not require allocations or unwritten extent conversion.

I wrote patches to do this yesterday, and ran it through testing
overnight. I made a note that I need to do what your first two
patches do, and this morning I was going to completely separate the
DIO unaligned write path from block aligned write path because
there's almost nothing shared between the two cases.

I already commented that I don't like the approach brian suggested
because of the requirement to cycle the ILOCK and duplicate all the
checks that the IOMAP_NOWAIT case already does in the XFS DIO write
submission code. i.e.  I lift ithe trigger for IOMAP_NOWAIT to the
iomap_dio_rw() caller so that we can use IOMAP_NOWAIT for unaligned
IO, and only if that returns -EAGAIN do we run an exclusive IO. THis
also means that we can run sub-block dio as AIO and under RWF_NOWAIT
conditions without explicitly having to check for these things...

Let me rework what I've done on the top of your first two patches
and test it and I'll send it out later today for comparison.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
