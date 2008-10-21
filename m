Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 01:05:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L85qKQ026349
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:05:53 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 124DD52527A
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:07:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id lytwNVs4WGB1rGX7 for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:07:37 -0700 (PDT)
Date: Tue, 21 Oct 2008 04:07:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2, RFC] convert xfs_getbmap to take formatter
	functions
Message-ID: <20081021080737.GA4193@infradead.org>
References: <48FD0503.3090203@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FD0503.3090203@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Oct 20, 2008 at 05:24:03PM -0500, Eric Sandeen wrote:
> Preliminary work to hook up fiemap, this allows us to pass in an
> arbitrary formatter to copy extent data back to userspace.
> 
> The formatter takes info for 1 extent, a pointer to the user "thing*"
> and a pointer to a "filled" variable to indicate whether a userspace
> buffer did get filled in (for fiemap, hole "extents" are skipped).
> 
> I'm just using the getbmapx struct as a "common denominator" because
> as far as I can see, it holds all info that any formatters will care
> about.
> 
> ("*thing" because fiemap doesn't pass the user pointer around, but rather
> has a pointer to a fiemap info structure, and helpers associated with it)
> 
> I'm still working on the fiemap hookup but wanted to put this out for comment.

This looks good to me.

>  /*
> - * Fcntl interface to xfs_bmapi.
> + * ioctl interface to xfs_bmapi.
>   */

>  /*
> - * Fcntl interface to xfs_bmapi.
> + * ioctl interface to xfs_bmapi.
>   */

Well, it will be for fiemap, too.  And the comment doesn't make much
sense either.  Either remove it completely or replace it by something
that makes sense.
