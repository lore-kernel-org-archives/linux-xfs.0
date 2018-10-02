Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43288 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbeJBJ17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 05:27:59 -0400
Date: Tue, 2 Oct 2018 03:47:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] vfs: check ->get_link return value
Message-ID: <20181002024703.GO32577@ZenIV.linux.org.uk>
References: <20181001224500.GE5872@magnolia>
 <20181002013105.GL32577@ZenIV.linux.org.uk>
 <20181002020712.GB6706@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002020712.GB6706@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Mon, Oct 01, 2018 at 07:07:12PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 02, 2018 at 02:31:06AM +0100, Al Viro wrote:
> > On Mon, Oct 01, 2018 at 03:45:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Teach callers of inode->i_op->get_link in the vfs code to check for a
> > > NULL return value and return an error status instead of blindly
> > > dereferencing the returned NULL pointer.
> > 
> > IDGI.  If you want it to fail with -EUCLEAN, then by all means return
> > it as you would any other error.
> > 
> > I've no problem with "fs image is fucked, return an error".  However,
> > "fs driver is fucked, paper over that if we'd caught one of the
> > symptoms" is a different story.
> 
> This whole thread got started from a suggestion Christoph made about a
> patch I had to fix the XFS side to return an error instead of a null
> pointer:
> 
> https://www.spinics.net/lists/linux-xfs/msg21372.html

Ugh...  What should happen for that to trigger?  If anything, I would rather
validate that somewhere around xfs_setup_iops() *AND* set ->i_link at the
same time, killing the whole xfs_vn_get_link_inline() thing (just use
simple_get_link() instead)...

See another reply for the reasons why such mitigation makes no sense.
