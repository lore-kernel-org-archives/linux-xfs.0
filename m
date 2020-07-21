Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8266C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE7820729
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:57:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RTmqaRM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgGUO5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUO5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:57:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2BEC061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PyqNMY5hLTnwO5ljh9ioJXMo2kdENFmKGIqWb53joX0=; b=RTmqaRM7JQ+2ACqE4C7e7W0o28
        e5g7/y5r3akAUhDCctPw2FHASH3duAugmT6y/baPd0ab0Y0pc+I8FO+ChD/mNSqtEVc8tUcFDWN3l
        IYO2jCTYhnOn7y+zwDkkyk7Hi8/HlLFwZKFnGxdgkFybsSMCUgiO8feE6ontDB61Jef/RjPxo227M
        3KBjIUqQxNc1C15rcvKLKQF26HGp+JBqDtmam0tNx222jyxWN1xnk7A9Kiuk5I/721x88t/fUpQfc
        joRpRgca7UDO3G4Tn5IVyk1HI4pi3RGgzEQExRpeSB+FUvNwV5lVh7EaBmZ67uEedN/YIRSz7kA4/
        MgzDiuZw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxthV-0001pq-DW; Tue, 21 Jul 2020 14:57:01 +0000
Date:   Tue, 21 Jul 2020 15:57:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: remove unnecessary quota type masking
Message-ID: <20200721145701.GG6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488196391.3813063.17612590871057481605.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488196391.3813063.17612590871057481605.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:46:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When XFS' quota functions take a parameter for the quota type, they only
> care about the three quota record types (user, group, project).
> Internal state flags and whatnot should never be passed by callers and
> are an error.  Now that we've moved responsibility for filtering out
> internal state to the callers, we can drop the masking everywhere else.
> 
> In other words, if you call a quota function, you must only pass in
> XFS_DQTYPE_*.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
