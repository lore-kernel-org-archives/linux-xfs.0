Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 15:31:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3LMUgoj000410
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 15:30:44 -0700
Date: Tue, 22 Apr 2008 08:31:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Fwd: xfs_repair -n report
Message-ID: <20080421223114.GS108924158@sgi.com>
References: <200804211452.01772.support@geoglobal.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804211452.01772.support@geoglobal.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: support@geoglobal.com
Cc: xfs@oss.sgi.com, vincent.roy@geoglobal.com

On Mon, Apr 21, 2008 at 02:52:01PM -0600, support@geoglobal.com wrote:
> Sorry, I truncated the original logfile of 128MB to a short version for 
> review. Again, all comments welcome.

Firstly, please post plain text attachments - that will cut down the
size of them as well...

> 
> Subject: xfs_repair -n report
> Date: Saturday 19 April 2008 23:22
> From: support@geoglobal.com
> To: xfs@oss.sgi.com, vincent.roy@geoglobal.com
> 
> RAID 5 - 4 disks on 9550 AMCC production machine / backup disk failed also
> verified without error - rebuilt after abrupt power shut down
> cannot mount - inconsistencies indicated - could not dump fs

Secondly, your raid has completely screwed the filesystem. I would
strongly suggest that you confirm that the rebuild of the RAID put
stuff back together properly (check things like the order of disks
in the stripe, etc). If it claims nothing is wrong, then it has been
lying to you.

I hope you have backups, because that's the only way you're going
to recover this mess.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
