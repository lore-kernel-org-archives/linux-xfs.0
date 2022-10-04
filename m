Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F66FC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 05:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJDF5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 01:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJDF5O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 01:57:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37277205D0
        for <linux-xfs@vger.kernel.org>; Mon,  3 Oct 2022 22:57:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 645388AC13F
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 16:57:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ofavW-00FQTV-MF
        for linux-xfs@vger.kernel.org; Tue, 04 Oct 2022 16:57:10 +1100
Date:   Tue, 4 Oct 2022 16:57:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next tree rebased to e033f40be262
Message-ID: <20221004055710.GN3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=633bcb39
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=kR6-9MUt5XfikCYSSSYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I just rebased the for-next branch of the XFS tree to fix the
complaints about mismatched author/sob information in a couple of
the commits I pushed last week. There is no change of the code in
the tree, just commit metadata was modified. The rebased commits are
listed below.

-Dave.

----------------------------------------------------------------

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

----------------------------------------------------------------
Head commit: 

  e033f40be262c4d227f8fbde52856e1d8646872b
  xfs: on memory failure, only shut down fs after scanning all mappings

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: on memory failure, only shut down fs after scanning all mappings

Shida Zhang (2):
      xfs: trim the mapp array accordingly in xfs_da_grow_inode_int
      xfs: rearrange the logic and remove the broken comment for xfs_dir2_isxx

 fs/xfs/libxfs/xfs_da_btree.c |  2 +-
 fs/xfs/libxfs/xfs_dir2.c     | 50 ++++++++++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_dir2.h     |  4 ++--
 fs/xfs/scrub/dir.c           |  2 +-
 fs/xfs/xfs_dir2_readdir.c    |  2 +-
 fs/xfs/xfs_notify_failure.c  | 26 +++++++++++++++++---------
 6 files changed, 52 insertions(+), 34 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
