Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7079 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751968AbdC0V60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 17:58:26 -0400
Date: Tue, 28 Mar 2017 08:58:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2 V2] xfs_io: hook up statx
Message-ID: <20170327215822.GH17542@dastard>
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <5245.1490608817@warthog.procyon.org.uk>
 <07e3308b-11a8-90d4-4ac9-96c3c36d3c4a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07e3308b-11a8-90d4-4ac9-96c3c36d3c4a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Howells <dhowells@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 27, 2017 at 12:47:33PM -0500, Eric Sandeen wrote:
> On 3/27/17 5:00 AM, David Howells wrote:
> > Eric Sandeen <sandeen@sandeen.net> wrote:
> > 
> >> These 2 patches are a second pass to add a statx command
> >> to xfs_io in hopes that it will aid creation of xfstests
> >> statx regression tests.
> > 
> > Would it be possible to redirect all the stat() calls made by xfstests to
> > statx() with translation of the output buffer back to struct stat?
> 
> I'm sure LD_PRELOAD tricks could do that, but it'd be a little unusual
> for xfstests, at least - kind of a side hack that's not really expected
> and therefore wouldn't get consistently run.
> 
> Honestly, just write a bash script for xfstests which tests expected
> statx behavior for various inputs, verifies what it can against stat,
> and it's all good...

Don't forget to add it to fsstress and randomise the flag values it
uses...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
