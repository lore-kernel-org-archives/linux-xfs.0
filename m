Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955F3C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjKGI3y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbjKGI3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:29:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331BABD;
        Tue,  7 Nov 2023 00:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OiPmvoe5Y0ppJQaTILBG8RrVwwaBOmCYO/Hksb5Iuxw=; b=3/5DqS2xBXv2UAJwok0eU1vbmy
        6Wgvb+wN7WOPVF/ZLGK16vbmjZUkGMNET2QnyHLT2bNYg3kQUNApCBCuzBb6sv+JRhNJsfLThT43B
        bpWP8eMkiLUuQfXdeIz6vMHFfidHrg1tcmfR+TJbkYzsSCstOJyLhswI0Tp8qpReB0nGU3iLQ3rGG
        +K/D4PgkKFPbX9utiRo4b34e1gYvGAF1ETqUWAA98mE2jzBKhs+qXs+mHiXPyyjOynj2M7cKfXDwJ
        LoKksdNHv+3e4QwMDM8pJVLxZLM+ckZhoEXTQMDx1UFRQPLU7Ki3CB8HlNCTLVH30w6/c8S+VdHj1
        Gf7zsCpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0HT3-000owf-0z;
        Tue, 07 Nov 2023 08:29:49 +0000
Date:   Tue, 7 Nov 2023 00:29:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <ZUn1fRNaxTgFhBqg@infradead.org>
References: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiECgUWZ/8HKi3k@dread.disaster.area>
 <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUlNroz8l5h1s1oF@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUlNroz8l5h1s1oF@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 07:33:50AM +1100, Dave Chinner wrote:
> That's not good. Can you please determine if this is a zero-day bug
> with the nrext64 feature? I think it was merged in 5.19, so if you
> could try to reproduce it on a 5.18 and 5.19 kernels first, that
> would be handy.
> 
> Also, from your s390 kernel build, can you get the pahole output
> for the struct xfs_dinode both for a good kernel and a bad kernel?

Another interesting angle is that s390 is the only mainstream big
endian platform left.  It might be interesting to also try to
reproduce this in a ppc64be or sparc64 system if someone has one
or a VM).

