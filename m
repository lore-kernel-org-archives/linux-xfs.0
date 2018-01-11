Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35332 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932068AbeALABA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 19:01:00 -0500
Date: Thu, 11 Jan 2018 15:59:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/27] xfs_scrub: create an abstraction for a block device
Message-ID: <20180111235924.GK5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520352472.2027.8375038586822233334.stgit@magnolia>
 <a4228240-76f6-5f43-cecf-5bd7d572bfcb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4228240-76f6-5f43-cecf-5bd7d572bfcb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 05:24:58PM -0600, Eric Sandeen wrote:
> On 1/5/18 7:52 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ...
> 
> > +/*
> > + * Disk Abstraction
> > + *
> > + * These routines help us to discover the geometry of a block device,
> > + * estimate the amount of concurrent IOs that we can send to it, and
> > + * abstract the process of performing read verification of disk blocks.
> > + */
> > +
> > +/* Figure out how many disk heads are available. */
> > +static unsigned int
> > +__disk_heads(
> > +	struct disk		*disk)
> > +{
> > +	int			iomin;
> > +	int			ioopt;
> > +	unsigned short		rot;
> > +	int			error;
> > +
> > +	/* If it's not a block device, throw all the CPUs at it. */
> > +	if (!S_ISBLK(disk->d_sb.st_mode))
> > +		return nproc;
> > +
> > +	/* Non-rotational device?  Throw all the CPUs. */
> > +	rot = 1;
> > +	error = ioctl(disk->d_fd, BLKROTATIONAL, &rot);
> > +	if (error == 0 && rot == 0)
> > +		return nproc;
> 
> I needed
> 
> +#ifndef BLKROTATIONAL
> +#define BLKROTATIONAL _IO(0x12,126)
> +#endif
> 
> to make this compile on my not /that/ ancient (?) rhel6 box ;)

Hmm... well, since I don't see backporting xfs kernel scrub to 2.6.32
maybe xfsprogs' build system should just turn off xfs_scrub on old
systems?

In any case, I #ifdef BLKROTATIONAL'd out the entire clause.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
