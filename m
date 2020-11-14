Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73611C5519F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0284B2225E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bqldOixf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKNKjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 05:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgKNKjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:39:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89C5C0613D1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tREVgE9pjiAd/Kzme3xNd9TPytlVb4cJSGtVbc/Qm7w=; b=bqldOixfkBh21eoZmk7KuxtlT5
        3zCR8j00xr4bkIZK/uupAwzmjZsfN8JlZVmHZb1CV3IYup4aQ+TVAMvk4EaeS9eJJW6iDpbEldVTG
        fUnKoKCTv4CtqdFmlbXQrdKf2E8DpSeDSnUepVp/hYUZWO0l38wbPNL2dwELOqbMUtlULSFCPPgOE
        WgSGkV0/dUd5Qfy2bhaofYULDmA0OPbJlmru8nHzWsUIymY3nOPXxg0TlHB2kJCgXcoKd20sYko2d
        mU+mchaHQlHIlBP7Dkz+ng7xhMis4fajjisRWPBDh8uxPu0HjrBLBqcDYBleRFRCIXnXlNN566Uuy
        0m7gyuEg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdsy9-0002wH-4o; Sat, 14 Nov 2020 10:39:45 +0000
Date:   Sat, 14 Nov 2020 10:39:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/4] xfs: fix the minrecs logic when dealing with inode
 root child blocks
Message-ID: <20201114103945.GA11074@infradead.org>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
 <160494586556.772802.12631379595730474933.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494586556.772802.12631379595730474933.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 09, 2020 at 10:17:45AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The comment and logic in xchk_btree_check_minrecs for dealing with
> inode-rooted btrees isn't quite correct.  While the direct children of
> the inode root are allowed to have fewer records than what would
> normally be allowed for a regular ondisk btree block, this is only true
> if there is only one child block and the number of records don't fit in
> the inode root.
> 
> Fixes: 08a3a692ef58 ("xfs: btree scrub should check minrecs")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
