Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6F2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 13:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346515AbiD1NIB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345704AbiD1NIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 09:08:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E578A84ED0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 06:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=32hfSctVctrewRMc5JGCK3Cq2nGRacxMr1QoXzFb+Yc=; b=PuTGt6dRY45webVP5LEBqQNOaK
        TI3aEVlTYNMcp4li6gGqeYvS3g8MNLx3B0F30GI/ByC3e67B7LYzfRf9dejSUj3DZe/IFqql/Wj/a
        D1TzIh/o5R5qyWazDykA9qtZFFs3FA+6Zcy3w2GvWIWZXwlP04awhXsjeBK31DNqzEHu8xJF9xWFp
        ychk52A8kCv3lfDA9CVau053lRaCIdlzeswPW7FV3Ezh5xbqD5Tn/vTXlU7hiSAdJC/xWvDilMj7A
        bm1crPuVVZjCjW382IotcBdBVj9KHb2aGDjvqq1GJ4Yd8sERG1lp6KeEW+gwkd3UWgwgp3EDS4NJr
        XP4JKvnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3p7-006vYJ-RI; Thu, 28 Apr 2022 13:04:45 +0000
Date:   Thu, 28 Apr 2022 06:04:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: add log item flags to indicate intents
Message-ID: <YmqQ7bsythoExDKe@infradead.org>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-4-david@fromorbit.com>
 <20220427030439.GB17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427030439.GB17025@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 08:04:39PM -0700, Darrick J. Wong wrote:
> > We need to be able to identify intent and intent done items quickly
> > and easily in upcoming patches, so simply add intent and intent done
> > type flags to the log item ops flags. These are static flags to
> > begin with, so intent items should have been typed like this from
> > the start.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Heh, I remember being told to infer intentness or intentdoneness instead
> of using explicit flags...
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

And I still think having this information redundant and not inferred
seems like a bad move.  But I'll scan the following patchs to see if
there is a good rationale for it, because based on this patch alone
it doesn't actually seem like a good idea to me.

