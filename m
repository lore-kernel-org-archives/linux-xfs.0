Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AD9C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 22:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbjKFWVe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 17:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbjKFWVc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 17:21:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5B9D6E
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 14:21:29 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE75C433C8;
        Mon,  6 Nov 2023 22:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699309289;
        bh=HXDu/lokU74NRgElRKNgkqpa49Q3NHpjYNjd7KFFx3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wknz2AIdt69DAYPCinX+Z9qmWXcCMHdLQai8ISwRa77mOC1pnOIKLxttLsB1Z3zf+
         g0gFYQZgS6E1uAQHm7rJZh3NKr4/VuYjxjyxWMtRm6nziY/VzxDNRJMxx+nrECXm1q
         YkWzOFcDiCb0GgcG/4hkFve3eeNhgkyzFYDJJeflk5hO5jE+11C6QjkOFuYRsUhCZb
         98ZN5UwXKp0LlT2Sp1pQXz99JUOoN1TTAAquvr3d2dtFzir1zwtbO9S5XWh/HGoe73
         ZKqBzD6j/wDWO+4H1QFOMhF5knO+zqYwla/6HAsr+rc/QuQFsJMTiTlXZ7rD3x9XzQ
         0CWE4D3XAqndA==
Date:   Mon, 6 Nov 2023 14:21:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] db: fix unsigned char related warnings
Message-ID: <20231106222128.GJ1205143@frogsfrogsfrogs>
References: <20231103160210.548636-1-hch@lst.de>
 <20231103203813.GG1205143@frogsfrogsfrogs>
 <20231106065939.GA16884@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231106065939.GA16884@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2023 at 07:59:39AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 03, 2023 at 01:38:13PM -0700, Darrick J. Wong wrote:
> > On Fri, Nov 03, 2023 at 05:02:10PM +0100, Christoph Hellwig wrote:
> > > Clean up the code in hash.c to use the normal char type for all
> > > high-level code, only casting to uint8_t when calling into low-level
> > > code.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > The problem is deeper than just this, but we gotta start somewhere...
> 
> Is it that much bigger?
> 
> Beѕides the usual problem of casts hiding bugs I think we are fine,
> but please double check:
> 
>  - the lowlevel xfs directory entry hashing code assumes unsigned
>    chars, because of that we long compiled with -funsigned-char just
>    for XFS, which got obsoleted by the kernel doing it entirely
>    after we've switched all the low-level code to use unsigned
>    char.
>  - given that traditional unix pathnames are just NULL terminate
>    by arrays and the 7-bit CI code doesn't even look at the
>    high bit we really don't care about signed vs unsigned except
>    for the usual C pitfall when casting or shiftting
> 
> So as long as all the low-level code uses unsigned char we should
> be fine.

I'll go take a look, though that might take a day or two.

--D
