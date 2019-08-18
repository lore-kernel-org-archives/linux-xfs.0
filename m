Return-Path: <SRS0=cq6/=WO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B46AC3A589
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 08:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A2520B7C
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 08:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qWvc+h5v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfHRIio (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 04:38:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfHRIio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Aug 2019 04:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bhYhFJtgi06Y2weD/gBhdAIBI+PumMUKI4rvlnGH5z0=; b=qWvc+h5vMAdrg8vRBjT++NCj9
        0Z2j4KbLvdyJ5X2AgUr/XqwO3Ovad1FnIYkm0Nztz3PbS22u1nOD1noHiyaNYVGv0Xkpg3BtupiCO
        MIpwVDeUGuIskFctfvpuBYFK9D3hU3T9X8IJy+Opd1aRA3TVfoHIZEVP4jcryb5ls8Cpw3oFI+A7k
        0lXaBRTLKj3UaKEtdSN2Uuzok1Exu41VfexLUDePl+GrhBKZOFrnBXgnK/RZkBIDd8LexR0SVGF1k
        udAOEqxQTlFbfNCMiWmK3DyKsynyP+eAHwD8juXImMCPSxh8+Py3XGKD9tAYvWJl+En+7+SRkR91h
        R8A7DHZGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hzGi2-0003bH-S7; Sun, 18 Aug 2019 08:38:42 +0000
Date:   Sun, 18 Aug 2019 01:38:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix reflink source file racing with directio
 writes
Message-ID: <20190818083842.GB13583@infradead.org>
References: <20190815165043.GB15186@magnolia>
 <20190816161134.GH15186@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816161134.GH15186@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 09:11:34AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While trawling through the dedupe file comparison code trying to fix
> page deadlocking problems, Dave Chinner noticed that the reflink code
> only takes shared IOLOCK/MMAPLOCKs on the source file.  Because
> page_mkwrite and directio writes do not take the EXCL versions of those
> locks, this means that reflink can race with writer processes.
> 
> For pure remapping this can lead to undefined behavior and file
> corruption; for dedupe this means that we cannot be sure that the
> contents are identical when we decide to go ahead with the remapping.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
