Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40826 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfDDVkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 17:40:03 -0400
Date: Thu, 4 Apr 2019 14:39:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 38/36] xfs_io: don't read garbage stack contents if
 INUMBERS goes nuts
Message-ID: <20190404213955.GU5147@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193444.GB1183@magnolia>
 <5a34954c-6174-ce78-73ad-a04f804c79c9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a34954c-6174-ce78-73ad-a04f804c79c9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 04, 2019 at 04:12:18PM -0500, Eric Sandeen wrote:
> On 3/20/19 2:34 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In theory INUMBERS will never return an ocount of zero, but on the off
> > chance it ever does we'll negative index the igroup array and return
> > stack contents for an inode number.  Don't do that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Is there more of a story behind this?  ;)

/me can't remember, I think it was just shutting up coverity complaints.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  io/open.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/io/open.c b/io/open.c
> > index f5fbd2c4..a406ea54 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -698,6 +698,9 @@ get_last_inode(void)
> >  		lastgrp = ocount;
> >  	}
> >  
> > +	if (lastgrp == 0)
> > +		return 0;
> > +
> >  	lastgrp--;
> >  
> >  	/* The last inode number in use */
> > 
