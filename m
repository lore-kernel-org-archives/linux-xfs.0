Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5193C7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:04:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 416FE304059
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 01:04:23 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id qhNylVaajHq9EH2Y for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 01:04:19 -0700 (PDT)
Date: Tue, 12 Mar 2013 04:04:11 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <924669527.12643828.1363075451534.JavaMail.root@redhat.com>
In-Reply-To: <20130312074608.GL21651@dastard>
Subject: Re: 3.9-rc2 xfs panic
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: xfs@oss.sgi.com
> Sent: Tuesday, March 12, 2013 3:46:08 PM
> Subject: Re: 3.9-rc2 xfs panic
> 
> On Tue, Mar 12, 2013 at 02:34:07AM -0400, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Dave Chinner" <david@fromorbit.com>
> > > To: "CAI Qian" <caiqian@redhat.com>
> > > Cc: xfs@oss.sgi.com
> > > Sent: Tuesday, March 12, 2013 2:07:01 PM
> > > Subject: Re: 3.9-rc2 xfs panic
> > > 
> > > On Tue, Mar 12, 2013 at 12:32:28AM -0400, CAI Qian wrote:
> > > > Just came across when running xfstests using 3.9-rc2 kernel on
> > > > a
> > > > power7
> > > > box with addition of this patch which fixed a known issue,
> > > > http://people.redhat.com/qcai/stable/01-fix-double-fetch-hlist.patch
> > > > 
> > > > The log shows it was happened around test case 370 with
> > > > TEST_PARAM_BLKSIZE = 2048
> > > 
> > > That doesn't sound like xfstests. it only has 305 tests, and no
> > > parameters like TEST_PARAM_BLKSIZE....
> > Sorry, it is a typo, test case 270 not 370. TEST_PARAM_BLKSIZE was
> > from an internal wrapper to be used to create new filessytem not
> > from the
> > original xfstests.
> 
> OK, so that means you're testing 2k filesystem block size on a 64k
> page size machine?
Looks like so. Would that be a problem?

TEST_PARAM_TEST_DEV not specified; using loopback file
TEST_PARAM_SCRATCH_DEV not specified; using loopback file
meta-data=/dev/loop0             isize=256    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=2048   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=2048   blocks=5120, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
TEST_DEV=/dev/loop0				# device containing TEST PARTITION
TEST_DIR=/mnt/testarea/test				# mount point of TEST PARTITION
SCRATCH_DEV=/dev/loop1			# device containing SCRATCH PARTITION
SCRATCH_MNT=/mnt/testarea/scratch			# mount point for SCRATCH PARTITION
SCRATCH_LOGDEV=			# optional external log for SCRATCH PARTITION
SCRATCH_RTDEV=			# optional realtime device for SCRATCH PARTITION
TMPFS_MOUNT_OPTIONS=""	# scratch mount options for tmpfs
TEST_FS_MOUNT_OPTS=""	# test mount options for tmpfs
> Are you running with CONFIG_XFS_DEBUG=y?
# CONFIG_XFS_DEBUG is not set
I can enable this if I can reproduce it.
> 
> > > So, looks like memory corruption - a corrupted slab, perhaps? Can
> > > you turn on memory poisoning, debugging, etc?
> 
> Does this turn anything up?
It is still running. Unsure if it is reproducible at this point.
CAI Qian
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
