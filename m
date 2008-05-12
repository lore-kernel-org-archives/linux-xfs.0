Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 May 2008 22:43:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4C5gf2L030369
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 22:42:43 -0700
Date: Mon, 12 May 2008 01:43:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/10] merge xfs_unmount into xfs_fs_put_super /
	xfs_fs_fill_super
Message-ID: <20080512054327.GA26038@infradead.org>
References: <20080501220048.GA2315@lst.de> <20080512022138.GX155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512022138.GX155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, May 12, 2008 at 12:21:38PM +1000, David Chinner wrote:
> > +	if (mp->m_flags & XFS_MOUNT_DMAPI) {
> > +		XFS_SEND_UNMOUNT(mp, rip, DM_RIGHT_NULL, 0, 0,
> > +				unmount_event_flags);
> > +	}
> 
> #ifdef HAVE_DMAPI around this chunk? I know the old code didn't,
> but it would then match the pre-unmount event hunk above...

We don't have #ifdefs around the other dmapi namespace bits.  In fact
I'd prefer to kill the one above aswell.  It's on my todo list because
I wan't to prove that using the normal event enabled macros are safe
in the unmount path first and just switch to those.
