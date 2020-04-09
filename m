Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F848C2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C051206F7
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jxuSASxd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgDIHli (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 03:41:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIHlh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HQTrm8Cg6ZyNBaNg67z3WCva6OQV2GyVWDVByZgNhec=; b=jxuSASxdQkPR0cfe+Z9m5n4bcL
        9kDPmdxWiZbbw/cVyo6M/K86hHd20YCe9QL+A+YcVwhWS09wVP3APE+EiqsTJPeyhu7QMPSPaWc6H
        BaxY3rUXIFeliCpcKqQtl3jBU7QBuScCZBPkbZ7laa64/fbf63jvSNn8JTQ9vnPMkHmkGZM2835NY
        YFUPZBeVSxPdSHAhGxjveRHoB8hHHfkb3P6+C5V0328XgfYa1SMTCwGtxaAOJIGrqd2UUvgn5EAF2
        cp6mjRuxD+QVqVDfbEYBIMJ/JwYPOl7eBNXdf556ULEzBVocWONqBy4APsrps7phSup/mXKOhwb5/
        MLpjj50Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRoY-0008EE-2J; Thu, 09 Apr 2020 07:41:30 +0000
Date:   Thu, 9 Apr 2020 00:41:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: libelf-0.175 breaks objtool
Message-ID: <20200409074130.GD21033@infradead.org>
References: <20190205133821.1a243836@gandalf.local.home>
 <20190206021611.2nsqomt6a7wuaket@treble>
 <20190206121638.3d2230c1@gandalf.local.home>
 <CAK8P3a1hsca02=jPQmBG68RTUAt-jDR-qo=UFwf13nZ0k-nDgA@mail.gmail.com>
 <20200406221614.ac2kl3vlagiaj5jf@treble>
 <CAK8P3a3QntCOJUeUfNmqogO51yh29i4NQCu=NBF4H1+h_m_Pug@mail.gmail.com>
 <CAK8P3a2Bvebrvj7XGBtCwV969g0WhmGr_xFNfSRsZ7WX1J308g@mail.gmail.com>
 <20200407163253.mji2z465ixaotnkh@treble>
 <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 08:44:11PM +0200, Arnd Bergmann wrote:
> That is very possible. The -g has been there since xfs was originally merged
> back in 2002, and I could not figure out why it was there (unlike the
> -DSTATIC=""
> and -DDEBUG flags that are set in the same line).
> 
> On the other hand, my feeling is that setting -g should not cause problems
> with objtool, if CONFIG_DEBUG_INFO is ok.

I suspect we shouldn't force -g ourselves in xfs.  Care to send a patch?
