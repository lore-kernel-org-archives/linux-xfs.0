Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833B4C4CECE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 06:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB3320872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 06:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jlOD7ADr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404875AbfJQGvy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 02:51:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389340AbfJQGvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 02:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=d2JP2AWGYf0cNaEdVn7rOOIAVzvJjkHyZyQ8VK9k0wE=; b=jlOD7ADrVXsHv65xBwPYNe8J3
        Skc0IWylL9lHQU1fqpq/UA3DJzfnitfclS3RBP6brCH1JDlstLO0H+QEX9oAboSRqAQ/37XcdbAMk
        p3NpRaJ783EbSe/sxo+tPRXtLQHdLKE39ko1zj3C0ioKHmlbWyzgqJ9vmEheZOkgL5h6Yi1AQi3a1
        zTYTusd8Pd3pbJKCy59TNYP2cM4ivBA3nDIpQy3JQWOdAlYrdObTVy3jJF4jX58MfYxmfsXDE4s8y
        jYgYy/2KOJfvXt4fhGxc0RAPap84ZO0VvBihNlQd2MfBi5cAQoA4/LJqRLNp4F8utmaSRGkazHbNN
        443m+4XQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKzdT-0001qr-VX; Thu, 17 Oct 2019 06:51:47 +0000
Date:   Wed, 16 Oct 2019 23:51:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ian Kent <raven@themaw.net>, Christoph Hellwig <hch@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 12/12] xfs: switch to use the new mount-api
Message-ID: <20191017065147.GB32610@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118650856.9678.4798822571611205029.stgit@fedora-28>
 <20191016181829.GA4870@infradead.org>
 <322766092bbf885ae17eee046c917937f9e76cfc.camel@themaw.net>
 <20191017045330.GI13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017045330.GI13108@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 09:53:30PM -0700, Darrick J. Wong wrote:
> > The problem is that this will probably be used in logging later and
> > there's a lot of logging that uses the upper case variant.
> > 
> > OTOH if all the log messages were changed to use lower case "xfs" then
> > one of the problems I see with logging (that name inconsistency) would
> > go away.
> > 
> > So I'm not sure what I should do here.
> 
> I would just leave it 'XFS' for consistency, but I might be in the back
> pocket of Big Letter. ;)

I isn't really used for much, and Al already has a patch from Eric in on
of his trees that kills the field in favor of the file_system_type name
field:

https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/commit/?h=work.mount-parser-later&id=543fdf1d617edd6d681fcc50e16478e832a7a2ac

So we should not spell them differently if we can.
