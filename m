Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5156CC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3285A20672
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QuNqZ0hL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgGOSm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgGOSm0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:42:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54365C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TI6c7iyYvyd86mVjSiLJ8OJHIb3kwiFXUwM4EbxTg6U=; b=QuNqZ0hLkdWbMBOIDXIaGVSVAG
        ZFaYBZc3lEIXGXtHIxnCeC4CyTjhUZM3mvHlgysWFBlJNAk2RlNYlUmmG3C8wEHjWzW9X1f0HWnL+
        UQLjEQ5n30QBhg3yEPCrQZEGvjrY+Gsrs22R32/83b0Vkug18SDF6sYOuQUVy9p7ViSGRUbQ30tws
        C/dNPCZjvEYPnzKjQ8rh46OsaoBtHWcZZOYXCv6LeKwMvr/dc3rnT01iHigZbTbjPnlApB+bbBRYT
        lNpeh3oXe9HDeSrrHv9MengY02LLaSL3z7yzJQLXbEbJlme0TqLpiR7B/dh5J4Ve8Td/AQh8c5m3f
        3YoAAIXA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmMK-0006DC-JM; Wed, 15 Jul 2020 18:42:24 +0000
Date:   Wed, 15 Jul 2020 19:42:24 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] repair: set the in-core inode parent in phase 3
Message-ID: <20200715184224.GA23618@infradead.org>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:33AM -0400, Brian Foster wrote:
> The inode processing code checks and resets invalid parent values on
> physical inodes in phase 3 but waits to update the parent value in
> the in-core tracking until phase 4. There doesn't appear to be any
> specific reason for the latter beyond caution. In reality, the only
> reason this doesn't cause problems is that phase 3 replaces an
> invalid on-disk parent with another invalid value, so the in-core
> parent returned by phase 4 translates to NULLFSINO.
> 
> This is subtle and fragile. To eliminate this duplicate processing
> behavior and break the subtle dependency of requiring an invalid
> dummy value in physical directory inodes, update the in-core parent
> tracking structure at the same point in phase 3 that physical inodes
> are updated. Invalid on-disk parent values will still translate to
> NULLFSINO for the in-core tracking to be identified by later phases.
> This ensures that if a valid dummy value is placed in a physical
> inode (such as rootino) with an invalid parent in phase 3, phase 4
> won't mistakenly return the valid dummy value to be incorrectly set
> in the in-core tracking over the NULLFSINO value that represents the
> broken on-disk state.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
