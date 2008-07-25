Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 22:01:06 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6P510Bl014440
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:01:04 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2F09192578E
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:02:10 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id m0tAXQTZBxSuDLTT for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:02:10 -0700 (PDT)
Date: Fri, 25 Jul 2008 15:01:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 981498 - remove mounpoint UUID code
Message-ID: <20080725050149.GL5947@disturbed>
References: <20080725033841.D689558C4C3F@chook.melbourne.sgi.com> <48894C66.5060204@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48894C66.5060204@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi-Altivanik <xaiki@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Thu, Jul 24, 2008 at 10:45:42PM -0500, Eric Sandeen wrote:
> Niv Sardi-Altivanik wrote:
> > remove mounpoint UUID code
> 
> Are you sure this didn't change any disk structures?  The patch I sent
> was RFC and completely untested...  (and disclosed as such...) :)

Looking at the original patch, it definitely does change the format
of log structures on disk. it removes the union of the uuid and rdev
in the xfs_inode_log_format[32|64] which takes that entry from 16
bytes down to 4 bytes. So I'd suggest that thisss should be removed
immediately before it hits public and people start corrupting their
filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
