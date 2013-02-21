Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF6997F50
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 11:02:21 -0600 (CST)
Message-ID: <5126531B.9080603@sgi.com>
Date: Thu, 21 Feb 2013 11:02:19 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/8] xfsprogs: misc small fixes
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 01/26/13 16:40, Eric Sandeen wrote:
> A handful of fixes from looking over a Coverity scan.
>
> The strncpy fixes (1/8, 5/8) might not be too critical,
> but I think they can't hurt.
>
> The libxfs xfs_alloc_arg initialization (2/8) might clash with Dave's
> libxfs syncup, it can be dropped if it makes things difficult.
> Fixes a real bug though.
>
> Tested by a quick run through xfstests -g auto

I committed the following patches of yours to OSS xfsprogs:

commit b3a5164e6e474f03cd2d5e6d5168d4ced3d3282b
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Jan 25 21:10:22 2013 +0000

     xfsprogs: Fix possible unallocated memory access in fiemap

Coverity flagged series patches 1, 3-8:

commit 55d1fd480b7328f0c51a7de5ed64ea371927c933
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Jan 26 22:40:25 2013 +0000

     libhandle: Guard against string overflow in path_to_fspath()

commit 2c2e994d0a1b972d020d7633202bf2f4cfc9f91b
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Jan 26 22:40:27 2013 +0000

     libxfs: fix setup_cursor array allocation

commit 50c79b8df93c45495e81c15aca65abde469f1565
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Jan 26 22:40:28 2013 +0000

     xfs_repair: Fix free of uninit ptr in xfs_acl_valid() error path

commit 6063fecad207d13981dea3e20f89f7ac4c3fb26f
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Jan 26 22:40:29 2013 +0000

     xfs_fsr: guard against path string overflows

commit 758bcc928858b85743d2f466f41c80cb40b93214
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Jan 26 22:40:30 2013 +0000

     xfs_fsr: check strdup results properly in initallfs()

commit ff85ea3f1456f20ba21a67c652f245da6360db15
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Jan 26 22:40:31 2013 +0000

     xfs_fsr: fix attribute no_change_count logic

commit a0a28a6ac3005ec320ef73066e57d9ae1fd41754
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Jan 26 22:40:32 2013 +0000

     xfs_fsr: remove extraneous close() in fsrallfs()

All these patches look and test okay. None of them interferes with 
Dave's xfsprogs "UBER" kernel/user space sync patch.

Thank-you,

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
