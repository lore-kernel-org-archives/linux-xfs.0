Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E73C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98F5A208DB
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:09:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gZFo8Q43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEIRJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:09:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF7CC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nrnrTzbv+2AJjOC7/vlp9HaWBNA58Of3SHmxqeRiaSU=; b=gZFo8Q43nk0iSM4fA9kfbwpvq/
        DRUry7VMJq4FyNbima//QenPMh80Q8N7YfJl/0nNVrzUPGfQ4XRXvu0wkwtjJGsWErDix6OTBFM0x
        vJA+cs6jwx5yGlVPSv2F0t8teSgmj5JZdzh3kHnIaa9H+n8KMj9wlKcwgygBguqzXLxtPTcWBNe6Q
        pUvYJSKn4bpKD7ONdq/jj17CulzHsxnRC6nAC9jpqkObebq6V+TjVYTR0Po7kc4+bSktfqfRzlBmB
        L/J+jBuUwE6e2QwZkX9UNr6aoHfq90LWiJFZaup91GG7/jRmzF8vuKB+8kzl1eGajmLURxpoxC3D5
        7E9bcFrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSyN-0000us-3M; Sat, 09 May 2020 17:09:11 +0000
Date:   Sat, 9 May 2020 10:09:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs_repair: warn when we would have rebuilt a
 directory
Message-ID: <20200509170911.GB12777@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904180502.982941.12047148158523698696.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904180502.982941.12047148158523698696.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:05AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> longform_dir2_entry_check should warn the user when we would have
> rebuilt a directory had -n not been given on the command line.  The
> missing warning results in repair returning 0 (all clean) when in fact
> there were things that it would have fixed.
> 
> Found by running xfs/496 against lents[0].hashval = middlebit.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
