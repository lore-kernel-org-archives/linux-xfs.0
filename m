Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74001ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4163B218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KTTtOQh9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbfJIPDB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:03:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55430 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfJIPDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gTdIumPMRj3wK50/w6XxEU5jaq2QeL+TAb3odFDnJ1I=; b=KTTtOQh9RVWFIh9e8z8S7fugc
        IWamSA5o7nwLQrm5RuI5Y5WNJphkQ8s0XPSOyKiZy20j22hWnYESX8BEe5frFKyuaHt3M67TEJm4a
        hP/OlFH5KHiK2Oy6P57O4peDf/1EAyK+IkLbMQxUFGEYzB4zxDHV6xqRnJYTD7B6O0Ny8IXuPX5P0
        2HpU7ESy52LLLRdwFRx+jaIhjHtLXAXxbR8kVJSRBrzvUcksg9eg4YGHrktxkFWCPwKeBgdPeifUu
        YpcAUzLkPuM8UtNoBOoxnksZdHPekRkqyOEY9gceNqYuLjd4L4UMPumxbabNzrAWFV3owiFXmi5E9
        JR9Aju7PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDUS-00084P-LU; Wed, 09 Oct 2019 15:03:00 +0000
Date:   Wed, 9 Oct 2019 08:03:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 09/17] xfs: mount-api - refactor xfs_fs_fill_super()
Message-ID: <20191009150300.GG10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062065791.32346.8183392339697088078.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062065791.32346.8183392339697088078.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:30:58PM +0800, Ian Kent wrote:
> Much of the code in xfs_fs_fill_super() will be used by the fill super
> function of the new mount-api.
> 
> So refactor the common code into a helper in an attempt to show what's
> actually changed.

I hate how this ends up leaving a pointless helper around.  If you
really absolutely want to add the helper here please also remove it
again at the end of the series.
