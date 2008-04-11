Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 00:37:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B7b227009554
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 00:37:03 -0700
Date: Fri, 11 Apr 2008 09:37:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] simplify xfs_lock_for_rename
Message-ID: <20080411073730.GA9236@lst.de>
References: <20080410184413.GB6771@lst.de> <op.t9fi87c93jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9fi87c93jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

> 
> It seems that do_rename() in namei.c calls lookup_hash/__lookup_hash
> which does an inode->i_op->lookup() to get the dentry. This will do
> the xfs_lookup anyway, taking a refernence if the target exists.
> 
> 	error = do_path_lookup(newdfd, newname, LOOKUP_PARENT, &newnd);
> 	...
> 	new_dentry = lookup_hash(&newnd);
> 	...
> 	error = vfs_rename(old_dir->d_inode, old_dentry,
> 				   new_dir->d_inode, new_dentry);
> 
> Therefore, target_ip/ipp2 is already known then when xfs_rename/
> xfs_lock_for_rename is called.

You're right.  Back to the drawing board to make rename even simpler.
None of the other patches I sent yesterday depends on this one so they
can go in independently.  And I'd especially like to see the lookup one
before lookup gets more complicated again for CI support.
