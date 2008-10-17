Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 18:52:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H1pN8j027733
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 18:51:23 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AA35509CB3
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 18:53:06 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id l9yXnA9L3MAnnnPt for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 18:53:06 -0700 (PDT)
Date: Fri, 17 Oct 2008 12:53:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_ERROR use - was Re: [PATCH] prevent NULL returns from
	d_obtain_alias
Message-ID: <20081017015301.GK25906@disturbed>
References: <20081015192839.GA867@lst.de> <E1KqWzC-00087u-TG@pomaz-ex.szeredi.hu> <20081016180947.GA26285@lst.de> <48F7D814.2080705@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F7D814.2080705@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 17, 2008 at 11:11:00AM +1100, Timothy Shimmin wrote:
> Fair enough.
> But XFS_ERROR is used throughout the function.
> I've found the whole idea of when and when not to use XFS_ERROR annoying :)
> 
> I've never used it (other than calling it to stay consistent with the code).
> Looking at the code, it is used to BUG and print a msg on particular error codes set in xfs_etrap[] -
> and it does this in xfs_error_trap().
> Can one not decide to do this at any error point?
> I can't see where we hook in to set up xfs_etrap.

You break into the debugger, modify the xfs_etrap array to contain
the set of errors you want to catch, then continue onwards.  I've
used this several times in the past couple of months to locate the
source of strange ENOSPC errors...

The conceptual idea is that every point where an error is first
detected gets wrapped with XFS_ERROR() so you don't need to sprinkle
printk's all through the code to find where the error is coming
from.

ISTR the Irix kernel debugger had a command to set the values
in the etrap array - if it did it never got ported to kdb....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
