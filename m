Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53885C76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 06:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbjDEGNF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 02:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbjDEGNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 02:13:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC9C120
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 23:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SYzGzXKN8+b2GwuirxBSKVa3AMhD9/wkNdxjust90pM=; b=pY6HWDckmw7unwEt3deEl7v8PY
        BSxpjPtLpbEQthrL8zmDEl8cJn0rGqW033U4x+8z7kSEtIjLnM5whVEWcN5yq5i2pIi350V8HQgDj
        tk3++XvBYlN/j/8t6UPUZsEgWFaBjwpVtmOXh1bLljFQG6Pek9zuYmPA4srOf0QdEGqxxRj5obSs4
        vIMMOOxWp7KSjskgSMKhzfDjRI/R5DceESWF/jk5fa1QXXWjh+ANXYzOBcOgGX7JNytv+C2OEC7yj
        U3E6HY/DaADvSIlipXcbkz9uDACmA5Qt++Dpt8uyOxbgxz8QoUo5z7dy7MaRU8OI0dDg+XEcnyqTg
        8AiGiXPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pjwO8-003Tsw-2g;
        Wed, 05 Apr 2023 06:12:56 +0000
Date:   Tue, 4 Apr 2023 23:12:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <ZC0RaOeTFtCxFfhx@infradead.org>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
 <20230404183214.GG109974@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404183214.GG109974@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 11:32:14AM -0700, Darrick J. Wong wrote:
> Yeah, I get that.  Fifteen years ago, Barry Naujok and Christoph merged
> this weird ascii-ci feature for XFS that purportedly does ... something.
> It clearly only works properly if you force userspace to use latin1,
> which is totally nuts in 2023 given that the distros default to UTF8
> and likely don't test anything else.  It probably wasn't even a good
> idea in *2008*, but it went in anyway.  Nobody tested this feature,
> metadump breaks with this feature enabled, but as maintainer I get to
> maintain these poorly designed half baked projects.

IIRC the idea was that it should do 7-bit ASCII only, so even accepting
Latin 1 characters seems like a bug compared to what it was documented
to do.

> I wouldn't ever enable this feature on any computer I use, and I think
> the unicode case-insensitive stuff that's been put in to ext4 and f2fs
> lately are not a tarpit that I ever want to visit in XFS.  Directory
> names should be sequences of bytes that don't include nulls or slashes,
> end of story.

That works fine if all you care is classic Linux / Unix users.  And
while I'd prefer if all the world was like that, the utf8 based CI
has real use cases.  Initially mostly for Samba file serving, but
apparently Wine also really benefits from it, so some people have CI
directories for that.  XFS ignoring this means we are missing out on
those usrers.

The irony is all the utf8 infrastruture was developed for XFS use
by SGI, never made it upstream back then and got picked up for ext4.
And while it is objectively horrible, plugging into this actually
working infrastructure would be the right thing for XFS instead
of the whacky ASCII only mode only done as a stepping stone while
the utf8 infrastructure got finished.
