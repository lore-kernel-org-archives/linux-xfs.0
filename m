Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDBCC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjKGIug (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKGIuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:50:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43025FA
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OlAds72u5HHcmD58S+NbGo92CZEfzoPTYi3yzTAzyhs=; b=L5uYzmSzAFAwgbCKqzU9OXv1TQ
        6AOf2CYrxLaN2Ks+UwU0/sV7moRxjUL7t6CQfmeC889EOULXDKYeboGfFF+T06fE5RhD63SlRn41x
        i38aox//nR1dgt+oR6JjeouC2N9dOBfVWpn8IDiJeB/N3c3RxWIpJ9FCbyNmUng6+tQRl+rVq3Loi
        Htg1YsuwSI44f1RRLb8oBHb6hFTmzqy/D/ZRhJ9HfSHLpZUCD+G+O9T2nnrKaCrDaAg6+6Wsz3x8u
        iz9N4khKhx+adOALaMgm9F+SO/l8QL2aSRzgywSqaed1hhaYh4PyKbjhb6ASi5DCjrh9tsCKZd7Z2
        MgQz3XRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0Hn7-000rIU-0V;
        Tue, 07 Nov 2023 08:50:33 +0000
Date:   Tue, 7 Nov 2023 00:50:33 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_scrub.service: reduce CPU usage to 60% when
 possible
Message-ID: <ZUn6WQslIFg+0Vc4@infradead.org>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074536.3746099.6775557055565988745.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506074536.3746099.6775557055565988745.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 06:55:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the xfs_scrub background service is configured to use -b,
> which means that the program runs completely serially.  However, even
> using 100% of one CPU with idle priority may be enough to cause thermal
> throttling and unwanted fan noise on smaller systems (e.g. laptops) with
> fast IO systems.
> 
> Let's try to avoid this (at least on systemd) by using cgroups to limit
> the program's usage to 60% of one CPU and lowering the nice priority in
> the scheduler.  What we /really/ want is to run steadily on an
> efficiency core, but there doesn't seem to be a means to ask the
> scheduler not to ramp up the CPU frequency for a particular task.
> 
> While we're at it, group the resource limit directives together.

Een 60% sounds like a lot to me, at least for systems that don't have
a whole lot of cores.  Of course there really isn't any good single
answer.  But this is probably a better default than the previous one,
so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
