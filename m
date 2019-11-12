Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5174AC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C97C21D7F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rByDII6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLQMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:12:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36740 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfKLQMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 11:12:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZvNS8BWhIj104MaXdjljrjdItYyM9+MlwJuyPts81D8=; b=rByDII6bVfsmvj2NB7BAIEYwu
        yL6OvpbSlwWXMnl5vpeiw3jl2d22B85J72cyit+YYvPP5yvuRLM5TlfKcxtOl+u7ZInNU7IpDkvat
        9+NYV8AC8Um0V8YoJh4ScMIcxP7CD7tYtyJhmBOJAzAurwZGUddE+gZPdoaceiY4X/4UiG0aNoEW8
        c8wiJ4hZMj1BqQer/vbwWcnkSFzNdiOWWs9Od7GxbQMDz1hLlqvwtGohw/V9NHxV6QS5Zng2U2jzC
        uTcHyb5Iqg1Aym2wTkbZugB9GQfZ7oCQkCIeLD5iS84lWvBgXbPItIDreS5dhVxCHxhOu8EFcbOdY
        Al4Kt96Jg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUYmY-000588-NO; Tue, 12 Nov 2019 16:12:42 +0000
Date:   Tue, 12 Nov 2019 08:12:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191112161242.GA19334@infradead.org>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
 <20191112082524.GA18779@infradead.org>
 <20191112160913.GW6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112160913.GW6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 08:09:13AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 12, 2019 at 12:25:24AM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 11, 2019 at 02:35:08PM -0800, Darrick J. Wong wrote:
> > > Also, please change struct xfs_inode.i_crtime to a timespec64 to match
> > > the other three timestamps in struct inode...
> > 
> > Or you could just merge my outstanding patch to do just that..
> 
> I must've missed it, got a link?

The series is at:

https://www.spinics.net/lists/linux-xfs/msg32997.html

Dave didn't like the last patch, but the first three should be fine.
