Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C810C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 05:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhLPFL1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 00:11:27 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40274 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhLPFL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 00:11:27 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1B0B610A46E0;
        Thu, 16 Dec 2021 16:11:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxj35-003dj3-U5; Thu, 16 Dec 2021 16:11:23 +1100
Date:   Thu, 16 Dec 2021 16:11:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't expose internal symlink metadata buffers
 to the vfs
Message-ID: <20211216051123.GC449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961698851.3129691.1262560189729839928.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961698851.3129691.1262560189729839928.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61baca7e
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=jUFqNg-nAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=pNUswijK6cjMahts2r0A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=-tElvS_Zar9K8zhlwiSp:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ian Kent reported that for inline symlinks, it's possible for
> vfs_readlink to hang on to the target buffer returned by
> _vn_get_link_inline long after it's been freed by xfs inode reclaim.
> This is a layering violation -- we should never expose XFS internals to
> the VFS.
> 
> When the symlink has a remote target, we allocate a separate buffer,
> copy the internal information, and let the VFS manage the new buffer's
> lifetime.  Let's adapt the inline code paths to do this too.  It's
> less efficient, but fixes the layering violation and avoids the need to
> adapt the if_data lifetime to rcu rules.  Clearly I don't care about
> readlink benchmarks.
> 
> As a side note, this fixes the minor locking violation where we can
> access the inode data fork without taking any locks; proper locking (and
> eliminating the possibility of having to switch inode_operations on a
> live inode) is essential to online repair coordinating repairs
> correctly.
> 
> Reported-by: Ian Kent <raven@themaw.net>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine, nicely avoids all the nasty RCU interactions trying to
handle this after the fact.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
