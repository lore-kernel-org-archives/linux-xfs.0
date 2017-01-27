Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51674 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932793AbdA0R0r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jan 2017 12:26:47 -0500
Subject: Re: [PATCH 2/2] xfs: use per-AG reservations for the finobt
References: <1485335667-22435-1-git-send-email-hch@lst.de>
 <1485335667-22435-3-git-send-email-hch@lst.de>
 <c4b1428d-6861-5290-d108-043ecbfeb1b1@sandeen.net>
 <20170127145930.GA14983@lst.de>
 <96908d89-882a-e1b9-5283-3c9502fdface@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3ca70fec-5af6-6ef3-4bfd-ae00d6efe719@sandeen.net>
Date: Fri, 27 Jan 2017 11:26:46 -0600
MIME-Version: 1.0
In-Reply-To: <96908d89-882a-e1b9-5283-3c9502fdface@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: darrick.wong@oracle.com, bfoster@redhat.com, linux-xfs@vger.kernel.org

On 1/27/17 9:43 AM, Eric Sandeen wrote:

> I'll keep looking to be sure it's legit.  It didn't really make sense
> to me either, but ... yup, i'm seeing it.  the fsync error doesn't
> come through as expected.  I'll keep looking into it.

Ok finally had time to actually look.  generic/108 is doing IO
across a stripe and failing one disk; it seems that the reservations
have moved the IO pattern in such a way that the fsync'd IO
does not hit the disk that failed, so the fsync succeeds.

If I bump up the write prior to the fsync frmo 6M to 8M, it fails
again as expected.

So I'm not quite sure how a 6M write on a 4M stripe device
doesn't hit the failing device, but a larger IO makes the test
fail again - so I'll chalk this up to a problematic assumption
in the test, not a problem with the patch.

Thanks,
-Eric
