Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 18:07:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B170Ym015834
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:07:00 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBF20DF3C9C
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:08:01 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id qbp094yC3jddYMQk for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:08:01 -0700 (PDT)
Date: Fri, 11 Jul 2008 11:07:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] simplify xfs_setattr
Message-ID: <20080711010759.GA11558@disturbed>
References: <20080627154557.GB31476@lst.de> <20080705172021.GA7177@lst.de> <48747DAD.7060501@sgi.com> <20080709162914.GA16308@lst.de> <4876AA39.804@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876AA39.804@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 10:32:57AM +1000, Timothy Shimmin wrote:
> Christoph Hellwig wrote:
> > On Wed, Jul 09, 2008 at 06:58:21PM +1000, Timothy Shimmin wrote:
> >>> -	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET))
> >>> -		flags |= ATTR_UTIME;
> >>> -#ifdef ATTR_NO_BLOCK
> >>> -	if ((ia_valid & ATTR_NO_BLOCK))
> >>> -		flags |= ATTR_NONBLOCK;
> >>> -#endif
> >>> -
> >> So this code looks different.
> >> We are now dropping the flags. Why is that?
> >> Presumably because we were mapping ia_valid's:
> >>    ATTR_MTIME_SET or ATTR_ATIME_SET --> ATTR_UTIME
> >>    ATTR_NO_BLOCK -> ATTR_NONBLOCK
> >> But now we pass ATTR_?TIME_SET and ATTR_NO_BLOCK straight thru.
> >> So previously we didn't map them onto va_mask bits but as separate flags
> >> instead.
> > 
> > Yeah, not that ATTR_NO_BLOCK doesn't actually exist in any tree I have
> > access to, and thus it's not actually handled in the new xfs_setattr.

Look in SLES9 and SLES10. It's used to enable the NFS server to
return EAGAIN for truncates that might block for a long time. This
can occur if a file migration to/from HSM is in progress. This will
return EJUKEBOX to NFS clients to prevent them from unnecessarily
resending the truncate over the wire due to timeouts and blocking
multiple (potentially all) nfsds trying to service the truncate....

It's just that someone here NACKed the mainline patches to the
NFS server to set this flag.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
