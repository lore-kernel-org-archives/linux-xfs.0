Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932265AbeALB1S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 20:27:18 -0500
Date: Thu, 11 Jan 2018 17:27:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/27] xfs_scrub: create an abstraction for a block device
Message-ID: <20180112012712.GS5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520352472.2027.8375038586822233334.stgit@magnolia>
 <a4228240-76f6-5f43-cecf-5bd7d572bfcb@sandeen.net>
 <20180111235924.GK5602@magnolia>
 <17af7817-cd57-6aeb-b33e-3df76b5c3f4a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17af7817-cd57-6aeb-b33e-3df76b5c3f4a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 06:04:38PM -0600, Eric Sandeen wrote:
> On 1/11/18 5:59 PM, Darrick J. Wong wrote:
> > On Thu, Jan 11, 2018 at 05:24:58PM -0600, Eric Sandeen wrote:
> ...
> 
> >>> +	/* Non-rotational device?  Throw all the CPUs. */
> >>> +	rot = 1;
> >>> +	error = ioctl(disk->d_fd, BLKROTATIONAL, &rot);
> >>> +	if (error == 0 && rot == 0)
> >>> +		return nproc;
> >>
> >> I needed
> >>
> >> +#ifndef BLKROTATIONAL
> >> +#define BLKROTATIONAL _IO(0x12,126)
> >> +#endif
> >>
> >> to make this compile on my not /that/ ancient (?) rhel6 box ;)
> > 
> > Hmm... well, since I don't see backporting xfs kernel scrub to 2.6.32
> > maybe xfsprogs' build system should just turn off xfs_scrub on old
> > systems?
> > 
> > In any case, I #ifdef BLKROTATIONAL'd out the entire clause.
> 
> ok.  well, other distros are making noise about using bleeding edge progs
> w/ older distro kernels (hence the mkfs config file wishes) so it's probably
> good to consider building against older environments.

<shrug> ok I can patch it in like that...

--D

> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
