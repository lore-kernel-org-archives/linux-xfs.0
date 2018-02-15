Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755188AbeBOIdU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 03:33:20 -0500
Date: Thu, 15 Feb 2018 16:33:17 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs/015: enlarge the initial fs size
Message-ID: <20180215083317.GQ18267@eguan.usersys.redhat.com>
References: <20180104054626.14458-1-eguan@redhat.com>
 <20180214152401.GO18267@eguan.usersys.redhat.com>
 <20180214164532.GH5217@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214164532.GH5217@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Feb 14, 2018 at 08:45:32AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 14, 2018 at 11:24:01PM +0800, Eryu Guan wrote:
> > On Thu, Jan 04, 2018 at 01:46:26PM +0800, Eryu Guan wrote:
> > > Kernel commit f59cf5c29919 ("xfs: remove "no-allocation"
> > > reservations for file creations") is known to cause earlier ENOSPC
> > > conditions, and xfs/015 is affected in the way that no new file/dir
> > > can be created in a newly created 16M XFS with both reflink and
> > > rmapbt enabled, thus xfs/015 fails due to the missing test dirs.
> > > 
> > > So enlarge the initial fs size to 32M that we're able to create new
> 
> 32M?  I thought this was a 64M -> 128M expansion?

The final fs size (after growfs) is expanded from 64M to 128M, but we
need the initial fs size (prior to growfs) to be 32M instead of 16M.

> 
> > > dir/file before growing the filesystem size.
> > > 
> > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> 
> I don't think this hurts anything, but otoh I couldn't reproduce the
> failure you're seeing on my setup.

You need "both reflink and rmapbt enabled", I can still reproduce it
with v4.16-rc1 kernel with MKFS_OPTIONS="-m reflink=1,rmapbt=1".

Thanks for reviewing!

Eryu

> 
> --D
> 
> > 
> > ping on this patch.
> > 
> > Eryu
> > 
> > > ---
> > >  tests/xfs/015 | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/tests/xfs/015 b/tests/xfs/015
> > > index 2c57f7882308..4939bb92f6fc 100755
> > > --- a/tests/xfs/015
> > > +++ b/tests/xfs/015
> > > @@ -66,15 +66,15 @@ _supported_os Linux
> > >  
> > >  _require_scratch
> > >  
> > > -# need 64M space, don't make any assumption
> > > +# need 128M space, don't make any assumption
> > >  _scratch_mkfs >/dev/null 2>&1
> > >  _scratch_mount
> > > -_require_fs_space $SCRATCH_MNT 65536
> > > +_require_fs_space $SCRATCH_MNT 131072
> > >  _scratch_unmount
> > >  
> > >  rm -f $seqres.full
> > >  
> > > -_scratch_mkfs_sized $((16 * 1024 * 1024)) > $tmp.mkfs.raw
> > > +_scratch_mkfs_sized $((32 * 1024 * 1024)) > $tmp.mkfs.raw
> > >  cat $tmp.mkfs.raw | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > >  # get original data blocks number and agcount
> > >  . $tmp.mkfs
> > > -- 
> > > 2.14.3
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
