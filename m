Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEC7C4167D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 07:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjKHHtN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 02:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjKHHtM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 02:49:12 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681A9113
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 23:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tSmZwmyLRtz/vpkdQmojoATiWQxtlZKOFUlvTQjSsmk=; b=etFVzA+Dw1WBjUvriXf3FbCp3E
        FR6TlHWJ6O3BwIZ2AOhDnEwnF1EwQNQ/VJi7+4uVxkjVHMG2ThCLYGBdVZ+K8oa2YAQFRVqo9K1nF
        Ywf5IxMXxDtdpQRkHnjt76/itFxhlHLNhxlu2IiImDNhw7QzsyMmGpopalm8OLgBh0l+Apx8Ckf8E
        uFBb31r6Zu3GCISlLoIpiwjHZ/bVELWa+hMpkFsDA+Xbc+wfe+tUVeMqaq9Bq7PLpZO6pjWHwHo+Q
        RkO3Qc3pJE+W7gfDxwa8iX7RAB/pbONvdYKnVsodX04k3D7AZwWhmUAm9Om9IjxRoP07NtRt8naJy
        l8BrRMSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0dJG-003Cvu-0G;
        Wed, 08 Nov 2023 07:49:10 +0000
Date:   Tue, 7 Nov 2023 23:49:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <ZUs9dh6Eft0rWrul@infradead.org>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
 <ZUn55/68v2VfQHCX@infradead.org>
 <20231107183511.GN1205143@frogsfrogsfrogs>
 <ZUs3Lex9NS55gXy3@infradead.org>
 <20231108074406.GL1758611@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108074406.GL1758611@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 11:44:06PM -0800, Darrick J. Wong wrote:
> > So if you make the pretty print mount point a new variable and pass
> > that first this would become say:
> > 
> > 	xfs_scrub -p /home -b /tmp/scrub
> > 
> > ad should still be fine.  OR am I missing something?
> 
> Nope, you're not missing anything.  I could have implemented it as
> another CLI switch and gotten the same result.  The appearance of
> "/tmp/scrub" in comm is a bit ugly, but I'm not all that invested in
> avoiding that.

So I'd definitively prefer that.  With the existing option remaining
the one it operates on, and the new designating the pretty printing.

> > But scrub has by definition full access to the fs as it's scrubbing
> > that.  But I guess that access is in the kernel code, which we trust
> > more than the user space code?
> 
> Yep.  Scrub runs with CAP_SYS_RAWIO, but I want to make it at least a
> little harder for people who specialize in weird ld exploits and the
> like. :)

Yes.  It's also good for the other reason you pointed out.

