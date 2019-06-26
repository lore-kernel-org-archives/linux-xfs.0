Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZPKi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 11:10:38 -0400
Date: Wed, 26 Jun 2019 08:09:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs cgroup writeback support
Message-ID: <20190626150958.GB5171@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
 <20190625032527.GF1611011@magnolia>
 <20190625100532.GE1462@lst.de>
 <20190626055701.GA5171@magnolia>
 <20190626055732.GA23631@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626055732.GA23631@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Wed, Jun 26, 2019 at 07:57:32AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 25, 2019 at 10:57:01PM -0700, Darrick J. Wong wrote:
> > That may be, but I don't want to merge this patchset only to find out
> > I've unleashed Pandora's box of untested cgroupwb hell... I /think/ they
> > fixed all those problems, but it didn't take all that long tracing the
> > blkg/blkcg object relationships for my brain to fall out. :/
> 
> c'mon.  We are adding handful of line patch to finally bring XFS in
> line with everyone else.  That doesn't mean we want to take over
> cgroup maintenance.

I didn't want us to take over maintenance of copy_file_range and the
remap ioctls either, but now look.  /me burns out on cleaning up new
features that haven't been adequately specified and tested and having to
retrofit sane behavior into existing userspace ABI; and I wouldn't be
shocked to hear Dave and Amir probably feel similarly.

<frown>

That said, I did go digging further into how cgroup writeback accounting
works and AFAICT the things people were complaining about in the last
three attempts to add cgroupwb support to xfs have been solved, so I
guess I'm fine with the series:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
