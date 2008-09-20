Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 23:49:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8K6n9tU007933
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 23:49:09 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99EF34618AE
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 23:50:41 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id LtgLcGUpuIh8W9Wb for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 23:50:41 -0700 (PDT)
Date: Sat, 20 Sep 2008 16:50:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] XFS: Given the log a pointer to the AIL
Message-ID: <20080920065038.GP5811@disturbed>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-7-git-send-email-david@fromorbit.com> <20080919092722.GF11443@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919092722.GF11443@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Sep 19, 2008 at 05:27:22AM -0400, Christoph Hellwig wrote:
> On Sun, Sep 14, 2008 at 12:57:55AM +1000, Dave Chinner wrote:
> > When we need to go from the log to the AIL, we have
> > to go via the xfs_mount. Add a xfs_ail pointer to the log
> > so we can go directly to the AIL associated with the log.
> 
> Looks correct, but I wonder what it actually buys us.

Not much initially.

The original intent of the log manager was that each
log could host transactions for multiple XFS filesystems,
which cannot be done if the log directly references a specific
filesystem. The log needs to be independent of an xfs_mount
for this sort of arrangement to work properly, and the only
time the log should reference a struct xfs_mount is through
a log item that needs to reference filesystem specific information
(another reason I haven't removed the li_mountp yet).

And, of course, then there's the other way around - multiple
logs in the one filesystem - the log needs a direct pointer
to the AIL that it puts all it's items into rather than the
xfs_mount, likewise the AIL needs a backpointer to the log....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
