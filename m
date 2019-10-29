Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57898CA9EC2
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FDC820830
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S+sLEJbD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfJ2HPg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 03:15:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfJ2HPg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 03:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Mz9fDVgYENCKrutIXtlIhFJoveOn+ZJ7z9IBMC1xFSk=; b=S+sLEJbDY28bUOHcmiiJyIAZ4
        Dl8S8FWhX3OyVqMSGjD+PN1SIHRY39Fm9OJKaLptr4b8vz9k3qIVosMCeNFQhkTijXnXFRXDO8Knf
        pom4ZS/YOdSOmJVSprluqBfJ8BmZwoYWgunTtIw8NM+1LO7+x2su1HeFsY0PRZT2G8cqNoL+P2qaC
        EzDGNSB4DoVhw4LOCPxvbAOFmEZHqvq9/sRudxGwQBwgJo9rONiE3Fw0dQ4i6cAdDwdsSYod779nj
        j3PTHgR705RpKzu2at0NBuR1HDb+/dIImg7s0TVxay8MxZt43POIomGTJ5HOOyBcsIEBYTlN+YNgQ
        ngTEAF8LQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPLj6-00016z-7p; Tue, 29 Oct 2019 07:15:36 +0000
Date:   Tue, 29 Oct 2019 00:15:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_growfs: allow mounted device node as argument
Message-ID: <20191029071536.GA31501@infradead.org>
References: <0283f073-88d8-977f-249c-f813dabd9390@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0283f073-88d8-977f-249c-f813dabd9390@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 10:23:51PM -0500, Eric Sandeen wrote:
> I can clone tests/xfs/289 to do tests of similar permutations for
> device names.

Can we just add the device name based tests to xfs/289?

The patch itself looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
