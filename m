Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:3963 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751896AbdJIK5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 06:57:03 -0400
Date: Mon, 9 Oct 2017 21:57:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about backups with XFS
Message-ID: <20171009105701.GL3666@dastard>
References: <20171007114343.3bd42f98@lubh.lubhome>
 <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>, linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 10:44:51AM +0200, Carlos Maiolino wrote:
> Hi.
> 
> 
> On Sat, Oct 07, 2017 at 02:43:43PM +0000, Luciano ES wrote:
> > I have a few questions and I was torn between asking them separately 
> > and putting them all in one message. I decided for the latter and I 
> > hope this is not a problem.
> > 
> > Once upon a time, many many years ago, I used to make backup copies 
> > of my file systems with the 'cp -aux' command, including my live 
> > root file system. Luckily, I never had to restore any live root file 
> > system from those backups. They probably would never have worked.
> > 
> > Later on, someone taught me to do it like this:
> > 
> > find /source -xdev -print0 | cpio -pa0V /target
> > 
> > That command is supposed to copy everything, including special files 
> > (not really sure which) that mere cp or even rsync would not copy. 
> > I actually used that approach several times, including restoration, 
> > and it always worked.
> > 
> > For some reason, I stopped making backups of my live root file 
> > system, but I still backup other partitions with rsync, always with 
> > the --delete-before parameter, so the target is always an exact copy 
> > of the source.
> > 
> > I have been using XFS for a few years and thought that maybe it's 
> > time I enjoyed all the benefits of the XFS management tools.
> > However, I am uncertain about things I haven't been able to find in 
> > the documentation or even on the Web:
> > 
> > Question #1:
> > Does xfsdump really copy EVERYTHING? Can I backup a full live root 
> > file system with it and expect a restored copy to boot and run 
> > uneventfully? Or should I rather do a 'hard' image with xfs_copy? 
> 
> xfs_copy must only be used an unmounted filesystem (or read-only, frozen, etc),
> so, unless you want to freeze/unmount your FS everytime you do a xfs_copy, then
> xfs_copy is not what you are looking for

I'll just say this: xfs_copy is not a backup tool. It's a filesystem
image replication tool designed for fast, efficient 1-to-many
duplication of a golden filesystem image to multiple drives, such as
is done in manufacturing lines....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
