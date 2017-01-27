Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43376 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933204AbdA0Pnt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jan 2017 10:43:49 -0500
Subject: Re: [PATCH 2/2] xfs: use per-AG reservations for the finobt
References: <1485335667-22435-1-git-send-email-hch@lst.de>
 <1485335667-22435-3-git-send-email-hch@lst.de>
 <c4b1428d-6861-5290-d108-043ecbfeb1b1@sandeen.net>
 <20170127145930.GA14983@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <96908d89-882a-e1b9-5283-3c9502fdface@sandeen.net>
Date: Fri, 27 Jan 2017 09:43:45 -0600
MIME-Version: 1.0
In-Reply-To: <20170127145930.GA14983@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: darrick.wong@oracle.com, bfoster@redhat.com, linux-xfs@vger.kernel.org

On 1/27/17 8:59 AM, Christoph Hellwig wrote:
> On Thu, Jan 26, 2017 at 11:08:00PM -0600, Eric Sandeen wrote:
>> This seems to cause regressions for me, at least on generic/108, xfs/004
> 
> xfs/004 isn't really broken, it just needs a change every time we
> tune some reservations.   I've been pondering to just drop that
> sub-check.

Ok yeah, I realized that this morning, sorry for the noise.
 
> I can't run generic/108 as it requires a modular scsi_debug, and
> none of my test setups uses modular kernels, so I'm curious on how
> that could get broken by this change.

I'll keep looking to be sure it's legit.  It didn't really make sense
to me either, but ... yup, i'm seeing it.  the fsync error doesn't
come through as expected.  I'll keep looking into it.

oh, btw:

>     Note that this could increase mount times with large finobt trees.  In
>     an ideal world we would have added a field for the number of finobt
>     fields to the AGI, similar to what we did for the refcount blocks.
>     We should do add it next time we rev the AGI or AGF format by adding
>     new fields.

maybe should stick a comment in there as a reminder? :)

-Eric
