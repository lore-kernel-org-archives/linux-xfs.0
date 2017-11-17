Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37889 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756468AbdKQDpU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2017 22:45:20 -0500
Date: Thu, 16 Nov 2017 19:45:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH for 4.14] xfs_copy: don't hang if /all/ the targets hit
 write errors
Message-ID: <20171117034509.GK5119@magnolia>
References: <20171116011232.GG5119@magnolia>
 <9bfccb40-f75c-b801-80aa-a80d05952795@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bfccb40-f75c-b801-80aa-a80d05952795@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, djwong@kernel.org

On Thu, Nov 16, 2017 at 03:10:39PM -0600, Eric Sandeen wrote:
> 
> 
> On 11/15/17 7:14 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If xfs_copy is told to copy a filesystem and /all/ the writer threads
> > hit an write error, there won't be any threads to unlock mainwait, which
> > means that write_wbuf will deadlock with itself trying to lock mainwait.
> > Therefore, if we discover that all the writer threads are dead, just
> > bail out.
> > 
> > Discovered by running xfs/073 with a tiny test device.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  copy/xfs_copy.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> > index 33e05df..fb37375 100644
> > --- a/copy/xfs_copy.c
> > +++ b/copy/xfs_copy.c
> > @@ -476,6 +476,7 @@ void
> >  write_wbuf(void)
> >  {
> >  	int		i;
> > +	int		badness = 0;
> >  
> >  	/* verify target threads */
> >  	for (i = 0; i < num_targets; i++)
> > @@ -486,6 +487,17 @@ write_wbuf(void)
> >  	for (i = 0; i < num_targets; i++)
> >  		if (target[i].state != INACTIVE)
> >  			pthread_mutex_unlock(&targ[i].wait);	/* wake up */
> > +		else
> > +			badness++;
> > +
> > +	/*
> > +	 * If all the targets are inactive then there won't be any io
> > +	 * threads left to release mainwait.  We're screwed, so bail out.
> > +	 */
> > +	if (badness == num_targets) {
> > +		check_errors();
> 
> libxfs_umount(mp); ?

Doh. v2 on its way

--D

> -Eric
> 
> > +		exit(1);
> > +	}
> >  
> >  	signal_maskfunc(SIGCHLD, SIG_UNBLOCK);
> >  	pthread_mutex_lock(&mainwait);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
