Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBA5C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3290D2176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dtDT2pB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbgBYSqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:46:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbgBYSqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GvmGO76mHTrzL1w+Y4jFsUFACYmWZn3iPlI8Biol/Nk=; b=dtDT2pB1HjezVha9VVjvW5J45K
        dMlkw3a2L6TE2HlVWj5Feo/Kye/566JOln3uOqWfbK0mUYvzkU5z/IPBsS+/g39e4V0MzbZaK+e5X
        sqhBBu2uhPHWraPPfF2/0wXIpWyncGm0SWgRzDbcejUguA/CrwOVPWumxAQITuPl/iui2rO1lBmX5
        esKu8PLJgJ0bT+u21nH9Ly/EHG2tmoOtnR+WHbRvKzt8svfu8CgYQbkbusFlL3PVCMwDivA5AQiT7
        s9g5QKWVPgksj2OSJusMrb54ooGumV2EYoKdiGDZy5yTNQYP3ZMjhLn98mYl9LwYaQ4iQffIBmx7s
        ZWndFRlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6fEK-0006Ym-2O; Tue, 25 Feb 2020 18:46:52 +0000
Date:   Tue, 25 Feb 2020 10:46:52 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V4] libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
Message-ID: <20200225184652.GA24401@infradead.org>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
 <1c7c39f7-91a7-be85-5906-e55180a91a5f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c7c39f7-91a7-be85-5906-e55180a91a5f@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 10:13:55AM -0800, Eric Sandeen wrote:
> I had a request from someone who cared about mkfs speed over
> a slower network block device to look into using faster zeroing
> methods, particularly for the log, during mkfs.
> 
> Using FALLOC_FL_ZERO_RANGE is faster in this case than writing
> a bunch of zeros across a wire.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
