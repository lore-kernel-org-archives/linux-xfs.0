Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC03C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 22:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91FCE207A6
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 22:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgL3WD4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Dec 2020 17:03:56 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:55927 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgL3WD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Dec 2020 17:03:56 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id E120910F522;
        Thu, 31 Dec 2020 09:03:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kujYl-001O8b-EZ; Thu, 31 Dec 2020 09:03:11 +1100
Date:   Thu, 31 Dec 2020 09:03:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Extreme fragmentation ho!
Message-ID: <20201230220311.GB164134@dread.disaster.area>
References: <20201221215453.GA1886598@onthe.net.au>
 <20201228220622.GA164134@dread.disaster.area>
 <20201230062836.GA2695485@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230062836.GA2695485@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=EO0W1A00QF6H6c12Q88A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 30, 2020 at 05:28:36PM +1100, Chris Dunlop wrote:
> On Tue, Dec 29, 2020 at 09:06:22AM +1100, Dave Chinner wrote:
> > On Tue, Dec 22, 2020 at 08:54:53AM +1100, Chris Dunlop wrote:
> > > The file is sitting on XFS on LV on a raid6 comprising 6 x 5400 RPM HDD:
> > 
> > ... probably not that unreasonable for pretty much the slowest
> > storage configuration you can possibly come up with for small,
> > metadata write intensive workloads.
> 
> [ Chris grimaces and glances over at the 8+3 erasure-encoded ceph rbd
> sitting like a pitch drop experiment in the corner. ]

I would have thought that should be able to do more than the 20 IOPS
the raid6 above will do on random 4kB writes.... :)

> Speaking of slow storage and metadata write intensive workloads, what's the
> reason reflinks with a realtime device isn't supported? That was one
> approach I wanted to try, to get the metadata ops running on a small fast
> storage with the bulk data sitting on big slow bulk storage. But:
> 
> # mkfs.xfs -m reflink=1 -d rtinherit=1 -r rtdev=/dev/fast /dev/slow
> reflink not supported with realtime devices

Yup, the realtime device is a pure data device, so all it's metadata
is held externally to the device (i.e. it is held in the "data
device", not the RT device). IOWs, it's a completely separate
filesystem implementation within XFS, and so requires independent
functional extensions to support reflink + rmap...

> My naive thought was a reflink was probably "just" a block range referenced
> from multiple places, and probably a refcount somewhere. It seems like it
> should be possible to have the range, references and refcount sitting on the
> fast storage pointing to the actual data blocks on the slow storage.

Yes, it is possible, but the current reflink implementation is based
on allocation group internal structures (rmap is the same), and the
realtime device doesn't have these. Hence there are new metadata
structures that need to be added (refcount btrees rooted in inodes,
not fixed location AG headers) and a bunch of new supporting code to
be written. Largely Darrick has done this already, it's just a
problem of review bandwidth and validation time:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

(which also includes realtime rmap support, a whole new internal
metadata inode directory to index all the new inode btrees for the
rt device, etc)

It's a pretty large chunk of shiny new code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
