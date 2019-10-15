Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C294ECE58E
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 08:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FD93217F9
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 08:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UlavkiBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfJOIBe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 04:01:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37838 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfJOIBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 04:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1hjKUVGeHNRInFeWaMu8pTCN9rukm3B6OsQ2Vm8GmAU=; b=UlavkiBd6rPMoW0IFuURQJ1kx
        9WRM7km8J3HgXlS7u5vUPz26XojTMb6mQI7F87eM1VqyLf9CDlFCyO7lj2Bhh+AFH3bAgDhz9uZ36
        whP86ZjdolPlSAjncJGy2Vd1MQPkYwbPSwCv+IEAYFqJUb/xUlGcPlkFnfcgI8HjhC9cULmQH0C+w
        XIU3XEAo2Bt6xRuZDLIJPhcXooEctcTSl1hb6Y0xpDChHNd+NkBY1XxR4zGybPe/JengqLRk1gjsb
        dnzPSC1VKeKnpmREm0ekUmXPkzSFegGtXo0d/ITCJexJPP2rliZmpCcMsdnaMBKE5VJF9wLEnjvTk
        X26WLowrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKHlu-0002K4-7C; Tue, 15 Oct 2019 08:01:34 +0000
Date:   Tue, 15 Oct 2019 01:01:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Pingfan Liu <kernelfans@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] xfs: introduce "metasync" api to sync metadata to fsblock
Message-ID: <20191015080134.GC3055@infradead.org>
References: <1570977420-3944-1-git-send-email-kernelfans@gmail.com>
 <20191014084027.GA3593@infradead.org>
 <20191015015620.GA14327@mypc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015015620.GA14327@mypc>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 15, 2019 at 09:56:20AM +0800, Pingfan Liu wrote:
> Agree. For the consistency of the whole fs, we need grub to be aware of
> log. While this patch just assumes that files accessed by grub are
> known, and the consistency is forced only on these files.
> > get by freezing and unfreezing the file system using the FIFREEZE and
> > FITHAW ioctls.  And if my memory is serving me correctly Dave has been
> freeze will block any further modification to the fs. That is different
> from my patch, which does not have such limitation.

So you freeze and immediately unfreeze.
