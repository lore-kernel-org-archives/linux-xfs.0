Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009CDC4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0F9A20714
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OdyBRg0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCXIoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:44:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33372 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgCXIoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 04:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L4jTaMELxOpwqg9EEvalqWSqQ2qnUVPmmPPmKoBYLaw=; b=OdyBRg0vA12K3xWFJ6qFLxauEu
        IzdsVcddCADJNUi/p6vS5Ydj4gl1qPwqd9H1DoYDESb86xfcMCK6XrzDg0+woG5rDMoPlnLgeBtCi
        8gZk31BYU+TfqJZGfNFXcIf5vxUTRse2dWuOk6obdN27gqTkNpza+Au/Xrsirr2pZ3R1bSqfJ4XPF
        1YGlEvO59KJ33IwzVn7A+3Ecovdye/7m04krwrTC6uRG4JBwkAqbtUkRiRHvHLrVyijicG1Cq1l6U
        wxcb4kqnXcUkyv4ofkieuA3YgmvqJV7oRE3YQexcVSBzJCRsEYW+NfXMrZ8ssnnSHKcu9kRPeuxb/
        WcGOKZUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGfAV-0003kh-48; Tue, 24 Mar 2020 08:44:15 +0000
Date:   Tue, 24 Mar 2020 01:44:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfsprogs: LDFLAGS comes from configure, not
 environment
Message-ID: <20200324084415.GE32036@infradead.org>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324001928.17894-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:19:26AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing:
> 
> $ LDFLAGS=foo make
> 
> bad things happen because we don't initialise LDFLAGS to an empty
> string in include/builddefs.in and hence make takes wahtever is in
> the environment and runs with it. This causes problems with linker
> options specified correctly through configure.
> 
> We don't support overriding build flags (like CFLAGS) though the
> make environment, so it was an oversight 13 years ago to allow
> LDFLAGS to be overridden when adding support to custom LDFLAGS being
> passed from the the configure script. This ensures we only ever use
> linker flags from configure, not the make environment.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
