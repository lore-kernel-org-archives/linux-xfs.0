Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D49E7F77
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 22:42:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E70C9AC001
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 20:42:22 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	unFvYoBFuiqbqJrz for <xfs@oss.sgi.com>;
	Mon, 27 Jan 2014 20:42:21 -0800 (PST)
Date: Tue, 28 Jan 2014 15:42:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs for-3.1.12 branch has been updated to 40c65a7
Message-ID: <20140128044216.GI2212@dastard>
References: <201401201822.48520.arekm@maven.pl>
 <52E6A9A2.1010905@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E6A9A2.1010905@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 27, 2014 at 12:46:58PM -0600, Rich Johnston wrote:
> Arkadiusz,
> =

> Thanks for compiling the list.
> =

> The for-3.1.12  Branch created from "a547280... 3.1.11 release"
> =

> If there are others you want committed, please let me know.
> =

> Thanks
> --Rich
> =

> =

> The following have been committed from the candidate list
> provided by Arkadiusz:
> =

> =

> 40c65a7... xfs_metadump: Make -F (force) optional
> ec3a1f1... xfs_repair: suggest reboot after dangerous repair
> 8660952... xfsprogs: suggest "-d" option for repair of RO mount
> 5a8206c... xfs_repair: correct docs for "-t" units
> 0d5c444... xfs_fsr: fix SWAPEXT failures under selinux
> f3d3dae... libxfs: fix root inode handling inconsistencies

Introduces this compiler warning in db/init.c:

init.c: In function =BFinit=BF:
init.c:152:3: warning: implicit declaration of function =BFxfs_initialize_p=
erag_data=BF [-Wimplicit-function-declaration]


> cf507b6... xfsprogs: remove xfs_check references from fsck.xfs
> script & manpage
> 6e2f2d1... xfsprogs: fix resource leak in longform_dir2_rebuild()
> ecde3f9... xfs_repair: test for bad level in dir2 node
> d299df7... xfs_repair: avoid segfault if reporting progress early in repa=
ir
> e660c2e... Sent: Friday, October 11, 2013 12:38:11 AM Subject:
> Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
> 5e1c7ac... xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
> aba6204... xfsprogs: fix return value of verify_set_primary_sb()
> a2ea195... xfsprogs: fix potential memory leak in verify_set_primary_sb()
> 3e53939... xfsprogs: fix potential memory leak in repare/sb.c
> 820b8c2... xfsprogs: avoid array overflow in pf_batch_read()
> 2a1dcdb... xfs_repair: zero out unused parts of superblocks
> 982508b... xfsprogs: fix inode crash in xfs_repair

Introduces this compiler warning in repair/phase6.c:

phase6.c: In function =BFmk_orphanage=BF:
phase6.c:895:3: warning: implicit declaration of function =BFalloc_ex_data=
=BF [-Wimplicit-function-declaration]

Running some smoke testing on the branch now. Rich, I expect that
you'll be doing some in-depth functionality, scalability and stress
testing of the branch over the next week or two?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
