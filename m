Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932471AbeALBd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 20:33:59 -0500
Date: Thu, 11 Jan 2018 17:23:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/27] xfs_scrub: common error handling
Message-ID: <20180112012352.GR5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520350018.2027.6588345400822739821.stgit@magnolia>
 <2a192224-9951-9e10-f7ac-daf9bab2d9ea@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a192224-9951-9e10-f7ac-daf9bab2d9ea@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 07:15:52PM -0600, Eric Sandeen wrote:
> On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Standardize how we record and report errors.
> > 
> 
> 
> > +/*
> > + * Reporting Status to the Console
> > + *
> > + * We aim for a roughly standard reporting format -- the severity of the
> > + * status being reported, a textual description of the objecting being
> 
> object?  (I mean, I suppose it might be objecting to your horribly
> corrupted filesystem?) ;)

Fixed.

> > + * reported, and whatever the status happens to be.
> > + *
> > + * Errors are the most severe and reflect filesystem corruption.
> > + * Warnings indicate that something is amiss and needs the attention of
> > + * the administrator, but does not constitute a corruption.  Information
> > + * is merely advisory.
> > + */
> > +
> 
> 
> >  /* Program name; needed for libxcmd error reports. */
> >  char				*progname = "xfs_scrub";
> >  
> > +/* Debug level; higher values mean more verbosity. */
> > +unsigned int			debug;
> > +
> > +/* Should we dump core if errors happen? */
> > +bool				dumpcore;
> 
> not independent of debug right, but ... *shrug* 

Wart from the old days.  I'll gate core dumping on debug.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
