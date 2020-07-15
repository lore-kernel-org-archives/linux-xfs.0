Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D21AC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C332065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vpBfA/Ka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGOSnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOSnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:43:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2087AC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YGgVSYlC9LMTTvpWQn+NaYdptgg8uPtbpHERw/05I5g=; b=vpBfA/Ka1HoXNn3Gl1GnqYRyWT
        mYLf9GsvPW/VJH+tw6/EQceM8/dEMBzd7VQojugQTubXxG0/ERHqBxzkHmX5EOKdKT/xTaP5FyF+2
        +PB6OXhZu2Tg8V0CQ5Ks0lRS3b91cLzyLNwYrHF6bKYfkXLGQN5QeuOwlU9z3xpTHVM8suZZw8N62
        kx7jkgq7Yrv13w6U1z/qpTSSnKJq+v9aOTrL5UNM4XaMmf/2y1/KYsxsjCfNePqtPR57TizUcqYd1
        eX6WWUw7fu9772ALgPO4uRAsl1RAd2uXN1RINMp8gNH7W89y+8CFIA2YtcJKcdO0cDKvuRcwraXJV
        +E0PBJwQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmNi-0006F8-Ir; Wed, 15 Jul 2020 18:43:50 +0000
Date:   Wed, 15 Jul 2020 19:43:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: don't double check dir2 sf parent in phase 4
Message-ID: <20200715184350.GB23618@infradead.org>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:34AM -0400, Brian Foster wrote:
> The shortform parent ino verification code runs once in phase 3
> (ino_discovery == true) and once in phase 4 (ino_discovery ==
> false). This is unnecessary and leads to duplicate error messages if
> repair replaces an invalid parent value with zero because zero is
> still an invalid value. Skip the check in phase 4.

This looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

As far as the existing code is concerned:  Does anyone else find the
ino_discovery booleand passed as int as annoying as I do?  An
"enum repair_phase phase" would be much more descriptive in my opinion.
