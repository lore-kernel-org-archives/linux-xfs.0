Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 01:01:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4H81kfB011744
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 01:01:48 -0700
Date: Thu, 17 May 2007 17:36:46 +1000
From: David Disseldorp <ddiss@sgi.com>
Subject: Re: Review: fix b0rked test 030 behaviour.
Message-ID: <20070517173646.0000116c@snort.melbourne.sgi.com>
In-Reply-To: <20070511011145.GN86004887@sgi.com>
References: <20070511011145.GN86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Change looks good Dave, test 148 (xfs_prepair64 version of 030) will need the same .out file change.

Cheers, David D

Index: xfs-cmds/xfstests/148.out
===================================================================
--- xfs-cmds.orig/xfstests/148.out      2007-05-03 17:10:29.554803451 +1000
+++ xfs-cmds/xfstests/148.out   2007-05-03 17:10:54.231584667 +1000
@@ -270,6 +270,10 @@ Phase 1 - find and verify superblock...
 Phase 2 - using <TYPEOF> log
         - zero log...
         - scan filesystem freespace and inode maps...
+bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
         - found root inode chunk
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...



On Fri, 11 May 2007 11:11:45 +1000
David Chinner <dgc@sgi.com> wrote:

> Test 030 is not testing things as it should.
> 
> Specifically, corrupting the AGFL with "-1" is a no-op on
> a freshly repaired filesystem, because xfs_repair rebuilds
> the AGF btrees and AGFL from scratch and does not populate
> the AGFL.
> 
> The current test does:
> 
> 	repair
> 	mount
> 	create file
> 	remove file
> 	umount
> 
> And it does the filesystem twiddling to check that the filesystem
> is ußable after repair. The problem is that this doesn't dirty the
> filesystem - the create is followed by a remove, so nothing is
> actually allocated and so the AGFL lists do not get modified.
> 
> hence after a repair/check/corruption cycle, writing "-1" to
> the AGFL is a no-op because it is already full of "-1" fields
> (NULL blocks).
> 
> With filestreams, the create/remove pair *does* modify the filesystem
> and so when we write "-1" to the AGFL, we get different output
> because the filesystem detects new corruptions and the test "fails".
> 
> So, to make behaviour consistent, dirty the filesystem before
> corrupting it on each cycle. Hence it doesn't matter if we are
> using filestreams or not, we'll really test out corrupting the
> AGFL with NULL blocks (-1) now.
> 
> Comments?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
> ---
>  xfstests/030.out.irix  |    4 ++++
>  xfstests/030.out.linux |    4 ++++
>  xfstests/common.repair |   10 ++++++++++
>  3 files changed, 18 insertions(+)
> 
> Index: xfs-cmds/xfstests/030.out.irix
> ===================================================================
> --- xfs-cmds.orig/xfstests/030.out.irix	2007-05-03 17:10:29.554803451 +1000
> +++ xfs-cmds/xfstests/030.out.irix	2007-05-03 17:10:54.227585189 +1000
> @@ -262,6 +262,10 @@ Wrote X.XXKb (value 0xffffffff)
>  Phase 1 - find and verify superblock...
>  Phase 2 - zero log...
>          - scan filesystem freespace and inode maps...
> +bad agbno AGBNO in agfl, agno 0
> +bad agbno AGBNO in agfl, agno 0
> +bad agbno AGBNO in agfl, agno 0
> +bad agbno AGBNO in agfl, agno 0
>          - found root inode chunk
>  Phase 3 - for each AG...
>          - scan and clear agi unlinked lists...
> Index: xfs-cmds/xfstests/030.out.linux
> ===================================================================
> --- xfs-cmds.orig/xfstests/030.out.linux	2007-05-03 17:10:29.554803451 +1000
> +++ xfs-cmds/xfstests/030.out.linux	2007-05-03 17:10:54.231584667 +1000
> @@ -270,6 +270,10 @@ Phase 1 - find and verify superblock...
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> +bad agbno AGBNO in agfl, agno 0
> +bad agbno AGBNO in agfl, agno 0
> +bad agbno AGBNO in agfl, agno 0
> +bad agbno AGBNO in agfl, agno 0
>          - found root inode chunk
>  Phase 3 - for each AG...
>          - scan and clear agi unlinked lists...
> Index: xfs-cmds/xfstests/common.repair
> ===================================================================
> --- xfs-cmds.orig/xfstests/common.repair	2007-05-03 17:10:29.554803451 +1000
> +++ xfs-cmds/xfstests/common.repair	2007-05-03 17:10:54.231584667 +1000
> @@ -72,8 +72,18 @@ _check_repair()
>  {
>  	value=$1
>  	structure="$2"
> +
> +	#ensure the filesystem has been dirtied since last repair
> +	_scratch_mount
> +	POSIXLY_CORRECT=yes \
> +	dd if=/bin/sh of=$SCRATCH_MNT/sh 2>&1 |_filter_dd
> +	sync
> +	rm -f $SCRATCH_MNT/sh
> +	umount $SCRATCH_MNT
> +
>  	_zero_position $value "$structure"
>  	_scratch_xfs_repair 2>&1 | _filter_repair
> +
>  	# some basic sanity checks...
>  	_check_scratch_fs
>  	_scratch_mount                                      #mount
> 
