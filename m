Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC7FC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3BE520726
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kjKFc4uO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfKRGib (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 01:38:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfKRGib (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 01:38:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yxJWnbV2AMBFeMsmQPpz/En4bGHFFMLDxvmcpbbwVdk=; b=kjKFc4uOwj6Xs5AfE9FonI/ge
        Ehp1tyDy1nIeg2jQjhQHdJcTtH5cDfyrMRFdci1B63AsfL2TPdi9CyR7ohJ9+Ty24vdqIlJgjz4qY
        I/Q8PC/ZMqWrgzU5yFAxslsJTBOOcx8xuzo7ALVGKaNNDPPKycgtGCFkHuJhYkPk4lWoZx7oOTeJ8
        1wKdje6hxaVRZjEjz1PRQgMvkkB351n0RPY467tfxOnYcwrL+5mL+1B3Xs6LE/8A3ue+/zQ9bFO5g
        dV2GnncQXbWDRgqGuHKxKcehOfjyS4fkVxaiuxSWVmHNlN6GD1SxzdOQr60oxlQCul+PfIFHloNrJ
        XZigdz4HQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iWagA-0007pI-Ur; Mon, 18 Nov 2019 06:38:30 +0000
Date:   Sun, 17 Nov 2019 22:38:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: report corruption only as a regular error
Message-ID: <20191118063830.GA29843@infradead.org>
References: <20191117191217.GU6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117191217.GU6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 17, 2019 at 11:12:17AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redefine XFS_IS_CORRUPT so that it reports corruptions only via
> xfs_corruption_report.  Since these are on-disk contents (and not checks
> of internal state), we don't ever want to panic the kernel.  This also
> amends the corruption report to recommend unmounting and running
> xfs_repair.

xfs/348 seems to pass fine for me with this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
