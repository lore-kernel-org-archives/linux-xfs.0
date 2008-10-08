Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 16:58:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m98NwFKZ009750
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 16:58:15 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A401E1B0CD12
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 16:59:54 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id GMVEOb2EukrRoEpc for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 16:59:54 -0700 (PDT)
Date: Thu, 9 Oct 2008 10:59:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] XFS: replace the mount inode list with radix tree
	traversals
Message-ID: <20081008235951.GA9597@disturbed>
References: <1223415692-6354-1-git-send-email-david@fromorbit.com> <20081008182051.GA22941@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008182051.GA22941@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 08, 2008 at 02:20:51PM -0400, Christoph Hellwig wrote:
> Anything new in the reposted patches?  I'm not really interested in
> reviewing this again and again unless something major changed.

No, nothing has changed because the bug I found I fixed in a
separate patch (the end-of-AG inode detection problem).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
