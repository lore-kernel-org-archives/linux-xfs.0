Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 00:29:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6E7SsC5003357
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 00:28:55 -0700
Message-ID: <487B019B.9090401@sgi.com>
Date: Mon, 14 Jul 2008 17:34:51 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: xfs bug in 2.6.26-rc9
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Mikael Abrahamsson wrote:
> On Fri, 11 Jul 2008, Dave Chinner wrote:
> 
>> That aside, what was the assert failure reported prior to the oops? 
>> i.e. paste the lines in the log before the ---[ cut here ]--- line? 
>> One of them will start with 'Assertion failed:', I think....
> 
> These ones?
> 
> Jul  8 04:44:56 via kernel: [554197.888008] Assertion failed: whichfork 
> == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, 
> line: 5879
> Jul  9 03:25:21 via kernel: [42940.748007] Assertion failed: whichfork 
> == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, 
> line: 5879

	xfs_ilock(ip, XFS_IOLOCK_SHARED);

	if (whichfork == XFS_DATA_FORK &&
		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
		error = xfs_flush_pages(ip, (xfs_off_t)0,
					       -1, 0, FI_REMAPF);
		if (error) {
			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
		return error;
		}
	}

	ASSERT(whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0);

This is a race between xfs_fsr and a mmap write.  xfs_fsr acquires the
iolock and then flushes the file and because it has the iolock it doesn't
expect any new delayed allocations to occur.  A mmap write can allocate
delayed allocations without acquiring the iolock so is able to get in
after the flush but before the ASSERT.

> 
> I'll happily rebuild the kernel without the debug option and do 
> xfs_check to weed out any possible logical problem with the volume, if 
> you don't need any further information from the current state of my volume.
> 
> I should also say that this assert failue happened two nights in a row 
> so I guess it's fairly reproducible (didn't happen on the 10th, and 
> today, the 11th it seems to have panic:ed around 03:30 (I start the 
> defragmentation via cron at 03:00) which I think is related.
> 
