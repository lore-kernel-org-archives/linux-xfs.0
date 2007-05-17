Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 05:28:38 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4HCSYfB013436
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 05:28:35 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4HCSXoR032548
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 08:28:33 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4HCSX8R248122
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 06:28:33 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4HCSWD9023479
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 06:28:33 -0600
Date: Thu, 17 May 2007 17:58:40 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64 and powerpc
Message-ID: <20070517122840.GA12381@amitarora.in.ibm.com>
References: <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070515193722.GA3487@amitarora.in.ibm.com> <20070515195421.GA2948@amitarora.in.ibm.com> <20070515200359.GA5834@amitarora.in.ibm.com> <20070516031626.GM85884050@sgi.com> <1179318076.10313.6.camel@kleikamp.austin.ibm.com> <20070516234036.GQ85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516234036.GQ85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, May 17, 2007 at 09:40:36AM +1000, David Chinner wrote:
> On Wed, May 16, 2007 at 07:21:16AM -0500, Dave Kleikamp wrote:
> > On Wed, 2007-05-16 at 13:16 +1000, David Chinner wrote:
> > > On Wed, May 16, 2007 at 01:33:59AM +0530, Amit K. Arora wrote:
> > 
> > > > Following changes were made to the previous version:
> > > >  1) Added description before sys_fallocate() definition.
> > > >  2) Return EINVAL for len<=0 (With new draft that Ulrich pointed to,
> > > >     posix_fallocate should return EINVAL for len <= 0.
> > > >  3) Return EOPNOTSUPP if mode is not one of FA_ALLOCATE or FA_DEALLOCATE
> > > >  4) Do not return ENODEV for dirs (let individual file systems decide if
> > > >     they want to support preallocation to directories or not.
> > > >  5) Check for wrap through zero.
> > > >  6) Update c/mtime if fallocate() succeeds.
> > > 
> > > Please don't make this always happen. c/mtime updates should be dependent
> > > on the mode being used and whether there is visible change to the file. If no
> > > userspace visible changes to the file occurred, then timestamps should not
> > > be changed.
> > 
> > i_blocks will be updated, so it seems reasonable to update ctime.  mtime
> > shouldn't be changed, though, since the contents of the file will be
> > unchanged.
> 
> That's assuming blocks were actually allocated - if the prealloc range already
> has underlying blocks there is no change and so we should not be changing
> mtime either. Only the filesystem will know if it has changed the file, so I
> think that timestamp updates need to be driven down to that level, not done
> blindy at the highest layer....

Ok. Will make this change in the next post.

--
Regards,
Amit Arora
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
