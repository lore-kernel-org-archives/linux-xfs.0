Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83480C76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 06:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjDEGPn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 02:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjDEGPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 02:15:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43602273D
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 23:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fOGdjRVjBOME11LGd0/WfGtk/hsczO+U60Wri4qblhs=; b=rmOHiMeV3E1zjIA9+Yow28HOhb
        0CP2nYv8dgO6NkTjuZZ/+7xYkCa/GUpR772t8td5j4GAx2dvyum+IX9itbcmhovUYP5yxtkv4n5Zd
        bgK8bd1lbDpOfSqEhZOc3qwDuf6EX2VME7aD4c6o5LA+yTd+HkSf2cmboTwSP6OaNEoVq+rMWY8Ec
        EddzLWLYJDkA1i40g3687SLDaXVA0vj63oiJjC0wsb/xOmXdoXG4O5huERGOZbWo0Q8PTk5+/NgaK
        p/Im3BQIYHf5IOJxbSXKW7/zv+mRJb56j9JiFhrU0sBhxGeNSZcTj/qKxPvXIquDxDRRPTrdiYDHj
        riQzYDrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pjwQl-003UFr-1t;
        Wed, 05 Apr 2023 06:15:39 +0000
Date:   Tue, 4 Apr 2023 23:15:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: test the ascii case-insensitive hash
Message-ID: <ZC0SC1XEC6a1/ck6@infradead.org>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062803200.174368.4290650174353254767.stgit@frogsfrogsfrogs>
 <CAHk-=wi-W-zJkW-URTQoLcLnRuwzmWj4MRqV6SHXmjKDV2zXFg@mail.gmail.com>
 <20230404205136.GA110000@frogsfrogsfrogs>
 <CAHk-=wiKYQuwJpUBNEsc73jaf4-3b3xL5-MD=YXgEBn+31KDKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiKYQuwJpUBNEsc73jaf4-3b3xL5-MD=YXgEBn+31KDKg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 02:21:35PM -0700, Linus Torvalds wrote:
> Fair enough. That works. I still think it should be made to be
> US-ASCII only, in order to not have any strange oddities.
> 
> Do you really have to support that "pseudo-latin1" thing? If it's
> literally just a "xfs_hashprep()" function, and you arbitrarily pick
> one random function, why make it be a known-broken one?

Because that's the one that has been used for 15 years as no one would
do this for new code?

