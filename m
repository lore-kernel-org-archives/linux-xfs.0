Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E797EC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB893206B7
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hdP94Bjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfLXL0K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 06:26:10 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfLXL0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 06:26:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q6Yp0YcDZT7nVo5e0+jFwYYHu+p/DcMMYg6XBoXf7+g=; b=hdP94Bjy/kdYTL0TDP+MhCSWO
        Xy6m46yCAA1+6OwgBA444k5T+9hIvZFzc1OmpO2SLnr07sBdjU1A5A26J2QOmNMJHqRdvyX80SjAz
        Hnc2fICGVH6UBu0vSUn0bZtU0ByuJndjm5+R6ExZUAMvKapIuHU4Lu0sJ7kDgpBlEAe7oXMIKPKVh
        BBK51k0Y/IrwhvMIBNWGav2CZ5rRvFlJZhIvDaCGlKTp3wPuHKCIMSvWydc+uWDjOyGyxDVKOJim9
        JhLFtsdQEJHYshjJyhTajxKhJDRvk1p/mj02mkAMHgXp3ZYq//oZ6Bm+1glPnq5Iz4c4IKfbTx3DK
        RI7O+6bPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijiKH-0001fH-M3; Tue, 24 Dec 2019 11:26:09 +0000
Date:   Tue, 24 Dec 2019 03:26:09 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191224112609.GB24663@infradead.org>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213171258.36934-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 12:12:57PM -0500, Brian Foster wrote:
> The insert range operation uses a unique transaction and ilock cycle
> for the extent split and each extent shift iteration of the overall
> operation. While this works, it is risks racing with other
> operations in subtle ways such as COW writeback modifying an extent
> tree in the middle of a shift operation.
> 
> To avoid this problem, make insert range atomic with respect to
> ilock. Hold the ilock across the entire operation, replace the
> individual transactions with a single rolling transaction sequence
> and relog the inode to keep it moving in the log. This guarantees
> that nothing else can change the extent mapping of an inode while
> an insert range operation is in progress.

This looks good, and similar to our usual truncate sequence:

Reviewed-by: Christoph Hellwig <hch@lst.de>
