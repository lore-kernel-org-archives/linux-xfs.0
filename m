Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G6WAxX072370 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 01:32:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAD9719BBEA
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:31:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CdVSsHjNV65QhI8p for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:31:49 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Lj6M3-0001ib-5Y
	for xfs@oss.sgi.com; Mon, 16 Mar 2009 06:31:19 +0000
Date: Mon, 16 Mar 2009 02:31:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: a couple of fixes for external logs
Message-ID: <20090316063119.GD4957@infradead.org>
References: <20090224131847.GB1579@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090224131847.GB1579@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Tue, Feb 24, 2009 at 08:18:47AM -0500, Christoph Hellwig wrote:
> Fix a couple of issues when running xfsqa with external logs:
> 
>  - update the 096 golden output for the external log case
>  - add a new _scratch_xfs_check similar to _scratch_xfs_logprint and
>    _scratch_xfs_repair that take the log device into account and use it
>    in test 134
>  - use _scratch_xfs_repair in test 202 to fix it for external log
>    devices
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests-dev/017
> ===================================================================
> --- xfstests-dev.orig/017	2009-02-23 21:05:07.000000000 +0000
> +++ xfstests-dev/017	2009-02-23 21:08:46.000000000 +0000
> @@ -67,7 +67,7 @@
>          echo ""                             >>$seq.full
>          echo "*** XFS_CHECK ***"            >>$seq.full
>          echo ""                             >>$seq.full
> -        xfs_check $checkopts $SCRATCH_DEV   >>$seq.full 2>&1 \
> +        _scratch_xfs_check $checkopts       >>$seq.full 2>&1 \
>              || _fail "xfs_check $checkopts failed"
>          _scratch_mount -o remount,rw \
>              || _fail "remount rw failed"
> Index: xfstests-dev/common.rc
> ===================================================================
> --- xfstests-dev.orig/common.rc	2009-02-23 21:05:07.000000000 +0000
> +++ xfstests-dev/common.rc	2009-02-24 00:09:39.000000000 +0000
> @@ -268,6 +268,14 @@
>      $XFS_LOGPRINT_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
>  }
>  
> +_scratch_xfs_check()
> +{
> +    SCRATCH_OPTIONS=""
> +    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +        SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
> +    $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
> +}
> +
>  _scratch_xfs_repair()
>  {
>      SCRATCH_OPTIONS=""
> Index: xfstests-dev/202
> ===================================================================
> --- xfstests-dev.orig/202	2009-02-23 21:15:56.000000000 +0000
> +++ xfstests-dev/202	2009-02-23 21:20:12.000000000 +0000
> @@ -20,6 +20,7 @@
>  # get standard environment, filters and checks
>  . ./common.rc
>  . ./common.filter
> +. ./common.repair
>  
>  # real QA test starts here
>  _supported_fs xfs
> @@ -31,10 +32,10 @@
>  _scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
>  
>  echo "== Trying to repair it (should fail) =="
> -xfs_repair $SCRATCH_DEV
> +_scratch_xfs_repair
>  
>  echo "== Trying to repair it with -o force_geometry =="
> -xfs_repair -o force_geometry $SCRATCH_DEV
> +_scratch_xfs_repair -o force_geometry 2>&1 | _filter_repair
>  
>  # success, all done
>  echo "*** done"
> Index: xfstests-dev/202.out
> ===================================================================
> --- xfstests-dev.orig/202.out	2009-02-23 21:18:49.000000000 +0000
> +++ xfstests-dev/202.out	2009-02-23 21:20:46.000000000 +0000
> @@ -6,19 +6,17 @@
>  Use the -o force_geometry option to proceed.
>  == Trying to repair it with -o force_geometry ==
>  Phase 1 - find and verify superblock...
> -Phase 2 - using internal log
> +Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
>          - found root inode chunk
>  Phase 3 - for each AG...
>          - scan and clear agi unlinked lists...
>          - process known inodes and perform inode discovery...
> -        - agno = 0
>          - process newly discovered inodes...
>  Phase 4 - check for duplicate blocks...
>          - setting up duplicate extent list...
>          - check for inodes claiming duplicate blocks...
> -        - agno = 0
>  Phase 5 - rebuild AG headers and trees...
>          - reset superblock...
>  Phase 6 - check inode connectivity...
> Index: xfstests-dev/096.external
> ===================================================================
> --- xfstests-dev.orig/096.external	2009-02-23 21:23:19.000000000 +0000
> +++ xfstests-dev/096.external	2009-02-23 21:24:38.000000000 +0000
> @@ -30,7 +30,7 @@
>  
>  
>  # test out data stripe
> ---- mkfs=-d su=266240,sw=1 ---
> +--- mkfs=-l version=1 -d su=266240,sw=1 ---
>  meta-data=DEV isize=256    agcount=N, agsize=N blks
>  data     =                       bsize=4096   blocks=N, imaxpct=25
>           =                       sunit=65     swidth=65 blks, unwritten=1
> @@ -41,7 +41,7 @@
>  
>  
>  # test out data stripe the same but using sunit & swidth
> ---- mkfs=-d sunit=520,swidth=520 ---
> +--- mkfs=-l version=1 -d sunit=520,swidth=520 ---
>  meta-data=DEV isize=256    agcount=N, agsize=N blks
>  data     =                       bsize=4096   blocks=N, imaxpct=25
>           =                       sunit=65     swidth=65 blks, unwritten=1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
