Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FBAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jan 2022 19:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348510AbiARTGl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 14:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245012AbiARTGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 14:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4FBC061574
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 11:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B7C66154D
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 19:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3778C340E0;
        Tue, 18 Jan 2022 19:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642532798;
        bh=o2+SfZh7SvaM7ncRxbqqXKUHUVE7hUxyKx9Idc/NLLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPvBYL/OUQUf3AkOoRhLFKATdod4yAAiszFWXBI+bZnavarkPXVcvj7xM8DUiIu97
         iZt+hRtz+8VDbEtmnDZPpNCGIlAtfpoCfy8GICzlW19evmqzJF3dwaJCPMWhyKjX6S
         lz+LAkTP8aunRfR9dGyoJFFAnigxonvwiH9HlDylW6VbBurKge9ER8VMwtlK2Cg5gP
         76UzST6HlrtUj0NKdy+cXUYoUOilCAu9EO/SEzoEiRvpvnVQzDnMt12xjZ8XguFYLo
         37dgO7407jJVQYwTa3zk5SD1y39a92J7zFxptr32QKnmeWzv6A72cBZR5Q1KvpiUFL
         MmyJmEBw0fxmw==
Date:   Tue, 18 Jan 2022 11:06:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unused xfs_ioctl32.h declarations
Message-ID: <20220118190638.GE13540@magnolia>
References: <20220118183005.GD13540@magnolia>
 <230711ee-631f-0c3a-b07f-268d5504a197@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230711ee-631f-0c3a-b07f-268d5504a197@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 18, 2022 at 12:50:12PM -0600, Eric Sandeen wrote:
> On 1/18/22 12:30 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Remove these unused ia32 compat declarations; all the bits involved have
> > either been withdrawn or hoisted to the VFS.
> 
> Hm, don't we still have all the non-compat counterparts still live in
> fs/xfs/libxfs/xfs_fs.h, or am I not keeping up?
> 
> #define XFS_IOC_RESVSP		_IOW ('X', 40, struct xfs_flock64)
> #define XFS_IOC_UNRESVSP	_IOW ('X', 41, struct xfs_flock64)
> #define XFS_IOC_RESVSP64	_IOW ('X', 42, struct xfs_flock64)
> #define XFS_IOC_UNRESVSP64	_IOW ('X', 43, struct xfs_flock64)
> #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
> 
> Why remove the compat ones but leave the abo ve? Aren't these all valid and
> tested ioctls, just under a different #define, and therefore harmless and
> also useful for backwards compatibility?
> 
> I feel like I'm missing something. :)

The implementation of those five ioctls (including all the ioctl32
compat noise) were hoisted to the VFS by Al and Christoph back in 2019.
Hence the #defines in xfs_ioctl32.h are no longer referenced by any
kernel code.  However, they missed the opportunity to remove these
definitions.

The struct compat_xfs_flock64 was still in use by the allocsp/freesp
xfs_ioctl32 code, but now that we're erasing it from history, it can go.

The definitions in xfs_fs.h have to be kept around because we export
them to userspace via /usr/include/xfs/xfs_fs.h.

--D

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   fs/xfs/xfs_ioctl32.h |   18 ------------------
> >   1 file changed, 18 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
> > index fc5a91f3a5e0..c14852362fce 100644
> > --- a/fs/xfs/xfs_ioctl32.h
> > +++ b/fs/xfs/xfs_ioctl32.h
> > @@ -142,24 +142,6 @@ typedef struct compat_xfs_fsop_attrmulti_handlereq {
> >   	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
> >   #ifdef BROKEN_X86_ALIGNMENT
> > -/* on ia32 l_start is on a 32-bit boundary */
> > -typedef struct compat_xfs_flock64 {
> > -	__s16		l_type;
> > -	__s16		l_whence;
> > -	__s64		l_start	__attribute__((packed));
> > -			/* len == 0 means until end of file */
> > -	__s64		l_len __attribute__((packed));
> > -	__s32		l_sysid;
> > -	__u32		l_pid;
> > -	__s32		l_pad[4];	/* reserve area */
> > -} compat_xfs_flock64_t;
> > -
> > -#define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
> > -#define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
> > -#define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
> > -#define XFS_IOC_UNRESVSP64_32	_IOW('X', 43, struct compat_xfs_flock64)
> > -#define XFS_IOC_ZERO_RANGE_32	_IOW('X', 57, struct compat_xfs_flock64)
> > -
> >   typedef struct compat_xfs_fsop_geom_v1 {
> >   	__u32		blocksize;	/* filesystem (data) block size */
> >   	__u32		rtextsize;	/* realtime extent size		*/
> > 
