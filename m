Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB730ECE58D
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 08:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 769F720650
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 08:40:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cm+smAvq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfJNIk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:40:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41194 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730443AbfJNIk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 04:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2gy955Uqq63ZjbU+vRHD094tE85UQvetN3oFV5jJfwc=; b=Cm+smAvqWaa00v+wmPEn5jh3n
        QUVIT5Kzd0V12wUiND2zUq1Vl2QDJ5amb5nalQN5GdfoVR20Dh0v1aElo8IXu7A7ZMhoIcPTtEdtV
        krdxDC148VEdY3U97N9jVuami18kQzgnMmPq97hHUgroXdB0bBJudmdHVQj0959AVucm395fQ8BZb
        RcwoZ0SngCzWEh9ieNrCH+pdJFeUHgVUmO5cKuF4LF8Rc/vhGovR1X4aC6swdpD7y8itVl5bSC/5C
        EK2K/x3XBRKoqIWzGMHJPZVXKmg7zuYZDcup33rInu89iicplLjANh7hPtEX/PsgDqMJQ2G2KLHEK
        Lgo6krLcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iJvtz-0002pq-Ao; Mon, 14 Oct 2019 08:40:27 +0000
Date:   Mon, 14 Oct 2019 01:40:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Pingfan Liu <kernelfans@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] xfs: introduce "metasync" api to sync metadata to fsblock
Message-ID: <20191014084027.GA3593@infradead.org>
References: <1570977420-3944-1-git-send-email-kernelfans@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570977420-3944-1-git-send-email-kernelfans@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 13, 2019 at 10:37:00PM +0800, Pingfan Liu wrote:
> When using fadump (fireware assist dump) mode on powerpc, a mismatch
> between grub xfs driver and kernel xfs driver has been obsevered.  Note:
> fadump boots up in the following sequence: fireware -> grub reads kernel
> and initramfs -> kernel boots.

This isn't something new.  To fundamentally fix this you need to
implement (in-memory) log recovery in grub.  That is the only really safe
long-term solutioin.  But the equivalent of your patch you can already
get by freezing and unfreezing the file system using the FIFREEZE and
FITHAW ioctls.  And if my memory is serving me correctly Dave has been
preaching that to the bootloader folks for a long time, but apparently
without visible results.
