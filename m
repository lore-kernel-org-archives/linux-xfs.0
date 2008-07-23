Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 19:22:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N2MYJv004498
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 19:22:35 -0700
Message-ID: <48869628.8010201@sgi.com>
Date: Wed, 23 Jul 2008 12:23:36 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] XFS: replace the mount inode list with radix tree
 traversals V2
References: <1216773673-3620-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1216773673-3620-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



Dave Chinner wrote:
> The list of all inodes on a mount is superfluous. We can traverse
> all inodes now by walking the per-AG inode radix trees without
> needing a separate list. This enables us to remove a bunch of
> complex list traversal code and remove another two pointers from
> the xfs_inode.

sounds like a good move.

> Also, by replacing the sync traversal with an ascending inode
> number traversal, we will issue better inode I/O patterns for
> writeback triggered by xfssyncd or unmount.

Dave, have you made any performance measurements showing this to
be the case? If so, what is the improvement? Or should we just assume
such traversals will be more naturally sequential and therefore more
efficient?

Cheers
-- Mark
