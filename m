Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1910C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 16:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABBCD206E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 16:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fbF+9y0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfK0Q0r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 11:26:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45380 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0Q0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 11:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=M2XNdYv36feZMbe+i4anmF0SOJZMfaG21DDu0KiOclc=; b=fbF+9y0vMiPOdTxvUoBBsKuQfA
        5FzuC7gw2kA1v9IJiaUZT1JNFnaGzVkYx+0ipzQVuAGsOptEXi6XtakUX1iZfLohtU3ioeEBXhfDL
        CDHEPeoxmo+NyZk/f1VJmTyNr/esIPKNneitZbcoU5/0eG2Jkp4UOJWv3WCawn0feXst4hh8zN3PO
        3k3bnEgYnDWGHhYS1NMzELKOcOeUWwYPMxooy7S0bvVmCQ3IpiO+vv7ln9lv4P+DkCvlukBYEUUtF
        g7bwqRixXwA2LBNR0IV5n8seFE/uOQ1WYo6F4d7nKc+einx0Z48rVCWStiesrssyzjy8VLDS27bpS
        ISB0cjQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ia09O-0003Pi-VL; Wed, 27 Nov 2019 16:26:46 +0000
Date:   Wed, 27 Nov 2019 08:26:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530
 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
Message-ID: <20191127162646.GA12929@infradead.org>
References: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
 <20191108065627.GA6260@infradead.org>
 <c52e2515-272f-476e-7cfa-a2ef23c66b56@gmail.com>
 <20191127154353.GA9847@infradead.org>
 <7b5db9fd-7f40-bf43-e494-d6d95839c0f1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b5db9fd-7f40-bf43-e494-d6d95839c0f1@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 27, 2019 at 05:25:20PM +0100, Arkadiusz Miśkiewicz wrote:
> Hm, 5.3 but I saw this on 5.1.15, too. See below. (or did you mean 5.1
> was with big changes?)

I meant 5.1, sorry.

> Probably it will be easier to just bisect and I plan to do that after
> backup catches up with missing data (and it takes days).

Thanks a lot!
