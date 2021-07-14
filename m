Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82EFC07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 07:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D645613B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 07:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbhGNHGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbhGNHGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 03:06:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72171C061574
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 00:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3bvB17spDFVTbJLRSXe9tuudEgOxZkakkZsd6o3JZeY=; b=LofETXn3wKK5+6GqRZTJBEK1tO
        YCBOQ8LIPS+jMDd/ArmGdYlsZllHcffEs5gIAVUwa1VyjjKzxa/ko3SKKYS01WweXmK0goIQCZUR6
        mqUoFpi9GkVWnbEWzOiZ4a3o8TNzIkj8SAiU4XscLVW4PFSlkh7KQ0/2MqqdCKCjDgM95OcHZ7UvK
        PNioq4/gLSkjNOVI6FvzvM/QVpjv3Okx3gNN3t+QHsCuis4RbyEv83lkVNLh22UffXobNbod5Vmwa
        EmxI+D56xuOjpGWrKk0KzBGlohq2+7UQ14QmqRyPHYsKWVrKijt/KXF4mFseaYWIpaqL1Aa2aiB8C
        NvSinm3Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3YvD-001wem-QH; Wed, 14 Jul 2021 07:03:14 +0000
Date:   Wed, 14 Jul 2021 08:03:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/16] xfs: replace xfs_sb_version checks with feature
 flag checks
Message-ID: <YO6MK6Q1QJl968HT@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert the xfs_sb_version_hasfoo() to checks against
> mp->m_features. Checks of the superblock itself during disk
> operations (e.g. in the read/write verifiers and the to/from disk
> formatters) are not converted - they operate purely on the
> superblock state. Everything else should use the mount features.
> 
> Large parts of this conversion were done with sed with commands like
> this:
> 
> for f in `git grep -l xfs_sb_version_has fs/xfs/*.c`; do
> 	sed -i -e 's/xfs_sb_version_has\(.*\)(&\(.*\)->m_sb)/xfs_has_\1(\2)/' $f
> done
> 
> With manual cleanups for things like "xfs_has_extflgbit" and other
> little inconsistencies in naming.
> 
> The result is ia lot less typing to check features and an XFS binary
> size reduced by a bit over 3kB:
> 
> $ size -t fs/xfs/built-in.a
> 	text	   data	    bss	    dec	    hex	filenam
> before	1130866  311352     484 1442702  16038e (TOTALS)
> after	1127727  311352     484 1439563  15f74b (TOTALS)

Impressive!

Reviewed-by: Christoph Hellwig <hch@lst.de>
