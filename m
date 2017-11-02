Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22693 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdKBEow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 00:44:52 -0400
Date: Wed, 1 Nov 2017 21:44:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/14] rollup of fstests fixes
Message-ID: <20171102044446.GP4911@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <20171102030601.GU17339@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102030601.GU17339@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Nov 02, 2017 at 11:06:01AM +0800, Eryu Guan wrote:
> On Wed, Nov 01, 2017 at 02:46:28PM -0700, Darrick J. Wong wrote:
> > This is a rollup of all the patches I've been sending to the list,
> > because the previous thread is a mess of resent patches and patch
> > series cramming.
> > 
> > Patches 1-2,4,6,8 are unchanged from last week.  They've possibly even
> > gone in already, but I can't tell what's in Eryu's private branch. :/
> > 
> > Patch 3 is the same as "PATCH v3 5/6" from the last series.
> 
> Yeah, I've queued above patches in my staging branch, a user-visible
> change I've made on commit is in patch 8 "common/xfs: remove inode-paths
> cruft", I added a "return $?" at the end of _check_xfs_test_fs(), as I
> replied to you earlier this week. So I'd just leave my queued patches
> untouched, that might be easier for me :)

Ok, works for me!

> > 
> > Patch 5 now checks that repair can fix the corruption introduced.
> 
> It was in my queue too, but I'll drop it and take the new version if
> the change looks sane.
> 
> > 
> > Patch 7 is new, it checks for /usr/sbin/thin_check before running
> > generic/459 per an earlier discussion on the list.
> > 
> > Patches 9-14 are new; I've been trying to clean up all the minor test
> > failures in preparation for 4.15 madness.
> 
> Thanks a lot for the cleanups! I'll look at them, maybe tommorrow, I'll
> be out for a few hours today..

<nod>

--D

> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
