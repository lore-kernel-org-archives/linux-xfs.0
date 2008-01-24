Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 18:06:57 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0O26isL022620
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 18:06:47 -0800
Date: Thu, 24 Jan 2008 13:06:56 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS file system corrupted beyond repair?
Message-ID: <20080124020656.GE155259@sgi.com>
References: <4f52331f0801230915p1d3c4c3ala010d9066addb411@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f52331f0801230915p1d3c4c3ala010d9066addb411@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Fong Vang <sudoyang@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 23, 2008 at 09:15:49AM -0800, Fong Vang wrote:
> One of our servers cannot mount an XFS file system after reboot.  xfs_check
> and xfs_repair cannot fix the problem.  Both indicate that there are no
> valid superblock can be found.

What happened before the reboot?

FWIW, is this on a md block device? If so, did it reconstruct correctly?

To find out what is in the superblock, can you post the output
of 'xfs_db -r -c "sb 0" -c p <dev>'?

Also, it could be instructive to see the exact errors check and
repair were outputting. Can you post the output of failing
xfs_repair/xfs_check?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
