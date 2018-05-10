Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:54444 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbeEJTJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 15:09:17 -0400
Date: Thu, 10 May 2018 20:09:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3] fs: don't scan the inode cache before SB_BORN is set
Message-ID: <20180510190916.GQ30522@ZenIV.linux.org.uk>
References: <20180510042132.GS23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510042132.GS23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, May 10, 2018 at 02:21:33PM +1000, Dave Chinner wrote:

> Setting sb->s_fs_info to NULL on xfs_mount setup failure only solves
> the use-after-free part of the problem - it doesn't solve the
> use-before-initialisation part. To solve that we need to check the
> SB_BORN flag in super_cache_count().
> 
> The SB_BORN flag is not set until ->fs_mount() completes
> successfully and trylock_super() won't succeed until it is set.
> Hence super_cache_scan() will not run until SB_BORN is set, so it
> makes sense to not allow super_cache_scan to run and enter the
> filesystem until it is set, too. This prevents the superblock
> shrinker from entering the filesystem while it is being set up and
> so avoids the use-before-initialisation issue.

I'm fine with the first part of that (fs/super.c, that is), but
I don't understand why do you need the xfs side of the patch with
that.  Confused...
