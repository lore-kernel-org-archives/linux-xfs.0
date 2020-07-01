Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF83EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD01D206A1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fSnAOnHE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgGAIxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgGAIxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:53:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00768C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ixG09YuiJhgCDzYH7MNGo3YpgSfw3i+bPRDP+BnUWHY=; b=fSnAOnHE2lAWDk38TsBcn/QqGg
        HHnQ1WIumepizN05WBXuJgZycnbLXvmEEoCO6HeAuQlaWClU0IBOKC+5yB1MBBl1CANT/zg3upU0i
        ox3CuRTuoP7g21LdaV2V2HwHdqkFYh3Ek45eH8jTR3lDPf9v1yO0tfb0h9F4A06fiYrQDIqwSzHEO
        c3UO6jTcF+WcixtvoAZ5js37lNBqTY8YzGxRP5ipJaGyT3fBIUZ2J+7Lh6DK1TCthwLtQKVrE2Klw
        yPScManF113I7ff0vaYMgP5AjsmM2GMHABxZHMSMQt+mtTOcObGeq9KTQreODSyhARSyCiA92ikPS
        U7oeYeYA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYV0-0007mY-LF; Wed, 01 Jul 2020 08:53:46 +0000
Date:   Wed, 1 Jul 2020 09:53:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/18] xfs: remove unnecessary arguments from quota
 adjust functions
Message-ID: <20200701085346.GM25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353179380.2864738.11917531841285726141.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353179380.2864738.11917531841285726141.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:43:13AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> struct xfs_dquot already has a pointer to the xfs mount, so remove the
> redundant parameter from xfs_qm_adjust_dq*.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
