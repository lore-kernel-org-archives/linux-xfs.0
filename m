Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95293CA9EC2
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6869820862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kqqat4wC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfJ2HQP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 03:16:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfJ2HQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 03:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ArGvlkDZMKfgAZC4k+F84a+Yqv5j9i5lxC08uOdIDvs=; b=Kqqat4wC1vAISXjMAbvIvPJD6
        ynBUEtUbtORF4j/kWz1Cm8FL6opCB9I7CJYUALtxw+G2u6nbPYnc4qklJNfzN1SDwE+JZOkVQLZzd
        2ap3bw7V9w1jcKAqMcXcOO9dbHZ1Ozdzk1roehhQSfvClthQ2k8omCrGB9lUJHAw+wjmuF1T9L8X+
        Oqjc1u2XUUobE6hATSht9akxpKolEPL+e/8mKCiHHxGIyQOc31dtNYwDpMLh3Gs0RG2STM3nLqT8P
        GuxnCNrHAalCxbev90XwPKAL0/2AhaYFfMU5yD+x/BZ2bH+CHcczdi8GgGAAgnvfui5NIFsCLEKtK
        9U7mWd41A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPLjj-00019G-FG; Tue, 29 Oct 2019 07:16:15 +0000
Date:   Tue, 29 Oct 2019 00:16:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191029071615.GB31501@infradead.org>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
 <20191025125628.GD16251@infradead.org>
 <20191025160448.GI913374@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025160448.GI913374@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 09:04:48AM -0700, Darrick J. Wong wrote:
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Note that we can remove the check for '/' from xfs_dir2_namecheck for
> > currentl mainline, given that verify_dirent_name in common code now has
> > that check.
> 
> We can't, because this is the same function that xfs_repair uses to
> decide if a directory entry is garbage.

So we'll at least need to document that for now.  And maybe find a way
to not do the work twice eventually in a way that doesn't break repair.
