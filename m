Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2736FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD083214DA
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uGEn1Ou/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKHG42 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:56:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHG42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 01:56:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1URJEcaBlXd5cNpZBUiN2riAv3gZOOZ20KmFrtMTWqY=; b=uGEn1Ou/os5DG4DycEDOWt2bJp
        E5/0wD4uGWmwGNqCWmUcsNQ7LLrLD74i/+ElBuQVl9u0icq4gDfM/LNd/0nAfWifiA44XYJcVA98l
        Ce3tL9PFvKBMXVz5M01Air3Y/4yrYl+xTZBg1ewvHOVHhdYp8MdIOPwK/UPzo+P38/sU+lypNq/Vy
        vdzIhrci1gwVgJl6ie2HzM/iJtE6wDdIHNd0UziUGE2zdL2JxjxlkVO4SLh+wbziSOpVHc9is5GTQ
        nGZYZ/lOVb2pn/6XlPdPJ+UC3VcZaJNDCgcnRjyCmOSEMTqE7kIPd0IqqldKlR73EPWDjne7+90Rw
        7dCsWkIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSyC3-0004jF-7O; Fri, 08 Nov 2019 06:56:27 +0000
Date:   Thu, 7 Nov 2019 22:56:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530
 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
Message-ID: <20191108065627.GA6260@infradead.org>
References: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 07:01:15AM +0100, Arkadiusz Miśkiewicz wrote:
> 
> Hello.
> 
> I have two servers:
> 
> backup4 - one with Adaptec ASR8885Q (that's the one which breaks so
> often but this time adaptes works)
> 
> backup3 - other with software raid only
> 
> Both are now running 5.3.8 kernels and both end up like this log below.
> It takes ~ up to day to reproduce.

The WARN_ON means that conversion of delalloc blocks failed to find
free space.  Something that should not be possible due to the delalloc
reservations.  What as the last kernel where you did not see something
like this?
