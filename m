Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9295C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjKGIsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjKGIsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:48:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58241BD
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6/rx0K4TGfQ6CXC0Hsugp1d7Xo+9JuTGEJ9ddo6qVBY=; b=MHW5SFm0rkdDyxk4tP6tuUCMUm
        kk9Q3NUABxtmpbLn5FqC5RRv0lhIZz+dz4/sJzXP6CdGRAYU2swcgvv6h6/3MNN/JW59tc7Rfq1eD
        HCcTHxrgcNYwZmjCGSFOB8o17+DhqHrRt7mjPbS3ibr9RFxVQzZDc65jI8SE344ltbEJUrOJEOp38
        eWczt5tG+luwmqCZQnd2jxiDTiZxcJgoLCqIAv3ZHSjlFtwmHxByPaX2vUhOaFGVh3p8DUy9jMO8M
        dSfhNiNunj9BrGlXvJvrwT+FdP7oOfHpTAugmZEKydL9XihHAkupXaDw0aRN8gvi4Vpd+PzNy+qWx
        RkOfOnHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0HlH-000r1o-0m;
        Tue, 07 Nov 2023 08:48:39 +0000
Date:   Tue, 7 Nov 2023 00:48:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <ZUn55/68v2VfQHCX@infradead.org>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 06:55:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the next patch, we'll tighten up the security on the xfs_scrub
> service so that it can't escape.  However, sanboxing the service
> involves making the host filesystem as inaccessible as possible, with
> the filesystem to scrub bind mounted onto a known location within the
> sandbox.  Hence we need one path for reporting and a new -A argument to
> tell scrub what it should actually be trying to open.

This confuses me a bit.  Let me try to see if I understood it correctly:

 - currently xfs_scrub is called on the mount point, where the
   mount-point is the first non-optional argument

With this patch there is a new environment variable that tells it what
mount point to use, and only uses the one passed as the argument for
reporting messages.

If I understand this correctly I find the decision odd.  I can see
why you want to separate the two.  But I'd still expect the mount point
to operate on to be passed as the argument, with an override for the
reported messages.  And I'd expect the override passed as a normal
command line option and not an environment variable. 

