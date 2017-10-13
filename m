Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751762AbdJMKIk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 06:08:40 -0400
Date: Fri, 13 Oct 2017 06:08:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] tests/xfs: test for NULL xattr buffer problem during
 unlink
Message-ID: <20171013100838.GA44117@bfoster.bfoster>
References: <20171012113627.39452-1-bfoster@redhat.com>
 <20171013054605.GN10593@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013054605.GN10593@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Oct 13, 2017 at 01:46:05PM +0800, Eryu Guan wrote:
> On Thu, Oct 12, 2017 at 07:36:27AM -0400, Brian Foster wrote:
> > XFS had a bug that resulted in an unexpected NULL buffer during
> > unlink of an inode with a multi-level attr fork tree. This occurred
> > due to a stale reference to content in a released/reclaimed buffer.
> > 
> > Use the XFS buffer LRU reference count error injection tag to
> > recreate the conditions for the bug. Create a file with a
> > multi-level attr fork tree and then unlink it with buffer caching
> > disabled.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Note that this test depends on a pending[1] XFS error injection tag.
> > 
> > Brian
> > 
> > [1] https://marc.info/?l=linux-xfs&m=150765408521029&w=2
> 
> I ran this test with above patch applied (v4.14-rc4 based), and kernel
> crashed as expected. Then cherry-pick commit f35c5e10c6ed ("xfs: reinit
> btree pointer on attr tree inactivation walk") and test passed. So test
> looks good to me, just that I added 'dangerous' group and referenced the
> fix in commit log and test description.
> 

I don't think dangerous is really necessary because this test won't run
on any kernels prior to those with the patch above, which is still
pending, and the crash issue had already been addressed in commit
cd87d8679 ("xfs: don't crash on unexpected holes in dir/attr btrees").

There is technically a crash possibility for custom kernels that
backport the later errortag patch without the earlier crash/corruption
fix, as you have for testing purposes. I think that is out of the
ordinary and doesn't really justify tagging the test, IMO.

Brian

> Thanks for the test!
> 
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
