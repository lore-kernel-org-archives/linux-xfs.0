Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 23:28:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6L6S4DW000594
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 23:28:16 -0700
Message-ID: <44C07377.3060209@sgi.com>
Date: Fri, 21 Jul 2006 16:25:59 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: fix remount vs barrier options
References: <20060721152807.D1998769@wobbly.melbourne.sgi.com>
In-Reply-To: <20060721152807.D1998769@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com, jeremy@sgi.com

Nathan Scott wrote:
> Hi,
> 
> Jeremy has had me scratching my head for a few days trying to
> figure out how the SCSI traces he's looking at can still show
> signs of write barriers being issued to the device, despite a
> "remount,nobarrier" having been done.
> 
> It finally clicked that we are not clearing the buffer flag
> from a previously written log buffer, even though we'll no
> longer set a new flag into a buffer (due to the mount flag
> being cleared), so we _can_ still issue barrier writes when
> remounted without barriers.
> 
> This was made more complicated by the way a freshly mounted
> filesystem with 8 log buffers wouldn't show up the problem,
> since we have to slowly cycle through the "clear" log buffers
> before we see the bug.  This seems like the simplest fix...
> 
> (Hmmm, actually, I wonder if this will also resolve the quota
> log I/O problem that was reported the other day too).
> 
Patch looks good to me.

--Tim
