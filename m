Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 00:35:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F7ZX7U031933
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 00:35:36 -0700
Date: Thu, 15 May 2008 17:36:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] don't run test 167 if killall is not installed
Message-ID: <20080515073605.GR155679365@sgi.com>
References: <20080515053918.GA16530@lst.de> <482BDAC1.7070407@sgi.com> <20080515071338.GA26247@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515071338.GA26247@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Tim Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Thu, May 15, 2008 at 09:13:38AM +0200, Christoph Hellwig wrote:
> On Thu, May 15, 2008 at 04:40:01PM +1000, Tim Shimmin wrote:
> > Looks reasonable.
> > 
> > However:
> > 
> > * could use set_prog_path like we do in common.config.
> > 
> > * I wonder if one could use "kill -$pgid" on the process group
> > for fsstress instead of killall (I've never tried it :).
> 
> Dave already commited the original version, but I'll send an update
> to use set_prog_path later today.

Sorry, didn't see that Tim replied as well. set_prog_path is fine
by me too, but stopping every test from running because killall is
not present is a bit of overkill, isn't it?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
