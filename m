Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 08:18:22 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l91FIIa0009551
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 08:18:18 -0700
Date: Mon, 1 Oct 2007 08:02:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
In-Reply-To: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
Message-ID: <alpine.LFD.0.999.0710010753500.3579@woody.linux-foundation.org>
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org



On Mon, 1 Oct 2007, Tim Shimmin wrote:
> 
> Lachlan's description:
>     This fix is for a problem that has been in XFS since day one.
>     [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.
	...

Why wasn't this in the commit logs? Now it just says it was reverted, with 
no actual reasoning *why*. And it apparently wasn't so obvious that no 
such reasoning is needed.

Gah. I ended up amending the commit and updating it with the comment.

		Linus
