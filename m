Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 06:29:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LDTKW9022468
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 06:29:22 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43567144C359
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 06:31:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id x6PjCa8JhPA6xkxO for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 06:31:04 -0700 (PDT)
Date: Tue, 21 Oct 2008 09:31:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2, RFC] convert xfs_getbmap to take formatter
	functions
Message-ID: <20081021133104.GA10372@infradead.org>
References: <48FD0503.3090203@sandeen.net> <20081021080737.GA4193@infradead.org> <48FDD7AA.5050006@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FDD7AA.5050006@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>

On Tue, Oct 21, 2008 at 08:22:50AM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Mon, Oct 20, 2008 at 05:24:03PM -0500, Eric Sandeen wrote:
> ...
> 
> >>  /*
> >> - * Fcntl interface to xfs_bmapi.
> >> + * ioctl interface to xfs_bmapi.
> >>   */
> > 
> >>  /*
> >> - * Fcntl interface to xfs_bmapi.
> >> + * ioctl interface to xfs_bmapi.
> >>   */
> > 
> > Well, it will be for fiemap, too.  And the comment doesn't make much
> > sense either.  Either remove it completely or replace it by something
> > that makes sense.
> > 
> 
> well aren't XFS_IOC_GETBMAP(X) and fiemap _both_ ioctl interfaces to
> xfs_bmapi?

Hmm, From the syscall point of view fiemap is indeed an ioctl, too.
But then again the point of this function isn't do anything
ioctl-related, but to allow to get a list of all extents for an inode
and format them arbitrarily.
