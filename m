Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 21:32:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N4WaRU021913
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:32:36 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92E2A3178C1
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:33:45 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id NhyefeiIVoS5p5hG for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:33:45 -0700 (PDT)
Date: Wed, 23 Jul 2008 14:33:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] XFS: replace the mount inode list with radix tree
	traversals V2
Message-ID: <20080723043343.GJ5947@disturbed>
References: <1216773673-3620-1-git-send-email-david@fromorbit.com> <48869628.8010201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48869628.8010201@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 12:23:36PM +1000, Mark Goodwin wrote:
>
>
> Dave Chinner wrote:
>> The list of all inodes on a mount is superfluous. We can traverse
>> all inodes now by walking the per-AG inode radix trees without
>> needing a separate list. This enables us to remove a bunch of
>> complex list traversal code and remove another two pointers from
>> the xfs_inode.
>
> sounds like a good move.
>
>> Also, by replacing the sync traversal with an ascending inode
>> number traversal, we will issue better inode I/O patterns for
>> writeback triggered by xfssyncd or unmount.
>
> Dave, have you made any performance measurements showing this to
> be the case?  If so, what is the improvement?

I don't have a test rig I can use to measure it sufficiently
accurately.

> Or should we just assume
> such traversals will be more naturally sequential and therefore more
> efficient?

Not an assumption - I've verified this occurs with blktrace. I'm
seeing ascending order dispatch and a reduction in the number and
distance of seeks as well as I/Os being issued to "disk" during such
events (like unmount, for example)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
