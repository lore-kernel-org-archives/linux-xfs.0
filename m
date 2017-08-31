Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58759 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750908AbdHaVwM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 17:52:12 -0400
Date: Fri, 1 Sep 2017 07:52:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix unused variable warning in xfs_buf_item_unlock()
Message-ID: <20170831215209.GQ10621@dastard>
References: <20170831160458.24886-1-bfoster@redhat.com>
 <20170831164107.GL3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170831164107.GL3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Aug 31, 2017 at 09:41:07AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 31, 2017 at 12:04:58PM -0400, Brian Foster wrote:
> > The ordered variable generates an unused warning on !DEBUG builds.
> > Separate the initialization of the associated variables from the
> > declarations to quiet gcc.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

And merged before everyone in different timezones has had a chance
to comment. :(

I just built the latest for-next with CONFIG_XFS_DEBUG=n and there's
three set-but-unused warnings, one of which is introduced by this
patch.

fs/xfs/libxfs/xfs_inode_fork.c: In function ¿xfs_iext_realloc_indirect¿:
fs/xfs/libxfs/xfs_inode_fork.c:1503:7: error: variable ¿size¿ set but not used [-Werror=unused-but-set-variable]
  int  size;  /* current indirection array size */
       ^~~~

fs/xfs/xfs_buf_item.c: In function ¿xfs_buf_item_unlock¿:
fs/xfs/xfs_buf_item.c:573:9: error: variable ¿ordered¿ set but not used [-Werror=unused-but-set-variable]
  bool   ordered;
         ^~~~~~~

fs/xfs/xfs_log_recover.c: In function ¿xlog_recover_process_intents¿:
fs/xfs/xfs_log_recover.c:4830:13: error: variable ¿last_lsn¿ set but not used [-Werror=unused-but-set-variable]
  xfs_lsn_t  last_lsn;
             ^~~~~~~~

Yeah, maintainer habits die hard; I'm still patching fs/xfs/Makefile
in my build trees with this:

-ccflags-y += -I$(src)                  # needed for trace events
+ccflags-y += -I$(src) -Werror -Wunused-but-set-variable

Which catches stupid problems like this that will the userspace
libxfs build will trip over when the next merge occurs.

Playing games with declaration/initialisation order to avoid
warnigns just doesn't work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
