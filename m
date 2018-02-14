Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031247AbeBNPbS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Feb 2018 10:31:18 -0500
Date: Wed, 14 Feb 2018 23:31:15 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] xfs: skip xfs_check in _check_xfs_filesystem
Message-ID: <20180214153115.GP18267@eguan.usersys.redhat.com>
References: <151803835881.19313.17455678207236452557.stgit@magnolia>
 <151803837117.19313.3481001926133028039.stgit@magnolia>
 <20180208125152.GE18267@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208125152.GE18267@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Feb 08, 2018 at 08:51:52PM +0800, Eryu Guan wrote:
> On Wed, Feb 07, 2018 at 01:19:31PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs_check has been long obsolete, so stop running it automatically
> > after every test.  Tests that explicitly want xfs_check can call it
> > via _scratch_xfs_check or _xfs_check; that part doesn't go away.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'd like to see an ACK on this from XFS community.

ping on this patch for review. Personally I'm happy to see skipping
xfs_check, it's deprecated and I can avoid test failures caused by
xfs_db crash due to out-of-memory in xfs_check run.

Thanks,
Eryu

> 
> > ---
> >  common/xfs |   17 -----------------
> >  1 file changed, 17 deletions(-)
> > 
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 3dba40d..c63e5dc 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -386,23 +386,6 @@ _check_xfs_filesystem()
> >  		ok=0
> >  	fi
> >  
> > -	# xfs_check runs out of memory on large files, so even providing the test
> > -	# option (-t) to avoid indexing the free space trees doesn't make it pass on
> > -	# large filesystems. Avoid it.
> > -	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
> > -		_xfs_check $extra_log_options $device 2>&1 |\
> > -			_fix_malloc >$tmp.fs_check
> > -	fi
> > -	if [ -s $tmp.fs_check ]; then
> > -		_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (c)"
> > -		echo "*** xfs_check output ***"		>>$seqres.full
> > -		cat $tmp.fs_check			>>$seqres.full
> > -		echo "*** end xfs_check output"		>>$seqres.full
> > -
> > -		xfs_metadump $device $seqres.check	>>$seqres.full 2>&1
> > -		ok=0
> > -	fi
> > -
> >  	$XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
> >  	if [ $? -ne 0 ]; then
> >  		_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (r)"
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
