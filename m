Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB07C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D89BE2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KXaIIJOc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgBYTvm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:51:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgBYTvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:51:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DJKBnAmKlR5YIgnRF60nrQBPseXmETqGd/sCAJEuWwY=; b=KXaIIJOcz1skwPs4lH6dQy8dp5
        srSlQIg5QhHyW9M8Z5ugazbkcSQSsS9Dmj/8Yd4TnZuYyQSkmGCHvK0KMjDDeBtzdaA/gabmRKr83
        0r0NnlBE4xbJqG6ndNSDJsVYrwHa1L3FjNHHmaNYaTZU/wX3u5fTJrtnIm9aEZwXPizAYTMUrK6gU
        FhWnvbFvOJ3CRWHxw69YZ+EslDkhVqSFS0yn1yK15h9W5YKmsGhm6L8MYqpVd3tuGXlb1ULEYO0z3
        9HTsNkkK3PegUyEyvs5PrdszqvttQMj7ZsgPI/Zv8aqMwypyC9HdOmHDM9pa2fKx2JTCxCcS8/wVw
        Lg/aGg8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6gF4-0007LJ-4I
        for linux-xfs@vger.kernel.org; Tue, 25 Feb 2020 19:51:42 +0000
Date:   Tue, 25 Feb 2020 11:51:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: clean up the attr interface v6
Message-ID: <20200225195142.GA28113@infradead.org>
References: <20200225194945.720496-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225194945.720496-1-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The conference wifi is too bad for git-send-email to finish the
series.  I'll retry later.
