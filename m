Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfEBQws (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 May 2019 12:52:48 -0400
Date: Thu, 2 May 2019 18:52:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502165244.GB14995@kroah.com>
References: <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
 <20190502114440.GB21563@kroah.com>
 <20190502132027.GF11584@sasha-vm>
 <20190502141025.GB13141@kroah.com>
 <20190502152736.GW2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502152736.GW2780@tuebingen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: Sasha Levin <sashal@kernel.org>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, stable@vger.kernel.org

On Thu, May 02, 2019 at 05:27:36PM +0200, Andre Noll wrote:
> On Thu, May 02, 16:10, Greg Kroah-Hartman wrote
> > Ok, then how about we hold off on this patch for 4.9.y then.  "no one"
> > should be using 4.9.y in a "server system" anymore, unless you happen to
> > have an enterprise kernel based on it.  So we should be fine as the
> > users of the older kernels don't run xfs.
> 
> Well, we do run xfs on top of bcache on vanilla 4.9 kernels on a few
> dozen production servers here. Mainly because we ran into all sorts
> of issues with newer kernels (not necessary related to xfs). 4.9,
> OTOH, appears to be rock solid for our workload.

Great, but what is wrong with 4.14.y or better yet, 4.19.y?  Do those
also work for your workload?  If not, we should fix that, and soon :)

I would _STRONGLY_ recommend moving of of 4.9 on any non-SoC-based
system at this point in time, there should not be any reason to stick
with it, unless you are paying a company to provide support for it.

thanks,

greg k-h
