Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2E5C4CECE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 06:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A6E820872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 06:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lrUwTWVL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392594AbfJQGs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 02:48:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392590AbfJQGs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 02:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yQ4SJVu5mq092MrQCOQDIvhclpSi92QPPLQ7NmXu42A=; b=lrUwTWVL4GUS1sWHALSiq+1qc
        COFHS4m0HGpHpSwrKIEjjwOUZTu9zegfFF4un/bsqpR2DwF4N8UFpTpUp5J/hyBBhMuj7betSGNvd
        ejOFMg6BIHWRIr++opKxPtry5JTr7lO9ZShrTkVpu/ZZH6EFt2ae4zDk29j9Suvc1BHXfHCYhOfBN
        oLeeyIVXHuNwtuzWI8c549dORc87fwA2m0IoTzB8/xv0YO+5x4hiNlJKi0kIqp/lpKgYIsOAiiZ9h
        QIcNMbLc1BnKVqnHWvH0zccdvxDkqnaiiI5xSCR19jMpadRx4rhGagjR11X03ChI/6j0VMkB1+wh2
        7oshwpO5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKzaE-000063-H1; Thu, 17 Oct 2019 06:48:26 +0000
Date:   Wed, 16 Oct 2019 23:48:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 10/12] xfs: move xfs_parseargs() validation to a helper
Message-ID: <20191017064826.GA32610@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118649791.9678.5158511909924114010.stgit@fedora-28>
 <20191016084009.GA21814@infradead.org>
 <53f92136d385e9764976e6b9aa393dda2d55683e.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f92136d385e9764976e6b9aa393dda2d55683e.camel@themaw.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 08:58:26AM +0800, Ian Kent wrote:
> > > +	if (nooptions)
> > > +		goto noopts;
> > 
> > This option is always false in this patch.  I'd suggest you only add
> > it once we actually add a user.
> 
> Thanks for looking at the series and for the comments.
> I'll get on with the recommended changes and post an update.

And for this one I'm not sure the goto option actually ever makes sense,
even with the final patch applied.  To me it looks like splitting the
function into two might be much cleaner.
