Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 22:40:56 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M5esvH024086
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 22:40:54 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A1E41917637
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 22:42:03 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ZfKy5J7aIpSgTjb1 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 22:42:03 -0700 (PDT)
Date: Tue, 22 Jul 2008 15:42:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] XFS: remove the mount inode list
Message-ID: <20080722054200.GK6761@disturbed>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-5-git-send-email-david@fromorbit.com> <20080722042903.GC27123@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722042903.GC27123@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 12:29:03AM -0400, Christoph Hellwig wrote:
> On Sun, Jul 20, 2008 at 10:19:54PM +1000, Dave Chinner wrote:
> > Now we've removed all users of the mount inode list,
> > we can kill it. This reduces the size of the xfs_inode
> > by 2 pointers.
> 
> Looks good, but xfsidbg needs to be fixed up for this.

Yeah, well, it's not in the git tree. CVS + quilt is too painful
to go back to once you've started using guilt + git + branches
and basked in it's goodness.

SGI folk - a -dev branch in the XFS git tree that contains
everything the CVS tree contains would be really helpful here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
