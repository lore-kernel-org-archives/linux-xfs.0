Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35189 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbfE2WUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:20:08 -0400
Date: Thu, 30 May 2019 08:20:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Recurring hand in XFS inode reclaim on 4.10
Message-ID: <20190529222004.GD29573@dread.disaster.area>
References: <CAMCX63xyxZwiPd0602im0M0m4jzSNfB3DcF1RekQ6A-03vXTmg@mail.gmail.com>
 <20190521224904.GI29573@dread.disaster.area>
 <CAMCX63zNvLCDE5ZmY-rUuF7JfL9Uauq4jvzPZuDecovUSnCLNQ@mail.gmail.com>
 <20190527033240.GA29573@dread.disaster.area>
 <CAMCX63wUkBh==QFoeRSTxFKGdoo5iDLS6hM5xcVLK8_LfVdhwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMCX63wUkBh==QFoeRSTxFKGdoo5iDLS6hM5xcVLK8_LfVdhwg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 28, 2019 at 10:16:39AM -0700, Jeffrey Baker wrote:
> On Sun, May 26, 2019 at 8:32 PM Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, May 24, 2019 at 01:34:58PM -0700, Jeffrey Baker wrote:
> > > Write rates on the nvme drives are all exactly the md0 rates / 4, so
> > > that seems normal.
> >
> > Write rates aren't that important - what do the io latencies, queue
> > depths and device utilisation figures look like?
> 
> 10s of microseconds, ~zero, and ~zero respectively.

So it sounds like the devices aren't showing signs of slowness, but
the filesystem and memory reclaim is sitting there twiddling it's
thumbs waiting for IO to complete?

Perhaps it might be worthwhile running a latency trace (e.g. with
ftrace or one of the newfangled bpf tools) to find out where
everything is blocking and how long they are waiting for things to
occur. That might give some more insight into what resource we are
waiting to be released to make progress...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
