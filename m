Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7637C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2964207DD
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EwGm/bGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgELIKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 04:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbgELIKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 04:10:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F2C061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 01:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JTemmbTGjAnmNd9SjY/4BRJKeF35TG/g0WwKO2/VhVE=; b=EwGm/bGHfrqHb8Ihzuf7sKHKni
        KCFClIidZ7HGg/E10ZIFW/x8mHS7UPBFZDHdbYxd2+cZ+ciHDse48AAYp6NX/QqYSrFruZ3O59itw
        MREHwNOeEg0wqbdEHC42caUZitjp8Fe+hM7G4js/MKKQ2pTknaK4LP1jkBMDE8TvdukS+2En28qtI
        PF8XTIbVt1TgcYnf2tV9OMeZNxDvduwkMm4ugYJYRCqZ48V60x9+UiFFt3TmVFl1YgvPtsj047MVL
        2IEG6L+cknD4hXX824nY4uEf2uf+d8XqvHt1FsYoZzmKrVdA9uDrGJCX1h3FkYC+ehb9lBTJRaRWq
        iaX1VeCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYPzp-0001ow-Ok; Tue, 12 May 2020 08:10:37 +0000
Date:   Tue, 12 May 2020 01:10:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: warn instead of fail verifier on empty attr3
 leaf block
Message-ID: <20200512081037.GB28206@infradead.org>
References: <20200511185016.33684-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511185016.33684-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 11, 2020 at 02:50:16PM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> What do folks think of something like this? We have a user report of a
> corresponding read verifier failure while processing unlinked inodes.
> This presumably means the attr fork was put in this state because the
> format conversion and xattr set are not atomic. For example, the
> filesystem crashed after the format conversion transaction hit the log
> but before the xattr set transaction. The subsequent recovery succeeds
> according to the logic below, but if the attr didn't hit the log the
> leaf block remains empty and sets a landmine for the next read attempt.
> This either prevents further xattr operations on the inode or prevents
> the inode from being removed from the unlinked list due to xattr
> inactivation failure.
> 
> I've not confirmed that this is how the user got into this state, but
> I've confirmed that it's possible. We have a couple band aids now (this
> and the writeback variant) that intend to deal with this problem and
> still haven't quite got it right, so personally I'm inclined to accept
> the reality that an empty attr leaf block is an expected state based on
> our current xattr implementation and just remove the check from the
> verifier (at least until we have atomic sets). I turned it into a
> warning/comment for the purpose of discussion. Thoughts?

If the transaction is not atomic I don't think we should even
warn in this case, even if it is unlikely to happen..
