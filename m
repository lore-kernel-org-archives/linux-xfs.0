Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33047 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750817AbdIIHGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 03:06:53 -0400
Date: Sat, 9 Sep 2017 17:06:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
Message-ID: <20170909070649.GJ17782@dastard>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
 <81dc9410-c9d1-20d3-65a6-6763d31b64b7@sandeen.net>
 <2418689.2OC4k4y5ao@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2418689.2OC4k4y5ao@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Sat, Sep 09, 2017 at 12:11:35PM +0530, Chandan Rajendra wrote:
> On Friday, September 8, 2017 10:25:26 PM IST Eric Sandeen wrote:
> > On 9/5/17 12:44 AM, Chandan Rajendra wrote:
> > > Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> > > physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> > > physical sector size of loop devices. On ppc64, this causes loop devices
> > > to have 64k as the physical sector size.
> > > 
> > > With these changes, mkfs.xfs now prints error messages when filesystem
> > > blocksize (4k) is less than underlying device's physical
> > > sectorsize (64k). These messages (printed on stderr) now cause several
> > > xfstests to fail on ppc64 machine since xfstests' _filter_mkfs() isn't
> > > able to filter out stderr.
> > > 
> > > Also, the messages themselves describe a possible sub-optimal setup. But
> > > the setup is still usable.
> > > 
> > > Hence this commit removes the calls to fprintf() used to print the
> > > messages.
> > 
> > So, it looks like the loop change is getting reverted, right ... still -
> > 
> > Although I suggested this change, I'm rethinking it.  I'm not a fan
> > of the warning for a default situation; the user can get this warning
> > with nothing but a bare mkfs, which is not good IMHO.
> > 
> > (dchinner OTOH thinks we should warn about this suboptimal situation
> > in any case - but I really don't think it's mkfs's job to be warning
> > about every suboptimal geometry - there are a lot of them out there!)
> > 
> > What I'd now propose is that we change this warning into a failure,
> > but only if a too-small block size was actually /specified/, i.e.
> > bsflag is set.  If we're adjusting sector size based on device geometry
> > and /default/ blocksize, I think we should just shut up about it.
> > 
> > i.e. something like:
> > 
> >                 if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
> 
> I agree with your changes from a system administrator's perspective. But
> without these messages, the sectorsize change for the loop device would 
> most likely not have been noticed.
> 
> > 			if (bsflag) {
> 
> Just FYI, We should also be checking blflag's value.

Just FYI, my mkfs series reworks this piece of code completely so
there aren't any flags to check.... :P

And given that we are planning on having config file overrides of
default mkfs values, we need to keep this warning even on default
configurations because the distro/site specific default blocksize in
the config file may trigger this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
