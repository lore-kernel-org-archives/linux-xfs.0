Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41817 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754372AbeDWI2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 04:28:48 -0400
Received: by mail-wr0-f194.google.com with SMTP id g21-v6so11235511wrb.8
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 01:28:48 -0700 (PDT)
Date: Mon, 23 Apr 2018 10:28:45 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Add a helper to retrieve xfs_inode from the
 address_space
Message-ID: <20180423082845.ofpuv2dfezoejyxt@odin.usersys.redhat.com>
References: <20180419143511.16924-1-cmaiolino@redhat.com>
 <20180419225002.GQ23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419225002.GQ23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 20, 2018 at 08:50:02AM +1000, Dave Chinner wrote:
> On Thu, Apr 19, 2018 at 04:35:11PM +0200, Carlos Maiolino wrote:
> > Reduce some code and local variable allocation on file operations by
> > using a new helper.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > Hi, I though this could be useful instead of keeping allocating file,
> > address_space and inode structs in several places, just to retrieve the
> > xfs_inode, what you guys think?
> > 
> > XFS_FTOINO() isn't really a good name, that's the first one which came to my
> > mind, if this is useful at all I can change the name to something else, like
> > XFS_AS_TO_INO() maybe, or something else?!
> 
> I'd prefer that we don't add more "vfs to xfs structure" macros like
> this. It doesn't make the code any more readable or correct,
> especially for non-XFS developers.
> 

Ok.

> > Although I think some vfs_wide helper like file_inode() would be more useful,
> > but, well, it's just an idea that came to my mind.
> 
> XFS_I(file_inode(file)) would be my preferred solution here, as it
> uses the correct VFS accessor function to get the VFS inode from
> the struct file and it's obvious what it does to anyone familiar
> with typical VFS and filesystem coding conventions.
> 

I think keep nesting function calls to reduce a few lines of code if harder to
read indeed, and I would stay with the current way and pretend I've never
submitted this patch :)

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Carlos
