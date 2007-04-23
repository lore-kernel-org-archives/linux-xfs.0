Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:49:36 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLnXfB014564
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:49:34 -0700
Date: Mon, 23 Apr 2007 22:19:52 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: possible recursive locking detected
Message-ID: <20070423211952.GA13572@infradead.org>
References: <Pine.LNX.4.64.0704021914060.3963@sheep.housecafe.de> <20603.194.246.123.250.1177344480.squirrel@derchris.gotdns.org:8080> <462D0D23.7010803@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462D0D23.7010803@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christian Kujau <lists@nerdbynature.de>, xfs@oss.sgi.com

On Mon, Apr 23, 2007 at 02:46:43PM -0500, Eric Sandeen wrote:
> Christian Kujau wrote:
> > Hi there,
> > 
> > On Mon, April 2, 2007 19:18, Christian Kujau wrote:
> >> when I enabled a few more debug-options in the kernel (vanilla
> >> 2.6.21-rc5), I came across:
> >>
> >> [ INFO: possible recursive locking detected ]
> >> 2.6.21-rc5 #2
> > 
> > The same happened with -rc7, see below. Can anyone comment if this
> > is/could lead to a problem?
> >
> 
> The consensus seems to be that it is cosmetic.

It's not really cosmetic.  It means i_lock and i_iolock are beeing
acquired without an order that is detectable by lockdep.  At the very
first it means annotations for lockdep are missing, because acquiring
two per-inode locks at the same time is a basic fact in unix filesystems.
But deeper than that the rules for taking both locks are not very well
defined in XFS.  These rules at least need documentation in form of
lockdep annotations, and possibly some fixes and cleanups around the
more dirty areas like xfs_lock_for_rename() or xfs_lock_dir_and_entry()
