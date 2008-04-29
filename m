Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 18:59:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T1xCun032707
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 18:59:14 -0700
Date: Tue, 29 Apr 2008 11:59:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size check 2 failed
Message-ID: <20080429015942.GL108924158@sgi.com>
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL> <481650F5.40205@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481650F5.40205@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lance Reed <lreed@brightcove.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Apr 28, 2008 at 05:34:29PM -0500, Eric Sandeen wrote:
> Lance Reed wrote:
> > I recently experienced a problem trying to expand an existing LVM + XFS installation.
> > The core problem was that xfs_growfs did not correctly resize the XFS filesystem while trying to expand from 11 TB to about 21 TB.
> > 
> > The previous setup had 5 x 2.18 TB LUNs using LVM2 for a total of just under 11 TB.
> > This is a 64bit Linux system.
> > Linux nfs3 2.6.18-8.1.15.el5 #1 SMP Mon Oct 22 08:32:28 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
> > CentOS release 5 (Final)
> > 
> > XFS versions:
> > xfsprogs-2.9.4-1.el5.centos
> > xfsdump-2.2.46-1.el5.centos
> > kmod-xfs-0.4-1.2.6.18_8.1.15.el5
> > 
> ...
> 
> > Thanks in advance for any help....
> 
> You probably hit:
> 
> TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
> http://oss.sgi.com/archives/xfs/2007-01/msg00053.html
> 
> which unfortunately probably was never backported to the centos5 xfs
> module.  Hmm maybe I should do that.  :(
> 
> Dave, do you remember what the fs looked like after hitting that bug?

Not exactly. I'd have to read this thread:
> 
> You may want to read through the "Repairing a possibly incomplete
> xfs_growfs command?" thread from earlier, on this list...

To remind myself. IIRC it shows all the information you need to gather
and all the commands needed to put the pieces back together again....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
