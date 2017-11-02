Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933888AbdKBDGD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Nov 2017 23:06:03 -0400
Date: Thu, 2 Nov 2017 11:06:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 00/14] rollup of fstests fixes
Message-ID: <20171102030601.GU17339@eguan.usersys.redhat.com>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Nov 01, 2017 at 02:46:28PM -0700, Darrick J. Wong wrote:
> This is a rollup of all the patches I've been sending to the list,
> because the previous thread is a mess of resent patches and patch
> series cramming.
> 
> Patches 1-2,4,6,8 are unchanged from last week.  They've possibly even
> gone in already, but I can't tell what's in Eryu's private branch. :/
> 
> Patch 3 is the same as "PATCH v3 5/6" from the last series.

Yeah, I've queued above patches in my staging branch, a user-visible
change I've made on commit is in patch 8 "common/xfs: remove inode-paths
cruft", I added a "return $?" at the end of _check_xfs_test_fs(), as I
replied to you earlier this week. So I'd just leave my queued patches
untouched, that might be easier for me :)

> 
> Patch 5 now checks that repair can fix the corruption introduced.

It was in my queue too, but I'll drop it and take the new version if
the change looks sane.

> 
> Patch 7 is new, it checks for /usr/sbin/thin_check before running
> generic/459 per an earlier discussion on the list.
> 
> Patches 9-14 are new; I've been trying to clean up all the minor test
> failures in preparation for 4.15 madness.

Thanks a lot for the cleanups! I'll look at them, maybe tommorrow, I'll
be out for a few hours today..

Thanks,
Eryu
