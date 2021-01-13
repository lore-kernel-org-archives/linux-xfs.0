Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA71C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40AE72343E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbhANBz6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbhAMXyD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jan 2021 18:54:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 475E421734;
        Wed, 13 Jan 2021 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610582002;
        bh=QNi7yYVzVWGsthKLQoXQ6r1jVpxVOy1fwpcIRiGlx9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYg92inFk4yUzFKtFzWoVrS9qnksdOlu8tQxaT+25lHYIx5DFNyJBqEPzxTGmJC77
         k61XBUUWgh+wBdsXzTWIhBYrPA1tZSsahZS/Y4aSbn2N9W9LS29Ag7peRvW9DlD5T8
         uyKuFi9XUMIHsHNBpdDBnhvHXr1V2v8tX72g/HrePyX8KKKvJj3fCOmnC2dTDD9Clk
         qR1DDgM4AMVZgD6TdSE7C+BVOPDq26RugZoYGUHIgh7dl5Us+4MBKcAStNT3zPtyev
         qBLTq0CnaKthloh+k87uP3UxHXEpB299JTjRo/VOpTofMQfcaiAKd6hUjgx+7Uo6Xm
         06/v/yGU/b+fQ==
Date:   Wed, 13 Jan 2021 15:53:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: consolidate the eofblocks and cowblocks workers
Message-ID: <20210113235321.GT1164246@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040742050.1582286.5743015618624198962.stgit@magnolia>
 <X/8L/uY2Pj4c7biG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/8L/uY2Pj4c7biG@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 04:04:30PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 11, 2021 at 03:23:40PM -0800, Darrick J. Wong wrote:
> > + * 100ths of a second) with the exception of blockgc_timer, which is measured
> > + * in seconds.
> >   */
> >  xfs_param_t xfs_params = {
> >  			  /*	MIN		DFLT		MAX	*/
> > @@ -28,8 +28,7 @@ xfs_param_t xfs_params = {
> >  	.rotorstep	= {	1,		1,		255	},
> >  	.inherit_nodfrg	= {	0,		1,		1	},
> >  	.fstrm_timer	= {	1,		30*100,		3600*100},
> > -	.eofb_timer	= {	1,		300,		3600*24},
> > -	.cowb_timer	= {	1,		1800,		3600*24},
> > +	.blockgc_timer	= {	1,		300,		3600*24},
> 
> Renaming this is going to break existing scripts.  We could either kill off the
> COW timer as it is relatively recent, or we could keep both and use the minimum.
> But removing both and picking an entirely new name seems a little dangerous.

"blockgc_timer" is the internal variable.  The xfs_sysctl.c changes at
the bottom of the patch erase speculative_cow_prealloc_lifetime, but the
older knob remains unchanged.  See xfs_sysctl.c:

	{
		.procname	= "speculative_prealloc_lifetime",
		.data		= &xfs_params.blockgc_timer.val,

And from the test system:

# ls /proc/sys/fs/xfs/
total 0
-rw-r--r-- 1 root root 0 Jan 13 15:46 error_level
-rw-r--r-- 1 root root 0 Jan 13 15:46 filestream_centisecs
-rw-r--r-- 1 root root 0 Jan 13 15:46 inherit_noatime
-rw-r--r-- 1 root root 0 Jan 13 15:46 inherit_nodefrag
-rw-r--r-- 1 root root 0 Jan 13 15:46 inherit_nodump
-rw-r--r-- 1 root root 0 Jan 13 15:46 inherit_nosymlinks
-rw-r--r-- 1 root root 0 Jan 13 15:46 inherit_sync
-rw-r--r-- 1 root root 0 Jan 13 15:46 irix_sgid_inherit
-rw-r--r-- 1 root root 0 Jan 13 15:46 irix_symlink_mode
-rw-r--r-- 1 root root 0 Jan 13 15:46 panic_mask
-rw-r--r-- 1 root root 0 Jan 13 15:46 rotorstep
-rw-r--r-- 1 root root 0 Jan 13 15:46 speculative_prealloc_lifetime
-rw-r--r-- 1 root root 0 Jan 13 15:46 stats_clear
-rw-r--r-- 1 root root 0 Jan 13 15:46 xfssyncd_centisecs

--D

> 
> Otherwise this looks sane to me.
