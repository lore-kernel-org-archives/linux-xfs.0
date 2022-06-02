Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4DCCCA473
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 00:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiFBAiL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 20:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiFBAiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 20:38:11 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E223C17067A;
        Wed,  1 Jun 2022 17:38:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D2B1D5EC4A9;
        Thu,  2 Jun 2022 10:38:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nwYqi-001bCC-VB; Thu, 02 Jun 2022 10:38:04 +1000
Date:   Thu, 2 Jun 2022 10:38:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 7/8] xfs: consider shutdown in bmapbt
 cursor delete assert
Message-ID: <20220602003804.GJ227878@dread.disaster.area>
References: <20220601104547.260949-1-amir73il@gmail.com>
 <20220601104547.260949-8-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601104547.260949-8-amir73il@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62980671
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=0fdg2fwtu5Mcqw8XrEgA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 01, 2022 at 01:45:46PM +0300, Amir Goldstein wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.
> 
> The assert in xfs_btree_del_cursor() checks that the bmapbt block
> allocation field has been handled correctly before the cursor is
> freed. This field is used for accurate calculation of indirect block
> reservation requirements (for delayed allocations), for example.
> generic/019 reproduces a scenario where this assert fails because
> the filesystem has shutdown while in the middle of a bmbt record
> insertion. This occurs after a bmbt block has been allocated via the
> cursor but before the higher level bmap function (i.e.
> xfs_bmap_add_extent_hole_real()) completes and resets the field.
> 
> Update the assert to accommodate the transient state if the
> filesystem has shutdown. While here, clean up the indentation and
> comments in the function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=56486f307100e8fc66efa2ebd8a71941fa10bf6f

-- 
Dave Chinner
david@fromorbit.com
