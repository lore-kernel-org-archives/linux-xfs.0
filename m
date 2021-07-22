Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A42C63797
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255546056C
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGVRmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhGVRmU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 13:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D6560243;
        Thu, 22 Jul 2021 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626978174;
        bh=KTTCVssZsd/hBf22pUA3vVKWdwtSWpzj/L8oofZDwqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A5YALjFcNX4ZQLwzM3yoNbEm4My4e+MGuH3e80gnyterlGf9xCbYArmcWIMIfAMNC
         kCkffrK6t1h79XdK3DfbBYe2hogHcsulv8jcStR5PFdXVuGzP3vdRyWVWbwC7uB1iI
         adhEZSmjr9MY6RXQUnJdkA3tUWHEZdoOR1DMUEb6g+JoAS1Qd3LySCrnnI4vyp+eWJ
         AnGDQfdmifZWZWCS54xlKEkQCV8fknTj1eNXAMQc6/7AmfrV7TORG2+ASbLc/lokCo
         Dhg8cOwd1cuXvoxaayXeGEgZbC+eqz4EBd4guQIXHh3MpM3sz2NPjK9BmLq2EO1aD3
         tMJz5Yct4hiQw==
Date:   Thu, 22 Jul 2021 11:22:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210722182254.GB559212@magnolia>
References: <20210722072610.975281-1-hch@lst.de>
 <20210722072610.975281-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722072610.975281-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 09:26:08AM +0200, Christoph Hellwig wrote:
> Disabling quota accounting is hairy, racy code with all kinds of pitfalls.
> And it has a very strange mind set, as quota accounting (unlike
> enforcement) really is a propery of the on-disk format.  There is no good

s/propery/property/

> use case for supporting this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  30 ----
>  fs/xfs/libxfs/xfs_trans_resv.h |   2 -
>  fs/xfs/xfs_dquot_item.c        | 134 ------------------
>  fs/xfs/xfs_dquot_item.h        |  17 ---
>  fs/xfs/xfs_qm.c                |   2 +-
>  fs/xfs/xfs_qm.h                |   3 -
>  fs/xfs/xfs_qm_syscalls.c       | 241 ++-------------------------------
>  fs/xfs/xfs_trans_dquot.c       |  38 ------
>  8 files changed, 13 insertions(+), 454 deletions(-)
> 

<snip> I think you could delete more...

> -	/*
> -	 * Give back all the dquot reference(s) held by inodes.
> -	 * Here we go thru every single incore inode in this file system, and
> -	 * do a dqrele on the i_udquot/i_gdquot that it may have.
> -	 * Essentially, as long as somebody has an inode locked, this guarantees
> -	 * that quotas will not be turned off. This is handy because in a
> -	 * transaction once we lock the inode(s) and check for quotaon, we can
> -	 * depend on the quota inodes (and other things) being valid as long as
> -	 * we keep the lock(s).
> -	 */
> -	error = xfs_dqrele_all_inodes(mp, flags);
> -	ASSERT(!error);

...because I think xfs_dqrele_all_inodes has lost all of its callers.
Can you please remove it and XFS_ICWALK_DQRELE from xfs_icache.[ch]?

--D
