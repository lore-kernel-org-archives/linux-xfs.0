Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CC4C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A58060230
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhC2Sbs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231747AbhC2SbW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 14:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE1756192C;
        Mon, 29 Mar 2021 18:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617042682;
        bh=x39qFyFlqPlCDIWyd28OCcfNUBQVrEy8TGNfX4Y8z8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vNo5N2prcquZT1T2A+jVVWLkEew9ljlgfIwfP/eRa197cGEop5tp6AZTv/mrI0wEQ
         vCI8XSurL4a5N4/Q+Q7B9fQc+D4R3mHxHU/K83g+wl1llJEiGwCAaVbu9cElYd9jzu
         CQHxd8L4LYXIsdpux7MBCIMmLXKMhbuLCZYB8gX0z5i1LDdiVxoMx1+8lOFf8DrsTZ
         yehAPfWysojZzwNyGSF4VB2lpsD6g9Ge/NYQvNztvtBcX1xcfamBVtzmwx+J46k3HY
         JqO6JKL8fQEym/EqBmW0UqAW7YDcDjIETkRU1MBEO1StLtmA0T6WEutyn7Jr8AwzQl
         +V3KtDMHOKVLQ==
Date:   Mon, 29 Mar 2021 11:31:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: attr fork related fstests failures on for-next
Message-ID: <20210329183120.GH4090233@magnolia>
References: <YGIZZLoiyULTaUev@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGIZZLoiyULTaUev@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 02:16:04PM -0400, Brian Foster wrote:
> Hi,
> 
> I'm seeing a couple different fstests failures on current for-next that
> appear to be associated with e6a688c33238 ("xfs: initialise attr fork on
> inode create"). The first is xfs_check complaining about sb versionnum
> bits on various tests:
> 
> generic/003 16s ... _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
> (see /root/xfstests-dev/results//generic/003.full for details)
> # cat results/generic/003.full
> ...
> _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
> *** xfs_check output ***
> sb versionnum missing attr bit 10
> *** end xfs_check output

FWIW I think this because that commit sets up an attr fork without
setting ATTR and ATTR2 in sb_version like xfs_bmap_add_attrfork does...

> ...
> #
> 
> With xfs_check bypassed, repair eventually complains about some attr
> forks. The first point I hit this variant is generic/117:
> 
> generic/117 9s ... _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (r)
> (see /root/xfstests-dev/results//generic/117.full for details)
> # cat results//generic/117.full
> ...
> _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (r)
> *** xfs_repair -n output ***
> ...
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> bad attr fork offset 24 in dev inode 135, should be 1
> would have cleared inode 135
> bad attr fork offset 24 in dev inode 142, should be 1
> would have cleared inode 142

...and I think this is because xfs_default_attroffset doesn't set the
correct value for device files.  For those kinds of files, xfs_repair
requires the data fork to be exactly 8 bytes.

--D

> ...
> 
> Both problems disappear with e6a688c33238 reverted.
> 
> Brian
> 
