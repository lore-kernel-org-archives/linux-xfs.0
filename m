Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8E6C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 15:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1A7207D8
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 15:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="egDSbUO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgEUPSO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 11:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgEUPSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 11:18:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74851C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vY5CqhnfxnaxarMwnjLDRYlkcDGuVwLtZz1MW8x1gD0=; b=egDSbUO9k2UTom07Lmi8Vc1Lwg
        hzapOFiEKOajNFzr8qchVSxiygKhdIaiKvBAo7bpTTVbXIVF44705/Hpi8SEPYY93rkXIsGaxFLPu
        Dbsuq0jkC1rhEN+j+BbjCVGZUcp23ujU4IMlPv9VIx/9vccSk5poXdO17W+ywCz8+UVLOp6aCFgS7
        S1xn9Z8M1w0BJ7rOzYXpiS6+RTCsTrwi9vKmPSGBV9gqWY+L0SVFO0mzeehMNbBe5Fh6+rtNo7rmE
        kSKksKJss6kNq5xBCKQ0TuleJRojsPPd95o/XmI3vg/tlyFyFGIVeIZP79AWa+znuOgcETLDlnNzc
        YitypjRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbmxX-0000j1-JQ; Thu, 21 May 2020 15:18:11 +0000
Date:   Thu, 21 May 2020 08:18:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7 V2] xfs: switch xfs_get_defquota to take explicit type
Message-ID: <20200521151811.GA2725@infradead.org>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
 <1590028518-6043-6-git-send-email-sandeen@redhat.com>
 <58bbabff-ac0e-9ab4-8caa-9981ff7e2fe8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bbabff-ac0e-9ab4-8caa-9981ff7e2fe8@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 10:05:40AM -0500, Eric Sandeen wrote:
> xfs_get_defquota() currently takes an xfs_dquot, and from that obtains
> the type of default quota we should get (user/group/project).
> 
> But early in init, we don't have access to a fully set up quota, so
> that's not possible.  The next patch needs go set up default quota
> timers early, so switch xfs_get_defquota to take an explicit type
> and add a helper function to obtain that type from an xfs_dquot
> for the existing callers.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
