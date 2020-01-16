Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD73C47409
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB7EB2075B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dBNc5stu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgAPJYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 04:24:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40808 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgAPJYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 04:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BEhq8qR0Mr6zs+rqKTvQhPOjTx6jtlJmHMRWXyuYOQc=; b=dBNc5stuMyIutn+3/mMh8LSO1
        DFXXpXYHT2fM9XrYz58lMqqFX9bpItiin0l1mr/sKvYCY2wekFp92LbUEsA7oa8bmU+/mbZdI5CdQ
        13EGgzwwF6IPrcICdrD8MBRZXNuyWEJt6RC/LGutp5ItGTGz/9+LYR33LZnkaCdZW02XgkMoiL5y7
        A4tISCa+FU0loKPikoFbC5yl8JqglqOHxZVs4o61Qwa7lMzAV3aOg7rHeCTCrA5A651BIF8lMtKjj
        nT2wNzNxHojH308GPM1lheyKeVPuB4aMOasZSWK5bTddtdXytJF9wUsQ3zWhGEWSmzOqfTuTJOS9D
        XW2svn4IA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1OL-00068c-Iu; Thu, 16 Jan 2020 09:24:41 +0000
Date:   Thu, 16 Jan 2020 01:24:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs/279: skip test if we can't allocate scsi_debug
 device
Message-ID: <20200116092441.GD21601@infradead.org>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915146054.2374854.14308605711454193767.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915146054.2374854.14308605711454193767.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:11:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Due to the unique structure of xfs/279 running _get_scsi_debug_dev from
> a backtick from inside subshell, the "could not get scsi_debug device"
> checks do not actually stop the test when modprobe scsi_debug fails.
> 
> Therefore, check the value of SCSI_DEBUG_DEV from the subshell and
> _notrun the test if we couldn't get memory.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
