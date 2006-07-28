Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 22:47:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S5kfDW015071
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 22:46:52 -0700
Date: Fri, 28 Jul 2006 15:45:58 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: fix bulkstat error detection logic
Message-ID: <20060728154558.I2196410@wobbly.melbourne.sgi.com>
References: <20060726102406.I2118045@wobbly.melbourne.sgi.com> <44C9A353.1050702@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44C9A353.1050702@sgi.com>; from tes@sgi.com on Fri, Jul 28, 2006 at 03:40:35PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 28, 2006 at 03:40:35PM +1000, Timothy Shimmin wrote:
> Looks reasonable.
> So you still do the inode buffer validation but we don't print out
> a corruption error msg and we return EINVAL instead of EFSCORRUPTED.

Right.

> Can we not be bulkstat'ing over inodes with reasonable numbers/locations but
> the inode data on disk is just corrupted?

Yes, we can, but we don't want bulkstat to shutdown the filesystem
in that situation.

cheers.

-- 
Nathan
