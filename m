Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbfAHUyZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jan 2019 15:54:25 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Broken dio refcounting leads to livelock?
References: <20190108002633.GL12689@magnolia> <20190108074644.GX4205@dastard>
        <20190108200803.GS12689@magnolia>
Date: Tue, 08 Jan 2019 15:54:23 -0500
In-Reply-To: <20190108200803.GS12689@magnolia> (Darrick J. Wong's message of
        "Tue, 8 Jan 2019 12:08:03 -0800")
Message-ID: <x49tvii7tvk.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> It looks like we're issuing two bios to satisfy a particular dio.
> However, the first bio completes before the submitter calls finish_plug??
>
> I guess this means that blk_start_plug no longer plugs up io requests,
> which means that the end_io function tries to wake up the submitter
> before it's even had a chance to issue the second bio.

blk_start_plug was always a hint.  If you exceed a certain number of
requests (BLK_MAX_REQUEST_COUNT, which is 16) or a certain size of
request (BLK_PLUG_FLUSH_SIZE, which is 128k), the block layer will flush
the plug list.

> This is surprising to me, because I was under the impression that
> blk_{start,finish}_plug held all the bios so there was no chance that
> any of them would issue (let alone call end_io) before finish_plug.

Definitely not the case.  The plug list is just a performance
optimization.

Cheers,
Jeff
