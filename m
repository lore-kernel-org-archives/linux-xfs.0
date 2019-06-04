Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37278 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfFDRZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 13:25:44 -0400
Date: Tue, 4 Jun 2019 10:25:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: use bios directly in the log code v2
Message-ID: <20190604172531.GA1200449@magnolia>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603173506.GC5390@magnolia>
 <20190603173816.GA2162@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603173816.GA2162@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:38:16PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 03, 2019 at 10:35:06AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 03, 2019 at 07:29:25PM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series switches the log writing and log recovery code to use bios
> > > directly, and remove various special cases from the buffer cache code.
> > > Note that I have developed it on top of the previous series of log item
> > > related cleanups, so if you don't have that applied there is a small
> > 
> > Hmm, /I/ don't have that applied. :/
> > 
> > Can you resend that series in its current form with (or without) all the
> > suggested review cleanups, please? :)
> 
> Actually that sentence above is stale.  It applied to v1, but not v2
> or this v3.

I assume you're going to resubmit the other log item cleanup series at
some point, right? :)

--D
