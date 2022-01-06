Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC341C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 04:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiAFEKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 23:10:06 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45071 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbiAFEKG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 23:10:06 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1B05062C1C7;
        Thu,  6 Jan 2022 15:10:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n5K6E-00BtSW-6X; Thu, 06 Jan 2022 15:10:02 +1100
Date:   Thu, 6 Jan 2022 15:10:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220106041002.GT945095@dread.disaster.area>
References: <20220105195226.GL656707@magnolia>
 <20220106023235.GL31606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106023235.GL31606@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61d66b9c
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=2vh1AmWuAvyLDwjQFqQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 05, 2022 at 06:32:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I was poking around in the directory code while diagnosing online fsck
> bugs, and noticed that xfs_readdir doesn't actually take the directory
> ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
> the data fork mappings and the VFS took i_rwsem (aka IOLOCK_SHARED) so
> we're protected against writer threads, but we really need to follow the
> locking model like we do in other places.
> 
> To avoid unnecessarily cycling the ILOCK for fairly small directories,
> change the block/leaf _getdents functions to consume the ILOCK hold that
> the parent readdir function took to decide on a _getdents implementation.
> 
> It is ok to cycle the ILOCK in readdir because the VFS takes the IOLOCK
> in the appropriate mode during lookups and writes, and we don't want to
> be holding the ILOCK when we copy directory entries to userspace in case
> there's a page fault.  We really only need it to protect against data
> fork lookups, like we do for other files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v3: better documentation and assertions around the IOLOCK
> v2: reduce the scope of the locked region, and reduce lock cycling
> ---
>  fs/xfs/xfs_dir2_readdir.c |   55 +++++++++++++++++++++++++++++----------------
>  1 file changed, 35 insertions(+), 20 deletions(-)

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
