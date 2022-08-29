Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3254DC0502E
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 14:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiH2OVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiH2OVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 10:21:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EA2696C3;
        Mon, 29 Aug 2022 07:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97DC6B810A1;
        Mon, 29 Aug 2022 14:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C57FC433C1;
        Mon, 29 Aug 2022 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661782864;
        bh=U0YzpPXyBtGzDIZyOLsF0+QyAtTGeB1D5ISsYu8mmZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EO2e524W6Hd89YHfiEEz+fr/u9lu7qQCjYH2nUq0BMmLf7YWB/GM4Z3IeO03qlxqA
         RYZUQ5xeNwyAcnMOMXUQH1jrihfiLcC/jcgc41vcKOuAhOuYM6Y2NI8HtgjtqMxsNy
         2si7BXbGJXpj19xqEG065sPh1eNbSUl7shWmkafVmuWmtJepvfTgLz1L0hZAVLfYFE
         lf46aEBz+/mwVOi/CH4n5ZbtEgaiqgtLMOut4lAFCJyloCx4KrdJ7olgfXgtkmqUK4
         IegSWKhADbajYGDx94Y4Puq2wSfIPJPqJyWH7IUY7ID6p0slt7n1QNVVXFfuTEMvrr
         uRFr4QeC62AAA==
Date:   Mon, 29 Aug 2022 07:21:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 0/7] xfs stable candidate patches for
 5.10.y (from v5.18+)
Message-ID: <YwzLTxUDxkefDI/g@magnolia>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 28, 2022 at 03:46:07PM +0300, Amir Goldstein wrote:
> Hi Darrick,
> 
> This 5.10.y backport series contains fixes from v5.18 and v5.19 releases.
> 
> Patches 1-5 in this series have already been applied to 5.15.y in Leah's
> latest update [1], so this 5.10.y is is mostly catching up with 5.15.y.
> 
> Patches 2-3 from the last 5.15.y update have not been picked for 5.10.y,
> because they were not trivial to backport as the quota code is quite
> different betrween 5.10.y and upstream.
> This omission leave fstests generic/681,682 broken on 5.10.y.
> 
> Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> I pointed Leah's attention to these patches and she said she will
> include them in a following 5.15.y update.
> 
> In particular, Darrick has pointed me at the fix in patch 6 a long time
> ago, but I was waiting to apply fixes to 5.10.y in chronoligal order.
> 

Woot! :)

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> Please note that the upstream fix 6f5097e3367a ("xfs: fix xfs_ifree()
> error handling to not leak perag ref") Which Fixes: 9a5280b312e2e
> ("xfs: reorder iunlink remove operation in xfs_ifree")
> is not relevant for the 5.10.y backport.
> 
> These patches has gone through the usual 30 auto group runs x 5 configs
> on kdevops.
> 
> Thanks,
> Amir.
> 
> 
> [1] https://lore.kernel.org/linux-xfs/20220819181431.4113819-1-leah.rumancik@gmail.com/
> 
> Amir Goldstein (1):
>   xfs: remove infinite loop when reserving free block pool
> 
> Brian Foster (1):
>   xfs: fix soft lockup via spinning in filestream ag selection loop
> 
> Darrick J. Wong (2):
>   xfs: always succeed at setting the reserve pool size
>   xfs: fix overfilling of reserve pool
> 
> Dave Chinner (2):
>   xfs: reorder iunlink remove operation in xfs_ifree
>   xfs: validate inode fork size against fork format
> 
> Eric Sandeen (1):
>   xfs: revert "xfs: actually bump warning counts when we send warnings"
> 
>  fs/xfs/libxfs/xfs_inode_buf.c | 35 +++++++++++++++++------
>  fs/xfs/xfs_filestream.c       |  7 +++--
>  fs/xfs/xfs_fsops.c            | 52 ++++++++++++++---------------------
>  fs/xfs/xfs_inode.c            | 22 ++++++++-------
>  fs/xfs/xfs_mount.h            |  8 ++++++
>  fs/xfs/xfs_trans_dquot.c      |  1 -
>  6 files changed, 71 insertions(+), 54 deletions(-)
> 
> -- 
> 2.25.1
> 
