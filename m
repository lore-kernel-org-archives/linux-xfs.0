Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50314 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932484AbdHVLNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 07:13:25 -0400
Date: Tue, 22 Aug 2017 13:13:22 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Support for data CRC
Message-ID: <20170822111322.jt66qlzvalsiju6n@breakpoint.cc>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <20170821230232.GS10621@dastard>
 <20170822055136.GA2697@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170822055136.GA2697@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 2017-08-21 22:51:36 [-0700], Christoph Hellwig wrote:
> On Tue, Aug 22, 2017 at 09:02:32AM +1000, Dave Chinner wrote:
> > On Mon, Aug 21, 2017 at 09:04:15PM +0200, Sebastian Andrzej Siewior wrote:
> > > Hi,
> > > 
> > > my understanding is that only metadata is protected by CRC in the new
> > > on-disk format. Are there any plans to also protect data?
> > 
> > Not in XFS.
> 
> I had at least some customer interest in it, although not in the short
> term.  Now that we have reflink we can do the required copy on write
> mechanisms, but I've not done any more detailed analysis of potential
> implementations yet.

copy on write. So the data crc is dead / not possible / not wanted or
part of copy on write?

Sebastian
