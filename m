Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B22C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E8BB64EB9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBIJMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhBIJKp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:10:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17338C06178B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o6bGgNvWCnG/oHftCM9FTvwTSwu4Cu3GAm5t7XJcRf4=; b=ImUJa4BLbi9rsVVHjMOSwc32bZ
        ajC85PWQCRq/4S27fT9kxd9I1yYpKZ6fDDOmeXGhgFQI8CGVQRVPOHL2vyGAO2QHTe6SY9GGIZa/+
        WQtEIJShccDRyMLGL7dbExr5A4yCb1YICPWzs3RjxGTNt0gC/gQbY3DdrSETGsYZ7VhNu5be8ICm+
        cj4e6k/ElXCQ2VTiRp/S+uMQIjgZQkWfOBnpG1LGSf6RzNc18sF0PjQWM8Zom5VveyOUj6EnH5+dC
        SNHX65D3gjmRBcYuvVIAPEqvsnkoMfAuuPspDNe1FQn65UFpcdrI1c+eVfLqYZFcA8rSggZll9RAj
        rMxrVZ9g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P1v-007D6p-HL; Tue, 09 Feb 2021 09:09:55 +0000
Date:   Tue, 9 Feb 2021 09:09:55 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs_repair: fix unmount error message to have a
 newline
Message-ID: <20210209090955.GD1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284382691.3057868.2014492091458444565.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284382691.3057868.2014492091458444565.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a newline so that this is consistent with the other error messages.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
