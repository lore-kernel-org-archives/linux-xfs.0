Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LJwBSp244033 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 14:58:11 -0500
Date: Fri, 21 Sep 2012 14:59:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: add _require_freeze and minor cleanups
Message-ID: <20120921195921.GB1140@sgi.com>
References: <505A4D04.2080105@redhat.com> <20120921163827.GA1140@sgi.com>
	<505C9A35.5000404@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <505C9A35.5000404@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 21, 2012 at 11:47:49AM -0500, Eric Sandeen wrote:
> On 9/21/12 11:38 AM, Ben Myers wrote:
> > Hey Eric,
> > 
> > On Wed, Sep 19, 2012 at 05:53:56PM -0500, Eric Sandeen wrote:
> >> More filesystems have grown freeze capability, so rather than
> >> hardcoding several in _supported_fs, make tests 068 and 280
> >> generic and then add a new _require_freeze() which checks whether
> >> the fs under test can be frozen before beginning the test.
> >>
> >> Minor other cleanups to 280:
> >> - remove extra _supported_fs line
> >> - clear $seq.full before beginning
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/068 b/068
> >> index b595d1d..617420c 100755
> >> --- a/068
> >> +++ b/068
> >> @@ -51,10 +51,11 @@ trap "_cleanup" 0 1 2 3 15
> >>  . ./common.filter
> >>  
> >>  # real QA test starts here
> >> -_supported_fs btrfs ext3 ext4 xfs
> >> +_supported_fs generic
> >>  _supported_os Linux IRIX
> >>  
> >>  _require_scratch
> >> +_require_freeze
> >>  
> >>  echo "*** init FS"
> >>  
> >> diff --git a/280 b/280
> >> index 55849ed..5e26173 100755
> >> --- a/280
> >> +++ b/280
> >> @@ -45,13 +45,15 @@ _cleanup()
> >>  
> >>  _require_scratch
> >>  _require_quota
> >> +_require_freeze
> >>  
> >>  # real QA test starts here
> >>  
> >>  # Modify as appropriate.
> >> -_supported_fs generic
> >>  _supported_os Linux
> >> -_supported_fs ext3 ext4 xfs
> >> +_supported_fs generic
> >> +
> >> +rm -f $seq.full
> >>  
> >>  umount $SCRATCH_DEV 2>/dev/null
> >>  _scratch_mkfs >> $seq.full 2>&1
> >> diff --git a/common.rc b/common.rc
> >> index 602513a..0e8a306 100644
> >> --- a/common.rc
> >> +++ b/common.rc
> >> @@ -1758,6 +1758,15 @@ _require_btrfs()
> >>  	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support $cmd)"
> >>  }
> >>  
> >> +# Does freeze work on this fs?
> >> +_require_freeze()
> >> +{
> >> +	xfs_freeze -f "$TEST_DIR" >/dev/null 2>&1
> >> +	result=$? 
> >> +	xfs_freeze -u "$TEST_DIR" >/dev/null 2>&1
> >> +	[ $result -eq 0 ] || _notrun "$FSTYP does not support freezing"
> >> +}
> >> +
> > 
> > Pretty good idea to generalize _require_freeze.  It looks like xfs_freeze is a
> > script that uses xfs_io which uses xfsctl XFS_IOC_FREEZE.  So isn't what you
> > have here xfs specific?  It wouldn't work for the other filesystems that
> > implement s_op.freeze_fs:
> 
> It got elevated to a generic ioctl:
> 
> fs/xfs/xfs_fs.h:
> /*      XFS_IOC_FREEZE            -- FIFREEZE   119      */
> /*      XFS_IOC_THAW              -- FITHAW     120      */
> 
> to:
> 
> include/linux/fs.h:
> #define FIFREEZE        _IOWR('X', 119, int)    /* Freeze */
> #define FITHAW          _IOWR('X', 120, int)    /* Thaw */

Ah, great.  I see it now.  It looks like test 119 is also using freeze.  Should
that one also _require_freeze?

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
