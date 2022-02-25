Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A439C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 17:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbiBYRMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 12:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiBYRMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 12:12:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179C42028A5
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 09:11:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3113B832BA
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 17:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F709C340F0;
        Fri, 25 Feb 2022 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645809088;
        bh=9AK6N4t+/tLekAXDdRhw+XAjdhoTuXctxRuirFlSJ9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bUeNeUT4TnZqnp+Sg/io69i3VAz3oA4ZyxOGo+83CD1VlJy7v3CJ3qWXDAF4QMBY4
         WRd949qvvRmWhesLWIR0TnheEmZT9NeWsUFbxhohEJiOFjmQYZcApoEaYWX427duMx
         9hK29GM7YWvW3LzLv0qsKG0cuGaqqlBKxNUF/DELjRh3pIhavreKxLMOylPbK8oeST
         C3/PHTZjnzfsgq/I2vGYcEX/x2mEFk4a4P68oZvg8aD/b2BxUVnXXCykqH+m0pcw38
         Bo3dtL1QecE35Ak8RIuU3Esx45+EiZkNZyN3ba9e0752Ow3BbGgsFTseS7N9kvV8DT
         H/GC3wPEPdnkw==
Date:   Fri, 25 Feb 2022 09:11:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
        christian.brauner@ubuntu.com, hch@lst.de
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220225171127.GR8313@magnolia>
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220225015738.GP8313@magnolia>
 <20220225094517.cd7ukcczezhspdq5@wittgenstein>
 <e7cbc35c-386b-3323-0cef-da1ebf358f1a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7cbc35c-386b-3323-0cef-da1ebf358f1a@virtuozzo.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 25, 2022 at 01:42:26PM +0300, Andrey Zhadchenko wrote:
> 
> 
> On 2/25/22 12:45, Christian Brauner wrote:
> > On Thu, Feb 24, 2022 at 05:57:38PM -0800, Darrick J. Wong wrote:
> > > On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
> > > > xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
> > > > bits.
> > > > Unfortunately chown syscall results in different callstask:
> > > > i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
> > > > has CAP_FSETID capable in init_user_ns rather than mntns userns.
> > > > 
> > > > Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> > > 
> > > LGTM...
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > Darrick, could I ask you to please wait with applying.
> > The correct fix for this is either to simply remove the check here
> > altogether as we figured out in the thread or to switch to a generic vfs
> > helper setattr_copy().
> > Andrey will send a new patch in the not too distant future afaict
> > including tests.
> 
> Yes, please do not apply this patch for now. I am currently working on next
> version, however it is postponed a bit due to my personal affairs.
> Also I intend to add a second patch for xfs_fileattr_set() since it has the
> similar flaw - it may drop S_ISUID|S_ISGID for directories and may not drop
> S_ISUID for executable files.
> I expect to send patches next week alongside with new xfstests.

Ah, fair enough.  Felipe noticed that generic/673 produced inconsistent
outputs between btrfs and xfs last week and had asked about why the
setuid/setgid dropping behavior was unique to xfs.  We discovered that
xfs' omission of the setattr_copy logic was behind that...

--D
