Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083A1C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3EC64E20
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhA1ScC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:32:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232136AbhA1S31 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 13:29:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 409BB64E20;
        Thu, 28 Jan 2021 18:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611857931;
        bh=+kZ/VHie6tlM/PHbWmbYwbNkn/6EtbWaoP9CUH0j62s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jhht+c+dFVa42PWOu5rAcmRin7ABEMM6JN77VBW6NT4Xg4uCY+tWXyIcCZTfu/Bra
         eGh+rCSSIYUoPZY5JdPv0MDF0xJJ89RhIHBPomjBPXjWIYTsPbkXet9AavLDajivw1
         cKu8MfERZx/U8/H6V4q8EXKiIn0xC2g/AUJI5y1mnZpZ9yAcreD17/A9DGU4ggJo6p
         DelEx9E2EGfezLyNyg/GSgSBkMdWAfjS5UaxyHqt0ZhL56GlHpj+/iugaEyqpK/ECI
         6xtEdOi2aDsvxzZbq+vgZIKR9CexhLkEMSe5nnUzUfWi5ybkFFidpJsplWDTGM6Frf
         JKZRR08RgmUTw==
Date:   Thu, 28 Jan 2021 10:18:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 11/13] xfs: refactor inode creation
 transaction/inode/quota allocation idiom
Message-ID: <20210128181850.GV7698@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181372686.1523592.6379270446924577363.stgit@magnolia>
 <20210128095737.GG1973802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128095737.GG1973802@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 09:57:37AM +0000, Christoph Hellwig wrote:
> On Wed, Jan 27, 2021 at 10:02:06PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > For file creation, create a new helper xfs_trans_alloc_icreate that
> > allocates a transaction and reserves the appropriate amount of quota
> > against that transction.  Replace all the open-coded idioms with a
> > single call to this helper so that we can contain the retry loops in the
> > next patchset.
> 
> For most callers this moves the call to xfs_trans_reserve_quota_icreate
> out of the ilock criticial section.  Which seems fine and actually
> mildly desirable.  But please document it.

Ok, done.  Add this as a second paragraph:

"This changes the locking behavior for non-tempfile creation slightly,
in that we now make the quota reservation without holding the directory
ILOCK.  While the dquots chosen for inode creation are based on the
directory state at a given point in time, the directory ILOCK was
released as soon as the dquot references are picked up.  Hence it was
never necessary to hold the directory ILOCK for the quota reservation."

--D
