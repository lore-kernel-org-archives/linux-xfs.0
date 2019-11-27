Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C054C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D3020665
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WL8gM8Yc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfK0Pny (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:43:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34862 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfK0Pnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 10:43:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HV3btWrQwd/ky9VgxUpM+mErQxyTePDvAugjnv60tfE=; b=WL8gM8Ycqn/pusomT685A8TMX9
        iiXHRNq59G02Clc/44OgZRzxX5+y4VOsT21FuXaddO6iRGGTLdmRZ+t575vVWqSoGBcJ/R87osm+W
        NhwV86i0vwPvEHPZnpNtI6DzJTJ3quMQtIAUYo9jyTorzzHdOUHeXOT6H8LIXJ+G8HjcdxbYIhaIM
        zgKXAY28Hu5TQDU17717ZV98T93XYwx4GVr1YiftELrKL8CsfOetY1qafi1rvTk6HyFMDJGhvkAZJ
        C0nBN+lUXTxOcJ+CzkSd0/2oqoe1tacdugO4nh2xl3hTHURbhUmrW9hiGAd+49XCFLApZOHePN+/Z
        LVd8Bn2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iZzTt-0004Yf-Dt; Wed, 27 Nov 2019 15:43:53 +0000
Date:   Wed, 27 Nov 2019 07:43:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530
 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
Message-ID: <20191127154353.GA9847@infradead.org>
References: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
 <20191108065627.GA6260@infradead.org>
 <c52e2515-272f-476e-7cfa-a2ef23c66b56@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c52e2515-272f-476e-7cfa-a2ef23c66b56@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 08:36:31AM +0100, Arkadiusz Miśkiewicz wrote:
> > The WARN_ON means that conversion of delalloc blocks failed to find
> > free space.  Something that should not be possible due to the delalloc
> > reservations.  What as the last kernel where you did not see something
> > like this?
> > 
> 
> 4.20.13 looks ok
> 5.1.15 bad (that warn_on triggered)
> 
> on both machines according to my old logs

Sorry for dropping the ball.  We have some pretty significant changes
between those version as 5.3 has a pretty big rewrite of the high level
writeback code, and this happens in code called from that.  But it
doesn't actually change (or should change) how we use the reservations,
which leaves me a little puzzled.  If I gave you an instrumented kernel
with new trace points, could you provide traces based on that?
