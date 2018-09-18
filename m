Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729992AbeIRVCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 17:02:44 -0400
Date: Tue, 18 Sep 2018 08:29:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm-writecache issue
Message-ID: <20180918152935.GA13016@infradead.org>
References: <20180918123238.GI27618@dastard>
 <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
 <alpine.LRH.2.02.1809180934040.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <8975ad6d-bfde-0a50-e60c-59228493f1b2@sandeen.net>
 <d2d949ec-b3b6-cba3-66f8-c225784d5951@sandeen.net>
 <alpine.LRH.2.02.1809181024150.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <b359bcc7-bc76-33cc-30fb-2c8ad2ba4682@sandeen.net>
 <alpine.LRH.2.02.1809181038350.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <b3a162a8-7c2b-8a66-6f11-2abff3381690@sandeen.net>
 <128a77fc-dbcb-278f-115c-da4a3d63e58f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <128a77fc-dbcb-278f-115c-da4a3d63e58f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>

On Tue, Sep 18, 2018 at 10:27:20AM -0500, Eric Sandeen wrote:
> (this may be a bit uninformed on my part, Darrick reminds me that jbd2's
> careful use of cache flushing & FUA probably means that it won't get burned
> by a partial 4k metadata update if the power fails.)

cache flushing and FUA is never going to help you with torn writes.

> 
> I'll stop for now and see if Dave wants to chime in on xfs's reliance on
> the actual atomic IO size for metadata IO.  ;)

What helps todays XFS (and probably ext4) is checksums on all metadata
blocks, as that way we can check if we wrote the full "block".  This
doesn't help applications that rely on the sector size unless they have
similar protections of their own.
