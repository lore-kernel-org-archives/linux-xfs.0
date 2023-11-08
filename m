Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AA6C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 07:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjKHHY3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 02:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjKHHY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 02:24:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E68E1706
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 23:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yAOU6pcwMKzn1OKp8JKd6eBi2POAn7k7rSk4xt05eiY=; b=0KZX0Sa0/uAcZLwKC59mJn8kzg
        mzMRkhhXRxS0SSY81ocqcUODl48fE52lNBMLlTK2GO37Qdewwcc5+otMVNI9J4la1qXmpyCPCZQgJ
        ekD+XboxiW7xo+CFYdtYkORlaedZstnvir2+Jdl5Ijj1rbbeAppgTcnCZJSiJU8l/TfnNQUuvfV2S
        MSy9vtQxbzuJQEo4wdffZVgB/4CfrE89HhORbLSS/b0PKxr7R/jytaTBOm/AKcTRdopY/KvfNnhTr
        cBT3BppFOkjOR2xFhPp5dyeZ8vjW/7BulZlbyriAkaLrRdWn08lRqRnulYbJzu5vMrp8L8AirsueM
        eisRDfPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0cvK-003Aoc-09;
        Wed, 08 Nov 2023 07:24:26 +0000
Date:   Tue, 7 Nov 2023 23:24:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <ZUs3qlyL2E6uhmfa@infradead.org>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
 <ZUn55/68v2VfQHCX@infradead.org>
 <20231107183511.GN1205143@frogsfrogsfrogs>
 <ZUs3Lex9NS55gXy3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUs3Lex9NS55gXy3@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 11:22:21PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 07, 2023 at 10:35:11AM -0800, Darrick J. Wong wrote:
> > The reason why I bolted on the SERVICE_MOUNTPOINT= environment variable
> > is to preserve procfs discoverability.  The bash translation of these
> > systemd unit definitions for a scrub of /home is:
> > 
> >   mount /home /tmp/scrub --bind
> >   SERVICE_MODE=1 SERVICE_MOUNTPOINT=/tmp/scrub xfs_scrub -b /home
> > 
> > And the top listing for that will look like:
> > 
> >     PID USER      PR  NI %CPU  %MEM     TIME+ COMMAND
> >   11804 xfs_scru+ 20  19 10.3   0.1   1:26.94 xfs_scrub -b /home
> > 
> > (I omitted a few columns to narrow the top output.)
> 
> So if you make the pretty print mount point a new variable and pass
> that first this would become say:

s/variable/option/

