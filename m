Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Sep 2007 16:51:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l84Npf4p003072
	for <xfs@oss.sgi.com>; Tue, 4 Sep 2007 16:51:44 -0700
Date: Wed, 5 Sep 2007 09:51:39 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
Message-ID: <20070904235139.GJ734179@sgi.com>
References: <46D6279F.40601@sgi.com> <46DDE4A2.1070204@agami.com> <20070904234926.GI734179@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070904234926.GI734179@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Shailendra Tripathi <stripathi@agami.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Sep 05, 2007 at 09:49:26AM +1000, David Chinner wrote:
> On Tue, Sep 04, 2007 at 04:05:06PM -0700, Shailendra Tripathi wrote:
> > Hi,
> >      Can someone explain how not checking the flushiter can losse 
> > filesize updates.
> > Let me the take the case mentioned here in the fix statement:
> > 
> > a. Clustered inode create -  flush iter - X( 0)
> > b. size update  --> flush iter --> Y
> > 
> > X and Y will always hold as: X <= Y, that is, it is not possible to have 
> > X >Y (unless size update is non -transactional. As far as I know, size 
> > update is always transactional.)
> 
> Size updates are not transactional. They are accidentally logged in

s/accidentally/intentionally/

> other transactions (e.g. truncates) but size updates due to data
> writes are never logged. When we write an inode, we take the latest
> in memory size and write it to disk without logging that change
> so we can't rely on log recovery to get it right simply by replaying
> transactions.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
