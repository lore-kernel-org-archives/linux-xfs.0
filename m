Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322DCC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 09:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiKVJxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbiKVJxI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2022 04:53:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDA3FD37
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 01:53:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38896B81601
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 09:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4663CC433C1;
        Tue, 22 Nov 2022 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669110785;
        bh=OX02qWJ9+KZtUoa/TQcvGBgdiie/dRWwp3twt2CL9lE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bl2o/clAqG8WKCwBwVpFm5IVwhXHpkVrGAvTWtqizWfkzCtYNIQo6ZnDjAcs6Ploi
         B0VU8VS3Yms2IOKMEby47//vHZswX0uI/32tjHgIXT3Nu8G61uAE4gFVxWXLPspOMD
         poC5FBm/0RkRT+PpOLGhrdCLXuKBZMiuoGIRIQTRwPIdZmYUpLyKzJncbCT7Bb9hnI
         /GZWS/imeV+TfVSPoVf3LTaMjJ9FKYJ3tiasjNWbH6xxEYdAe1ZmVxj7y8DSNTFK9N
         C63xuYWFpXJXZZ9DcJFY/zwhsIj5NRLphAJrEiKJQH6XIBgCUAkRosFJut3YWYeaPc
         Kc+boD1EiaIRQ==
Date:   Tue, 22 Nov 2022 10:53:00 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs for-next branch updated
Message-ID: <20221122095300.lt5mwo4lhqr4vlwx@andromeda>
References: <20221121143547.m33n36fufbz2x626@andromeda>
 <0bul_4vxtkpTuol85qbMYtteFmwirc1b8DMYjMK3wzADXA9cxc37kwbs_lr1fMsI_58SzPV43qMy24wj3tGdKw==@protonmail.internalid>
 <Y3wW9SCRYmBX3K9a@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3wW9SCRYmBX3K9a@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 21, 2022 at 04:25:25PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 21, 2022 at 03:35:47PM +0100, Carlos Maiolino wrote:
> > Hello.
> >
> > The xfsprogs, for-next branch located at:
> >
> > https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?h=for-next
> >
> > has just been updated.
> >
> > The new head is:
> >
> > b827e2318 xfs: fix sb write verify for lazysbcount
> >
> >
> > This update contains only the libxfs-sync for Linux 6.1, and will serve as a
> > base for the xfsprogs 6.1 release.
> > Please, let me know if any issue.
> >
> >
> > The following commits are now in the for-next tree:
> >
> > [b827e2318] xfs: fix sb write verify for lazysbcount
> 
> Why was this commit merged for xfsprogs 6.1?  That patch is queued for
> kernel 6.2 in for-next, but the merge window is not open yet.
> 

Since 6.1 isn't out yet, I did a `libxfs-apply <last libxfscommit>..`, my fault
for not spotting you've patches already queued for 6.2. I'm planning to release
xfsprogs-6.1 some time later after linux 6.1 is out, so this patch will already
be in Linus's tree by the time. I can also get this patch out of the tree when I
push the other patches I have queued up, although I'm trying to avoid doing
forced updates to the tree. Is it ok for you to leave it in the tree, or better
remove it by now?
Cheers

-- 
Carlos Maiolino
