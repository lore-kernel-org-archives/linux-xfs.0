Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89282C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 20:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiADUq2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 15:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiADUq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 15:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AFBC061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 12:46:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58BEC615A7
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 20:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACECDC36AE0;
        Tue,  4 Jan 2022 20:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641329186;
        bh=lwGqY+vdihyVnjDFSK/VS+dlssqOiO7O4icAnfqkKBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3N0f9SYvVBQTzmeTIca4EBEVgJ8Ti0H+s9jGIZyffjC3gL0J0dDz7MtI02gu/fGI
         x9CIfKjnZfgnQiCfK8unt60uvtRexLE9bsFgU5bZN13/ocHhBSO7mml9rRiajTEZMS
         /Pnw4N59KZy6BIcXvughhxIT6At/A1LqK9v6z0AQgSXTLLmGPwOGo3QKxzdDctfElS
         NtKNRWSPEkJnsRNIf7zvifR2bpTa0qgMzM9k2K6VYziIVuTPPEi0Xgvymmh7eOi/4w
         gIPGHuVnus8il8SwpPiZMieeR26LL47o5+L2quC1zYnNGKQS5Dr+Ct//MPTGGCSvGI
         gtSNK4Xdk7QHQ==
Date:   Tue, 4 Jan 2022 12:46:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: The question of Q_XQUOTARM ioctl
Message-ID: <20220104204626.GF31583@magnolia>
References: <616F9367.3030801@fujitsu.com>
 <20220104023456.GE31606@magnolia>
 <YdP1Y8FAeu871lr7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdP1Y8FAeu871lr7@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 03, 2022 at 11:21:07PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 03, 2022 at 06:34:56PM -0800, Darrick J. Wong wrote:
> > > 
> > > I don't know the right intention for Q_XQUOTARM now. Can you give me
> > > some advise? Or, we should remove Q_XQUOTARM ioctl and
> > > xfs_qm_scall_trunc_qfile code.
> > 
> > I think xfs_qm_scall_trunc_qfiles probably should be doing:
> > 
> > 	if (xfs_has_quota(mp) || flags == 0 ||
> > 	    (flags & ~XFS_QMOPT_QUOTALL)) {
> > 		xfs_debug(...);
> > 		return -EINVAL;
> > 	}
> > 
> > Note the inversion in the has_quota test.  That would make it so that
> > you can truncate the quota files if quota is not on.

NAK, that's wrong.  xfs_has_quota tells us if the superblock feature bit
is set.  The feature bit guards the sb_[ugp]uotino fields, so the above
code causes us to bail out with EINVAL if the filesystem doesn't have
quota inodes at all.  Thus, inverting the check (to make it so that we
only try to truncate if the fields are garbage) is not correct.

> Yes, that sounds reasonable.  Although I'd split the xfs_has_quota
> file into a separate check with a separate debug message.

So I think the fix here is to fix the testcases.  xfs/220 becomes:

# turn off quota accounting...
$XFS_QUOTA_PROG -x -c off $SCRATCH_DEV

# ...but if the kernel doesn't support turning off accounting, remount with
# noquota option to turn it off...
if $XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_DEV | grep -q 'Accounting: ON'; then
	_scratch_unmount
	_scratch_mount -o noquota
fi

# ...and remove space allocated to the quota files
# (this used to give wrong ENOSYS returns in 2.6.31)
$XFS_QUOTA_PROG -x -c remove $SCRATCH_DEV


--D
