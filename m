Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E05C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 10:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF9F64DD6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 10:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhA1KBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 05:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhA1KBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 05:01:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CCDC061574
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 02:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xJJYClXHh51TnueFP7dtd8CdCLGbqa7oy0GiDJrIkM8=; b=jVchJI+52LohXdWrZ5x7Pvt3XK
        AaFcF+DX0eT/sRNWZPsv621AoXsVeQtfrGnu5LOfzShRH1e7hfBJiVYSwMemIvCTUa+zuPa8gGBY8
        thZCamTCu7D/JgFOtwle68ilAG61RDfywWMiSPYe4NTkNOqGT9nyD7fjR2qAP5yrBwGiwP/4C0Ine
        6Q0X/gqJVGqpXrwKZvei+DWX8rELWAN4//v5ucftVwTSvW2gXcwyFLTRvokcPVyvvTQnFu7YQVsuM
        hXXDZ4UNQCqAYsSWtQlVsZfmHNT617ZbPblSk1CajyRbu1QbZ2pmL6GsB/AbIgpqi8pI5f9rrKNNK
        tpOxdZcA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l545q-008IQ7-LD; Thu, 28 Jan 2021 10:00:07 +0000
Date:   Thu, 28 Jan 2021 10:00:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 13/13] xfs: clean up xfs_trans_reserve_quota_chown a bit
Message-ID: <20210128100002.GI1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181373829.1523592.77926677559106032.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181373829.1523592.77926677559106032.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:02:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clean up the calling conventions of xfs_trans_reserve_quota_chown a
> littel bit -- we can pass in a boolean force parameter since that's the

s/littel/little/

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
