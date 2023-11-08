Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D63CC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 07:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjKHHWY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 02:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbjKHHWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 02:22:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A31AC
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 23:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f2/hniEONjyoDSWOEPyj3qxtacisHWjJLtnURmjJ+RA=; b=wtnq4csfe9yk07kGAWiSIyvAMb
        A4ySomTP2sb+uCxMN2DOVqhucKPMNfxulHQDTEJddxH4EmrOhpVktDGZnEu72OdQbz1GGmPiX/U2W
        eV9FWk10G1Jmb2GIhoBfBBT/hXuoFbCT1DPrweohM8+XmJLkgiTyRyb4smRuB71dfHrV7iHmlf5DD
        0X496or7iSlI4x3Nhk/AF2SKdVOgjuPfQMFSqTTgkW8XO1Li/3t2Db/cHeql/qnYOaWt2PLLSVxEJ
        TKMHSUN8jZYLB4cUozQ1sP3r+v+QJ0bh4Lu8noRgs8b9roIAqgVZAFfruzBV4rJWfXVvlyB5viFD7
        eTjG1cJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0ctJ-003AfY-0E;
        Wed, 08 Nov 2023 07:22:21 +0000
Date:   Tue, 7 Nov 2023 23:22:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <ZUs3Lex9NS55gXy3@infradead.org>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
 <ZUn55/68v2VfQHCX@infradead.org>
 <20231107183511.GN1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107183511.GN1205143@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 10:35:11AM -0800, Darrick J. Wong wrote:
> The reason why I bolted on the SERVICE_MOUNTPOINT= environment variable
> is to preserve procfs discoverability.  The bash translation of these
> systemd unit definitions for a scrub of /home is:
> 
>   mount /home /tmp/scrub --bind
>   SERVICE_MODE=1 SERVICE_MOUNTPOINT=/tmp/scrub xfs_scrub -b /home
> 
> And the top listing for that will look like:
> 
>     PID USER      PR  NI %CPU  %MEM     TIME+ COMMAND
>   11804 xfs_scru+ 20  19 10.3   0.1   1:26.94 xfs_scrub -b /home
> 
> (I omitted a few columns to narrow the top output.)

So if you make the pretty print mount point a new variable and pass
that first this would become say:

	xfs_scrub -p /home -b /tmp/scrub

ad should still be fine.  OR am I missing something?

> For everyone else following at home -- the reason for bind mounting the
> actual mountpoint into a private mount tree at /tmp/scrub is (a) to
> make it so that the scrub process can only see a ro version of a subset
> of the filesystem tree; and (b) separate the mountpoint in the scrub
> process so that the sysadmin typing "umount /home" will see it disappear
> out of most process' mount trees without that affecting scrub.
> 
> (I don't think xfs_scrub is going to go rogue and start reading users'
> credit card numbers out of /home, but why give it an easy opportunity?)

But scrub has by definition full access to the fs as it's scrubbing
that.  But I guess that access is in the kernel code, which we trust
more than the user space code?
