Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4660FC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F5892082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a084H3QJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgBYRiz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:38:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38096 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYRiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:38:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cqSGTKUyK3M/fQTVpubAm11EElenRjyCj1XJomdlcK4=; b=a084H3QJOeXJGWvikUMUr5RIN5
        LTW3JGSyQl8oUVxaWTszztkexrD8f5z4J0oauAvOk5anaqBgk8/FH0citoKIU+u+jnMey3pbDci9x
        CCHSCUqKHXJ6LALyPXmWOOfpI7jDM8Z+9BZHDPM9F/Am0RrKqh/VEE0SNToyEnpQSSMO4UvhJ73Q7
        HGYf4jA+mpxOT04fGnXXdujYn3llO6I+3bO1SmRhIPpzwRMkHivPm3S5MQn2m5vo3HkOHv/01p1J9
        WT2ajNgT/r9mCjWEJm6VmPYIHyaznD0Opvw2z7rZvcyGu0l1blWLjTG3MCPQKpqeWthAIKXQCfDd6
        EmUvKtUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eAY-00018l-PB; Tue, 25 Feb 2020 17:38:54 +0000
Date:   Tue, 25 Feb 2020 09:38:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/7] libfrog: always fsync when flushing a device
Message-ID: <20200225173854.GD20570@infradead.org>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258947176.451075.17374209516005783362.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258947176.451075.17374209516005783362.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Always call fsync() when we're flushing a device, even if it is a block
> device.  It's probably redundant to call fsync /and/ BLKFLSBUF, but the
> latter has odd behavior so we want to make sure the standard flush
> methods have a chance to run first.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
