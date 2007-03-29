Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 02:58:45 -0700 (PDT)
Received: from atrey.karlin.mff.cuni.cz (atrey.karlin.mff.cuni.cz [195.113.31.123])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2T9wc6p016037
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 02:58:39 -0700
Date: Thu, 29 Mar 2007 11:34:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
Message-ID: <20070329093400.GB14616@atrey.karlin.mff.cuni.cz>
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com> <460A6298.4040702@j-o-a.de> <460A821B.4080308@sandeen.net> <460AC857.6040305@j-o-a.de> <460B068C.6060903@tlinx.org> <460B25BE.3050808@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460B25BE.3050808@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <lkml@tlinx.org>
Cc: Oliver Joa <oliver@j-o-a.de>, Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

> Oliver Joa wrote:
> >>eason or another, xfs has detected a corrupted on-disk inode format 
> >>which it cannot recognize, and shuts down.
> ----
> Oh, one other thing that may not apply in your case, but may.
> Does your SATA disk support write caching?  Does it support
> something called a barrier function?  (not real clear on all
> the ways this can go wrong, but I believe barriers are supposed
> to guarantee previous data has been fixed on disk (not in write
> cache).  If the SATA controller issues a reset, it may very well
> purge the write cache.  Theoretically, I can think of a _possibility_,
> that the reset disk would purge the write cache and the barrier
> indicator would tell xfs to resume writing.  From a recent thread
> on the xfs list, it would appear this could be a "bad" thing (like
> crossing the streams ala "ghostbusters", but in a data-integrity
> context).
  As far as I can remember, barrier does not mean that data is fixed on
disk. It is only a command that forces all the writes before the barrier
to be performed before all the writes after the barrier. So this is more
an ordering restriction than a data integrity thing...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
