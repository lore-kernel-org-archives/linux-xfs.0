Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C633C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10157207ED
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:01:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o+MnIddC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgERRBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgERRBP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:01:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE27C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5ZSr1rnibG+//L2MgCNchbgttdtal3oUPfXbrHgvfVg=; b=o+MnIddC+yaue0MnIbC2QoFlzo
        wRik7qSaXDKzjeppHzsqUoU+1s0HCVgLcRCIYJfnYlwhxG4YX0yIqTQV007/WLtpEaxyYSxYTTlvw
        FXkKZFavERi6q8Hx+IGu26BQZccwYvAAJlCivxC+3xdByYCdidcVL9oGUD0FFnEg/G8nf0CmVNZUc
        4LVugakL8wINi5MpgE6Y9gQQ2IdSZRxxtXnCrNr6S/Ky8LV9dBZMX4atvm0UrtKLXCmkHB8DWp8zm
        A+lZILU6VUOZulyWzl7ZeXtaZVS3lypImvBxTMBNZ3i+KqQrWUdaIHLt6rPwJF80zGvEx/GWAqB38
        Suz5dcAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaj8a-0000HI-3k; Mon, 18 May 2020 17:01:12 +0000
Date:   Mon, 18 May 2020 10:01:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH, RFCRAP] xfs: handle ENOSPC quota return in
 xfs_file_buffered_aio_write
Message-ID: <20200518170112.GB18061@infradead.org>
References: <e6b9090b-722a-c9d1-6c82-0dcb3f0be5a2@redhat.com>
 <20200518123454.GB10938@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518123454.GB10938@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 08:34:54AM -0400, Brian Foster wrote:
> Christoph's comment aside, note that the quota helpers here are filtered
> scans based on the dquots attached to the inode. It's basically an
> optimized scan when we know the failure was due to quota, so I don't
> think there should ever be a need to run a quota scan after running the
> -ENOSPC handling above. For project quota, it might make more sense to
> check if a pdquot is attached, check xfs_dquot_lowsp() and conditionally
> update the eofb to do a filtered pquota scan if appropriate (since
> calling the quota helper above would also affect other dquots attached
> to the inode, which I don't think we want to do). Then we can fall back
> to the global scan if the pquota optimization is not relevant or still
> returns -ENOSPC on the subsequent retry.

That's what I've implemented.  But it turns out -ENOSPC can of course
still mean a real -ENOSPC even with project quotas attached.  So back
to the drawing board - I think I basically need to replace the enospc
with a tristate saying what kind of scan we've tried.  Or we just ignore
the issue and keep the current global scan after a potential project
quota -ENOSPC, because all that cruft isn't worth it after all.
