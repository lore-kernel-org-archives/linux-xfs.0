Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE25DC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 16:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C492073E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 16:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GQgJ4vEX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCXQQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 12:16:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54416 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgCXQQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 12:16:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J2pXxLPsKXDI5Fcdc1HmcPMMjkHxZ8dqPlPkR3JHYpY=; b=GQgJ4vEXn044tPE2K4CJNIh6lz
        KG1DggMppmzFX7sOWzr2Zv63AFP1+SiZfS0jX/zJAtKSJaxKHO6/tK0D2voBNXjdBhCzOWWE1Y1JF
        yPVBDPcjqtgIMFnTNOhnwyVoleDVYNkJjSzdfwI2grmUN1DgCIujVrNFM89P1MaZOu9Li5Sec2VHH
        5/1R1C8IrGG0C3yTU9Dt+d7q/LTpOOqLoHjMo6EyHVoB7NIMu/rLcrr4QQJB6ormqL/oy3wsYKl5S
        Hib7lIZeZHjXGU9SgpT0JnnnOuV7ag6Tq3a2wtJlm6Bhci1Zcs75nuZvPPLZjin7KN9jiHSVCxaZo
        RPaytC5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGmEZ-0002of-RO; Tue, 24 Mar 2020 16:16:55 +0000
Date:   Tue, 24 Mar 2020 09:16:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Pawan Prakash Sharma <pawanprakash101@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs duplicate UUID
Message-ID: <20200324161655.GA10586@infradead.org>
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 09:43:25PM +0530, Pawan Prakash Sharma wrote:
> Hi,
> 
> I am using ZFS filesystem and created a block device(ZVOL) and mounted
> and formatted that as xfs filesystem. I have one application running
> which is using this xfs file system.
> 
> Now, when I am creating a ZFS snapshot and ZFS clone and trying to
> mount the clone filesystem, I am getting duplicate UUID error and I am
> not able to moiunt it.

Don't ask for our help if you are intentionally violating our
copyrights.
