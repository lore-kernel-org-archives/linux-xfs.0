Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58808 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbfGGXYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 19:24:05 -0400
Date: Mon, 8 Jul 2019 09:22:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] dget_parent() misuse in xfs_filestream_get_parent()
Message-ID: <20190707232254.GF7689@dread.disaster.area>
References: <20190628060026.GR17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628060026.GR17978@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Jun 28, 2019 at 07:00:27AM +0100, Al Viro wrote:
> 	dget_parent() never returns NULL.  So this
> 
>         parent = dget_parent(dentry);
>         if (!parent)
>                 goto out_dput;
> 
>         dir = igrab(d_inode(parent));
>         dput(parent);
> 
> out_dput:
> 
> is obviously fishy.  What is that code trying to do?  Is that
> "dentry might be a root of disconnected tree, in which case
> we want xfs_filestream_get_parent() to return NULL"? 

We want the parent inode of the current file inode if it is in
memory. We don't care about the parent dentry that is returned as
such, it's just the mechanism for finding the directory inode. The
directory inode is what holds the allocation policy for all files in
that directory, and that's what we need here.

If there is no parent directory inode in memory, then we'll just use
the default allocator behaviour rather than the context specific
one we get from the directory inode...

> If so,
> that should be
> 
>         parent = dget_parent(dentry);
>         if (parent != dentry)
> 		dir = igrab(d_inode(parent));
>         dput(parent);

Seems reasonable. This code is largely legacy functionality, the
allocator was really a specific workload policy that was never
widely deployed and so the combination of disconnected dentries and
this allocator have probably never been seen in real life...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
