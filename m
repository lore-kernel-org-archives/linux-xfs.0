Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Nov 2006 19:44:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA23hraG015861
	for <xfs@oss.sgi.com>; Wed, 1 Nov 2006 19:43:55 -0800
Date: Thu, 2 Nov 2006 14:42:54 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_growfs after lvextend don't increase mounted size.
Message-ID: <20061102034254.GC11034@melbourne.sgi.com>
References: <4549218B.2020807@mmtab.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4549218B.2020807@mmtab.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Per Mellander <per.m@mmtab.se>
Cc: xfs@oss.sgi.com

On Wed, Nov 01, 2006 at 11:36:59PM +0100, Per Mellander wrote:
> Hi!
> 
> I've got a 6.5TB xfs filesystem on a LVM2 volume. I wanted to increase 
> the size of the fs so I added another ~10TB to the volume. Every step 
> taken was successfull, (ie no errors) but the filesystem size remained 
> unchanged even after the xfs_growfs.

There's a 32 bit overflow in the growfs code (and transaction code
on 32 bit systems) so you can't grow by more than 2TB at a time.
I've got a fix under test for this at the moment.

Can you see if you can grow using:

# xfs_growfs -D <current size + (2TB / FSB) - 1> </path/to/mntpt>

FSB = filesystem block size, and the current size is also in FSB.
You can get both the current size and the FSB from xfs_growfs -n <mtpt>

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
