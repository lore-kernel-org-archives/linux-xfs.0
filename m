Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DBEC33C8C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FBD0208C4
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wq43JLcu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgAGOPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 09:15:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgAGOPZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 09:15:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xqlYop5DhphzrZQdTxc1fAsHUP2VxeXuzg6FxawW7Xc=; b=Wq43JLcuwuEuk6GyqgY6qoOT1
        MMMF1xDkbnQZvkSqT/+ud8jWdinfh3CHOuiT1OyWJeJwLVLLv9DnZgFr7BqIKVUA8K247A0yGL0qF
        942PHKdN61tO1IJYTyq0w+RcPAOrYlpQKjeqQ+KZLZA7Nx4tGMRhZiX0ChcjPuOEO9Z0Us4dYWBt8
        zPHrbTfzdR3kJGVTTCdsyDY+gdtG2J+fSeGxp3eJctQVvsNZSL/4YnUyhNssW1eiwZsV2Yo/jSgbu
        u1bEmUF9+EUWz+YEF/KQdGM4Z9pEA9tMY/pJ3PHqH7emlJWJznLty8ynIKxE7U1SMSPym5x/jKqul
        PV9Hx+k/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iopdi-0004L7-GT; Tue, 07 Jan 2020 14:15:22 +0000
Date:   Tue, 7 Jan 2020 06:15:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20200107141522.GB10628@infradead.org>
References: <20191218163954.296726-1-arnd@arndb.de>
 <20191218163954.296726-2-arnd@arndb.de>
 <20191224084514.GC1739@infradead.org>
 <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
 <CAK8P3a30VpwVCSt0kTXZK7r5__80uBGbNOnDh1YhkAkcoBcQrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a30VpwVCSt0kTXZK7r5__80uBGbNOnDh1YhkAkcoBcQrg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 02, 2020 at 09:34:48PM +0100, Arnd Bergmann wrote:
> I tried adding the helper now but ran into a stupid problem: the best
> place to put it would be linux/time32.h, but then I have to include
> linux/compat.h from there, which in turn pulls in tons of other
> headers in any file using linux/time.h.
> 
> I considered making it a macro instead, but that's also really ugly.
> 
> I now think we should just defer this change until after v5.6, once I
> have separated linux/time.h from linux/time32.h.
> In the meantime I'll resend the other two patches that I know we
> need in v5.6 in order to get there, so Darrick can apply them to his
> tree.

Sounds good.
