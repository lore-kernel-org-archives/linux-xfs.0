Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21295C001B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 08:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbiLNITX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 03:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLNIS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 03:18:28 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD537649
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 00:18:26 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id js9so6137069pjb.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 00:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kOm0MZReKWazQGN5giEeTi7y+aFq7AC7riN0e5D1w+0=;
        b=M3pWLV/3D3JTOQSVEhlwmOe0ziXMYnuYS/rZR8uRJpnnYCBZANYFmyTGKz6lwHe5bv
         WLhzRr0QrTU2saplqTIWV5pt5+DhlDl5wjn3UaTvisDexlXS5feWoMRRWTwd4VyXAMuB
         m2HRG1VBtn6I38xAv6KPf1PoCwocrsE8atw0nmUqKIeIjnZi/lL6W/abv13kYO3YDbXt
         B/I9bLMznXdoZMG5/0y/Q5UrBLKNr3/BvSiBq/TLgLEVnPX+n4lzDm0Ic0s7CqYzYEJ1
         9iPLLWmhTAXixunMXQAOAhl+WvXHdY9fk22edCZiWYmq4xCKy77WKV462GGT5Eeuovxt
         nVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOm0MZReKWazQGN5giEeTi7y+aFq7AC7riN0e5D1w+0=;
        b=iijg8tQaWwEivm2dHg54aDv+NcV1KZHXoJivDMXpcwJNXjO7sTbbUPri/kinRW62n4
         qBx1HXXL9etHsDtMfJHU1t+DjvMMqfcMLWjiIUnJokqowA1ub/zN8dtr+HPOnK3WT6ed
         uv/Jes+3gTy990zLkyYmK/L7Cax+hSdZkHdiFM3yzUhKCDAh9c1EDplaPy+D0WadNMp3
         zX8RjgAofdhIj4FJ+Sj/5SeKIArmN/0dibsXL9lRWFKaBpKGVQwpNjwKWaFzFs1zrGlQ
         +M+slfGf5i85OgY1ggS5bpydIeMhmK/xMdaO3pCLs4iOd7Yw/mZaCB1TeGOAKPJgA8Jd
         s3qQ==
X-Gm-Message-State: ANoB5pnwMszxxu7NA+p7R7KX2d7X6BlweGRssl/eT98AhMWH+vfQQEat
        2yXNa3FOyp+ckHbUI2LLswWYHw==
X-Google-Smtp-Source: AA0mqf7iKyWddkE7va9h558jjiI5EULItJmIXN8thVlZmlNc3h2hDo3TaOkHNGwDb/6bExsXSAR+AQ==
X-Received: by 2002:a17:902:9891:b0:189:2688:c97f with SMTP id s17-20020a170902989100b001892688c97fmr22634591plp.50.1671005906436;
        Wed, 14 Dec 2022 00:18:26 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id ix17-20020a170902f81100b001895f7c8a71sm1239606plb.97.2022.12.14.00.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 00:18:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5My7-008GrP-D9; Wed, 14 Dec 2022 19:18:23 +1100
Date:   Wed, 14 Dec 2022 19:18:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 06/11] xfs: initialize fs-verity on file open and
 cleanup on inode destruction
Message-ID: <20221214081823.GL3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-7-aalbersh@redhat.com>
 <20221214013524.GF3600936@dread.disaster.area>
 <Y5leUu9cnFbN0OM1@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5leUu9cnFbN0OM1@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 09:25:38PM -0800, Eric Biggers wrote:
> On Wed, Dec 14, 2022 at 12:35:24PM +1100, Dave Chinner wrote:
> > On Tue, Dec 13, 2022 at 06:29:30PM +0100, Andrey Albershteyn wrote:
> > > fs-verity will read and attach metadata (not the tree itself) from
> > > a disk for those inodes which already have fs-verity enabled.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > ---
> > >  fs/xfs/xfs_file.c  | 8 ++++++++
> > >  fs/xfs/xfs_super.c | 2 ++
> > >  2 files changed, 10 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 242165580e682..5eadd9a37c50e 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -32,6 +32,7 @@
> > >  #include <linux/mman.h>
> > >  #include <linux/fadvise.h>
> > >  #include <linux/mount.h>
> > > +#include <linux/fsverity.h>
> > >  
> > >  static const struct vm_operations_struct xfs_file_vm_ops;
> > >  
> > > @@ -1170,9 +1171,16 @@ xfs_file_open(
> > >  	struct inode	*inode,
> > >  	struct file	*file)
> > >  {
> > > +	int		error = 0;
> > > +
> > >  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
> > >  		return -EIO;
> > >  	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
> > > +
> > > +	error = fsverity_file_open(inode, file);
> > > +	if (error)
> > > +		return error;
> > 
> > This is a hot path, so shouldn't we elide the function call
> > altogether if verity is not enabled on the inode? i.e:
> > 
> > 	if (IS_VERITY(inode)) {
> > 		error = fsverity_file_open(inode, file);
> > 		if (error)
> > 			return error;
> > 	}
> > 
> > It doesn't really matter for a single file open, but when you're
> > opening a few million inodes every second the function call overhead
> > only to immediately return because IS_VERITY() is false adds up...
> > 
> > >  	return generic_file_open(inode, file);
> > >  }
> > >  
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 8f1e9b9ed35d9..50c2c819ba940 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -45,6 +45,7 @@
> > >  #include <linux/magic.h>
> > >  #include <linux/fs_context.h>
> > >  #include <linux/fs_parser.h>
> > > +#include <linux/fsverity.h>
> > >  
> > >  static const struct super_operations xfs_super_operations;
> > >  
> > > @@ -647,6 +648,7 @@ xfs_fs_destroy_inode(
> > >  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> > >  	XFS_STATS_INC(ip->i_mount, vn_rele);
> > >  	XFS_STATS_INC(ip->i_mount, vn_remove);
> > > +	fsverity_cleanup_inode(inode);
> > 
> > Similarly, shouldn't this be:
> > 
> > 	if (fsverity_active(inode))
> > 		fsverity_cleanup_inode(inode);
> > 
> 
> If you actually want to do that, then we should instead make these functions
> inline functions that do the "is anything needed?" check, then call a
> double-underscored version that does the actual work.  Some of the fscrypt
> functions are like that.  Then all filesystems would get the benefit.

Agreed, that's the right way to do it. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
