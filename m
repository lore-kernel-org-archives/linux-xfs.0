Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C2CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 12:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbiEJM4n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 08:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242195AbiEJM4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:56:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B770836156
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jbzd1XvXrEIAR0Ab42EKVLi3errZEQLdruukNAEfLtU=; b=4N+4gW6nMJaRyPZs9eCIscewlM
        EYoaTvbaRdE97zQz8YMe0sDBAImDTVK7Cc3SyNuwP1WEzidZai2V3Kxpd2I2tJ5uNWWeNBNqds7iu
        iRWFqHK4axduCvHqov6yEXPLR28VQdR76FWZgu25E5MtL0upRydj+VBxUgWhgOMa28uoOKvGm2THX
        QH7hn9f9pegJlpZEfjTNUZI+8xTvhYt0GWZeabnuLCw4r7jnw0aU1c/2OCji+j4f4MJOiNq2JfzYR
        uKYK8kg87sovAxXMa/7WSaCl7C/UeT4kXnIPGaS5/dw0zO8UGLSAaq+UEEqb0YWgIB/+JBBvZYaNa
        ET5k7h3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPLU-0021Mq-HT; Tue, 10 May 2022 12:52:08 +0000
Date:   Tue, 10 May 2022 05:52:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_repair: check free rt extent count
Message-ID: <Ynpf+KLA1jD6P5vF@infradead.org>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
 <165176669425.247207.10108411720464005906.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176669425.247207.10108411720464005906.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 09:04:54AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Check the superblock's free rt extent count against what we observed.
> This increases the runtime and memory usage, but we can now report
> undercounting frextents as a result of a logging bug in the kernel.
> Note that repair has always fixed the undercount, but it no longer does
> that silently.

This looks sensible, but can't we still skip running phase5 for
file systems without an RT subvolume?
