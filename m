Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B4DC33CA1
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 08:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07C28207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 08:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sxn7SBH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgATI6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 03:58:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58558 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgATI6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 03:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=14d8zS2Hb1pLKuTvWcY9hM/Pp0Vz46GHATgOAdVlWho=; b=Sxn7SBH9fFhB+W3fGgQ++5wiA
        EzpXJVtRhjvK5484qEM/0xLdya/6owdpMuo2ktLFYz6xTeW+GyFQGY9STd3+xtiVGM3DF/y0jLF6z
        oxtxQFsxItLBaVHmcopMH5G39Qv4djy43G3Qua3Dnxygdg6kksc9xYFIxUV80XcmpWqy7yLUe/dCI
        6UIB7+qMIxaFWeL2ajgyrlLkv4RqMEyMtDHJZ5JGrARDNhJCxb+hPV5a1XkIqm91+9mKyPatIKxUL
        WxSXoCxywv0O7dvL53gZR8SsR1lC6Sm0ZziFb6S5MayFwfLfSoCdLEa0zo9RY2YMlWPaqyvKYCwut
        0iEvZq2mQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1itSsr-0006AT-MW; Mon, 20 Jan 2020 08:58:09 +0000
Date:   Mon, 20 Jan 2020 00:58:09 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: stop using ->data_entry_p()
Message-ID: <20200120085809.GA22525@infradead.org>
References: <2cf1f45b-b3b2-f630-50d5-ff34c000b0c8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf1f45b-b3b2-f630-50d5-ff34c000b0c8@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 17, 2020 at 05:17:11PM -0600, Eric Sandeen wrote:
> The ->data_entry_p() op went away in v5.5 kernelspace, so rework
> xfs_repair to use ->data_entry_offset instead, in preparation
> for the v5.5 libxfs backport.
> 
> This could later be cleaned up to use offsets as was done
> in kernel commit 8073af5153c for example.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I'll munge this patch in mid-libxfs-sync, just before the
> ->data_entry_p removal patch.

Looks good, and I can give the cleanup a try once I find a little time.
