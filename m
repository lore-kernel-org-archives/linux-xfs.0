Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:23252 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfBTXr0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Feb 2019 18:47:26 -0500
Date: Wed, 20 Feb 2019 16:47:24 -0700
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190220234723.GA5999@localhost.localdomain>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
> I think the variability makes life really miserable for layers above it.
> 
> Might be worth constructing some tooling that we can use to validate or
> shame vendors over - testing things like a full device discard, discard of
> fs block size and big chunks, discard against already discarded, etc.

With respect to fs block sizes, one thing making discards suck is that
many high capacity SSDs' physical page sizes are larger than the fs block
size, and a sub-page discard is worse than doing nothing.

We've discussed previously about supporting block size larger than
the system's page size, but it doesn't look like that's gone anywhere.
Maybe it's worth revisiting since it's really inefficient if you write
or discard at the smaller granularity.
