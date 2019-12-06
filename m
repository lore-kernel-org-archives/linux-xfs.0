Return-Path: <SRS0=r/Pz=Z4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F26BC43603
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 08:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45DE224677
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 08:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gt4DiNYC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfLFI1R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Dec 2019 03:27:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52438 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfLFI1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Dec 2019 03:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7O6BuTokIZ7T0VvWyASbsgi/CXxC232YFvu8nxqdelk=; b=Gt4DiNYC3dL11RiciTiPLFWyZ
        UhHpf/weVA/sEfZf+JKD0mevG/aFs58H+bI8B1JFn+edvxsQQ0HRt4KCXL3aLn1QTxe2rAAZeDFoC
        PQZBYnKvGTIyFkko3Wr7IPeJJ4wdGIeRn17QZkE8n1C7oRj4sMKSIni2FN7CjRCnglqkT9tHWMQeV
        FASHd/cuF0Orwv5+s1jNPeqp9f8Zq7VgJRhApjBTSll+CdHVgVkRlTDygMyIZvISQS/4+eaUBRE9l
        DyLeZEdftIYCi1yIPPbjd36j3RXKh1+W7YIEztWRF6JMguzJcVp0+lqlntUe+VRQ90ZwTLQAfV7GM
        bYU+ljp/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1id8xC-0003o7-WE; Fri, 06 Dec 2019 08:27:11 +0000
Date:   Fri, 6 Dec 2019 00:27:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@infradead.org>, Ian Kent <raven@themaw.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20191206082710.GA14367@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063684.32346.12253005903079702405.stgit@fedora-28>
 <20191009144859.GB10349@infradead.org>
 <20191009152127.GZ26530@ZenIV.linux.org.uk>
 <20191009152911.GA30439@infradead.org>
 <20191009160310.GA26530@ZenIV.linux.org.uk>
 <20191009180102.GA9056@infradead.org>
 <20191009182222.GB26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009182222.GB26530@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:22:22PM +0100, Al Viro wrote:
> Massaging the parser data structures can be done on top of the
> other work just as well - the conflicts will be trivial to deal
> with.  And I'm perfectly fine with having the parser stuff
> go in last, just prior to -rc1, so resolution will be my
> headache.

So, it is that time of the cycle now.  Would you mind updating
the branch and feeding it to Linus?
