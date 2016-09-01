Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 46F367CA2
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 10:57:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EDE2A8F8037
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 08:57:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CBW7bF1vAAIK27pC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 01 Sep 2016 08:57:41 -0700 (PDT)
Date: Thu, 1 Sep 2016 08:57:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/13] xfs: fix $XFS_DB_PROG usage
Message-ID: <20160901155736.GA25818@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
	<147216773738.32641.691363173215857168.stgit@birch.djwong.org>
	<20160901073731.GA27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160901073731.GA27776@eguan.usersys.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 01, 2016 at 03:37:31PM +0800, Eryu Guan wrote:
> On Thu, Aug 25, 2016 at 04:28:57PM -0700, Darrick J. Wong wrote:
> > xfs_db requires us to pass in the log device, if any; this can be
> > accomplished via _scratch_xfs_db_options (if we're operating on the
> > scratch device, anyway).  However, many of the tests/xfs/ scripts
> > pass only $SCRATCH_DEV directly, so they'll fail if we test with an
> > external log.  So, fix that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> [snip]
> > diff --git a/tests/xfs/111 b/tests/xfs/111
> > index f6a41a8..4899020 100755
> > --- a/tests/xfs/111
> > +++ b/tests/xfs/111
> > @@ -64,7 +64,7 @@ INO=`ls -i $SCRATCH_MNT/512 | awk '{print $1}'`
> >  _scratch_unmount
> >  
> >  # Figure out where that middle inode starts
> > -BYTE=`$XFS_DB_PROG -c "convert inode $INO byte" $SCRATCH_DEV \
> > +BYTE=`$XFS_DB_PROG -c "convert inode $INO byte" `_scratch_xfs_db_options` \
> 
> This has syntax error because of the nested ``, $SCRATCH_DEV is already
> within a ``. Replace `` with $() could fix it.
> 
> -BYTE=`$XFS_DB_PROG -c "convert inode $INO byte" `_scratch_xfs_db_options` \
> +BYTE=`$XFS_DB_PROG -c "convert inode $INO byte" $(_scratch_xfs_db_options) \
> 
> [snip]
> 
> > diff --git a/tests/xfs/186 b/tests/xfs/186
> > index 192a8c8..347db0d 100755
> > --- a/tests/xfs/186
> > +++ b/tests/xfs/186
> > @@ -98,8 +98,8 @@ _print_inode()
> >  {
> >  	echo ""
> >  	echo "================================="
> > -	$XFS_DB_PROG -c "version" $SCRATCH_DEV 2>&1 | _filter_version
> > -	$XFS_DB_PROG -c "inode $inum" -c p $SCRATCH_DEV 2>&1 | _filter_inode
> > +	$XFS_DB_PROG -c "version" `_scratch_xfs_db_options` 2>&1 | _filter_version
> > +	$XFS_DB_PROG -c "inode $inum" -c p `_scratch_xfs_db_options` 2>&1 | _filter_inode
> >  	echo "================================="
> >  }
> >  
> > @@ -136,7 +136,7 @@ _changeto_attr1()
> >  	echo ""
> >  	echo "Try setting attr1 by db"
> >  	echo ""
> > -	$XFS_DB_PROG -x -c "version attr1" $SCRATCH_DEV | _filter_version
> > +	$XFS_DB_PROG -x -c "version attr1" `_scratch_xfs_db_options` | _filter_version
> >  }
> >  
> >  # get standard environment, filters and checks
> > @@ -173,7 +173,7 @@ fi
> >  
> >  # set inum to root dir ino
> >  # we'll add in dirents and EAs into the root directory
> > -eval `$XFS_DB_PROG -r -c 'sb 0' -c 'p rootino' $SCRATCH_DEV | $SED_PROG 's/ //g'`
> > +eval `$XFS_DB_PROG -r -c 'sb 0' -c 'p rootino' `_scratch_xfs_db_options` | $SED_PROG 's/ //g'`
> 
> And here.
> 
> I can fix them at commit time.

I actually found more files that needed fixing, so I'll resubmit with
the extra fixes + the two fixes above.  Thank you for the review!

--D

> 
> Thanks,
> Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
