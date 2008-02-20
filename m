Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 13:21:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1KLL3mG022897
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 13:21:07 -0800
Date: Thu, 21 Feb 2008 08:21:20 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Is CVS stable?
Message-ID: <20080220212120.GT155407@sgi.com>
References: <eb736a810802200026g1b956abar922548d3e67a9682@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb736a810802200026g1b956abar922548d3e67a9682@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: eric c <xcellula@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 20, 2008 at 02:26:42AM -0600, eric c wrote:
> Hello,
> 
> I have recently seen some patches for slabcache related
> xfs_inode/xfs_vnode_t/dentry_cache taking up alot of memory:
>   http://oss.sgi.com/archives/xfs/2007-12/msg00154.html
>   http://oss.sgi.com/archives/xfs/2008-02/msg00138.html
> 
> If I cvs on linux-2.6-xfs, is it stable for production or bleeding?

Mostly stable, but it is our _development_ tree and that means it
can be broken at any given time. And by "broken" I mean corrupt your
filesystems and lose all your data. IOWs, use the CVS tree in
production at your own risk.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
