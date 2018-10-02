Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53682 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbeJBIsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 04:48:18 -0400
Date: Mon, 1 Oct 2018 19:07:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: check ->get_link return value
Message-ID: <20181002020712.GB6706@magnolia>
References: <20181001224500.GE5872@magnolia>
 <20181002013105.GL32577@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002013105.GL32577@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Tue, Oct 02, 2018 at 02:31:06AM +0100, Al Viro wrote:
> On Mon, Oct 01, 2018 at 03:45:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach callers of inode->i_op->get_link in the vfs code to check for a
> > NULL return value and return an error status instead of blindly
> > dereferencing the returned NULL pointer.
> 
> IDGI.  If you want it to fail with -EUCLEAN, then by all means return
> it as you would any other error.
> 
> I've no problem with "fs image is fucked, return an error".  However,
> "fs driver is fucked, paper over that if we'd caught one of the
> symptoms" is a different story.

This whole thread got started from a suggestion Christoph made about a
patch I had to fix the XFS side to return an error instead of a null
pointer:

https://www.spinics.net/lists/linux-xfs/msg21372.html

I hadn't thought it was all /that/ necessary to fix the vfs since there
are plenty of other places where the vfs assumes the fs knows what it's
doing and sneezes hard if not...

> NAK in that form.  If we have that happen, let the damn thing oops.
> Quietly papering over bugs like that is just plain wrong.

Sounds good to me!  Patch withdrawn. :)

--D
