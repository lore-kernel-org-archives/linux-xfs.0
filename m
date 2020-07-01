Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31883C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 118862074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CFSg18VV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgGAIwQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgGAIwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:52:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BD5C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VMtyIodS3FUt8xRmP3WXZ01HSZ1IbadH1CmciNONtXQ=; b=CFSg18VVdGIDfPx0qmPynrYwn5
        KCAmp0x9lWqkCpd38tJkJl/ELBCfT/6UzTxZXeqAzgSK24T+E4SIU0Suj6pRKTYM2Je6zYYv0wA+g
        d4/fZadQ/55Q/18yam51ng/GW+BhHMa+QKJfWijxcWnkhLHThyzDC6fVmW5uSlZmMWxeoHoh2lt6U
        TkjlHgJ2t66sUGoLisa5lE9uaDUgIN4G+hWEXpYZYJGMGxY4vtcBxSDIi+DTd4jZ3TSeno25BgQg8
        UxthR1RJIKXQGADSd4l/oquS1Or2vGCmH/H/WlxNQyil0/Fo+9fj4S4rdfXQL7NYqpuWPZwWTxsF9
        D9/BR1/g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYTV-0007hu-T3; Wed, 01 Jul 2020 08:52:13 +0000
Date:   Wed, 1 Jul 2020 09:52:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] xfs: remove qcore from incore dquots
Message-ID: <20200701085213.GK25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353178119.2864738.14352743945962585449.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353178119.2864738.14352743945962585449.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:43:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've stopped using qcore entirely, drop it from the incore
> dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
