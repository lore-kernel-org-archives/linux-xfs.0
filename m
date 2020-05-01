Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30D8C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9327220787
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mZCKnY7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgEAHsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 03:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgEAHsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:48:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA11C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 00:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jTnB4OFNv0BV2WiGDpmYooAwKPFaAbmSyOdYiopudJI=; b=mZCKnY7cbV9iqUG6avaTn2trcq
        2Xx5QD26Rrlx4s7AB0VxQhBso8FazoOMy4terwp9LEPnpT7iqujhlq+l3MPIDM/1FmXKBNxiCzt44
        EzLCzd+LFhud0S6r+/W6jDHbMAOGEYCy/YcdDQQr/EDsKHLgLM5Vm1/5Bin3wEVSo/FhRAyV/PEK9
        tdv2VSQey7k23++3SAsJebyOd0/n2YdoqKRDT94IclTg5YzeIyHLbfVmW7VUYN3AMfxSKV4Qj+/GK
        BHi/jhO0/cEGJh4jwEFKyugJOWnkTHODX+CgObmeOGjCxfbwFEnfyQGS27lUv585q5qO3LEpr8ZqK
        XDeNZLaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQPE-0002ux-8a; Fri, 01 May 2020 07:48:20 +0000
Date:   Fri, 1 May 2020 00:48:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 07/17] xfs: ratelimit unmount time per-buffer I/O
 error alert
Message-ID: <20200501074820.GD29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-8-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:43PM -0400, Brian Foster wrote:
> At unmount time, XFS emits an alert for every in-core buffer that
> might have undergone a write error. In practice this behavior is
> probably reasonable given that the filesystem is likely short lived
> once I/O errors begin to occur consistently. Under certain test or
> otherwise expected error conditions, this can spam the logs and slow
> down the unmount.
> 
> Now that we have a ratelimit mechanism specifically for buffer
> alerts, reuse it for the per-buffer alerts in xfs_wait_buftarg().
> Also lift the final repair message out of the loop so it always
> prints and assert that the metadata error handling code has shut
> down the fs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

As Dave pointed out the ASSERT seems to agressive (and not really
related to the rate limiting).  Except for the ASSERT this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
