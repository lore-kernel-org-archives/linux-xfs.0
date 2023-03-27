Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0334C761A6
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Mar 2023 16:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjC0QHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Mar 2023 12:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjC0QHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2023 12:07:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993B52688
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 09:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3407461350
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 16:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CBEC433D2;
        Mon, 27 Mar 2023 16:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679933227;
        bh=vYVG+PxJ5sSnzcSqte8S1ssreV0puj7mG7vG9OxiBFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0d1YpdNrn6YosBw8xD9bJ294C/PYBRcSGnCSy/fEE9PkLxfmX7lxNr0uFsL+LdRf
         YzC87grTpHczvXq1dqMQPBm+PCPlB+bHqmN0nEC0UFbHOj3MR9xRAvHm5ZbDiMVg8W
         H1ad3C5IFGQ9Z3mLFo7NugkuxhEaxKOk1O8+dx2F8iEFTsrYvDnEUBA6ZMwDtCpjrm
         DUxZKdTwEbuHBtoEP19vvIndg4o6Lj1ZgQC8Uv1WTufRjh0CTVUy9iXAyD5Z64eDWT
         6w4JjBOph04GDcdkDzqwLbnBApp8dPIYUVzwhQt2dguLs5cfFgOG4b9xTwgYBIfoHC
         tcgNJknfsn2wQ==
Date:   Mon, 27 Mar 2023 09:07:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 0/2] Two more xfs backports for 5.10.y
 (from v5.11)
Message-ID: <20230327160706.GD16180@frogsfrogsfrogs>
References: <20230326170623.386288-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326170623.386288-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 26, 2023 at 08:06:21PM +0300, Amir Goldstein wrote:
> Darrick,
> 
> These two backports were selected by Chandan for 5.4.y, but are
> currently missing from 5.10.y.
> 
> I've put them through the usual kdevops testing routine.
> 
> This is the second time that I have considered patch #2 for 5.10.y.
> The last time around, I observed increased the probablity of a known
> buffer corruption assertion when running xfs/076, so I suspected
> a regression, and dropped it from the submission [1].
> 
> At the time, the alleged regression happened only in the kdevops setup
> and neither I nor Brain were able to understand why that happens [2].
> This time around, the kdevops setup did not observe that odd regression.

Heh, I had a roommate once whose name got misspelled to Brain on the
water bills, and I still chuckle every time I see that. ;)

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-xfs/20220601104547.260949-1-amir73il@gmail.com/
> [2] https://lore.kernel.org/linux-xfs/YpY6hUknor2S1iMd@bfoster/T/#mf1add66b8309a75a8984f28ea08718f22033bce7
> 
> Brian Foster (1):
>   xfs: don't reuse busy extents on extent trim
> 
> Darrick J. Wong (1):
>   xfs: shut down the filesystem if we screw up quota reservation
> 
>  fs/xfs/xfs_extent_busy.c | 14 --------------
>  fs/xfs/xfs_trans_dquot.c | 13 ++++++++++---
>  2 files changed, 10 insertions(+), 17 deletions(-)
> 
> -- 
> 2.34.1
> 
