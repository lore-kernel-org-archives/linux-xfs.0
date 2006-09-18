Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 15:40:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8IMeEZd028072
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:40:25 -0700
Date: Tue, 19 Sep 2006 08:39:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: File system block reservation mechanism is broken
Message-ID: <20060918223918.GZ3034@melbourne.sgi.com>
References: <Pine.LNX.4.64.0609151242110.21194@madrid.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0609151242110.21194@madrid.max-t.internal>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 15, 2006 at 12:44:16PM -0400, Stephane Doyon wrote:
> [Resending. Seems my previous post did not make it somehow...]
> 
> The mechanism allowing to reserve file system blocks, xfs_reserve_blocks() 
> / XFS_IOC_SET_RESBLKS, appears to have been broken by the patch that 
> introduced per-cpu superblock counters.

Thanks for finding this, Stephane. It turns out our xfsqa test that
is supposed to test this feature only tests whether the ioctl
succeeds or fails - it doesn't check whether values have been set
properly, whether the reservation really is reserved, etc. Hence
we've always got false successes from this test and hence it's never
been noticed as broken.

Your patch is based on a tree that is a little out of date - the
allocation set aside code has already been pushed into
xfs_reserve_blocks().  Unfortunately I didn't notice that this code
didn't work with SMP counters at the same time I realised it needed
to obey the set aside restrictions....

I'll have a fix for the problem soon and get the QA test updated
to test the ioctl properly.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
