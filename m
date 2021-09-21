Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D58C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1624A61215
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhIUIpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhIUIpW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 04:45:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC63AC061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ePJmbMAVzZsz4RluztY8CiY1H46Rs74T30Y0BZyGHrU=; b=L4B/RDzf8uc8koopCk5Sog0CQw
        o/6N5a1ET7R60vEzbGchDlCH7RYDL8mrnZuoCz0e5MB7QqkBzF4YKt1LcUkUTq07OgZk1iar0b52o
        BzefDEf5mUz2FQm7B1RmizgfWNJCePzgNVGfLD9SUbQXw36+f67EtE14Tx4VeXlrymSbHG2R1Ko6E
        f2jIII2ZT3WUDOHgbr7OIvjJHHIo2nJsO4IH/6VUAVvPmv0XxFxuGuCeoXOGTxVX5np8BP5u6YnGb
        rgueNmI42FVI8z810WhlB1sRh5qal/dN4VrU54mvoZzlCWzP3Slxr53rGvlTMJ4OJwpYOmrOnAjaV
        ojVEGlSQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbN0-003e4L-UO; Tue, 21 Sep 2021 08:43:30 +0000
Date:   Tue, 21 Sep 2021 09:43:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: dynamically allocate btree scrub context
 structure
Message-ID: <YUmbJvitO5DeRR5D@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192856634.416199.12496831484611764326.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192856634.416199.12496831484611764326.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 06:29:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reorganize struct xchk_btree so that we can dynamically size the context
> structure to fit the type of btree cursor that we have.  This will
> enable us to use memory more efficiently once we start adding very tall
> btree types.

So bs->levels[0].has_lastkey replaces bs->firstkey?  Can you explain
a bit more how this works for someone not too familiar with the scrub
code.

> +static inline size_t
> +xchk_btree_sizeof(unsigned int levels)
> +{
> +	return sizeof(struct xchk_btree) +
> +				(levels * sizeof(struct xchk_btree_levels));

This should probably use struct_size().
