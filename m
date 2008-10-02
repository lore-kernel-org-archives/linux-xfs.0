Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Oct 2008 16:50:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m92NoclP014729
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2008 16:50:39 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D44C71365A80
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2008 16:52:15 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 08FJHoutG1kPiyZX for <xfs@oss.sgi.com>; Thu, 02 Oct 2008 16:52:15 -0700 (PDT)
Date: Fri, 3 Oct 2008 09:52:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Regression Issue in kernel 2.6.26.3
Message-ID: <20081002235211.GI30001@disturbed>
References: <48E51BF5.3080100@g-b.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E51BF5.3080100@g-b.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Albert Graham <albert.graham@g-b.net>
Cc: xfs@oss.sgi.com

On Thu, Oct 02, 2008 at 08:07:33PM +0100, Albert Graham wrote:
> Hi Guys,
>
> I use Fedora 8 as my MythTV backend server which uses XFS, ISince 
> upgrading from kernel-2.6.25 to kernel-2.6.26 I've been getting the 
> following errors (see below).

The freespace btrees are getting out of sync for some reason.

That is, when we go to allocate an extent, we have to update two
free space btrees. This shutdown:

> XFS internal error XFS_WANT_CORRUPTED_RETURN at line 280 of file fs/xfs/xfs_alloc.c.  Caller 0xf88e0018

Indicates the extent being allocated was not found in one of the
two trees.

This corruption could have happened a long time ago in the past, and
it may simply be coincidental that you've tripped over this at
roughly the same time you upgraded the kernel.

Can you run xfs_check on the filesystem to determine if a freespace
tree is corrupted (post the output if it is), then run xfs_repair
to rebuild them?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
