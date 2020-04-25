Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD6CC54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F206C2071E
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JAPALcK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDYR2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYR2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:28:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224C8C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NEzs2IlBJpk3y4LVL2JAkWj4H45AahYQ9wkN6DS4bGE=; b=JAPALcK6ktusD1Q8nsVegm4OKf
        dvFsku19vpG1rjw1Kjky6tjHLAAtLmmeTfiXK2/V/QtU3SSn+jVs5/8XvX/fJjIKEtijNtmEicUem
        hQnNVq4ZeGH/Cu3uUmbhctyDJ49cqrH9BnpvK1KKWVhbIGhWEwPS33YC8jFYhwy3LFeuhK8dONc36
        DfeZKuBwe25rCif33+tU8pkJ2NexHCYApTkrRSQoPUoJRQKQmGLF61ux2k+SxEjVAqrmhRzAkgYou
        8qcBdMb5CNZ7ThM4LQ5fDL7kwyQPVujGxEd/TWOl5SKEZOV5UcsFKK/o1peIjTG1A7AIFfvDlRgMF
        R0tveRjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSObh-0005iI-12; Sat, 25 Apr 2020 17:28:49 +0000
Date:   Sat, 25 Apr 2020 10:28:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 06/13] xfs: fix duplicate verification from
 xfs_qm_dqflush()
Message-ID: <20200425172849.GE30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-7-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:22PM -0400, Brian Foster wrote:
> The pre-flush dquot verification in xfs_qm_dqflush() duplicates the
> read verifier by checking the dquot in the on-disk buffer. Instead,
> verify the in-core variant before it is flushed to the buffer.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
