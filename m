Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D70C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4C8214D8
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="orS9qiWO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgEAICO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAICO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:02:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F276C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DhSpB53Ki1HWrZVakinThisfMfyfIRplXJf3XbBo4x8=; b=orS9qiWOm3b8JRmPnxAyWPA1sD
        e2bp7MS5Cnhc9Qk21g48aXB+pTdW4/v2yiThtzT5NKIg5/pAhVraSC1NpkOiP/CMuYHtUmW6zHpHn
        c3jJNWGPnlR6/Bdz79lDxueC1yto7gfWcje7934DtgF4eDf04snySvyQzt4WscsX8pnUznjzgSAML
        ZBPeVmg8rdbQwLw5n+vvvwI6yR4XFCP6GugryZ9OYdqGJuAdDPVRdEzqbDt12QvRI+yDOYXaWjk+m
        L206+YHTsTzH43RoWEQiTsmopsohHgl0Dl6j2/DOv224tqlDwfxRxxgehN2Btj2wHP3E5kVHnwdLo
        RjrdpViA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQcg-0004IQ-HM; Fri, 01 May 2020 08:02:14 +0000
Date:   Fri, 1 May 2020 01:02:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 15/17] xfs: random buffer write failure errortag
Message-ID: <20200501080214.GJ29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-16-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-16-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:51PM -0400, Brian Foster wrote:
> Introduce an error tag to randomly fail async buffer writes. This is
> primarily to facilitate testing of the XFS error configuration
> mechanism.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
