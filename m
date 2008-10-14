Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 16:38:50 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9DNclpV027173
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 16:38:47 -0700
Message-ID: <48F3EA6F.9000209@sgi.com>
Date: Tue, 14 Oct 2008 10:40:15 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: fw: [PATCH] fix instant oops with tracing enabled
References: <20081013223932.GE10716@disturbed>
In-Reply-To: <20081013223932.GE10716@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, hch@lst.de



Dave Chinner wrote:
> SGI folks,
>
> Looks like Christoph is having problems posting to the list;
> the spam filter is dropping all his mail. In the mean time,
> here's a fix for an oops in the tracing code as a result of
> the last check ins. I didn't see this because the "combine
> inodes" patches removes xfs_icount altogether.

Lachlan also saw some regressions after merging these patchsets :
. replace the mount inode list with radix tree traversals
. clean up sync code

> If that
> series is going to be included in the current round of checkins
> then this patch probably isn't needed.

The agreed plan for 2.6.28 still has the following patchsets to go in:

. Combine the XFS and Linux inode structures V2
. Track reclaimable inodes in inode cache
. AIL cleanup and bug fixes
. Account for allocated blocks when expanding directories
. Check for valid transaction headers in recovery
. fix remount rw with unrecognized options

It's starting to look like a pretty aggressive merge and QA schedule.
Dave, is it worth doing any testing until these are *all* merged?

Thanks
-- Mark
