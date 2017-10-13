Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbdJMFqH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 01:46:07 -0400
Date: Fri, 13 Oct 2017 13:46:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] tests/xfs: test for NULL xattr buffer problem during
 unlink
Message-ID: <20171013054605.GN10593@eguan.usersys.redhat.com>
References: <20171012113627.39452-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012113627.39452-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 07:36:27AM -0400, Brian Foster wrote:
> XFS had a bug that resulted in an unexpected NULL buffer during
> unlink of an inode with a multi-level attr fork tree. This occurred
> due to a stale reference to content in a released/reclaimed buffer.
> 
> Use the XFS buffer LRU reference count error injection tag to
> recreate the conditions for the bug. Create a file with a
> multi-level attr fork tree and then unlink it with buffer caching
> disabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Note that this test depends on a pending[1] XFS error injection tag.
> 
> Brian
> 
> [1] https://marc.info/?l=linux-xfs&m=150765408521029&w=2

I ran this test with above patch applied (v4.14-rc4 based), and kernel
crashed as expected. Then cherry-pick commit f35c5e10c6ed ("xfs: reinit
btree pointer on attr tree inactivation walk") and test passed. So test
looks good to me, just that I added 'dangerous' group and referenced the
fix in commit log and test description.

Thanks for the test!

Eryu
