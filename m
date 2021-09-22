Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A947C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 18:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68AF961131
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 18:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbhIVS5Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 14:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235203AbhIVS5X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Sep 2021 14:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9434961107;
        Wed, 22 Sep 2021 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632336953;
        bh=AqgfVJ5cM8U3pTTGRVeSteDUaaxgAHiGuA4RFy1awVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPgtTl/GV/QOD9xbfhiWwLxpgszrATn8JH1T6OnmDfFYsGETdLXsIBth5NJ3rxAvG
         WP+IuGO/phPA3pBMhRYvkR/76Uct93t/x02sGks1GLrAyrJaLrfz2lfpKiXwVCoI3+
         Zv13acOfM0jBlwwB40W9UzUOJ/EbMLiZcuwhh5R3bqGO+YJd25XyWDXh0DvTx1zWAj
         6ZrND1MFvm+l7/ipI2gmXPA3EUSHyhqAj+iJhd5RZtYcS85nTp8aaiUkVyX0qUZqqI
         UVql/C8GBc0zpVSLWxatdoYeAOLkv4CrHTUP7+EQqt+2Q1J1Q25jxL6W63AvpXPgQ7
         LpsvhajzNaNBA==
Date:   Wed, 22 Sep 2021 11:55:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, chandan.babu@oracle.com,
        chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <20210922185553.GM570615@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
 <20210920230635.GM1756565@dread.disaster.area>
 <YUmf9Zmp01WcEw0T@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUmf9Zmp01WcEw0T@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 10:03:49AM +0100, Christoph Hellwig wrote:
> On Tue, Sep 21, 2021 at 09:06:35AM +1000, Dave Chinner wrote:
> > On Fri, Sep 17, 2021 at 06:30:10PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Replace the statically-sized btree cursor zone with dynamically sized
> > > allocations so that we can reduce the memory overhead for per-AG bt
> > > cursors while handling very tall btrees for rt metadata.
> > 
> > Hmmmmm. We do a *lot* of btree cursor allocation and freeing under
> > load. Keeping that in a single slab rather than using heap memory is
> > a good idea for stuff like this for many reasons...
> 
> Or rather a few slabs for the different kind of cursors.  But otherwise
> agreed.

I think I prefer to let Chandan decide if there are going to be enough
heavily fragmented files to warrant a second slab for maxlevels>9 files.
We should probably be selective about which cursor maxheight we want to
use depending on whether or not the file really needs it.

--D
